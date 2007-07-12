From: akpm@linux-foundation.org
Subject: + pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces.patch added to -mm tree
Date: Thu, 12 Jul 2007 15:48:04 -0700
Message-ID: <200707122248.l6CMm54g008897@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45791 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758469AbXGLWtI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jul 2007 18:49:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, clg@fr.ibm.com, dev@openvz.org, ebiederm@xmission.com, herbert@13thfloor.at, sukadev@us.ibm.com


The patch titled
     pid namespaces: dynamic kmem cache allocator for pid namespaces
has been added to the -mm tree.  Its filename is
     pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pid namespaces: dynamic kmem cache allocator for pid namespaces
From: Pavel Emelianov <xemul@openvz.org>

Add kmem_cache to pid_namespace to allocate pids from.

Since both implementations expand the struct pid to carry more numerical
values each namespace should have separate cache to store pids of different
sizes.

Each kmem cache is name "pid_<NR>", where <NR> is the number of numerical ids
on the pid.  Different namespaces with same level of nesting will have same
caches.

This patch has two FIXMEs that are to be fixed after we reach the consensus
about the struct pid itself.

The first one is that the namespace to free the pid from in free_pid() must be
taken from pid.  Now the init_pid_ns is used.

The second FIXME is about the cache allocation.  When we do know how long the
object will be then we'll have to calculate this size in create_pid_cachep. 
Right now the sizeof(struct pid) value is used.

Signed-off-by: Pavel Emelianov <xemul@openvz.org>
Acked-by: Cedric Le Goater <clg@fr.ibm.com>
Acked-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Kirill Korotaev <dev@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pid_namespace.h |    1 
 kernel/pid.c                  |   70 +++++++++++++++++++++++++++++---
 2 files changed, 65 insertions(+), 6 deletions(-)

diff -puN include/linux/pid_namespace.h~pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces include/linux/pid_namespace.h
--- a/include/linux/pid_namespace.h~pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces
+++ a/include/linux/pid_namespace.h
@@ -20,6 +20,7 @@ struct pid_namespace {
 	struct pidmap pidmap[PIDMAP_ENTRIES];
 	int last_pid;
 	struct task_struct *child_reaper;
+	struct kmem_cache_t *pid_cachep;
 };
 
 extern struct pid_namespace init_pid_ns;
diff -puN kernel/pid.c~pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces kernel/pid.c
--- a/kernel/pid.c~pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces
+++ a/kernel/pid.c
@@ -32,7 +32,6 @@
 #define pid_hashfn(nr) hash_long((unsigned long)nr, pidhash_shift)
 static struct hlist_head *pid_hash;
 static int pidhash_shift;
-static struct kmem_cache *pid_cachep;
 struct pid init_struct_pid = INIT_STRUCT_PID;
 
 int pid_max = PID_MAX_DEFAULT;
@@ -176,11 +175,16 @@ static int next_pidmap(struct pid_namesp
 
 fastcall void put_pid(struct pid *pid)
 {
+	struct pid_namespace *ns;
+
 	if (!pid)
 		return;
+
+	/* FIXME - this must be the namespace this pid lives in */
+	ns = &init_pid_ns;
 	if ((atomic_read(&pid->count) == 1) ||
 	     atomic_dec_and_test(&pid->count))
-		kmem_cache_free(pid_cachep, pid);
+		kmem_cache_free(ns->pid_cachep, pid);
 }
 EXPORT_SYMBOL_GPL(put_pid);
 
@@ -208,12 +212,14 @@ struct pid *alloc_pid(void)
 	struct pid *pid;
 	enum pid_type type;
 	int nr = -1;
+	struct pid_namespace *ns;
 
-	pid = kmem_cache_alloc(pid_cachep, GFP_KERNEL);
+	ns = current->nsproxy->pid_ns;
+	pid = kmem_cache_alloc(ns->pid_cachep, GFP_KERNEL);
 	if (!pid)
 		goto out;
 
-	nr = alloc_pidmap(current->nsproxy->pid_ns);
+	nr = alloc_pidmap(ns);
 	if (nr < 0)
 		goto out_free;
 
@@ -230,7 +236,7 @@ out:
 	return pid;
 
 out_free:
-	kmem_cache_free(pid_cachep, pid);
+	kmem_cache_free(ns->pid_cachep, pid);
 	pid = NULL;
 	goto out;
 }
@@ -365,6 +371,56 @@ struct pid *find_ge_pid(int nr)
 }
 EXPORT_SYMBOL_GPL(find_get_pid);
 
+struct pid_cache {
+	int nr_ids;
+	char name[16];
+	struct kmem_cache *cachep;
+	struct list_head list;
+};
+
+static LIST_HEAD(pid_caches_lh);
+static DEFINE_MUTEX(pid_caches_mutex);
+
+/*
+ * creates the kmem cache to allocate pids from.
+ * @nr_ids: the number of numerical ids this pid will have to carry
+ */
+
+static struct kmem_cache *create_pid_cachep(int nr_ids)
+{
+	struct pid_cache *pcache;
+	struct kmem_cache *cachep;
+
+	mutex_lock(&pid_caches_mutex);
+	list_for_each_entry (pcache, &pid_caches_lh, list)
+		if (pcache->nr_ids == nr_ids)
+			goto out;
+
+	pcache = kmalloc(sizeof(struct pid_cache), GFP_KERNEL);
+	if (pcache == NULL)
+		goto err_alloc;
+
+	snprintf(pcache->name, sizeof(pcache->name), "pid_%d", nr_ids);
+	cachep = kmem_cache_create(pcache->name,
+			/* FIXME add numerical ids here */
+			sizeof(struct pid), 0, SLAB_HWCACHE_ALIGN, NULL, NULL);
+	if (cachep == NULL)
+		goto err_cachep;
+
+	pcache->nr_ids = nr_ids;
+	pcache->cachep = cachep;
+	list_add(&pcache->list, &pid_caches_lh);
+out:
+	mutex_unlock(&pid_caches_mutex);
+	return pcache->cachep;
+
+err_cachep:
+	kfree(pcache);
+err_alloc:
+	mutex_unlock(&pid_caches_mutex);
+	return NULL;
+}
+
 struct pid_namespace *copy_pid_ns(unsigned long flags, struct pid_namespace *old_ns)
 {
 	BUG_ON(!old_ns);
@@ -412,5 +468,7 @@ void __init pidmap_init(void)
 	set_bit(0, init_pid_ns.pidmap[0].page);
 	atomic_dec(&init_pid_ns.pidmap[0].nr_free);
 
-	pid_cachep = KMEM_CACHE(pid, SLAB_PANIC);
+	init_pid_ns.pid_cachep = create_pid_cachep(1);
+	if (init_pid_ns.pid_cachep == NULL)
+		panic("Can't create pid_1 cachep\n");
 }
_

Patches currently in -mm which might be from xemul@openvz.org are

make-common-helpers-for-seq_files-that-work-with-list_head-s.patch
make-input-layer-use-seq_list_xxx-helpers.patch
git-net.patch
make-proc-slabinfo-use-seq_list_xxx-helpers.patch
make-afs-use-seq_list_xxx-helpers.patch
make-crypto-api-use-seq_list_xxx-helpers.patch
make-proc-misc-use-seq_list_xxx-helpers.patch
make-proc-modules-use-seq_list_xxx-helpers.patch
make-proc-tty-drivers-use-seq_list_xxx-helpers.patch
make-proc-self-mountstats-use-seq_list_xxx-helpers.patch
make-nfs-client-use-seq_list_xxx-helpers.patch
report-that-kernel-is-tainted-if-there-were-an-oops-before.patch
remove-config_uts_ns-and-config_ipc_ns.patch
user-namespace-add-the-framework.patch
user-namespace-add-unshare.patch
mm-fix-create_new_namespaces-return-value.patch
add-a-kmem_cache-for-nsproxy-objects.patch
make-isdn-capi-use-seq_list_xxx-helpers.patch
pid-namespaces-round-up-the-api.patch
pid-namespaces-make-get_pid_ns-return-the-namespace-itself.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces.patch

From: akpm@linux-foundation.org
Subject: + slub-use-sysfses-release-mechanism-for-kmem_cache.patch added
 to -mm tree
Date: Thu, 01 May 2014 13:10:10 -0700
Message-ID: <5362aa22.2F8N+wBrJf0Authg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33637 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbaEAUKL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2014 16:10:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@ZenIV.linux.org.uk, tglx@linutronix.de, sasha.levin@oracle.com, rmk@arm.linux.org.uk, penberg@kernel.org, greg@kroah.com, bvanassche@acm.org, cl@linux.com

Subject: + slub-use-sysfses-release-mechanism-for-kmem_cache.patch added to -mm tree
To: cl@linux.com,bvanassche@acm.org,greg@kroah.com,penberg@kernel.org,rmk@arm.linux.org.uk,sasha.levin@oracle.com,tglx@linutronix.de,viro@ZenIV.linux.org.uk
From: akpm@linux-foundation.org
Date: Thu, 01 May 2014 13:10:10 -0700


The patch titled
     Subject: slub: use sysfs'es release mechanism for kmem_cache
has been added to the -mm tree.  Its filename is
     slub-use-sysfses-release-mechanism-for-kmem_cache.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slub-use-sysfses-release-mechanism-for-kmem_cache.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slub-use-sysfses-release-mechanism-for-kmem_cache.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Lameter <cl@linux.com>
Subject: slub: use sysfs'es release mechanism for kmem_cache

debugobjects warning during netfilter exit:

[  418.311956] ------------[ cut here ]------------
[  418.312449] WARNING: CPU: 6 PID: 4178 at lib/debugobjects.c:260 debug_print_object+0x8d/0xb0()
[  418.313243] ODEBUG: free active (active state 0) object type: timer_list hint: 
delayed_work_timer_fn+0x0/0x20
[  418.314038] Modules linked in:
[  418.314038] CPU: 6 PID: 4178 Comm: kworker/u16:2 Tainted: G        W 
3.11.0-next-20130906-sasha #3984
[  418.314038] Workqueue: netns cleanup_net
[  418.314038]  0000000000000104 ffff880410371a58 ffffffff841b7815 0000000000000104
[  418.314038]  ffff880410371aa8 ffff880410371a98 ffffffff8112540c ffff880410371a78
[  418.314038]  ffffffff853ea0ab ffff8800bdc68b80 ffffffff85a65c00 ffffffff87676658
[  418.314038] Call Trace:
[  418.314038]  [<ffffffff841b7815>] dump_stack+0x52/0x87
[  418.320315]  [<ffffffff8112540c>] warn_slowpath_common+0x8c/0xc0
[  418.321040]  [<ffffffff811254f6>] warn_slowpath_fmt+0x46/0x50
[  418.321101]  [<ffffffff81a60ded>] debug_print_object+0x8d/0xb0
[  418.321101]  [<ffffffff811444e0>] ? __queue_work+0x390/0x390
[  418.321101]  [<ffffffff81a61605>] __debug_check_no_obj_freed+0xa5/0x220
[  418.321101]  [<ffffffff81249e76>] ? kmem_cache_destroy+0x86/0xe0
[  418.321101]  [<ffffffff81a61795>] debug_check_no_obj_freed+0x15/0x20
[  418.321101]  [<ffffffff812874d7>] kmem_cache_free+0x197/0x340
[  418.321101]  [<ffffffff81249e76>] kmem_cache_destroy+0x86/0xe0
[  418.321101]  [<ffffffff83d5d681>] nf_conntrack_cleanup_net_list+0x131/0x170
[  418.321101]  [<ffffffff83d5ec5d>] nf_conntrack_pernet_exit+0x5d/0x70
[  418.321101]  [<ffffffff83cda1ce>] ops_exit_list+0x5e/0x70
[  418.321101]  [<ffffffff83cda80b>] cleanup_net+0xfb/0x1c0
[  418.321101]  [<ffffffff81145c28>] process_one_work+0x338/0x550
[  418.321101]  [<ffffffff81145b50>] ? process_one_work+0x260/0x550
[  418.321883]  [<ffffffff81147605>] worker_thread+0x215/0x350
[  418.321883]  [<ffffffff811473f0>] ? manage_workers+0x180/0x180
[  418.321883]  [<ffffffff81150887>] kthread+0xe7/0xf0
[  418.321883]  [<ffffffff811507a0>] ? __init_kthread_worker+0x70/0x70
[  418.321883]  [<ffffffff841c7a2c>] ret_from_fork+0x7c/0xb0
[  418.321883]  [<ffffffff811507a0>] ? __init_kthread_worker+0x70/0x70

Also during dkkokie cleanup:

[  191.835040] WARNING: CPU: 12 PID: 9725 at lib/debugobjects.c:260 debug_print_object+0x8c/0xb0()
[  191.838129] ODEBUG: free active (active state 0) object type: timer_list hint: delayed_work_timer_fn+0x0/0x20
[  191.840545] Modules linked in:
[  191.841297] CPU: 12 PID: 9725 Comm: trinity-c141 Not tainted 3.15.0-rc2-next-20140423-sasha-00018-gc4ff6c4 #408
[  191.842479]  0000000000000009 ffff88000a8ebc38 ffffffff975271f2 0000000000000001
[  191.842479]  ffff88000a8ebc88 ffff88000a8ebc78 ffffffff9415afcc ffff88000a8a3d98
[  191.842479]  ffff8801b3ad5140 ffffffff98e76200 ffffffff988dc502 ffffffff9b70c870
[  191.842479] Call Trace:
[  191.842479] dump_stack (lib/dump_stack.c:52)
[  191.842479] warn_slowpath_common (kernel/panic.c:430)
[  191.842479] warn_slowpath_fmt (kernel/panic.c:445)
[  191.842479] debug_print_object (lib/debugobjects.c:262)
[  191.842479] ? __queue_work (kernel/workqueue.c:1452)
[  191.842479] __debug_check_no_obj_freed (lib/debugobjects.c:697)
[  191.842479] debug_check_no_obj_freed (lib/debugobjects.c:726)
[  191.842479] kmem_cache_free (mm/slub.c:2689 mm/slub.c:2717)
[  191.871535] ? kmem_cache_destroy (mm/slab_common.c:363)
[  191.871535] kmem_cache_destroy (mm/slab_common.c:363)
[  191.871535] dcookie_unregister (fs/dcookies.c:302 fs/dcookies.c:343)
[  191.871535] event_buffer_release (arch/x86/oprofile/../../../drivers/oprofile/event_buffer.c:153)
[  191.871535] __fput (fs/file_table.c:217)
[  191.871535] ____fput (fs/file_table.c:253)
[  191.871535] task_work_run (kernel/task_work.c:125 (discriminator 1))
[  191.871535] do_notify_resume (include/linux/tracehook.h:196 arch/x86/kernel/signal.c:751)
[  191.871535] int_signal (arch/x86/kernel/entry_64.S:807)


Sysfs has a release mechanism. Use that to release the kmem_cache structure
if CONFIG_SYSFS is enabled.

Signed-off-by: Christoph Lameter <cl@linux.com>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Tested-by: Sasha Levin <sasha.levin@oracle.com>
Acked-by: Greg KH <greg@kroah.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slub_def.h |    4 ++++
 mm/slab.h                |    2 ++
 mm/slab_common.c         |   13 +++++++++++--
 mm/slub.c                |   28 ++++++++--------------------
 4 files changed, 25 insertions(+), 22 deletions(-)

diff -puN include/linux/slub_def.h~slub-use-sysfses-release-mechanism-for-kmem_cache include/linux/slub_def.h
--- a/include/linux/slub_def.h~slub-use-sysfses-release-mechanism-for-kmem_cache
+++ a/include/linux/slub_def.h
@@ -101,4 +101,8 @@ struct kmem_cache {
 	struct kmem_cache_node *node[MAX_NUMNODES];
 };
 
+#ifdef CONFIG_SYSFS
+#define SLAB_SUPPORTS_SYSFS
+#endif
+
 #endif /* _LINUX_SLUB_DEF_H */
diff -puN mm/slab.h~slub-use-sysfses-release-mechanism-for-kmem_cache mm/slab.h
--- a/mm/slab.h~slub-use-sysfses-release-mechanism-for-kmem_cache
+++ a/mm/slab.h
@@ -57,6 +57,7 @@ struct mem_cgroup;
 struct kmem_cache *
 __kmem_cache_alias(const char *name, size_t size, size_t align,
 		   unsigned long flags, void (*ctor)(void *));
+void sysfs_slab_remove(struct kmem_cache *);
 #else
 static inline struct kmem_cache *
 __kmem_cache_alias(const char *name, size_t size, size_t align,
@@ -91,6 +92,7 @@ __kmem_cache_alias(const char *name, siz
 #define CACHE_CREATE_MASK (SLAB_CORE_FLAGS | SLAB_DEBUG_FLAGS | SLAB_CACHE_FLAGS)
 
 int __kmem_cache_shutdown(struct kmem_cache *);
+void slab_kmem_cache_release(struct kmem_cache *);
 
 struct seq_file;
 struct file;
diff -puN mm/slab_common.c~slub-use-sysfses-release-mechanism-for-kmem_cache mm/slab_common.c
--- a/mm/slab_common.c~slub-use-sysfses-release-mechanism-for-kmem_cache
+++ a/mm/slab_common.c
@@ -323,6 +323,12 @@ static int kmem_cache_destroy_memcg_chil
 }
 #endif /* CONFIG_MEMCG_KMEM */
 
+void slab_kmem_cache_release(struct kmem_cache *s)
+{
+	kfree(s->name);
+	kmem_cache_free(kmem_cache, s);
+}
+
 void kmem_cache_destroy(struct kmem_cache *s)
 {
 	get_online_cpus();
@@ -352,8 +358,11 @@ void kmem_cache_destroy(struct kmem_cach
 		rcu_barrier();
 
 	memcg_free_cache_params(s);
-	kfree(s->name);
-	kmem_cache_free(kmem_cache, s);
+#ifdef SLAB_SUPPORTS_SYSFS
+	sysfs_slab_remove(s);
+#else
+	slab_kmem_cache_release();
+#endif
 	goto out_put_cpus;
 
 out_unlock:
diff -puN mm/slub.c~slub-use-sysfses-release-mechanism-for-kmem_cache mm/slub.c
--- a/mm/slub.c~slub-use-sysfses-release-mechanism-for-kmem_cache
+++ a/mm/slub.c
@@ -210,7 +210,6 @@ enum track_item { TRACK_ALLOC, TRACK_FRE
 #ifdef CONFIG_SYSFS
 static int sysfs_slab_add(struct kmem_cache *);
 static int sysfs_slab_alias(struct kmem_cache *, const char *);
-static void sysfs_slab_remove(struct kmem_cache *);
 static void memcg_propagate_slab_attrs(struct kmem_cache *s);
 #else
 static inline int sysfs_slab_add(struct kmem_cache *s) { return 0; }
@@ -3238,24 +3237,7 @@ static inline int kmem_cache_close(struc
 
 int __kmem_cache_shutdown(struct kmem_cache *s)
 {
-	int rc = kmem_cache_close(s);
-
-	if (!rc) {
-		/*
-		 * Since slab_attr_store may take the slab_mutex, we should
-		 * release the lock while removing the sysfs entry in order to
-		 * avoid a deadlock. Because this is pretty much the last
-		 * operation we do and the lock will be released shortly after
-		 * that in slab_common.c, we could just move sysfs_slab_remove
-		 * to a later point in common code. We should do that when we
-		 * have a common sysfs framework for all allocators.
-		 */
-		mutex_unlock(&slab_mutex);
-		sysfs_slab_remove(s);
-		mutex_lock(&slab_mutex);
-	}
-
-	return rc;
+	return kmem_cache_close(s);
 }
 
 /********************************************************************
@@ -5122,6 +5104,11 @@ static void memcg_propagate_slab_attrs(s
 #endif
 }
 
+static void kmem_cache_release(struct kobject *k)
+{
+	slab_kmem_cache_release(to_slab(k));
+}
+
 static const struct sysfs_ops slab_sysfs_ops = {
 	.show = slab_attr_show,
 	.store = slab_attr_store,
@@ -5129,6 +5116,7 @@ static const struct sysfs_ops slab_sysfs
 
 static struct kobj_type slab_ktype = {
 	.sysfs_ops = &slab_sysfs_ops,
+	.release = kmem_cache_release,
 };
 
 static int uevent_filter(struct kset *kset, struct kobject *kobj)
@@ -5255,7 +5243,7 @@ out_put_kobj:
 	goto out;
 }
 
-static void sysfs_slab_remove(struct kmem_cache *s)
+void sysfs_slab_remove(struct kmem_cache *s)
 {
 	if (slab_state < FULL)
 		/*
_

Patches currently in -mm which might be from cl@linux.com are

slub-fix-memcg_propagate_slab_attrs.patch
mm-compaction-make-isolate_freepages-start-at-pageblock-boundary.patch
slub-use-sysfses-release-mechanism-for-kmem_cache.patch
slab-fix-the-type-of-the-index-on-freelist-index-accessor.patch
mm-slubc-convert-printk-to-pr_foo.patch
mm-slubc-convert-vnsprintf-static-to-va_format.patch
slab-document-kmalloc_order.patch
mm-disable-zone_reclaim_mode-by-default.patch
mm-page_alloc-do-not-cache-reclaim-distances.patch
mm-page_alloc-do-not-cache-reclaim-distances-fix.patch
mem-hotplug-implement-get-put_online_mems.patch
slab-get_online_mems-for-kmem_cache_createdestroyshrink.patch
mm-compaction-clean-up-unused-code-lines.patch
mm-compaction-cleanup-isolate_freepages.patch
mm-compaction-cleanup-isolate_freepages-fix.patch
mm-compaction-cleanup-isolate_freepages-fix-2.patch
mm-replace-__get_cpu_var-uses-with-this_cpu_ptr.patch
linux-next.patch


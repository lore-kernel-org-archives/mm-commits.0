From: akpm@linux-foundation.org
Subject: - pid-namespaces-create-a-slab-cache-for-struct-pid_namespace.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:51:52 -0700
Message-ID: <200710192251.l9JMpqRj024218@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57158 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765217AbXJSXGN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:06:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sukadev@us.ibm.com, ebiederm@xmission.com, menage@google.com, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     pid namespaces: create a slab-cache for 'struct pid_namespace'
has been removed from the -mm tree.  Its filename was
     pid-namespaces-create-a-slab-cache-for-struct-pid_namespace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pid namespaces: create a slab-cache for 'struct pid_namespace'
From: Sukadev Bhattiprolu <sukadev@us.ibm.com>

This will help fixing memory leaks due to bad reference counting.

Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN kernel/pid.c~pid-namespaces-create-a-slab-cache-for-struct-pid_namespace kernel/pid.c
--- a/kernel/pid.c~pid-namespaces-create-a-slab-cache-for-struct-pid_namespace
+++ a/kernel/pid.c
@@ -40,6 +40,7 @@
 static struct hlist_head *pid_hash;
 static int pidhash_shift;
 struct pid init_struct_pid = INIT_STRUCT_PID;
+static struct kmem_cache *pid_ns_cachep;
 
 int pid_max = PID_MAX_DEFAULT;
 
@@ -486,7 +487,7 @@ static struct pid_namespace *create_pid_
 	struct pid_namespace *ns;
 	int i;
 
-	ns = kmalloc(sizeof(struct pid_namespace), GFP_KERNEL);
+	ns = kmem_cache_alloc(pid_ns_cachep, GFP_KERNEL);
 	if (ns == NULL)
 		goto out;
 
@@ -516,7 +517,7 @@ static struct pid_namespace *create_pid_
 out_free_map:
 	kfree(ns->pidmap[0].page);
 out_free:
-	kfree(ns);
+	kmem_cache_free(pid_ns_cachep, ns);
 out:
 	return ERR_PTR(-ENOMEM);
 }
@@ -527,7 +528,7 @@ static void destroy_pid_namespace(struct
 
 	for (i = 0; i < PIDMAP_ENTRIES; i++)
 		kfree(ns->pidmap[i].page);
-	kfree(ns);
+	kmem_cache_free(pid_ns_cachep, ns);
 }
 
 struct pid_namespace *copy_pid_ns(unsigned long flags, struct pid_namespace *old_ns)
@@ -601,4 +602,6 @@ void __init pidmap_init(void)
 	init_pid_ns.pid_cachep = create_pid_cachep(1);
 	if (init_pid_ns.pid_cachep == NULL)
 		panic("Can't create pid_1 cachep\n");
+
+	pid_ns_cachep = KMEM_CACHE(pid_namespace, SLAB_PANIC);
 }
_

Patches currently in -mm which might be from sukadev@us.ibm.com are

origin.patch

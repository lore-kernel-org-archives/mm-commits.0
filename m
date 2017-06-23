From: akpm@linux-foundation.org
Subject: [patch 6/8] slub: make sysfs file removal asynchronous
Date: Fri, 23 Jun 2017 15:08:52 -0700
Message-ID: <594d9174.N6IT3nO9Fs4WVibk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33032 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753397AbdFWWIx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jun 2017 18:08:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, tj@kernel.org, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, rostedt@goodmis.org

From: Tejun Heo <tj@kernel.org>
Subject: slub: make sysfs file removal asynchronous

bf5eb3de3847 ("slub: separate out sysfs_slab_release() from
sysfs_slab_remove()") made slub sysfs file removals synchronous to
kmem_cache shutdown.  Unfortunately, this created a possible ABBA deadlock
between slab_mutex and sysfs draining mechanism triggering the following
lockdep warning.

  ======================================================
  [ INFO: possible circular locking dependency detected ]
  4.10.0-test+ #48 Not tainted
  -------------------------------------------------------
  rmmod/1211 is trying to acquire lock:
   (s_active#120){++++.+}, at: [<ffffffff81308073>] kernfs_remove+0x23/0x40

  but task is already holding lock:
   (slab_mutex){+.+.+.}, at: [<ffffffff8120f691>] kmem_cache_destroy+0x41/0x2d0

  which lock already depends on the new lock.

  the existing dependency chain (in reverse order) is:

  -> #1 (slab_mutex){+.+.+.}:
	 lock_acquire+0xf6/0x1f0
	 __mutex_lock+0x75/0x950
	 mutex_lock_nested+0x1b/0x20
	 slab_attr_store+0x75/0xd0
	 sysfs_kf_write+0x45/0x60
	 kernfs_fop_write+0x13c/0x1c0
	 __vfs_write+0x28/0x120
	 vfs_write+0xc8/0x1e0
	 SyS_write+0x49/0xa0
	 entry_SYSCALL_64_fastpath+0x1f/0xc2

  -> #0 (s_active#120){++++.+}:
	 __lock_acquire+0x10ed/0x1260
	 lock_acquire+0xf6/0x1f0
	 __kernfs_remove+0x254/0x320
	 kernfs_remove+0x23/0x40
	 sysfs_remove_dir+0x51/0x80
	 kobject_del+0x18/0x50
	 __kmem_cache_shutdown+0x3e6/0x460
	 kmem_cache_destroy+0x1fb/0x2d0
	 kvm_exit+0x2d/0x80 [kvm]
	 vmx_exit+0x19/0xa1b [kvm_intel]
	 SyS_delete_module+0x198/0x1f0
	 entry_SYSCALL_64_fastpath+0x1f/0xc2

  other info that might help us debug this:

   Possible unsafe locking scenario:

	 CPU0                    CPU1
	 ----                    ----
    lock(slab_mutex);
				 lock(s_active#120);
				 lock(slab_mutex);
    lock(s_active#120);

   *** DEADLOCK ***

  2 locks held by rmmod/1211:
   #0:  (cpu_hotplug.dep_map){++++++}, at: [<ffffffff810a7877>] get_online_cpus+0x37/0x80
   #1:  (slab_mutex){+.+.+.}, at: [<ffffffff8120f691>] kmem_cache_destroy+0x41/0x2d0

  stack backtrace:
  CPU: 3 PID: 1211 Comm: rmmod Not tainted 4.10.0-test+ #48
  Hardware name: Hewlett-Packard HP Compaq Pro 6300 SFF/339A, BIOS K01 v02.05 05/07/2012
  Call Trace:
   dump_stack+0x86/0xc3
   print_circular_bug+0x1be/0x210
   __lock_acquire+0x10ed/0x1260
   ? 0xffffffffa0000077
   lock_acquire+0xf6/0x1f0
   ? kernfs_remove+0x23/0x40
   __kernfs_remove+0x254/0x320
   ? kernfs_remove+0x23/0x40
   ? __kernfs_remove+0x5/0x320
   kernfs_remove+0x23/0x40
   sysfs_remove_dir+0x51/0x80
   kobject_del+0x18/0x50
   __kmem_cache_shutdown+0x3e6/0x460
   kmem_cache_destroy+0x1fb/0x2d0
   kvm_exit+0x2d/0x80 [kvm]
   vmx_exit+0x19/0xa1b [kvm_intel]
   SyS_delete_module+0x198/0x1f0
   ? SyS_delete_module+0x5/0x1f0
   entry_SYSCALL_64_fastpath+0x1f/0xc2
  RIP: 0033:0x7fdf0439f487
  RSP: 002b:00007ffcd39eb6b8 EFLAGS: 00000206 ORIG_RAX: 00000000000000b0
  RAX: ffffffffffffffda RBX: 0000000000000046 RCX: 00007fdf0439f487
  RDX: 000000000000000a RSI: 0000000000000800 RDI: 000055e4e32f3258
  RBP: 0000000000000000 R08: 000000000000000a R09: 0000000000000000
  R10: 00007fdf0440ace0 R11: 0000000000000206 R12: 000055e4e32f31f0
  R13: 00007ffcd39ea6a0 R14: 0000000000000000 R15: 000055e4e32f31f0

It'd be the cleanest to deal with the issue by removing sysfs files
without holding slab_mutex before the rest of shutdown; however, given the
current code structure, it is pretty difficult to do so.  This patch punts
sysfs file removal to a work item.  Before bf5eb3de3847, the removal was
punted to a RCU delayed work item which is executed after release.  Now,
we're punting to a different work item on shutdown which still maintains
the goal removing the sysfs files earlier when destroying kmem_caches.

Link: http://lkml.kernel.org/r/20170620204512.GI21326@htj.duckdns.org
Fixes: bf5eb3de3847 ("slub: separate out sysfs_slab_release() from sysfs_slab_remove()")
Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Tested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slub_def.h |    1 
 mm/slub.c                |   40 ++++++++++++++++++++++++-------------
 2 files changed, 27 insertions(+), 14 deletions(-)

diff -puN include/linux/slub_def.h~slub-make-sysfs-file-removal-asynchronous include/linux/slub_def.h
--- a/include/linux/slub_def.h~slub-make-sysfs-file-removal-asynchronous
+++ a/include/linux/slub_def.h
@@ -84,6 +84,7 @@ struct kmem_cache {
 	int red_left_pad;	/* Left redzone padding size */
 #ifdef CONFIG_SYSFS
 	struct kobject kobj;	/* For sysfs */
+	struct work_struct kobj_remove_work;
 #endif
 #ifdef CONFIG_MEMCG
 	struct memcg_cache_params memcg_params;
diff -puN mm/slub.c~slub-make-sysfs-file-removal-asynchronous mm/slub.c
--- a/mm/slub.c~slub-make-sysfs-file-removal-asynchronous
+++ a/mm/slub.c
@@ -5625,6 +5625,28 @@ static char *create_unique_id(struct kme
 	return name;
 }
 
+static void sysfs_slab_remove_workfn(struct work_struct *work)
+{
+	struct kmem_cache *s =
+		container_of(work, struct kmem_cache, kobj_remove_work);
+
+	if (!s->kobj.state_in_sysfs)
+		/*
+		 * For a memcg cache, this may be called during
+		 * deactivation and again on shutdown.  Remove only once.
+		 * A cache is never shut down before deactivation is
+		 * complete, so no need to worry about synchronization.
+		 */
+		return;
+
+#ifdef CONFIG_MEMCG
+	kset_unregister(s->memcg_kset);
+#endif
+	kobject_uevent(&s->kobj, KOBJ_REMOVE);
+	kobject_del(&s->kobj);
+	kobject_put(&s->kobj);
+}
+
 static int sysfs_slab_add(struct kmem_cache *s)
 {
 	int err;
@@ -5632,6 +5654,8 @@ static int sysfs_slab_add(struct kmem_ca
 	struct kset *kset = cache_kset(s);
 	int unmergeable = slab_unmergeable(s);
 
+	INIT_WORK(&s->kobj_remove_work, sysfs_slab_remove_workfn);
+
 	if (!kset) {
 		kobject_init(&s->kobj, &slab_ktype);
 		return 0;
@@ -5695,20 +5719,8 @@ static void sysfs_slab_remove(struct kme
 		 */
 		return;
 
-	if (!s->kobj.state_in_sysfs)
-		/*
-		 * For a memcg cache, this may be called during
-		 * deactivation and again on shutdown.  Remove only once.
-		 * A cache is never shut down before deactivation is
-		 * complete, so no need to worry about synchronization.
-		 */
-		return;

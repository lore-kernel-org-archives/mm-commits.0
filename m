From: akpm@linux-foundation.org
Subject: [merged] slub-drop-mutex-before-deleting-sysfs-entry.patch removed from -mm tree
Date: Wed, 19 Dec 2012 12:42:28 -0800
Message-ID: <20121219204229.76247200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:41681 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755326Ab2LSUmd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 15:42:33 -0500
Received: by mail-la0-f74.google.com with SMTP id v3so121336lag.5
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 12:42:31 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glommer@parallels.com, cl@linux-foundation.org, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, penberg@kernel.org, rientjes@google.com, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: drop mutex before deleting sysfs entry
has been removed from the -mm tree.  Its filename was
     slub-drop-mutex-before-deleting-sysfs-entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Glauber Costa <glommer@parallels.com>
Subject: slub: drop mutex before deleting sysfs entry

Sasha Levin recently reported a lockdep problem resulting from the new
attribute propagation introduced by kmemcg series.  In short, slab_mutex
will be called from within the sysfs attribute store function.  This will
create a dependency, that will later be held backwards when a cache is
destroyed - since destruction occurs with the slab_mutex held, and then
calls in to the sysfs directory removal function.

In this patch, I propose to adopt a strategy close to what
__kmem_cache_create does before calling sysfs_slab_add, and release the
lock before the call to sysfs_slab_remove.  This is pretty much the last
operation in the kmem_cache_shutdown() path, so we could do better by
splitting this and moving this call alone to later on.  This will fit
nicely when sysfs handling is consistent between all caches, but will look
weird now.

Lockdep info:

[  351.935003] ======================================================
[  351.937693] [ INFO: possible circular locking dependency detected ]
[  351.939720] 3.7.0-rc4-next-20121106-sasha-00008-g353b62f #117 Tainted: G        W
[  351.942444] -------------------------------------------------------
[  351.943528] trinity-child13/6961 is trying to acquire lock:
[  351.943528]  (s_active#43){++++.+}, at: [<ffffffff812f9e11>] sysfs_addrm_finish+0x31/0x60
[  351.943528]
[  351.943528] but task is already holding lock:
[  351.943528]  (slab_mutex){+.+.+.}, at: [<ffffffff81228a42>] kmem_cache_destroy+0x22/0xe0
[  351.943528]
[  351.943528] which lock already depends on the new lock.
[  351.943528]
[  351.943528]
[  351.943528] the existing dependency chain (in reverse order) is:
[  351.943528]
-> #1 (slab_mutex){+.+.+.}:
[  351.960334]        [<ffffffff8118536a>] lock_acquire+0x1aa/0x240
[  351.960334]        [<ffffffff83a944d9>] __mutex_lock_common+0x59/0x5a0
[  351.960334]        [<ffffffff83a94a5f>] mutex_lock_nested+0x3f/0x50
[  351.960334]        [<ffffffff81256a6e>] slab_attr_store+0xde/0x110
[  351.960334]        [<ffffffff812f820a>] sysfs_write_file+0xfa/0x150
[  351.960334]        [<ffffffff8127a220>] vfs_write+0xb0/0x180
[  351.960334]        [<ffffffff8127a540>] sys_pwrite64+0x60/0xb0
[  351.960334]        [<ffffffff83a99298>] tracesys+0xe1/0xe6
[  351.960334]
-> #0 (s_active#43){++++.+}:
[  351.960334]        [<ffffffff811825af>] __lock_acquire+0x14df/0x1ca0
[  351.960334]        [<ffffffff8118536a>] lock_acquire+0x1aa/0x240
[  351.960334]        [<ffffffff812f9272>] sysfs_deactivate+0x122/0x1a0
[  351.960334]        [<ffffffff812f9e11>] sysfs_addrm_finish+0x31/0x60
[  351.960334]        [<ffffffff812fa369>] sysfs_remove_dir+0x89/0xd0
[  351.960334]        [<ffffffff819e1d96>] kobject_del+0x16/0x40
[  351.960334]        [<ffffffff8125ed40>] __kmem_cache_shutdown+0x40/0x60
[  351.960334]        [<ffffffff81228a60>] kmem_cache_destroy+0x40/0xe0
[  351.960334]        [<ffffffff82b21058>] mon_text_release+0x78/0xe0
[  351.960334]        [<ffffffff8127b3b2>] __fput+0x122/0x2d0
[  351.960334]        [<ffffffff8127b569>] ____fput+0x9/0x10
[  351.960334]        [<ffffffff81131b4e>] task_work_run+0xbe/0x100
[  351.960334]        [<ffffffff81110742>] do_exit+0x432/0xbd0
[  351.960334]        [<ffffffff81110fa4>] do_group_exit+0x84/0xd0
[  351.960334]        [<ffffffff8112431d>] get_signal_to_deliver+0x81d/0x930
[  351.960334]        [<ffffffff8106d5aa>] do_signal+0x3a/0x950
[  351.960334]        [<ffffffff8106df1e>] do_notify_resume+0x3e/0x90
[  351.960334]        [<ffffffff83a993aa>] int_signal+0x12/0x17
[  351.960334]
[  351.960334] other info that might help us debug this:
[  351.960334]
[  351.960334]  Possible unsafe locking scenario:
[  351.960334]
[  351.960334]        CPU0                    CPU1
[  351.960334]        ----                    ----
[  351.960334]   lock(slab_mutex);
[  351.960334]                                lock(s_active#43);
[  351.960334]                                lock(slab_mutex);
[  351.960334]   lock(s_active#43);
[  351.960334]
[  351.960334]  *** DEADLOCK ***
[  351.960334]
[  351.960334] 2 locks held by trinity-child13/6961:
[  351.960334]  #0:  (mon_lock){+.+.+.}, at: [<ffffffff82b21005>] mon_text_release+0x25/0xe0
[  351.960334]  #1:  (slab_mutex){+.+.+.}, at: [<ffffffff81228a42>] kmem_cache_destroy+0x22/0xe0
[  351.960334]
[  351.960334] stack backtrace:
[  351.960334] Pid: 6961, comm: trinity-child13 Tainted: G        W    3.7.0-rc4-next-20121106-sasha-00008-g353b62f #117
[  351.960334] Call Trace:
[  351.960334]  [<ffffffff83a3c736>] print_circular_bug+0x1fb/0x20c
[  351.960334]  [<ffffffff811825af>] __lock_acquire+0x14df/0x1ca0
[  351.960334]  [<ffffffff81184045>] ? debug_check_no_locks_freed+0x185/0x1e0
[  351.960334]  [<ffffffff8118536a>] lock_acquire+0x1aa/0x240
[  351.960334]  [<ffffffff812f9e11>] ? sysfs_addrm_finish+0x31/0x60
[  351.960334]  [<ffffffff812f9272>] sysfs_deactivate+0x122/0x1a0
[  351.960334]  [<ffffffff812f9e11>] ? sysfs_addrm_finish+0x31/0x60
[  351.960334]  [<ffffffff812f9e11>] sysfs_addrm_finish+0x31/0x60
[  351.960334]  [<ffffffff812fa369>] sysfs_remove_dir+0x89/0xd0
[  351.960334]  [<ffffffff819e1d96>] kobject_del+0x16/0x40
[  351.960334]  [<ffffffff8125ed40>] __kmem_cache_shutdown+0x40/0x60
[  351.960334]  [<ffffffff81228a60>] kmem_cache_destroy+0x40/0xe0
[  351.960334]  [<ffffffff82b21058>] mon_text_release+0x78/0xe0
[  351.960334]  [<ffffffff8127b3b2>] __fput+0x122/0x2d0
[  351.960334]  [<ffffffff8127b569>] ____fput+0x9/0x10
[  351.960334]  [<ffffffff81131b4e>] task_work_run+0xbe/0x100
[  351.960334]  [<ffffffff81110742>] do_exit+0x432/0xbd0
[  351.960334]  [<ffffffff811243b9>] ? get_signal_to_deliver+0x8b9/0x930
[  351.960334]  [<ffffffff8117d402>] ? get_lock_stats+0x22/0x70
[  351.960334]  [<ffffffff8117d48e>] ? put_lock_stats.isra.16+0xe/0x40
[  351.960334]  [<ffffffff83a977fb>] ? _raw_spin_unlock_irq+0x2b/0x80
[  351.960334]  [<ffffffff81110fa4>] do_group_exit+0x84/0xd0
[  351.960334]  [<ffffffff8112431d>] get_signal_to_deliver+0x81d/0x930
[  351.960334]  [<ffffffff8117d48e>] ? put_lock_stats.isra.16+0xe/0x40
[  351.960334]  [<ffffffff8106d5aa>] do_signal+0x3a/0x950
[  351.960334]  [<ffffffff811c8b33>] ? rcu_cleanup_after_idle+0x23/0x170
[  351.960334]  [<ffffffff811cc1c4>] ? rcu_eqs_exit_common+0x64/0x3a0
[  351.960334]  [<ffffffff811caa5d>] ? rcu_user_enter+0x10d/0x140
[  351.960334]  [<ffffffff811cc8d5>] ? rcu_user_exit+0xc5/0xf0
[  351.960334]  [<ffffffff8106df1e>] do_notify_resume+0x3e/0x90
[  351.960334]  [<ffffffff83a993aa>] int_signal+0x12/0x17

Signed-off-by: Glauber Costa <glommer@parallels.com>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@kernel.org>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff -puN mm/slub.c~slub-drop-mutex-before-deleting-sysfs-entry mm/slub.c
--- a/mm/slub.c~slub-drop-mutex-before-deleting-sysfs-entry
+++ a/mm/slub.c
@@ -3153,8 +3153,19 @@ int __kmem_cache_shutdown(struct kmem_ca
 {
 	int rc = kmem_cache_close(s);
 
-	if (!rc)
+	if (!rc) {
+		/*
+		 * We do the same lock strategy around sysfs_slab_add, see
+		 * __kmem_cache_create. Because this is pretty much the last
+		 * operation we do and the lock will be released shortly after
+		 * that in slab_common.c, we could just move sysfs_slab_remove
+		 * to a later point in common code. We should do that when we
+		 * have a common sysfs framework for all allocators.
+		 */
+		mutex_unlock(&slab_mutex);
 		sysfs_slab_remove(s);
+		mutex_lock(&slab_mutex);
+	}
 
 	return rc;
 }
_

Patches currently in -mm which might be from glommer@parallels.com are

origin.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch


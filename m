From: akpm@linux-foundation.org
Subject: [merged] memcg-fix-false-positive-vm_bug-on-non-smp.patch removed from -mm tree
Date: Mon, 29 Nov 2010 11:50:54 -0800
Message-ID: <201011291951.oATJpN82007286@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41849 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751756Ab0K2Tvg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Nov 2010 14:51:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill@shutemov.name, balbir@linux.vnet.ibm.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujtisu.com, mm-commits@vger.kernel.org


The patch titled
     memcg: fix false positive VM_BUG on non-SMP
has been removed from the -mm tree.  Its filename was
     memcg-fix-false-positive-vm_bug-on-non-smp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: fix false positive VM_BUG on non-SMP
From: Kirill A. Shutemov <kirill@shutemov.name>

kernel BUG at mm/memcontrol.c:2155!
invalid opcode: 0000 [#1]
last sysfs file:

Pid: 18, comm: sh Not tainted 2.6.37-rc3 #3 /Bochs
EIP: 0060:[<c10731b2>] EFLAGS: 00000246 CPU: 0
EIP is at mem_cgroup_move_account+0xe2/0xf0
EAX: 00000004 EBX: c6f931d4 ECX: c681c300 EDX: c681c000
ESI: c681c300 EDI: ffffffea EBP: c681c000 ESP: c46f3e30
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process sh (pid: 18, ti=c46f2000 task=c6826e60 task.ti=c46f2000)
Stack:
 00000155 c681c000 0805f000 c46ee180 c46f3e5c c7058820 c1074d37 00000000
 08060000 c46db9a0 c46ec080 c7058820 0805f000 08060000 c46f3e98 c1074c50
 c106c75e c46f3e98 c46ec080 08060000 0805ffff c46db9a0 c46f3e98 c46e0340
Call Trace:
 [<c1074d37>] ? mem_cgroup_move_charge_pte_range+0xe7/0x130
 [<c1074c50>] ? mem_cgroup_move_charge_pte_range+0x0/0x130
 [<c106c75e>] ? walk_page_range+0xee/0x1d0
 [<c10725d6>] ? mem_cgroup_move_task+0x66/0x90
 [<c1074c50>] ? mem_cgroup_move_charge_pte_range+0x0/0x130
 [<c1072570>] ? mem_cgroup_move_task+0x0/0x90
 [<c1042616>] ? cgroup_attach_task+0x136/0x200
 [<c1042878>] ? cgroup_tasks_write+0x48/0xc0
 [<c1041e9e>] ? cgroup_file_write+0xde/0x220
 [<c101398d>] ? do_page_fault+0x17d/0x3f0
 [<c108a79d>] ? alloc_fd+0x2d/0xd0
 [<c1041dc0>] ? cgroup_file_write+0x0/0x220
 [<c1077ba2>] ? vfs_write+0x92/0xc0
 [<c1077c81>] ? sys_write+0x41/0x70
 [<c1140e3d>] ? syscall_call+0x7/0xb
Code: 03 00 74 09 8b 44 24 04 e8 1c f1 ff ff 89 73 04 8d 86 b0 00 00 00 b9 01 00 00 00 89 da 31 ff e8 65 f5 ff ff e9 4d ff ff ff 0f 0b <0f> 0b 0f 0b 0f 0b 90 8d b4 26 00 00 00 00 83 ec 10 8b 0d f4 e3
EIP: [<c10731b2>] mem_cgroup_move_account+0xe2/0xf0 SS:ESP 0068:c46f3e30
---[ end trace 7daa1582159b6532 ]---

lock_page_cgroup and unlock_page_cgroup are implemented using
bit_spinlock.  bit_spinlock doesn't touch the bit if we are on non-SMP
machine, so we can't use the bit to check whether the lock was taken.

Let's introduce is_page_cgroup_locked based on bit_spin_is_locked instead
of PageCgroupLocked to fix it.

[akpm@linux-foundation.org: s/is_page_cgroup_locked/page_is_cgroup_locked/]
Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujtisu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_cgroup.h |    7 +++++--
 mm/memcontrol.c             |    2 +-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff -puN include/linux/page_cgroup.h~memcg-fix-false-positive-vm_bug-on-non-smp include/linux/page_cgroup.h
--- a/include/linux/page_cgroup.h~memcg-fix-false-positive-vm_bug-on-non-smp
+++ a/include/linux/page_cgroup.h
@@ -59,8 +59,6 @@ static inline void ClearPageCgroup##unam
 static inline int TestClearPageCgroup##uname(struct page_cgroup *pc)	\
 	{ return test_and_clear_bit(PCG_##lname, &pc->flags);  }
 
-TESTPCGFLAG(Locked, LOCK)
-
 /* Cache flag is set only once (at allocation) */
 TESTPCGFLAG(Cache, CACHE)
 CLEARPCGFLAG(Cache, CACHE)
@@ -104,6 +102,11 @@ static inline void unlock_page_cgroup(st
 	bit_spin_unlock(PCG_LOCK, &pc->flags);
 }
 
+static inline int page_is_cgroup_locked(struct page_cgroup *pc)
+{
+	return bit_spin_is_locked(PCG_LOCK, &pc->flags);
+}
+
 #else /* CONFIG_CGROUP_MEM_RES_CTLR */
 struct page_cgroup;
 
diff -puN mm/memcontrol.c~memcg-fix-false-positive-vm_bug-on-non-smp mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-false-positive-vm_bug-on-non-smp
+++ a/mm/memcontrol.c
@@ -2152,7 +2152,7 @@ static void __mem_cgroup_move_account(st
 {
 	VM_BUG_ON(from == to);
 	VM_BUG_ON(PageLRU(pc->page));
-	VM_BUG_ON(!PageCgroupLocked(pc));
+	VM_BUG_ON(!page_is_cgroup_locked(pc));
 	VM_BUG_ON(!PageCgroupUsed(pc));
 	VM_BUG_ON(pc->mem_cgroup != from);
 
_

Patches currently in -mm which might be from kirill@shutemov.name are

origin.patch
linux-next.patch


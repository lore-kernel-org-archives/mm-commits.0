From: akpm@linux-foundation.org
Subject: [merged] ocfs2-check-if-cluster-name-exists-before-deref.patch
 removed from -mm tree
Date: Mon, 31 Mar 2014 11:21:17 -0700
Message-ID: <5339b21d.9aEglfeMSGmzUyY6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46751 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287AbaCaSVS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 31 Mar 2014 14:21:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rgoldwyn@suse.com, mfasheh@suse.de, jlbec@evilplan.org, sasha.levin@oracle.com

Subject: [merged] ocfs2-check-if-cluster-name-exists-before-deref.patch removed from -mm tree
To: sasha.levin@oracle.com,jlbec@evilplan.org,mfasheh@suse.de,rgoldwyn@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 31 Mar 2014 11:21:17 -0700


The patch titled
     Subject: ocfs2: check if cluster name exists before deref
has been removed from the -mm tree.  Its filename was
     ocfs2-check-if-cluster-name-exists-before-deref.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sasha Levin <sasha.levin@oracle.com>
Subject: ocfs2: check if cluster name exists before deref

Commit c74a3bdd9b "ocfs2: add clustername to cluster connection" is trying
to strlcpy a string which was explicitly passed as NULL in the very same
patch, triggering a NULL ptr deref.

[  640.225193] BUG: unable to handle kernel NULL pointer dereference at           (null)
[  640.230224] IP: strlcpy (lib/string.c:388 lib/string.c:151)
[  640.230224] PGD 82a93a067 PUD 82a93b067 PMD 0
[  640.230224] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[  640.230224] Dumping ftrace buffer:
[  640.230224]    (ftrace buffer empty)
[  640.230224] Modules linked in:
[  640.230224] CPU: 19 PID: 19426 Comm: trinity-c19 Tainted: G        W     3.14.0-rc7-next-20140325-sasha-00014-g9476368-dirty #274
[  640.230224] task: ffff88082bc53000 ti: ffff88082b674000 task.ti: ffff88082b674000
[  640.230224] RIP:  strlcpy (lib/string.c:388 lib/string.c:151)
[  640.230224] RSP: 0018:ffff88082b675d88  EFLAGS: 00010296
[  640.230224] RAX: 0000000000000007 RBX: ffffffff8853b260 RCX: 000000006f6d7366
[  640.230224] RDX: 0000000000000011 RSI: 0000000000000000 RDI: ffff88052bcd3518
[  640.230224] RBP: ffff88082b675da8 R08: 00000000746e756f R09: 0000000000000000
[  640.230224] R10: ffff88052bcd34d0 R11: 0000000000000000 R12: ffff88052bcd3518
[  640.230224] R13: ffff88052c003fb8 R14: ffff88052bcd34d0 R15: 00000000ffffffea
[  640.230224] FS:  00007f04ae7a6700(0000) GS:ffff88052cc00000(0000) knlGS:0000000000000000
[  640.230224] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  640.230224] CR2: 0000000000000000 CR3: 000000082115b000 CR4: 00000000000006a0
[  640.230224] DR0: 0000000000698000 DR1: 0000000000698000 DR2: 0000000000000000
[  640.230224] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000602
[  640.230224] Stack:
[  640.230224]  ffffffff86b3c260 ffffffff8853b260 ffffffff86b3c260 ffff88052c003fb8
[  640.230224]  ffff88082b675df8 ffffffff818a3a5d 0000000000000000 0000000700000000
[  640.230224]  0000000000000282 ffff88052c003f48 ffff88003e6b01a0 ffff88052c0f81a0
[  640.230224] Call Trace:
[  640.230224]  ocfs2_cluster_connect (fs/ocfs2/stackglue.c:350)
[  640.230224]  ocfs2_cluster_connect_agnostic (fs/ocfs2/stackglue.c:396)
[  640.230224]  ? ocfs2_control_open (fs/ocfs2/dlmfs/userdlm.c:660)
[  640.230224]  user_dlm_register (fs/ocfs2/dlmfs/userdlm.c:679)
[  640.230224]  ? dlmfs_get_inode (fs/ocfs2/dlmfs/dlmfs.c:468)
[  640.230224]  dlmfs_mkdir (fs/ocfs2/dlmfs/dlmfs.c:503)
[  640.230224]  ? security_inode_permission (security/security.c:555)
[  640.230224]  ? __inode_permission (fs/namei.c:414)
[  640.230224]  vfs_mkdir (fs/namei.c:3467)
[  640.230224]  SyS_mkdirat (fs/namei.c:3488 fs/namei.c:3472)
[  640.230224]  tracesys (arch/x86/kernel/entry_64.S:749)
[  640.230224] Code: 41 c6 44 1d 00 00 48 83 c4 08 5b 4c 89 e0 41 5c 41 5d 5d c3 0f 1f 80 00 00 00 00 55 48 89 e5 41 55 41 54 49 89 fc 53 48 83 ec 08 <80> 3e 00 74 1c 48 89 f0 0f 1f 84 00 00 00 00 00 48 83 c0 01 80
[  640.230224] RIP  strlcpy (lib/string.c:388 lib/string.c:151)
[  640.230224]  RSP <ffff88082b675d88>
[  640.230224] CR2: 0000000000000000

akpm: this patch probably disables the feature.  A temporary thing to
avoid triviel oopses.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/stackglue.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/ocfs2/stackglue.c~ocfs2-check-if-cluster-name-exists-before-deref fs/ocfs2/stackglue.c
--- a/fs/ocfs2/stackglue.c~ocfs2-check-if-cluster-name-exists-before-deref
+++ a/fs/ocfs2/stackglue.c
@@ -346,7 +346,9 @@ int ocfs2_cluster_connect(const char *st
 
 	strlcpy(new_conn->cc_name, group, GROUP_NAME_MAX + 1);
 	new_conn->cc_namelen = grouplen;
-	strlcpy(new_conn->cc_cluster_name, cluster_name, CLUSTER_NAME_MAX + 1);
+	if (cluster_name_len)
+		strlcpy(new_conn->cc_cluster_name, cluster_name,
+			CLUSTER_NAME_MAX + 1);
 	new_conn->cc_cluster_name_len = cluster_name_len;
 	new_conn->cc_recovery_handler = recovery_handler;
 	new_conn->cc_recovery_data = recovery_data;
_

Patches currently in -mm which might be from sasha.levin@oracle.com are

watchdog-trigger-all-cpu-backtrace-when-locked-up-and-going-to-panic.patch
lib-radix_tree-tree-node-interface-fix.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v2.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
mm-add-pte_present-check-on-existing-hugetlb_entry-callbacks.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-remove-read_cache_page_async.patch
mmnuma-reorganize-change_pmd_range.patch
mmnuma-reorganize-change_pmd_range-fix.patch
mm-numa-recheck-for-transhuge-pages-under-lock-during-protection-changes.patch
mm-numa-recheck-for-transhuge-pages-under-lock-during-protection-changes-fix.patch
move-mmu-notifier-call-from-change_protection-to-change_pmd_range.patch
mm-per-thread-vma-caching-fix-5.patch
mm-try_to_unmap_cluster-should-lock_page-before-mlocking.patch
zram-delete-zram_init_device-fix.patch
zram-move-comp-allocation-out-of-init_lock.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch


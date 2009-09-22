From: akpm@linux-foundation.org
Subject: [merged] ksm-unmerge-is-an-origin-of-ooms.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:40:25 -0700
Message-ID: <200909222040.n8MKePBs005545@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38764 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752602AbZIVUlE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:41:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh.dickins@tiscali.co.uk, aarcange@redhat.com, ieidus@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ksm: unmerge is an origin of OOMs
has been removed from the -mm tree.  Its filename was
     ksm-unmerge-is-an-origin-of-ooms.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ksm: unmerge is an origin of OOMs
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

Just as the swapoff system call allocates many pages of RAM to various
processes, perhaps triggering OOM, so "echo 2 >/sys/kernel/mm/ksm/run"
(unmerge) is liable to allocate many pages of RAM to various processes,
perhaps triggering OOM; and each is normally run from a modest admin
process (swapoff or shell), easily repeated until it succeeds.

So treat unmerge_and_remove_all_rmap_items() in the same way that we treat
try_to_unuse(): generalize PF_SWAPOFF to PF_OOM_ORIGIN, and bracket both
with that, to ask the OOM killer to kill them first, to prevent them from
spawning more and more OOM kills.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Acked-by: Izik Eidus <ieidus@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    2 +-
 mm/ksm.c              |    2 ++
 mm/oom_kill.c         |    2 +-
 mm/swapfile.c         |    4 ++--
 4 files changed, 6 insertions(+), 4 deletions(-)

diff -puN include/linux/sched.h~ksm-unmerge-is-an-origin-of-ooms include/linux/sched.h
--- a/include/linux/sched.h~ksm-unmerge-is-an-origin-of-ooms
+++ a/include/linux/sched.h
@@ -1720,7 +1720,7 @@ extern cputime_t task_gtime(struct task_
 #define PF_FROZEN	0x00010000	/* frozen for system suspend */
 #define PF_FSTRANS	0x00020000	/* inside a filesystem transaction */
 #define PF_KSWAPD	0x00040000	/* I am kswapd */
-#define PF_SWAPOFF	0x00080000	/* I am in swapoff */
+#define PF_OOM_ORIGIN	0x00080000	/* Allocating much memory to others */
 #define PF_LESS_THROTTLE 0x00100000	/* Throttle me less: I clean memory */
 #define PF_KTHREAD	0x00200000	/* I am a kernel thread */
 #define PF_RANDOMIZE	0x00400000	/* randomize virtual address space */
diff -puN mm/ksm.c~ksm-unmerge-is-an-origin-of-ooms mm/ksm.c
--- a/mm/ksm.c~ksm-unmerge-is-an-origin-of-ooms
+++ a/mm/ksm.c
@@ -1557,7 +1557,9 @@ static ssize_t run_store(struct kobject 
 	if (ksm_run != flags) {
 		ksm_run = flags;
 		if (flags & KSM_RUN_UNMERGE) {
+			current->flags |= PF_OOM_ORIGIN;
 			err = unmerge_and_remove_all_rmap_items();
+			current->flags &= ~PF_OOM_ORIGIN;
 			if (err) {
 				ksm_run = KSM_RUN_STOP;
 				count = err;
diff -puN mm/oom_kill.c~ksm-unmerge-is-an-origin-of-ooms mm/oom_kill.c
--- a/mm/oom_kill.c~ksm-unmerge-is-an-origin-of-ooms
+++ a/mm/oom_kill.c
@@ -79,7 +79,7 @@ unsigned long badness(struct task_struct
 	/*
 	 * swapoff can easily use up all memory, so kill those first.
 	 */
-	if (p->flags & PF_SWAPOFF)
+	if (p->flags & PF_OOM_ORIGIN)
 		return ULONG_MAX;
 
 	/*
diff -puN mm/swapfile.c~ksm-unmerge-is-an-origin-of-ooms mm/swapfile.c
--- a/mm/swapfile.c~ksm-unmerge-is-an-origin-of-ooms
+++ a/mm/swapfile.c
@@ -1575,9 +1575,9 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	p->flags &= ~SWP_WRITEOK;
 	spin_unlock(&swap_lock);
 
-	current->flags |= PF_SWAPOFF;
+	current->flags |= PF_OOM_ORIGIN;
 	err = try_to_unuse(type);
-	current->flags &= ~PF_SWAPOFF;
+	current->flags &= ~PF_OOM_ORIGIN;
 
 	if (err) {
 		/* re-insert swap space back into swap_list */
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

origin.patch
linux-next.patch
vfs-optimize-touch_time-too.patch
vfs-seq_file-add-helpers-for-data-filling.patch
fs-new-truncate-helpers.patch
fs-use-new-truncate-helpers.patch
fs-introduce-new-truncate-sequence.patch
fs-convert-simple-fs-to-new-truncate.patch
tmpfs-convert-to-use-the-new-truncate-convention.patch
ext2-convert-to-use-the-new-truncate-convention.patch
fat-convert-to-use-the-new-truncate-convention.patch
btrfs-convert-to-use-the-new-truncate-convention.patch
jfs-convert-to-use-the-new-truncate-convention.patch
udf-convert-to-use-the-new-truncate-convention.patch
minix-convert-to-use-the-new-truncate-convention.patch
getrusage-fill-ru_maxrss-value.patch
walk-system-ram-range-fix.patch
ramfs-move-ramfs_magic-to-include-linux-magich.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
prio_tree-debugging-patch.patch


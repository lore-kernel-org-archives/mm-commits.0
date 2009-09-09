From: akpm@linux-foundation.org
Subject: + ksm-unmerge-is-an-origin-of-ooms.patch added to -mm tree
Date: Tue, 08 Sep 2009 22:40:48 -0700
Message-ID: <200909090540.n895emRr022851@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41528 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750778AbZIIFlC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2009 01:41:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh.dickins@tiscali.co.uk, aarcange@redhat.com, ieidus@redhat.com


The patch titled
     ksm: unmerge is an origin of OOMs
has been added to the -mm tree.  Its filename is
     ksm-unmerge-is-an-origin-of-ooms.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1723,7 +1723,7 @@ extern cputime_t task_gtime(struct task_
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
@@ -1564,7 +1564,9 @@ static ssize_t run_store(struct kobject 
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
@@ -1573,9 +1573,9 @@ SYSCALL_DEFINE1(swapoff, const char __us
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

linux-next.patch
acpi-fix-null-bug-for-hid-uid-string-2.patch
vfs-optimize-touch_time-too-fix.patch
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
mm-oom-analysis-add-shmem-vmstat.patch
ksm-add-mmu_notifier-set_pte_at_notify.patch
ksm-first-tidy-up-madvise_vma.patch
ksm-define-madv_mergeable-and-madv_unmergeable.patch
ksm-the-mm-interface-to-ksm.patch
ksm-no-debug-in-page_dup_rmap.patch
ksm-identify-pageksm-pages.patch
ksm-kernel-samepage-merging.patch
ksm-prevent-mremap-move-poisoning.patch
ksm-change-copyright-message.patch
ksm-change-ksm-nice-level-to-be-5.patch
ksm-rename-kernel_pages_allocated.patch
ksm-move-pages_sharing-updates.patch
ksm-pages_unshared-and-pages_volatile.patch
ksm-break-cow-once-unshared.patch
ksm-keep-quiet-while-list-empty.patch
ksm-five-little-cleanups.patch
ksm-fix-endless-loop-on-oom.patch
ksm-distribute-remove_mm_from_lists.patch
ksm-fix-oom-deadlock.patch
ksm-fix-deadlock-with-munlock-in-exit_mmap.patch
ksm-sysfs-and-defaults.patch
ksm-add-some-documentation.patch
ksm-remove-vm_mergeable_flags.patch
ksm-clean-up-obsolete-references.patch
ksm-unmerge-is-an-origin-of-ooms.patch
ksm-mremap-use-err-from-ksm_madvise.patch
mm-add_to_swap_cache-must-not-sleep.patch
mm-add_to_swap_cache-does-not-return-eexist.patch
mm-includecheck-fix-for-mm-shmemc.patch
mm-introduce-page_lru_base_type-fix.patch
mm-replace-various-uses-of-num_physpages-by-totalram_pages.patch
hugetlbfs-allow-the-creation-of-files-suitable-for-map_private-on-the-vfs-internal-mount.patch
hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions.patch
hugetlb-add-map_hugetlb-example.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
ramfs-move-ramfs_magic-to-include-linux-magich.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
prio_tree-debugging-patch.patch


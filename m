From: akpm@linux-foundation.org
Subject: + ipc-shmc-fix-undefined-reference-to-user_shm_unlock.patch added to -mm tree
Date: Sun, 13 Sep 2009 16:02:31 -0700
Message-ID: <200909132302.n8DN2V85009262@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35089 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751352AbZIMXDq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 Sep 2009 19:03:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh.dickins@tiscali.co.uk, stable@kernel.org, vapier@gentoo.org


The patch titled
     ipc/shm.c: fix undefined reference to user_shm_unlock
has been added to the -mm tree.  Its filename is
     ipc-shmc-fix-undefined-reference-to-user_shm_unlock.patch

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
Subject: ipc/shm.c: fix undefined reference to user_shm_unlock
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

My 353d5c30c666580347515da609dd74a2b8e9b828 "mm: fix hugetlb bug due to
user_shm_unlock call" broke the CONFIG_SYSVIPC !CONFIG_MMU build of both
2.6.31 and 2.6.30.6: "undefined reference to `user_shm_unlock'".

gcc didn't understand my comment!  so couldn't figure out to optimize away
user_shm_unlock() from the error path in the hugetlb-less case, as it does
elsewhere.  Help it to do so, in a language it understands.

Reported-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: <stable@kernel.org>		[2.6.30.x, 2.6.31.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN ipc/shm.c~ipc-shmc-fix-undefined-reference-to-user_shm_unlock ipc/shm.c
--- a/ipc/shm.c~ipc-shmc-fix-undefined-reference-to-user_shm_unlock
+++ a/ipc/shm.c
@@ -410,7 +410,7 @@ static int newseg(struct ipc_namespace *
 	return error;
 
 no_id:
-	if (shp->mlock_user)	/* shmflg & SHM_HUGETLB case */
+	if (is_file_hugepages(file) && shp->mlock_user)
 		user_shm_unlock(size, shp->mlock_user);
 	fput(file);
 no_file:
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

ipc-shmc-fix-undefined-reference-to-user_shm_unlock.patch
linux-next.patch
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
vfs-seq_file-add-helpers-for-data-filling.patch
vfs-revert-proc-mounts-to-old-behavior-for-unreachable-mountpoints.patch
vfs-no-unreachable-prefix-for-sysvipc-maps-in-proc-pid-maps.patch
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
mm-munlock-use-follow_page.patch
mm-remove-unused-gup-flags.patch
mm-add-get_dump_page.patch
mm-foll_dump-replace-foll_anon.patch
mm-follow_hugetlb_page-flags.patch
mm-fix-anonymous-dirtying.patch
mm-reinstate-zero_page.patch
mm-foll-flags-for-gup-flags.patch
mmap-remove-unnecessary-code.patch
tmpfs-depend-on-shmem.patch
mmap-avoid-unnecessary-anon_vma-lock-acquisition-in-vma_adjust.patch
mmap-save-some-cycles-for-the-shared-anonymous-mapping.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
ramfs-move-ramfs_magic-to-include-linux-magich.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
prio_tree-debugging-patch.patch


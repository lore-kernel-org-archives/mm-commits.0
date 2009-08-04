From: akpm@linux-foundation.org
Subject: + ksm-break-cow-once-unshared.patch added to -mm tree
Date: Tue, 04 Aug 2009 15:01:06 -0700
Message-ID: <200908042201.n74M17xj013471@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38378 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754978AbZHDWNP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Aug 2009 18:13:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh.dickins@tiscali.co.uk, aarcange@redhat.com, ieidus@redhat.com


The patch titled
     ksm: break cow once unshared
has been added to the -mm tree.  Its filename is
     ksm-break-cow-once-unshared.patch

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
Subject: ksm: break cow once unshared
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

We kept agreeing not to bother about the unswappable shared KSM pages
which later become unshared by others: observation suggests they're not
a significant proportion.  But they are disadvantageous, and it is easier
to break COW to replace them by swappable pages, than offer statistics
to show that they don't matter; then we can stop worrying about them.

Doing this in ksm_do_scan, they don't go through cmp_and_merge_page on
this pass: give them a good chance of getting into the unstable tree
on the next pass, or back into the stable, by computing checksum now.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Acked-by: Izik Eidus <ieidus@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN mm/ksm.c~ksm-break-cow-once-unshared mm/ksm.c
--- a/mm/ksm.c~ksm-break-cow-once-unshared
+++ a/mm/ksm.c
@@ -1275,6 +1275,14 @@ static void ksm_do_scan(unsigned int sca
 			return;
 		if (!PageKsm(page) || !in_stable_tree(rmap_item))
 			cmp_and_merge_page(page, rmap_item);
+		else if (page_mapcount(page) == 1) {
+			/*
+			 * Replace now-unshared ksm page by ordinary page.
+			 */
+			break_cow(rmap_item->mm, rmap_item->address);
+			remove_rmap_item_from_tree(rmap_item);
+			rmap_item->oldchecksum = calc_checksum(page);
+		}
 		put_page(page);
 	}
 }
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

acpi-fix-null-bug-for-hid-uid-string.patch
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
ksm-sysfs-and-defaults.patch
ksm-add-some-documentation.patch
ksm-remove-vm_mergeable_flags.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
ramfs-move-ramfs_magic-to-include-linux-magich.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
prio_tree-debugging-patch.patch


From: akpm@linux-foundation.org
Subject: [merged] ksm-break-cow-once-unshared.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:39:51 -0700
Message-ID: <200909222039.n8MKdpFa004273@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51566 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752561AbZIVUkV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:40:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh.dickins@tiscali.co.uk, aarcange@redhat.com, ieidus@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ksm: break cow once unshared
has been removed from the -mm tree.  Its filename was
     ksm-break-cow-once-unshared.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1268,6 +1268,14 @@ static void ksm_do_scan(unsigned int sca
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


From: akpm@linux-foundation.org
Subject: + dax-improve-comment-about-truncate-race.patch added to -mm tree
Date: Tue, 04 Aug 2015 14:34:29 -0700
Message-ID: <55c12fe5.tekXO9GamsY98ejD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56621 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873AbbHDVea (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Aug 2015 17:34:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: improve comment about truncate race
has been added to the -mm tree.  Its filename is
     dax-improve-comment-about-truncate-race.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dax-improve-comment-about-truncate-race.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dax-improve-comment-about-truncate-race.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: dax: improve comment about truncate race

Jan Kara pointed out I should be more explicit here about the perils of
racing against truncate.  The comment is mostly the same as for the PTE
case.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN fs/dax.c~dax-improve-comment-about-truncate-race fs/dax.c
--- a/fs/dax.c~dax-improve-comment-about-truncate-race
+++ a/fs/dax.c
@@ -553,7 +553,12 @@ int __dax_pmd_fault(struct vm_area_struc
 	if (!buffer_size_valid(&bh) || bh.b_size < PMD_SIZE)
 		goto fallback;
 
-	/* Guard against a race with truncate */
+	/*
+	 * If a truncate happened while we were allocating blocks, we may
+	 * leave blocks allocated to the file that are beyond EOF.  We can't
+	 * take i_mutex here, so just leave them hanging; they'll be freed
+	 * when the file is deleted.
+	 */
 	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	if (pgoff >= size) {
 		result = VM_FAULT_SIGBUS;
_

Patches currently in -mm which might be from willy@linux.intel.com are

mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested.patch
mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested-fix.patch
dax-move-dax-related-functions-to-a-new-header.patch
dax-revert-userfaultfd-change.patch
thp-prepare-for-dax-huge-pages.patch
thp-prepare-for-dax-huge-pages-fix.patch
mm-add-a-pmd_fault-handler.patch
mm-export-various-functions-for-the-benefit-of-dax.patch
mm-add-vmf_insert_pfn_pmd.patch
dax-add-huge-page-fault-support.patch
ext2-huge-page-fault-support.patch
ext4-huge-page-fault-support.patch
xfs-huge-page-fault-support.patch
ext4-use-ext4_get_block_write-for-dax.patch
thp-change-insert_pfns-return-type-to-void.patch
dax-improve-comment-about-truncate-race.patch
ext4-add-ext4_get_block_dax.patch
ext4-start-transaction-before-calling-into-dax.patch
dax-fix-race-between-simultaneous-faults.patch
thp-decrement-refcount-on-huge-zero-page-if-it-is-split.patch
thp-fix-zap_huge_pmd-for-dax.patch
dax-dont-use-set_huge_zero_page.patch
dax-ensure-that-zero-pages-are-removed-from-other-processes.patch
dax-use-linear_page_index.patch


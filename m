From: akpm@linux-foundation.org
Subject: + mm-mark-stable-page-dirty-in-ksm.patch added to -mm tree
Date: Mon, 19 Oct 2015 14:39:06 -0700
Message-ID: <562562fa.QFr7cLnRsqsB6wxo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46371 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbbJSVjH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Oct 2015 17:39:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mark stable page dirty in KSM
has been added to the -mm tree.  Its filename is
     mm-mark-stable-page-dirty-in-ksm.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mark-stable-page-dirty-in-ksm.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mark-stable-page-dirty-in-ksm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: mark stable page dirty in KSM

Stable page could be shared by several processes and last process could
own the page among them after CoW or zapping for every process except last
process happens.  Then, page table entry of the page in last process can
have no dirty bit and PG_dirty flag in page->flags.  In this case,
MADV_FREE could discard the page wrongly.  For preventing it, we mark
stable page dirty.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN mm/ksm.c~mm-mark-stable-page-dirty-in-ksm mm/ksm.c
--- a/mm/ksm.c~mm-mark-stable-page-dirty-in-ksm
+++ a/mm/ksm.c
@@ -1050,6 +1050,18 @@ static int try_to_merge_one_page(struct
 			 */
 			set_page_stable_node(page, NULL);
 			mark_page_accessed(page);
+			/*
+			 * Stable page could be shared by several processes
+			 * and last process could own the page among them after
+			 * CoW or zapping for every process except last process
+			 * happens. Then, page table entry of the page
+			 * in last process can have no dirty bit.
+			 * In this case, MADV_FREE could discard the page
+			 * wrongly.
+			 * For preventing it, we mark stable page dirty.
+			 */
+			if (!PageDirty(page))
+				SetPageDirty(page);
 			err = 0;
 		} else if (pages_identical(page, kpage))
 			err = replace_page(vma, page, kpage, orig_pte);
_

Patches currently in -mm which might be from minchan@kernel.org are

thp-use-is_zero_pfn-only-after-pte_present-check.patch
x86-add-pmd_-for-thp.patch
sparc-add-pmd_-for-thp.patch
powerpc-add-pmd_-for-thp.patch
arm-add-pmd_mkclean-for-thp.patch
arm64-add-pmd_-for-thp.patch
mm-support-madvisemadv_free.patch
mm-support-madvisemadv_free-fix.patch
mm-support-madvisemadv_free-fix-5.patch
mm-support-madvisemadv_free-fix-6.patch
mm-mark-stable-page-dirty-in-ksm.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-5.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-6.patch
mm-free-swp_entry-in-madvise_free.patch
mm-move-lazy-free-pages-to-inactive-list.patch
mm-move-lazy-free-pages-to-inactive-list-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch


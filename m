From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-mark-stable-page-dirty-in-ksm.patch removed
 from -mm tree
Date: Mon, 02 Nov 2015 14:53:38 -0800
Message-ID: <5637e972.XbMURaw96P8P16cU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56014 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbbKBWxi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Nov 2015 17:53:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mark stable page dirty in KSM
has been removed from the -mm tree.  Its filename was
     mm-mark-stable-page-dirty-in-ksm.patch

This patch was dropped because an updated version will be merged

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

x86-add-pmd_-for-thp.patch
sparc-add-pmd_-for-thp.patch
powerpc-add-pmd_-for-thp.patch
arm-add-pmd_mkclean-for-thp.patch
arm64-add-pmd_-for-thp.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-free-swp_entry-in-madvise_free.patch
mm-move-lazy-free-pages-to-inactive-list.patch


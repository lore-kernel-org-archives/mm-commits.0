From: akpm@linux-foundation.org
Subject: + mm-make-optimistic-check-for-swapin-readahead-fix.patch added
 to -mm tree
Date: Mon, 02 May 2016 14:41:18 -0700
Message-ID: <5727c97e.qqkeu2H7UhNz1mkL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56217 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932200AbcEBVlT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 May 2016 17:41:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, aneesh.kumar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: [PATCH] mm: make optimistic check for swapin readahead fix
has been added to the -mm tree.  Its filename is
     mm-make-optimistic-check-for-swapin-readahead-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-make-optimistic-check-for-swapin-readahead-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-make-optimistic-check-for-swapin-readahead-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] mm: make optimistic check for swapin readahead fix

Link: http://lkml.kernel.org/r/20160502183234.1dad8115@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/huge_memory.c~mm-make-optimistic-check-for-swapin-readahead-fix mm/huge_memory.c
--- a/mm/huge_memory.c~mm-make-optimistic-check-for-swapin-readahead-fix
+++ a/mm/huge_memory.c
@@ -101,7 +101,7 @@ static DECLARE_WAIT_QUEUE_HEAD(khugepage
  * fault.
  */
 static unsigned int khugepaged_max_ptes_none __read_mostly;
-static unsigned int khugepaged_max_ptes_swap __read_mostly = HPAGE_PMD_NR/8;
+static unsigned int khugepaged_max_ptes_swap __read_mostly;
 static unsigned long allocstall;
 
 static int khugepaged(void *none);
@@ -703,6 +703,7 @@ static int __init hugepage_init(void)
 
 	khugepaged_pages_to_scan = HPAGE_PMD_NR * 8;
 	khugepaged_max_ptes_none = HPAGE_PMD_NR - 1;
+	khugepaged_max_ptes_swap = HPAGE_PMD_NR / 8;
 	/*
 	 * hugepages can't be allocated by the buddy allocator
 	 */
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

mm-rename-_count-field-of-the-struct-page-to-_refcount-fix6.patch
mm-make-optimistic-check-for-swapin-readahead-fix.patch


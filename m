From: akpm@linux-foundation.org
Subject: + dequeue_huge_page-warning-fix.patch added to -mm tree
Date: Wed, 18 Jul 2007 00:30:17 -0700
Message-ID: <200707180734.l6I7YgYE030545@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38719 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755005AbXGRHf1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 03:35:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, agl@us.ibm.com, clameter@sgi.com, hermes@gibson.dropbear.id.au, wli@holomorphy.com


The patch titled
     dequeue_huge_page() warning fix
has been added to the -mm tree.  Its filename is
     dequeue_huge_page-warning-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: dequeue_huge_page() warning fix
From: Andrew Morton <akpm@linux-foundation.org>

mm/hugetlb.c: In function `dequeue_huge_page':
mm/hugetlb.c:72: warning: 'nid' might be used uninitialized in this function

Cc: Christoph Lameter <clameter@sgi.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: David Gibson <hermes@gibson.dropbear.id.au>
Cc: William Lee Irwin III <wli@holomorphy.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff -puN mm/hugetlb.c~dequeue_huge_page-warning-fix mm/hugetlb.c
--- a/mm/hugetlb.c~dequeue_huge_page-warning-fix
+++ a/mm/hugetlb.c
@@ -78,16 +78,13 @@ static struct page *dequeue_huge_page(st
 	for (z = zonelist->zones; *z; z++) {
 		nid = zone_to_nid(*z);
 		if (cpuset_zone_allowed_softwall(*z, htlb_alloc_mask) &&
-		    !list_empty(&hugepage_freelists[nid]))
-			break;
-	}
-
-	if (*z) {
-		page = list_entry(hugepage_freelists[nid].next,
-				  struct page, lru);
-		list_del(&page->lru);
-		free_huge_pages--;
-		free_huge_pages_node[nid]--;
+		    !list_empty(&hugepage_freelists[nid])) {
+			page = list_entry(hugepage_freelists[nid].next,
+					  struct page, lru);
+			list_del(&page->lru);
+			free_huge_pages--;
+			free_huge_pages_node[nid]--;
+		}
 	}
 	return page;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
readahead-split-ondemand-readahead-interface-into-two-functions-fix.patch
kernel-doc-fix-leading-dot-in-man-mode-output.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags.patch
add-sys-kernel-notes-fix.patch
lockstat-core-infrastructure.patch
lockstat-human-readability-tweaks-fix.patch
lockdep-various-fixes.patch
lockstat-measure-lock-bouncing.patch
some-kmalloc-memset-kzalloc-tree-wide.patch
dequeue_huge_page-warning-fix.patch

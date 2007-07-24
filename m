From: akpm@linux-foundation.org
Subject: + fix-hugetlb-page-allocation-leak.patch added to -mm tree
Date: Mon, 23 Jul 2007 17:19:58 -0700
Message-ID: <200707240019.l6O0JwRd019439@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49645 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750714AbXGXAUJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 20:20:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kenchen@google.com


The patch titled
     fix hugetlb page allocation leak
has been added to the -mm tree.  Its filename is
     fix-hugetlb-page-allocation-leak.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix hugetlb page allocation leak
From: "Ken Chen" <kenchen@google.com>

dequeue_huge_page() has a serious memory leak upon hugetlb page
allocation.  The for loop continues on allocating hugetlb pages out of
all allowable zone, where this function is supposedly only dequeue one
and only one pages.

Fixed it by breaking out of the for loop once a hugetlb page is found.

Signed-off-by: Ken Chen <kenchen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN mm/hugetlb.c~fix-hugetlb-page-allocation-leak mm/hugetlb.c
--- a/mm/hugetlb.c~fix-hugetlb-page-allocation-leak
+++ a/mm/hugetlb.c
@@ -84,6 +84,7 @@ static struct page *dequeue_huge_page(st
 			list_del(&page->lru);
 			free_huge_pages--;
 			free_huge_pages_node[nid]--;
+			break;
 		}
 	}
 	return page;
_

Patches currently in -mm which might be from kenchen@google.com are

fix-hugetlb-page-allocation-leak.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
writeback-fix-periodic-superblock-dirty-inode-flushing.patch

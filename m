From: akpm@linux-foundation.org
Subject: - fix-hugetlb-page-allocation-leak.patch removed from -mm tree
Date: Tue, 24 Jul 2007 16:24:55 -0700
Message-ID: <200707242324.l6ONOtE7006316@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56245 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757921AbXGXXZg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jul 2007 19:25:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kenchen@google.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     fix hugetlb page allocation leak
has been removed from the -mm tree.  Its filename was
     fix-hugetlb-page-allocation-leak.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
writeback-fix-periodic-superblock-dirty-inode-flushing.patch

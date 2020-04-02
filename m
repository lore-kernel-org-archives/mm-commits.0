From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 124/155] mm/vmscan.c: clean code by removing
 unnecessary assignment
Date: Wed, 01 Apr 2020 21:10:15 -0700
Message-ID: <20200402041015.Sm_nRspvB%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbgDBEKQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:10:16 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org, mateusznosek0@gmail.com, mm-commits@vger.kernel.org, richard.weiyang@gmail.com, torvalds@linux-foundation.org, willy@infradead.org

From: Mateusz Nosek <mateusznosek0@gmail.com>
Subject: mm/vmscan.c: clean code by removing unnecessary assignment

Previously 0 was assigned to variable 'lruvec_size', but the variable was
never read later.  So the assignment can be removed.

Link: http://lkml.kernel.org/r/20200229214022.11853-1-mateusznosek0@gmail.com
Fixes: f87bccde6a7d ("mm/vmscan: remove unused lru_pages argument")
Signed-off-by: Mateusz Nosek <mateusznosek0@gmail.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/vmscan.c~mm-vmscanc-clean-code-by-removing-unnecessary-assignment
+++ a/mm/vmscan.c
@@ -2427,10 +2427,8 @@ out:
 		case SCAN_FILE:
 		case SCAN_ANON:
 			/* Scan one type exclusively */
-			if ((scan_balance == SCAN_FILE) != file) {
-				lruvec_size = 0;
+			if ((scan_balance == SCAN_FILE) != file)
 				scan = 0;
-			}
 			break;
 		default:
 			/* Look ma, no brain */
_

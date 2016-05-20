From: akpm@linux-foundation.org
Subject: [patch 099/117] mm, page_alloc: simplify last cpupid reset
Date: Thu, 19 May 2016 17:13:53 -0700
Message-ID: <573e56c1.yuPJYviNF3ZnfIUv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46570 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185AbcETANy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 20:13:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mgorman@techsingularity.net, brouer@redhat.com, vbabka@suse.cz

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, page_alloc: simplify last cpupid reset

The current reset unnecessarily clears flags and makes pointless calculations.

Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN include/linux/mm.h~mm-page_alloc-simplify-last-cpupid-reset include/linux/mm.h
--- a/include/linux/mm.h~mm-page_alloc-simplify-last-cpupid-reset
+++ a/include/linux/mm.h
@@ -850,10 +850,7 @@ extern int page_cpupid_xchg_last(struct
 
 static inline void page_cpupid_reset_last(struct page *page)
 {
-	int cpupid = (1 << LAST_CPUPID_SHIFT) - 1;

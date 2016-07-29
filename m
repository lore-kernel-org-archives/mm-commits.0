From: akpm@linux-foundation.org
Subject: [merged] mm-meminit-remove-early_page_nid_uninitialised.patch
 removed from -mm tree
Date: Fri, 29 Jul 2016 11:54:24 -0700
Message-ID: <579ba660.jGYcFCHig6wsqHEX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37061 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbcG2SyZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2016 14:54:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, meminit: remove early_page_nid_uninitialised
has been removed from the -mm tree.  Its filename was
     mm-meminit-remove-early_page_nid_uninitialised.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, meminit: remove early_page_nid_uninitialised

The helper early_page_nid_uninitialised() has been dead since commit
974a786e63c9 ("mm, page_alloc: remove MIGRATE_RESERVE") so remove the
dead code.

Link: http://lkml.kernel.org/r/1468008031-3848-2-git-send-email-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   13 -------------
 1 file changed, 13 deletions(-)

diff -puN mm/page_alloc.c~mm-meminit-remove-early_page_nid_uninitialised mm/page_alloc.c
--- a/mm/page_alloc.c~mm-meminit-remove-early_page_nid_uninitialised
+++ a/mm/page_alloc.c
@@ -295,14 +295,6 @@ static inline bool __meminit early_page_
 	return false;
 }
 
-static inline bool early_page_nid_uninitialised(unsigned long pfn, int nid)
-{
-	if (pfn >= NODE_DATA(nid)->first_deferred_pfn)
-		return true;
-
-	return false;
-}
-
 /*
  * Returns false when the remaining initialisation should be deferred until
  * later in the boot cycle when it can be parallelised.
@@ -341,11 +333,6 @@ static inline bool early_page_uninitiali
 {
 	return false;
 }

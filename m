From: akpm@linux-foundation.org
Subject: [merged] thp-cleanup-how-khugepaged-enters-freezer.patch removed
 from -mm tree
Date: Mon, 29 Jun 2015 13:37:23 -0700
Message-ID: <5591ac83.YQTdSVjI8+GJmThZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50251 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007AbbF2Uh0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:37:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jkosina@suse.cz, aarcange@redhat.com, mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: cleanup how khugepaged enters freezer
has been removed from the -mm tree.  Its filename was
     thp-cleanup-how-khugepaged-enters-freezer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiri Kosina <jkosina@suse.cz>
Subject: thp: cleanup how khugepaged enters freezer

khugepaged_do_scan() checks in every iteration whether freezing(current)
is true, and in such case breaks out of the loop, which causes
try_to_freeze() to be called immediately afterwards in
khugepaged_wait_work().

If nothing else, this causes unnecessary freezing(current) test, and also
makes the way khugepaged enters freezer a bit less obvious than necessary.

Let's just try to freeze directly, instead of splitting it into two
(directly adjacent) phases.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN mm/huge_memory.c~thp-cleanup-how-khugepaged-enters-freezer mm/huge_memory.c
--- a/mm/huge_memory.c~thp-cleanup-how-khugepaged-enters-freezer
+++ a/mm/huge_memory.c
@@ -2799,7 +2799,7 @@ static void khugepaged_do_scan(void)
 
 		cond_resched();
 
-		if (unlikely(kthread_should_stop() || freezing(current)))
+		if (unlikely(kthread_should_stop() || try_to_freeze()))
 			break;
 
 		spin_lock(&khugepaged_mm_lock);
@@ -2820,8 +2820,6 @@ static void khugepaged_do_scan(void)
 
 static void khugepaged_wait_work(void)
 {
-	try_to_freeze();

From: akpm@linux-foundation.org
Subject: + thp-cleanup-how-khugepaged-enters-freezer.patch added to -mm
 tree
Date: Tue, 21 Apr 2015 16:08:01 -0700
Message-ID: <5536d851.igjAR+BFBuYklPwN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35055 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933362AbbDUXIC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Apr 2015 19:08:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jkosina@suse.cz, aarcange@redhat.com, mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: cleanup how khugepaged enters freezer
has been added to the -mm tree.  Its filename is
     thp-cleanup-how-khugepaged-enters-freezer.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/thp-cleanup-how-khugepaged-enters-freezer.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/thp-cleanup-how-khugepaged-enters-freezer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

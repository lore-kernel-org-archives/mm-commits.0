From: akpm@linux-foundation.org
Subject: + mm-meminit-remove-early_page_nid_uninitialised.patch added to
 -mm tree
Date: Fri, 08 Jul 2016 13:19:26 -0700
Message-ID: <57800ace.it6o/6GfUpKCY0He%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42713 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755427AbcGHUT1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jul 2016 16:19:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, meminit: remove early_page_nid_uninitialised
has been added to the -mm tree.  Its filename is
     mm-meminit-remove-early_page_nid_uninitialised.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-meminit-remove-early_page_nid_uninitialised.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-meminit-remove-early_page_nid_uninitialised.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

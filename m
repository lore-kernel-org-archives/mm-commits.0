From: akpm@linux-foundation.org
Subject: + mm-put-activate_page_pvecs-and-others-pagevec-together.patch
 added to -mm tree
Date: Wed, 27 Apr 2016 14:04:06 -0700
Message-ID: <57212946.Hc6erUTAgoxy5M8k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49494 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256AbcD0VEH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Apr 2016 17:04:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingli199x@qq.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: put activate_page_pvecs and other pagevecs together
has been added to the -mm tree.  Its filename is
     mm-put-activate_page_pvecs-and-others-pagevec-together.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-put-activate_page_pvecs-and-others-pagevec-together.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-put-activate_page_pvecs-and-others-pagevec-together.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ming Li <mingli199x@qq.com>
Subject: mm: put activate_page_pvecs and other pagevecs together

Put the activate_page_pvecs definition next to those of the other
pagevecs, for clarity.

Signed-off-by: Ming Li <mingli199x@qq.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/swap.c~mm-put-activate_page_pvecs-and-others-pagevec-together mm/swap.c
--- a/mm/swap.c~mm-put-activate_page_pvecs-and-others-pagevec-together
+++ a/mm/swap.c
@@ -47,6 +47,9 @@ static DEFINE_PER_CPU(struct pagevec, lr
 static DEFINE_PER_CPU(struct pagevec, lru_rotate_pvecs);
 static DEFINE_PER_CPU(struct pagevec, lru_deactivate_file_pvecs);
 static DEFINE_PER_CPU(struct pagevec, lru_deactivate_pvecs);
+#ifdef CONFIG_SMP
+static DEFINE_PER_CPU(struct pagevec, activate_page_pvecs);
+#endif
 
 /*
  * This path almost never happens for VM activity - pages are normally
@@ -274,8 +277,6 @@ static void __activate_page(struct page
 }
 
 #ifdef CONFIG_SMP
-static DEFINE_PER_CPU(struct pagevec, activate_page_pvecs);

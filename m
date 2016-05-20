From: akpm@linux-foundation.org
Subject: [patch 031/162] mm/swap.c: put activate_page_pvecs and other
 pagevecs together
Date: Fri, 20 May 2016 16:57:56 -0700
Message-ID: <573fa484.aAycyH1UrNekTgpU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52293 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbcETX55 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 19:57:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mingli199x@qq.com

From: Ming Li <mingli199x@qq.com>
Subject: mm/swap.c: put activate_page_pvecs and other pagevecs together

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

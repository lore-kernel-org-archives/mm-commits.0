From: akpm@linux-foundation.org
Subject: + netfilter-xt_time-gives-a-wrong-monthday-in-a-leap-year.patch added to -mm tree
Date: Wed, 27 Aug 2008 16:20:30 -0700
Message-ID: <200808272320.m7RNKUUn028077@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59567 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751815AbYH0XUm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Aug 2008 19:20:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kaih.luo@gmail.com, jengelh@computergmbh.de, kaber@trash.net


The patch titled
     netfilter: xt_time gives a wrong monthday in a leap year
has been added to the -mm tree.  Its filename is
     netfilter-xt_time-gives-a-wrong-monthday-in-a-leap-year.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: netfilter: xt_time gives a wrong monthday in a leap year
From: Kaihui Luo <kaih.luo@gmail.com>

The function localtime_3 in xt_time.c gives a wrong monthday in a leap
year after 28th 2.  calculating monthday should use the array
days_since_leapyear[] not days_since_year[] in a leap year.

Signed-off-by: Kaihui Luo <kaih.luo@gmail.com>
Cc: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Patrick McHardy <kaber@trash.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/netfilter/xt_time.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN net/netfilter/xt_time.c~netfilter-xt_time-gives-a-wrong-monthday-in-a-leap-year net/netfilter/xt_time.c
--- a/net/netfilter/xt_time.c~netfilter-xt_time-gives-a-wrong-monthday-in-a-leap-year
+++ a/net/netfilter/xt_time.c
@@ -136,17 +136,19 @@ static void localtime_3(struct xtm *r, t
 	 * from w repeatedly while counting.)
 	 */
 	if (is_leap(year)) {
+		/* use days_since_leapyear[] in a leap year */
 		for (i = ARRAY_SIZE(days_since_leapyear) - 1;
-		    i > 0 && days_since_year[i] > w; --i)
+		    i > 0 && days_since_leapyear[i] > w; --i)
 			/* just loop */;
+		r->monthday = w - days_since_leapyear[i] + 1;
 	} else {
 		for (i = ARRAY_SIZE(days_since_year) - 1;
 		    i > 0 && days_since_year[i] > w; --i)
 			/* just loop */;
+		r->monthday = w - days_since_year[i] + 1;
 	}
 
 	r->month    = i + 1;
-	r->monthday = w - days_since_year[i] + 1;
 	return;
 }
 
_

Patches currently in -mm which might be from kaih.luo@gmail.com are

netfilter-xt_time-gives-a-wrong-monthday-in-a-leap-year.patch


From: akpm@linux-foundation.org
Subject: + zlc_setup-handle-jiffies-wraparound.patch added to -mm tree
Date: Fri, 29 Feb 2008 00:06:01 -0800
Message-ID: <200802290806.m1T861il012667@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:33797 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752042AbYB2IHI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Feb 2008 03:07:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, Lee.Schermerhorn@hp.com, mel@csn.ul.ie, pj@sgi.com


The patch titled
     zlc_setup(): handle jiffies wraparound
has been added to the -mm tree.  Its filename is
     zlc_setup-handle-jiffies-wraparound.patch

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
Subject: zlc_setup(): handle jiffies wraparound
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

jiffies subtraction may cause an overflow problem.  It should be using
time_after().

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~zlc_setup-handle-jiffies-wraparound mm/page_alloc.c
--- a/mm/page_alloc.c~zlc_setup-handle-jiffies-wraparound
+++ a/mm/page_alloc.c
@@ -1276,7 +1276,7 @@ static nodemask_t *zlc_setup(struct zone
 	if (!zlc)
 		return NULL;
 
-	if (jiffies - zlc->last_full_zap > 1 * HZ) {
+       if (time_after(jiffies, zlc->last_full_zap + HZ)) {
 		bitmap_zero(zlc->fullzones, MAX_ZONES_PER_ZONELIST);
 		zlc->last_full_zap = jiffies;
 	}
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

zlc_setup-handle-jiffies-wraparound.patch


From: akpm@linux-foundation.org
Subject: + pps-initialize-ts_real-properly.patch added to -mm tree
Date: Fri, 25 Feb 2011 12:46:09 -0800
Message-ID: <201102252046.p1PKk9Ft028693@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47697 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753102Ab1BYUq0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Feb 2011 15:46:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lasaine@lvk.cs.msu.su, giometti@linux.it, johnstul@us.ibm.com


The patch titled
     pps: initialize ts_real properly
has been added to the -mm tree.  Its filename is
     pps-initialize-ts_real-properly.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pps: initialize ts_real properly
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>

Initialize ts_real.flags to fix compiler warning about possible
uninitialized use of this field.

Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Rodolfo Giometti <giometti@linux.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/kapi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/pps/kapi.c~pps-initialize-ts_real-properly drivers/pps/kapi.c
--- a/drivers/pps/kapi.c~pps-initialize-ts_real-properly
+++ a/drivers/pps/kapi.c
@@ -168,7 +168,7 @@ void pps_event(struct pps_device *pps, s
 {
 	unsigned long flags;
 	int captured = 0;
-	struct pps_ktime ts_real;
+	struct pps_ktime ts_real = { .sec = 0, .nsec = 0, .flags = 0 };
 
 	/* check event type */
 	BUG_ON((event & (PPS_CAPTUREASSERT | PPS_CAPTURECLEAR)) == 0);
_

Patches currently in -mm which might be from lasaine@lvk.cs.msu.su are

pps-initialize-ts_real-properly.patch
pps-make-pps_gen_parport-depend-on-broken.patch
pps-remove-unreachable-code.patch


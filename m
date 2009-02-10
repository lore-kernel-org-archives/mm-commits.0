From: akpm@linux-foundation.org
Subject: + fbdev-newport-newport_wait-return-0-on-timeout.patch added to -mm tree
Date: Tue, 10 Feb 2009 14:03:53 -0800
Message-ID: <200902102203.n1AM3rp1028911@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55302 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755408AbZBJWEa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Feb 2009 17:04:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, krzysztof.h1@poczta.fm


The patch titled
     fbdev: newport: newport_*wait() return 0 on timeout
has been added to the -mm tree.  Its filename is
     fbdev-newport-newport_wait-return-0-on-timeout.patch

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
Subject: fbdev: newport: newport_*wait() return 0 on timeout
From: Roel Kluin <roel.kluin@gmail.com>

With a postfix decrement t reaches -1 on timeout which results in a
return of 0.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/video/newport.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/video/newport.h~newport-newport_wait-return-0-on-timeout include/video/newport.h
--- a/include/video/newport.h~newport-newport_wait-return-0-on-timeout
+++ a/include/video/newport.h
@@ -453,7 +453,7 @@ static __inline__ int newport_wait(struc
 {
 	int t = BUSY_TIMEOUT;
 
-	while (t--)
+	while (--t)
 		if (!(regs->cset.status & NPORT_STAT_GBUSY))
 			break;
 	return !t;
@@ -463,7 +463,7 @@ static __inline__ int newport_bfwait(str
 {
 	int t = BUSY_TIMEOUT;
 
-	while (t--)
+	while (--t)
 		if(!(regs->cset.status & NPORT_STAT_BBUSY))
 			break;
 	return !t;
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

rtc-t-reaches-1-tested-0.patch
linux-next.patch
drm-fix-lock_test_with_return-macro.patch
dvb-negative-internal-sub_range-wont-get-noticed.patch
leds-fix-confusion.patch
paride-pgc-xs-confusion.patch
mm-get_nid_for_pfn-returns-int.patch
alpha-fix-macros.patch
spi-limit-reaches-1-tested-0.patch
rtc-wm8350-retries-will-reach-1.patch
fbdev-newport-newport_wait-return-0-on-timeout.patch
ufs-sector_t-cannot-be-negative.patch


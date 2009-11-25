From: akpm@linux-foundation.org
Subject: + rtc-vr41xx-use-resource_size.patch added to -mm tree
Date: Wed, 25 Nov 2009 12:57:10 -0800
Message-ID: <200911252057.nAPKvA7P014687@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45561 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753923AbZKYU5m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Nov 2009 15:57:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yuasa@linux-mips.org


The patch titled
     rtc-vr41xx: use resource_size()
has been added to the -mm tree.  Its filename is
     rtc-vr41xx-use-resource_size.patch

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
Subject: rtc-vr41xx: use resource_size()
From: Yoichi Yuasa <yuasa@linux-mips.org>

Signed-off-by: Yoichi Yuasa <yuasa@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-vr41xx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-vr41xx.c~rtc-vr41xx-use-resource_size drivers/rtc/rtc-vr41xx.c
--- a/drivers/rtc/rtc-vr41xx.c~rtc-vr41xx-use-resource_size
+++ a/drivers/rtc/rtc-vr41xx.c
@@ -327,7 +327,7 @@ static int __devinit rtc_probe(struct pl
 	if (!res)
 		return -EBUSY;
 
-	rtc1_base = ioremap(res->start, res->end - res->start + 1);
+	rtc1_base = ioremap(res->start, resource_size(res));
 	if (!rtc1_base)
 		return -EBUSY;
 
@@ -337,7 +337,7 @@ static int __devinit rtc_probe(struct pl
 		goto err_rtc1_iounmap;
 	}
 
-	rtc2_base = ioremap(res->start, res->end - res->start + 1);
+	rtc2_base = ioremap(res->start, resource_size(res));
 	if (!rtc2_base) {
 		retval = -EBUSY;
 		goto err_rtc1_iounmap;
_

Patches currently in -mm which might be from yuasa@linux-mips.org are

rtc-vr41xx-use-resource_size.patch


From: akpm@linux-foundation.org
Subject: + rtc-rtc-mc13xxx-fix-unterminated-platform_device_id-table.patch added to -mm tree
Date: Thu, 07 Apr 2011 14:21:53 -0700
Message-ID: <201104072121.p37LLrrk000606@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57542 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750886Ab1DGVWH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Apr 2011 17:22:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, u.kleine-koenig@pengutronix.de


The patch titled
     drivers/rtc/rtc-mc13xxx.c: fix unterminated platform_device_id tab=
le
has been added to the -mm tree.  Its filename is
     rtc-rtc-mc13xxx-fix-unterminated-platform_device_id-table.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: drivers/rtc/rtc-mc13xxx.c: fix unterminated platform_device_id=
 table
=46rom: Axel Lin <axel.lin@gmail.com>

The platform_device_id table is supposed to be zero-terminated.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-mc13xxx.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/rtc/rtc-mc13xxx.c~rtc-rtc-mc13xxx-fix-unterminated-pl=
atform_device_id-table drivers/rtc/rtc-mc13xxx.c
--- a/drivers/rtc/rtc-mc13xxx.c~rtc-rtc-mc13xxx-fix-unterminated-platfo=
rm_device_id-table
+++ a/drivers/rtc/rtc-mc13xxx.c
@@ -401,6 +401,7 @@ const struct platform_device_id mc13xxx_
 	}, {
 		.name =3D "mc13892-rtc",
 	},
+	{ }
 };
=20
 static struct platform_driver mc13xxx_rtc_driver =3D {
_

Patches currently in -mm which might be from axel.lin@gmail.com are

rtc-rtc-mc13xxx-fix-unterminated-platform_device_id-table.patch
linux-next.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

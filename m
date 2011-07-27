From: akpm@linux-foundation.org
Subject: + rtc-omap-fix-initialization-of-control-register.patch added to -mm tree
Date: Wed, 27 Jul 2011 14:19:15 -0700
Message-ID: <201107272119.p6RLJFf9008734@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45937 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755160Ab1G0VUN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jul 2011 17:20:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dg@emlix.com, a.zummo@towertech.it


The patch titled
     rtc-omap: fix initialization of control register
has been added to the -mm tree.  Its filename is
     rtc-omap-fix-initialization-of-control-register.patch

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
Subject: rtc-omap: fix initialization of control register
=46rom: Daniel Gl=F6ckner <dg@emlix.com>

As the comment explains, the intention of the code is to clear the
OMAP_RTC_CTRL_MODE_12_24 bit, but instead it only clears the
OMAP_RTC_CTRL_SPLIT and OMAP_RTC_CTRL_AUTO_COMP bits, which should be
kept. OMAP_RTC_CTRL_DISABLE, OMAP_RTC_CTRL_SET_32_COUNTER,
OMAP_RTC_CTRL_TEST, and OMAP_RTC_CTRL_ROUND_30S are also better off
being cleared.

Signed-off-by: Daniel Gl=F6ckner <dg@emlix.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-omap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-omap.c~rtc-omap-fix-initialization-of-control=
-register drivers/rtc/rtc-omap.c
--- a/drivers/rtc/rtc-omap.c~rtc-omap-fix-initialization-of-control-reg=
ister
+++ a/drivers/rtc/rtc-omap.c
@@ -368,7 +368,7 @@ static int __init omap_rtc_probe(struct=20
 		pr_info("%s: already running\n", pdev->name);
=20
 	/* force to 24 hour mode */
-	new_ctrl =3D reg & ~(OMAP_RTC_CTRL_SPLIT|OMAP_RTC_CTRL_AUTO_COMP);
+	new_ctrl =3D reg & (OMAP_RTC_CTRL_SPLIT|OMAP_RTC_CTRL_AUTO_COMP);
 	new_ctrl |=3D OMAP_RTC_CTRL_STOP;
=20
 	/* BOARD-SPECIFIC CUSTOMIZATION CAN GO HERE:
_

Patches currently in -mm which might be from dg@emlix.com are

rtc-omap-fix-initialization-of-control-register.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

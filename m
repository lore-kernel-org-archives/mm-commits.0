From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-tegrac-properly-initialize-spinlock.patch added to -mm tree
Date: Fri, 22 Jul 2011 15:13:52 -0700
Message-ID: <201107222213.p6MMDq3c018149@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46728 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750956Ab1GVWOC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Jul 2011 18:14:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: u.kleine-koenig@pengutronix.de, achew@nvidia.com, stable@kernel.org


The patch titled
     drivers/rtc/rtc-tegra.c: properly initialize spinlock
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-tegrac-properly-initialize-spinlock.patch

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
Subject: drivers/rtc/rtc-tegra.c: properly initialize spinlock
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

Using __SPIN_LOCK_UNLOCKED for a dynamically allocated lock is wrong an=
d
breaks with PREEMPT_RT_FULL.

Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Cc: Andrew Chew <achew@nvidia.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-tegra.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-tegra.c~drivers-rtc-rtc-tegrac-properly-initi=
alize-spinlock drivers/rtc/rtc-tegra.c
--- a/drivers/rtc/rtc-tegra.c~drivers-rtc-rtc-tegrac-properly-initializ=
e-spinlock
+++ a/drivers/rtc/rtc-tegra.c
@@ -343,7 +343,7 @@ static int __devinit tegra_rtc_probe(str
=20
 	/* set context info. */
 	info->pdev =3D pdev;
-	info->tegra_rtc_lock =3D __SPIN_LOCK_UNLOCKED(info->tegra_rtc_lock);
+	spin_lock_init(&info->tegra_rtc_lock);
=20
 	platform_set_drvdata(pdev, info);
=20
_

Patches currently in -mm which might be from u.kleine-koenig@pengutroni=
x.de are

linux-next.patch
include-linux-ioporth-new-helper-to-define-common-struct-resource-const=
ructs.patch
drivers-rtc-rtc-tegrac-properly-initialize-spinlock.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

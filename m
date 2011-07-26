From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-tegrac-properly-initialize-spinlock.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:56:35 -0700
Message-ID: <201107260755.p6Q7tcUD003476__16505.4299789064$1311667027$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57687 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753313Ab1GZH4y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:56:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: u.kleine-koenig@pengutronix.de, achew@nvidia.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     drivers/rtc/rtc-tegra.c: properly initialize spinlock
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-tegrac-properly-initialize-spinlock.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: drivers/rtc/rtc-tegra.c: properly initialize spinlock
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

Using __SPIN_LOCK_UNLOCKED for a dynamically allocated lock is wrong an=
d
breaks the build with PREEMPT_RT_FULL.

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

origin.patch
linux-next.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

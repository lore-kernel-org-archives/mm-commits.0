From: akpm@linux-foundation.org
Subject: - smc91x-add-insw-outsw-to-default-config-v2.patch removed from -mm tree
Date: Thu, 27 Mar 2008 12:48:35 -0700
Message-ID: <200803271948.m2RJmZLH019141@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53420 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760662AbYC0TtD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Mar 2008 15:49:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: magnus.damm@gmail.com, damm@igel.co.jp, jeff@garzik.org, lethal@linux-sh.org, nico@cam.org, mm-commits@vger.kernel.org


The patch titled
     smc91x: add insw/outsw to default config
has been removed from the -mm tree.  Its filename was
     smc91x-add-insw-outsw-to-default-config-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: smc91x: add insw/outsw to default config
From: Magnus Damm <magnus.damm@gmail.com>

This patch makes sure SMC_insw()/SMC_outsw() are defined for the default
configuration.  Without this change BUG()s will be triggered when using 16-bit
only platform data and the default configuration.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
Acked-by: Nicolas Pitre <nico@cam.org>
Cc: Paul Mundt <lethal@linux-sh.org>,
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/smc91x.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/net/smc91x.h~smc91x-add-insw-outsw-to-default-config-v2 drivers/net/smc91x.h
--- a/drivers/net/smc91x.h~smc91x-add-insw-outsw-to-default-config-v2
+++ a/drivers/net/smc91x.h
@@ -448,6 +448,8 @@ static inline void LPD7_SMC_outsw (unsig
 #define SMC_outb(v, a, r)	writeb(v, (a) + (r))
 #define SMC_outw(v, a, r)	writew(v, (a) + (r))
 #define SMC_outl(v, a, r)	writel(v, (a) + (r))
+#define SMC_insw(a, r, p, l)	readsw((a) + (r), p, l)
+#define SMC_outsw(a, r, p, l)	writesw((a) + (r), p, l)
 #define SMC_insl(a, r, p, l)	readsl((a) + (r), p, l)
 #define SMC_outsl(a, r, p, l)	writesl((a) + (r), p, l)
 
_

Patches currently in -mm which might be from magnus.damm@gmail.com are

git-net.patch
smc91x-add-insw-outsw-to-default-config-v2.patch
git-sh.patch
sm501-add-uart-support.patch


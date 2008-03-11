From: akpm@linux-foundation.org
Subject: - tifm-fix-memorystick-host-initialization-code.patch removed from -mm tree
Date: Mon, 10 Mar 2008 20:21:53 -0700
Message-ID: <200803110321.m2B3LrcF019755@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45583 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753539AbYCKDbI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 23:31:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oakad@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     tifm: fix memorystick host initialization code
has been removed from the -mm tree.  Its filename was
     tifm-fix-memorystick-host-initialization-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tifm: fix memorystick host initialization code
From: Alex Dubov <oakad@yahoo.com>

Instead of assuming that host is powered on only once at card insertion, allow
for the possibility that memstick layer may need to cycle card's power to get
it out from some unhealthy states.

Signed-off-by: Alex Dubov <oakad@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/host/tifm_ms.c |   40 +++++++++++-------------------
 1 file changed, 15 insertions(+), 25 deletions(-)

diff -puN drivers/memstick/host/tifm_ms.c~tifm-fix-memorystick-host-initialization-code drivers/memstick/host/tifm_ms.c
--- a/drivers/memstick/host/tifm_ms.c~tifm-fix-memorystick-host-initialization-code
+++ a/drivers/memstick/host/tifm_ms.c
@@ -496,7 +496,18 @@ static void tifm_ms_set_param(struct mem
 
 	switch (param) {
 	case MEMSTICK_POWER:
-		/* this is set by card detection mechanism */
+		/* also affected by media detection mechanism */
+		if (value == MEMSTICK_POWER_ON) {
+			host->mode_mask = TIFM_MS_SYS_SRAC | TIFM_MS_SYS_REI;
+			writel(TIFM_MS_SYS_RESET, sock->addr + SOCK_MS_SYSTEM);
+			writel(TIFM_MS_SYS_FCLR | TIFM_MS_SYS_INTCLR,
+			       sock->addr + SOCK_MS_SYSTEM);
+			writel(0xffffffff, sock->addr + SOCK_MS_STATUS);
+		} else if (value == MEMSTICK_POWER_OFF) {
+			writel(TIFM_MS_SYS_FCLR | TIFM_MS_SYS_INTCLR,
+			       sock->addr + SOCK_MS_SYSTEM);
+			writel(0xffffffff, sock->addr + SOCK_MS_STATUS);
+		}
 		break;
 	case MEMSTICK_INTERFACE:
 		if (value == MEMSTICK_SERIAL) {
@@ -531,22 +542,6 @@ static void tifm_ms_abort(unsigned long 
 	tifm_eject(host->dev);
 }
 
-static int tifm_ms_initialize_host(struct tifm_ms *host)
-{
-	struct tifm_dev *sock = host->dev;
-	struct memstick_host *msh = tifm_get_drvdata(sock);
-
-	host->mode_mask = TIFM_MS_SYS_SRAC | TIFM_MS_SYS_REI;
-	writel(TIFM_MS_SYS_RESET, sock->addr + SOCK_MS_SYSTEM);
-	writel(TIFM_MS_SYS_FCLR | TIFM_MS_SYS_INTCLR,
-	       sock->addr + SOCK_MS_SYSTEM);
-	writel(0xffffffff, sock->addr + SOCK_MS_STATUS);
-	if (tifm_has_ms_pif(sock))
-		msh->caps |= MEMSTICK_CAP_PAR4;
-
-	return 0;
-}
-
 static int tifm_ms_probe(struct tifm_dev *sock)
 {
 	struct memstick_host *msh;
@@ -575,10 +570,10 @@ static int tifm_ms_probe(struct tifm_dev
 	msh->set_param = tifm_ms_set_param;
 	sock->card_event = tifm_ms_card_event;
 	sock->data_event = tifm_ms_data_event;
-	rc = tifm_ms_initialize_host(host);
+	if (tifm_has_ms_pif(sock))
+		msh->caps |= MEMSTICK_CAP_PAR4;
 
-	if (!rc)
-		rc = memstick_add_host(msh);
+	rc = memstick_add_host(msh);
 	if (!rc)
 		return 0;
 
@@ -616,11 +611,6 @@ static void tifm_ms_remove(struct tifm_d
 	spin_unlock_irqrestore(&sock->lock, flags);
 
 	memstick_remove_host(msh);
-
-	writel(TIFM_MS_SYS_FCLR | TIFM_MS_SYS_INTCLR,
-	       sock->addr + SOCK_MS_SYSTEM);
-	writel(0xffffffff, sock->addr + SOCK_MS_STATUS);

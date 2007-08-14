From: akpm@linux-foundation.org
Subject: - via-rhine-disable-rx_copybreak-on-archs-that.patch removed from -mm tree
Date: Tue, 14 Aug 2007 12:12:05 -0700
Message-ID: <200708141912.l7EJC51A016374@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44608 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934739AbXHNTMd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 15:12:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jailbird@alcatraz.fdf.net, ink@jurassic.park.msu.ru, jeff@garzik.org, romieu@fr.zoreil.com, mm-commits@vger.kernel.org


The patch titled
     via-rhine: disable rx_copybreak on archs that don't allow unaligned DMA access
has been removed from the -mm tree.  Its filename was
     via-rhine-disable-rx_copybreak-on-archs-that.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: via-rhine: disable rx_copybreak on archs that don't allow unaligned DMA access
From: Dustin Marquess <jailbird@alcatraz.fdf.net>

Patch to disable the rx_copybreak feature on hardware architectures that
don't allow unaligned DMA access.

#ifdef code taken from tulip_core.c.  Problem pointed out by Ivan
Kokshaysky.

Signed-off-by: Dustin Marquess <jailbird@alcatraz.fdf.net>
Cc: Francois Romieu <romieu@fr.zoreil.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/via-rhine.c |    6 ++++++
 1 files changed, 6 insertions(+)

diff -puN drivers/net/via-rhine.c~via-rhine-disable-rx_copybreak-on-archs-that drivers/net/via-rhine.c
--- a/drivers/net/via-rhine.c~via-rhine-disable-rx_copybreak-on-archs-that
+++ a/drivers/net/via-rhine.c
@@ -42,7 +42,13 @@ static int max_interrupt_work = 20;
 
 /* Set the copy breakpoint for the copy-only-tiny-frames scheme.
    Setting to > 1518 effectively disables this feature. */
+#if defined(__alpha__) || defined(__arm__) || defined(__hppa__) \
+       || defined(CONFIG_SPARC) || defined(__ia64__) \
+       || defined(__sh__) || defined(__mips__)
+static int rx_copybreak = 1518;
+#else
 static int rx_copybreak;
+#endif
 
 /* Work-around for broken BIOSes: they are unable to get the chip back out of
    power state D3 so PXE booting fails. bootparam(7): via-rhine.avoid_D3=1 */
_

Patches currently in -mm which might be from jailbird@alcatraz.fdf.net are

origin.patch

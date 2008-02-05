From: akpm@linux-foundation.org
Subject: - m68knommu-use-array_size-in-coldfire-serial-driver.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:33:32 -0800
Message-ID: <200802052233.m15MXDLC012389@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35681 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760888AbYBEWlw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:41:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gerg@snapgear.com, gerg@uclinux.org, mm-commits@vger.kernel.org


The patch titled
     m68knommu: use ARRAY_SIZE in ColdFire serial driver
has been removed from the -mm tree.  Its filename was
     m68knommu-use-array_size-in-coldfire-serial-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m68knommu: use ARRAY_SIZE in ColdFire serial driver
From: Greg Ungerer <gerg@snapgear.com>

Use ARRAY_SIZE macroto get maximum ports in ColdFire serial driver.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/mcf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/serial/mcf.c~m68knommu-use-array_size-in-coldfire-serial-driver drivers/serial/mcf.c
--- a/drivers/serial/mcf.c~m68knommu-use-array_size-in-coldfire-serial-driver
+++ a/drivers/serial/mcf.c
@@ -434,7 +434,7 @@ static struct uart_ops mcf_uart_ops = {
 
 static struct mcf_uart mcf_ports[3];
 
-#define	MCF_MAXPORTS	(sizeof(mcf_ports) / sizeof(struct mcf_uart))
+#define	MCF_MAXPORTS	ARRAY_SIZE(mcf_ports)
 
 /****************************************************************************/
 #if defined(CONFIG_SERIAL_MCF_CONSOLE)
_

Patches currently in -mm which might be from gerg@snapgear.com are

origin.patch
add-cmpxchg_local-to-m68knommu.patch

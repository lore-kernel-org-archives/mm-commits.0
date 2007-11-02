From: akpm@linux-foundation.org
Subject: + m68knommu-use-array_size-in-coldfire-serial-driver.patch added to -mm tree
Date: Fri, 02 Nov 2007 14:35:18 -0700
Message-ID: <200711022135.lA2LZIJc011999@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54133 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752194AbXKBVf4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Nov 2007 17:35:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gerg@snapgear.com, gerg@uclinux.org


The patch titled
     m68knommu: use ARRAY_SIZE in ColdFire serial driver
has been added to the -mm tree.  Its filename is
     m68knommu-use-array_size-in-coldfire-serial-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

m68knommu-fix-pread-pwrite-defines.patch
m68knommu-use-raw-read-write-for-all-register-access-in-coldfire-timer.patch
m68knommu-use-container_of-to-access-uart-struct-in-coldfire-serial-driver.patch
m68knommu-cleanup-port-field-access-from-uart-struct-in-coldfire-serial-driver.patch
m68knommu-use-array_size-in-coldfire-serial-driver.patch
add-build-support-for-new-coldfire-serial-driver.patch
add-configure-support-for-new-coldfire-serial-driver.patch
m68knommu-platform-setup-for-5206-coldfire-uarts.patch
m68knommu-platform-setup-for-5206e-coldfire-uarts.patch
m68knommu-platform-setup-for-520x-coldfire-uarts.patch
m68knommu-platform-setup-for-5249-coldfire-uarts.patch
m68knommu-platform-setup-for-5272-coldfire-uarts.patch
add-cmpxchg_local-to-m68knommu.patch

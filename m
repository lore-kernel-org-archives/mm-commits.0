From: akpm@linux-foundation.org
Subject: [merged] net-thunderx-add-64-bit-dependency.patch removed from
 -mm tree
Date: Mon, 01 Jun 2015 12:16:06 -0700
Message-ID: <556caf76.fpGJcD3PIEiQnnTl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47444 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753433AbbFATQG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Jun 2015 15:16:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     Subject: net: thunderx: add 64-bit dependency
has been removed from the -mm tree.  Its filename was
     net-thunderx-add-64-bit-dependency.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: net: thunderx: add 64-bit dependency

The thunderx ethernet driver fails to build on architectures
that do not have an atomic readq() and writeq() function for
64-bit PCI bus access:

drivers/net/ethernet/cavium/thunder/thunder_bgx.c: In function 'bgx_reg_read':
include/asm-generic/io.h:195:23: error: implicit declaration of function 'readq' [-Werror=implicit-function-declaration]

It seems impossible to get this driver to work on most 32-bit
hardware, so it's better to add an explicit dependency, in
order to let us keep building 'allmodconfig' kernels on
all architectures.

As the driver is meant for the internal hardware on an arm64 SoC, this
is not a problem for usability. Allowing the build on all 64-bit
architectures rather than just CONFIG_ARM64 on the other hand means that
we get the benefit of build testing on x86.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/cavium/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/ethernet/cavium/Kconfig~net-thunderx-add-64-bit-dependency drivers/net/ethernet/cavium/Kconfig
--- a/drivers/net/ethernet/cavium/Kconfig~net-thunderx-add-64-bit-dependency
+++ a/drivers/net/ethernet/cavium/Kconfig
@@ -4,7 +4,7 @@
 
 config NET_VENDOR_CAVIUM
 	tristate "Cavium ethernet drivers"
-	depends on PCI
+	depends on PCI && 64BIT
 	---help---
 	  Enable support for the Cavium ThunderX Network Interface
 	  Controller (NIC). The NIC provides the controller and DMA
_

Patches currently in -mm which might be from arnd@arndb.de are

ocfs2-use-64bit-variables-to-track-heartbeat-time.patch
scsi-resolve-sg-buffer-const-ness-issue.patch
scsi-resolve-sg-buffer-const-ness-issue-fix.patch
linux-next.patch


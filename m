From: akpm@linux-foundation.org
Subject: - serial_txx9-use-assigned-device-numbers.patch removed from -mm tree
Date: Tue, 08 May 2007 19:50:41 -0700
Message-ID: <200705090250.l492ofpI009379@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35571 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S970017AbXEICux (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:50:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     serial_txx9: Use assigned device numbers
has been removed from the -mm tree.  Its filename was
     serial_txx9-use-assigned-device-numbers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: serial_txx9: Use assigned device numbers
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

The serial_txx9 driver have abused device numbers (major 4, minor 128) if
CONFIG_SERIAL_TXX9_STDSERIAL was not set.  This patch makes the driver use
proper device numbers assigned for it (major 204, minor 196-203).  I
suppose a typical user of this driver set CONFIG_SERIAL_TXX9_STDSERIAL to Y
(i.e.  use "ttyS0"), so this patch would not cause big compatibility issue.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/serial_txx9.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/serial/serial_txx9.c~serial_txx9-use-assigned-device-numbers drivers/serial/serial_txx9.c
--- a/drivers/serial/serial_txx9.c~serial_txx9-use-assigned-device-numbers
+++ a/drivers/serial/serial_txx9.c
@@ -62,7 +62,7 @@
 
 #include <asm/io.h>
 
-static char *serial_version = "1.08";
+static char *serial_version = "1.09";
 static char *serial_name = "TX39/49 Serial driver";
 
 #define PASS_LIMIT	256
@@ -70,13 +70,14 @@ static char *serial_name = "TX39/49 Seri
 #if !defined(CONFIG_SERIAL_TXX9_STDSERIAL)
 /* "ttyS" is used for standard serial driver */
 #define TXX9_TTY_NAME "ttyTX"
-#define TXX9_TTY_MINOR_START	(64 + 64)	/* ttyTX0(128), ttyTX1(129) */
+#define TXX9_TTY_MINOR_START	196
+#define TXX9_TTY_MAJOR	204
 #else
 /* acts like standard serial driver */
 #define TXX9_TTY_NAME "ttyS"
 #define TXX9_TTY_MINOR_START	64
-#endif
 #define TXX9_TTY_MAJOR	TTY_MAJOR
+#endif
 
 /* flag aliases */
 #define UPF_TXX9_HAVE_CTS_LINE	UPF_BUGGY_UART
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

origin.patch
git-mips.patch
mips-make-resources-for-ds1742-static-__initdata.patch

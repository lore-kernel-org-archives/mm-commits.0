From: akpm@linux-foundation.org
Subject: - make-probe_serial_gsc-static.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:35:27 -0700
Message-ID: <200810202035.m9KKZRvO011154@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52971 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753109AbYJTUpl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:45:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     make probe_serial_gsc() static
has been removed from the -mm tree.  Its filename was
     make-probe_serial_gsc-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: make probe_serial_gsc() static
From: Adrian Bunk <bunk@kernel.org>

This patch makes the needlessly global probe_serial_gsc() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250_gsc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/serial/8250_gsc.c~make-probe_serial_gsc-static drivers/serial/8250_gsc.c
--- a/drivers/serial/8250_gsc.c~make-probe_serial_gsc-static
+++ a/drivers/serial/8250_gsc.c
@@ -111,7 +111,7 @@ static struct parisc_driver serial_drive
 	.probe		= serial_init_chip,
 };
 
-int __init probe_serial_gsc(void)
+static int __init probe_serial_gsc(void)
 {
 	register_parisc_driver(&lasi_driver);
 	register_parisc_driver(&serial_driver);
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
linux-next.patch
m32r-kernel-smpbootc-must-include-linux-cpuh.patch
the-overdue-eepro100-removal.patch
parisc-lib-make-code-static.patch
drivers-parisc-make-code-static.patch
if-0-ses_match_host.patch
drivers-scsi-a2091c-make-2-functions-static.patch
drivers-scsi-a3000c-make-2-functions-static.patch
fs_mbcache-dont-needlessly-make-it-built-in.patch
reiser4.patch


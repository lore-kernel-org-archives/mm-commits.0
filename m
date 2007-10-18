From: akpm@linux-foundation.org
Subject: - drivers-char-ip2-ip2mainc-kmalloc-memset-conversion-to-kzalloc.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:55:00 -0700
Message-ID: <200710180655.l9I6t06m030563@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36266 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760692AbXJRHhU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:37:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, mm-commits@vger.kernel.org


The patch titled
     drivers/char/ip2/ip2main.c: kmalloc + memset conversion to kzalloc
has been removed from the -mm tree.  Its filename was
     drivers-char-ip2-ip2mainc-kmalloc-memset-conversion-to-kzalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/char/ip2/ip2main.c: kmalloc + memset conversion to kzalloc
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/char/ip2/ip2main.c | 104398 -> 104346 (-52 bytes)
 drivers/char/ip2/ip2main.o | 210710 -> 210702 (-8 bytes)

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ip2/ip2main.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/char/ip2/ip2main.c~drivers-char-ip2-ip2mainc-kmalloc-memset-conversion-to-kzalloc drivers/char/ip2/ip2main.c
--- a/drivers/char/ip2/ip2main.c~drivers-char-ip2-ip2mainc-kmalloc-memset-conversion-to-kzalloc
+++ a/drivers/char/ip2/ip2main.c
@@ -646,10 +646,9 @@ ip2_loadmain(int *iop, int *irqp, unsign
 
 	for ( i = 0; i < IP2_MAX_BOARDS; ++i ) {
 		if ( ip2config.addr[i] ) {
-			pB = kmalloc( sizeof(i2eBordStr), GFP_KERNEL);
-			if ( pB != NULL ) {
+			pB = kzalloc(sizeof(i2eBordStr), GFP_KERNEL);
+			if (pB) {
 				i2BoardPtrTable[i] = pB;
-				memset( pB, 0, sizeof(i2eBordStr) );
 				iiSetAddress( pB, ip2config.addr[i], ii2DelayTimer );
 				iiReset( pB );
 			} else {
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

origin.patch
git-cifs.patch
kernel-forkc-remove-unneeded-variable-initialization-in-copy_process.patch
fs-reiser4-plugin-file-cryptcompressc-kmalloc-memset-conversion-to-kzalloc.patch
reiser4-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-init_superc-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-plugin-inode_ops_renamec-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-ktxnmgrdc-kmalloc-memset-conversion-to-kzalloc.patch

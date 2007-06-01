From: akpm@linux-foundation.org
Subject: - fix-broken-clir-in-isdn-driver.patch removed from -mm tree
Date: Fri, 01 Jun 2007 10:47:55 -0700
Message-ID: <200706011747.l51HlsBV015162@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:37355 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761515AbXFARsb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2007 13:48:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kkeil@suse.de, matthias.goebl@goebl.net, mm-commits@vger.kernel.org


The patch titled
     Fix broken CLIR in isdn driver
has been removed from the -mm tree.  Its filename was
     fix-broken-clir-in-isdn-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix broken CLIR in isdn driver
From: Karsten Keil <kkeil@suse.de>

I noticed that CLIR (aka "hide your calling number") in isdn_tty is broken:
The at-command parser filters out the required "R" (e.g.  ATDR089123456)
It's been broken for a *very* long time.

Signed-off-by: Karsten Keil <kkeil@suse.de>
Signed-off-by: Matthias Goebl <matthias.goebl@goebl.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/i4l/isdn_tty.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/isdn/i4l/isdn_tty.c~fix-broken-clir-in-isdn-driver drivers/isdn/i4l/isdn_tty.c
--- a/drivers/isdn/i4l/isdn_tty.c~fix-broken-clir-in-isdn-driver
+++ a/drivers/isdn/i4l/isdn_tty.c
@@ -2693,8 +2693,9 @@ isdn_tty_getdial(char *p, char *q,int cn
 	int limit = ISDN_MSNLEN - 1;	/* MUST match the size of interface var to avoid
 					buffer overflow */
 
-	while (strchr(" 0123456789,#.*WPTS-", *p) && *p && --cnt>0) {
+	while (strchr(" 0123456789,#.*WPTSR-", *p) && *p && --cnt>0) {
 		if ((*p >= '0' && *p <= '9') || ((*p == 'S') && first) ||
+		    ((*p == 'R') && first) ||
 		    (*p == '*') || (*p == '#')) {
 			*q++ = *p;
 			limit--;
_

Patches currently in -mm which might be from kkeil@suse.de are

origin.patch
use-mutex-instead-of-semaphore-in-capi-20-driver.patch
make-isdn-capi-use-seq_list_xxx-helpers.patch
update-isdn-tree-to-use-pci_get_device.patch
use-menuconfig-objects-isdn-config_isdn.patch
use-menuconfig-objects-isdn-config_isdn_i4l.patch
use-menuconfig-objects-isdn-config_isdn_drv_gigaset.patch
use-menuconfig-objects-isdn-config_isdn_capi.patch
use-menuconfig-objects-isdn-config_capi_avm.patch
use-menuconfig-objects-isdn-config_capi_eicon.patch

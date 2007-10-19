From: akpm@linux-foundation.org
Subject: - netport_conc-fix-build-errors-and-warnings.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:40:16 -0700
Message-ID: <200710190340.l9J3eGqb012697@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50007 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965653AbXJSDlH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:41:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ralf@linux-mips.org, adaplas@pol.net, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     netport_con.c: fix build errors and warnings
has been removed from the -mm tree.  Its filename was
     netport_conc-fix-build-errors-and-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: netport_con.c: fix build errors and warnings
From: Ralf Baechle <ralf@linux-mips.org>

Fix build broken by accaa24c492f1aa3b9c37226d868dc59c3007531:

  CC      drivers/video/console/newport_con.o
drivers/video/console/newport_con.c: In function 'newport_show_logo':
drivers/video/console/newport_con.c:111: error: assignment of read-only location
drivers/video/console/newport_con.c:111: warning: assignment makes integer from pointer without a cast
drivers/video/console/newport_con.c:112: error: assignment of read-only location
drivers/video/console/newport_con.c:112: warning: assignment makes integer from pointer without a cast

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/newport_con.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/video/console/newport_con.c~netport_conc-fix-build-errors-and-warnings drivers/video/console/newport_con.c
--- a/drivers/video/console/newport_con.c~netport_conc-fix-build-errors-and-warnings
+++ a/drivers/video/console/newport_con.c
@@ -98,7 +98,7 @@ static inline void newport_init_cmap(voi
 	}
 }
 
-static struct linux_logo *newport_show_logo(void)
+static const struct linux_logo *newport_show_logo(void)
 {
 #ifdef CONFIG_LOGO_SGI_CLUT224
 	const struct linux_logo *logo = fb_find_logo(8);
@@ -108,8 +108,8 @@ static struct linux_logo *newport_show_l
 
 	if (!logo)
 		return NULL;
-	*clut = logo->clut;
-	*data = logo->data;
+	clut = logo->clut;
+	data = logo->data;
 
 	for (i = 0; i < logo->clutsize; i++) {
 		newport_bfwait(npregs);
_

Patches currently in -mm which might be from ralf@linux-mips.org are

origin.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
define-global-bit-macro.patch

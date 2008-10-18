From: akpm@linux-foundation.org
Subject: - cirrusfb-add-noaccel-module-parameter.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:17:24 -0700
Message-ID: <200810182317.m9INHO5b029082@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53422 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751812AbYJRXR0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:17:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     cirrusfb: add noaccel module parameter
has been removed from the -mm tree.  Its filename was
     cirrusfb-add-noaccel-module-parameter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cirrusfb: add noaccel module parameter
From: Krzysztof Helt <krzysztof.h1@wp.pl>

The noaccel parameter is already handled if the driver is not built as
module.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cirrusfb.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/video/cirrusfb.c~cirrusfb-add-noaccel-module-parameter drivers/video/cirrusfb.c
--- a/drivers/video/cirrusfb.c~cirrusfb-add-noaccel-module-parameter
+++ a/drivers/video/cirrusfb.c
@@ -352,7 +352,7 @@ struct cirrusfb_info {
 	void (*unmap)(struct fb_info *info);
 };
 
-static int noaccel;
+static int noaccel __devinitdata;
 static char *mode_option __devinitdata = "640x480@60";
 
 /****************************************************************************/
@@ -2525,6 +2525,8 @@ module_init(cirrusfb_init);
 
 module_param(mode_option, charp, 0);
 MODULE_PARM_DESC(mode_option, "Initial video mode e.g. '648x480-8@60'");
+module_param(noaccel, bool, 0);
+MODULE_PARM_DESC(noaccel, "Disable acceleration");
 
 #ifdef MODULE
 module_exit(cirrusfb_exit);
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
fb-convert-lock-unlock_kernel-into-local-fb-mutex.patch


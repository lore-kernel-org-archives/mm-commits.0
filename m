From: akpm@linux-foundation.org
Subject: + tdfxfb-mtrr-support-fix-2.patch added to -mm tree
Date: Thu, 09 Aug 2007 11:29:56 -0700
Message-ID: <200708091829.l79ITuji012972@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43032 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751073AbXHISaE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 14:30:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl


The patch titled
     tdfxfb-mtrr-support fix-2
has been added to the -mm tree.  Its filename is
     tdfxfb-mtrr-support-fix-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: tdfxfb-mtrr-support fix-2
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch fixes compilation with setup options bug and corrects
description of the nomtrr option.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tdfxfb.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/video/tdfxfb.c~tdfxfb-mtrr-support-fix-2 drivers/video/tdfxfb.c
--- a/drivers/video/tdfxfb.c~tdfxfb-mtrr-support-fix-2
+++ a/drivers/video/tdfxfb.c
@@ -1337,8 +1337,8 @@ static void tdfxfb_setup(char *options)
 			nopan = 1;
 		} else if (!strcmp(this_opt, "nowrap")) {
 			nowrap = 1;
-		} else if (!strcmp(this_opt, "hwcursor")) {
-			hwcursor = simple_strtoul(opt + 9, NULL, 0);
+		} else if (!strncmp(this_opt, "hwcursor=", 9)) {
+			hwcursor = simple_strtoul(this_opt + 9, NULL, 0);
 #ifdef CONFIG_MTRR
 		} else if (!strncmp(this_opt, "nomtrr", 6)) {
 			nomtrr = 1;
@@ -1409,7 +1409,7 @@ MODULE_PARM_DESC(hwcursor, "Enable hardw
 			"(1=enable, 0=disable, default=1)");
 #ifdef CONFIG_MTRR
 module_param(nomtrr, bool, 0);
-MODULE_PARM_DESC(nomtrr, "Disable MTRR support (0 or 1=disabled) (default=0)");
+MODULE_PARM_DESC(nomtrr, "Disable MTRR support (default: enabled)");
 #endif
 
 module_init(tdfxfb_init);
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

git-hwmon.patch
pm3fb-copyarea-and-partial-imageblit-suppor.patch
skeletonfb-wrong-field-name-fix.patch
pm3fb-header-file-reduction.patch
pm3fb-imageblit-improved.patch
pm3fb-3-small-fixes.patch
pm3fb-improvements-and-cleanups.patch
pm3fb-mtrr-support-and-noaccel-option.patch
pm2fb-mtrr-support-and-noaccel-option.patch
pm2fb-accelerated-imageblit.patch
pm2fb-source-code-improvements.patch
pm2fb-permedia-2v-initialization-fixes.patch
pm2fb-accelerated-24-bit-fillrect.patch
tridentfb-coding-style-improvement.patch
tdfxfb-coding-style-improvement.patch
tdfxfb-3-fixes.patch
tdfxfb-palette-fixes.patch
tdfxfb-code-improvements.patch
tdfxfb-hardware-cursor.patch
tdfxfb-mtrr-support.patch
tdfxfb-mtrr-support-fix.patch
tdfxfb-mtrr-support-fix-2.patch
pm2fb-checkpatch-fixes.patch
pm3fb-checkpatch-fixes.patch

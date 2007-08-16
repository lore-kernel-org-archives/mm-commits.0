From: akpm@linux-foundation.org
Subject: + pm3fb-mtrr-support-and-noaccel-option-make-pm3fb_init-static-again.patch added to -mm tree
Date: Thu, 16 Aug 2007 13:34:38 -0700
Message-ID: <200708162034.l7GKYcZP005495@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57043 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756377AbXHPUe4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Aug 2007 16:34:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, adaplas@gmail.com, krzysztof.h1@wp.pl


The patch titled
     make pm3fb_init() static again
has been added to the -mm tree.  Its filename is
     pm3fb-mtrr-support-and-noaccel-option-make-pm3fb_init-static-again.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: make pm3fb_init() static again
From: Adrian Bunk <bunk@kernel.org>

pm3fb_init() needlessly became global.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pm3fb.c |    4 +---
 1 files changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/video/pm3fb.c~pm3fb-mtrr-support-and-noaccel-option-make-pm3fb_init-static-again drivers/video/pm3fb.c
--- a/drivers/video/pm3fb.c~pm3fb-mtrr-support-and-noaccel-option-make-pm3fb_init-static-again
+++ a/drivers/video/pm3fb.c
@@ -798,8 +798,6 @@ static void pm3fb_write_mode(struct fb_i
 /*
  * hardware independent functions
  */
-int pm3fb_init(void);
-
 static int pm3fb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 {
 	u32 lpitch;
@@ -1419,7 +1417,7 @@ static int __init pm3fb_setup(char *opti
 }
 #endif /* MODULE */
 
-int __init pm3fb_init(void)
+static int __init pm3fb_init(void)
 {
 	/*
 	 *  For kernel boot options (in 'video=pm3fb:<options>' format)
_

Patches currently in -mm which might be from bunk@kernel.org are

kconfig-syntax-cleanups.patch
pm3fb-mtrr-support-and-noaccel-option-make-pm3fb_init-static-again.patch
sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch

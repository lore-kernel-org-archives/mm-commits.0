From: akpm@linux-foundation.org
Subject: - pm3fb-mtrr-support-and-noaccel-option-make-pm3fb_init-static-again.patch removed from -mm tree
Date: Mon, 15 Oct 2007 21:58:04 -0700
Message-ID: <200710160458.l9G4w43Z009884@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60190 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756088AbXJPE6U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 00:58:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, adaplas@gmail.com, krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     make pm3fb_init() static again
has been removed from the -mm tree.  Its filename was
     pm3fb-mtrr-support-and-noaccel-option-make-pm3fb_init-static-again.patch

This patch was dropped because it was folded into pm3fb-mtrr-support-and-noaccel-option.patch

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

origin.patch
uml-fix-inlines.patch
i-oat-add-support-for-msi-and-msi-x.patch
pm3fb-mtrr-support-and-noaccel-option.patch
pm3fb-mtrr-support-and-noaccel-option-make-pm3fb_init-static-again.patch
bitmaph-remove-dead-artifacts.patch
sysctl-parport-remove-binary-paths-fix.patch
sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch
memory-controller-add-per-container-lru-and-reclaim-v7-cleanup.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-cleanup.patch
remove-asm-bitopsh-includes.patch
forbid-asm-bitopsh-direct-inclusion.patch
alpha-lock-bitops-fix.patch
reiser4-cryptcompress-misc-fixups-make-3-functions-static.patch
remove-asm-bitopsh-includes-reiser4.patch

From: akpm@linux-foundation.org
Subject: [folded-merged]
 arch-unicore32-kernel-early_printkc-setup_early_printk-missing-initialization-fix.patch removed from -mm tree
Date: Mon, 27 Jan 2014 16:54:55 -0800
Message-ID: <52e6ffdf.AReJ7LnZ8BUgE32u%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37798 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428AbaA1Ay4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 27 Jan 2014 19:54:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xypron.glpk@gmx.de, paul.gortmaker@windriver.com, gxt@mprc.pku.edu.cn, akpm@linux-foundation.org

Subject: [folded-merged] arch-unicore32-kernel-early_printkc-setup_early_printk-missing-initialization-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,gxt@mprc.pku.edu.cn,paul.gortmaker@windriver.com,xypron.glpk@gmx.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 27 Jan 2014 16:54:55 -0800


The patch titled
     Subject: arch-unicore32-kernel-early_printkc-setup_early_printk-missing-initialization-fix
has been removed from the -mm tree.  Its filename was
     arch-unicore32-kernel-early_printkc-setup_early_printk-missing-initialization-fix.patch

This patch was dropped because it was folded into arch-unicore32-kernel-early_printkc-setup_early_printk-missing-initialization.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: arch-unicore32-kernel-early_printkc-setup_early_printk-missing-initialization-fix

simplify code.

Cc: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/unicore32/kernel/early_printk.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff -puN arch/unicore32/kernel/early_printk.c~arch-unicore32-kernel-early_printkc-setup_early_printk-missing-initialization-fix arch/unicore32/kernel/early_printk.c
--- a/arch/unicore32/kernel/early_printk.c~arch-unicore32-kernel-early_printkc-setup_early_printk-missing-initialization-fix
+++ a/arch/unicore32/kernel/early_printk.c
@@ -35,17 +35,11 @@ static struct console early_ocd_console
 
 static int __init setup_early_printk(char *buf)
 {
-	int keep_early = 0;
-
 	if (!buf || early_console)
 		return 0;
 
-	if (strstr(buf, "keep"))
-		keep_early = 1;
-
 	early_console = &early_ocd_console;

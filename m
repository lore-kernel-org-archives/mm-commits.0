From: akpm@linux-foundation.org
Subject: [merged]
 arch-unicore32-kernel-early_printkc-setup_early_printk-missing-initialization.patch removed from -mm tree
Date: Tue, 28 Jan 2014 11:09:09 -0800
Message-ID: <52e80055.wKtN6TnET/arfVl2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45466 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143AbaA1TJK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jan 2014 14:09:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, paul.gortmaker@windriver.com, gxt@mprc.pku.edu.cn, xypron.glpk@gmx.de

Subject: [merged] arch-unicore32-kernel-early_printkc-setup_early_printk-missing-initialization.patch removed from -mm tree
To: xypron.glpk@gmx.de,gxt@mprc.pku.edu.cn,paul.gortmaker@windriver.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 Jan 2014 11:09:09 -0800


The patch titled
     Subject: arch/unicore32/kernel/early_printk.c:setup_early_printk: missing initialization
has been removed from the -mm tree.  Its filename was
     arch-unicore32-kernel-early_printkc-setup_early_printk-missing-initialization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: arch/unicore32/kernel/early_printk.c:setup_early_printk: missing initialization

Ii is based on uninitialized value keep_early.  This leads to
unpredictable result.

[akpm@linux-foundation.org: simplify code]
Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/unicore32/kernel/early_printk.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff -puN arch/unicore32/kernel/early_printk.c~arch-unicore32-kernel-early_printkc-setup_early_printk-missing-initialization arch/unicore32/kernel/early_printk.c
--- a/arch/unicore32/kernel/early_printk.c~arch-unicore32-kernel-early_printkc-setup_early_printk-missing-initialization
+++ a/arch/unicore32/kernel/early_printk.c
@@ -35,17 +35,11 @@ static struct console early_ocd_console
 
 static int __init setup_early_printk(char *buf)
 {
-	int keep_early;
-
 	if (!buf || early_console)
 		return 0;
 
-	if (strstr(buf, "keep"))
-		keep_early = 1;
-
 	early_console = &early_ocd_console;

From: akpm@linux-foundation.org
Subject: +
 arch-unicore32-kernel-early_printkc-setup_early_printk-missing-initialization.patch added to -mm tree
Date: Mon, 27 Jan 2014 13:50:08 -0800
Message-ID: <52e6d490.oDmr2abUGzwSkWm+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36753 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446AbaA0VuJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 27 Jan 2014 16:50:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, paul.gortmaker@windriver.com, gxt@mprc.pku.edu.cn, xypron.glpk@gmx.de

Subject: + arch-unicore32-kernel-early_printkc-setup_early_printk-missing-initialization.patch added to -mm tree
To: xypron.glpk@gmx.de,gxt@mprc.pku.edu.cn,paul.gortmaker@windriver.com
From: akpm@linux-foundation.org
Date: Mon, 27 Jan 2014 13:50:08 -0800


The patch titled
     Subject: arch/unicore32/kernel/early_printk.c:setup_early_printk: missing initialization
has been added to the -mm tree.  Its filename is
     arch-unicore32-kernel-early_printkc-setup_early_printk-missing-initialization.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-unicore32-kernel-early_printkc-setup_early_printk-missing-initialization.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-unicore32-kernel-early_printkc-setup_early_printk-missing-initialization.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: arch/unicore32/kernel/early_printk.c:setup_early_printk: missing initialization

Ii is based on uninitialized value keep_early.  This leads to
unpredictable result.

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/unicore32/kernel/early_printk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/unicore32/kernel/early_printk.c~arch-unicore32-kernel-early_printkc-setup_early_printk-missing-initialization arch/unicore32/kernel/early_printk.c
--- a/arch/unicore32/kernel/early_printk.c~arch-unicore32-kernel-early_printkc-setup_early_printk-missing-initialization
+++ a/arch/unicore32/kernel/early_printk.c
@@ -35,7 +35,7 @@ static struct console early_ocd_console
 
 static int __init setup_early_printk(char *buf)
 {
-	int keep_early;
+	int keep_early = 0;
 
 	if (!buf || early_console)
 		return 0;
_

Patches currently in -mm which might be from xypron.glpk@gmx.de are

arch-unicore32-kernel-early_printkc-setup_early_printk-missing-initialization.patch
arch-unicore32-kernel-early_printkc-setup_early_printk-missing-initialization-fix.patch


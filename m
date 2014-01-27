From: akpm@linux-foundation.org
Subject: +
 arch-unicore32-kernel-early_printkc-setup_early_printk-missing-initialization-fix.patch added to -mm tree
Date: Mon, 27 Jan 2014 13:50:09 -0800
Message-ID: <52e6d491.N6y7Rz1cXZdTy0A5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36757 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000AbaA0VuK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 27 Jan 2014 16:50:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xypron.glpk@gmx.de, paul.gortmaker@windriver.com, gxt@mprc.pku.edu.cn, akpm@linux-foundation.org

Subject: + arch-unicore32-kernel-early_printkc-setup_early_printk-missing-initialization-fix.patch added to -mm tree
To: akpm@linux-foundation.org,gxt@mprc.pku.edu.cn,paul.gortmaker@windriver.com,xypron.glpk@gmx.de
From: akpm@linux-foundation.org
Date: Mon, 27 Jan 2014 13:50:09 -0800


The patch titled
     Subject: arch-unicore32-kernel-early_printkc-setup_early_printk-missing-initialization-fix
has been added to the -mm tree.  Its filename is
     arch-unicore32-kernel-early_printkc-setup_early_printk-missing-initialization-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-unicore32-kernel-early_printkc-setup_early_printk-missing-initialization-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-unicore32-kernel-early_printkc-setup_early_printk-missing-initialization-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
-
-	if (keep_early)
+	if (strstr(buf, "keep"))
 		early_console->flags &= ~CON_BOOT;
 	else
 		early_console->flags |= CON_BOOT;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
arch-unicore32-kernel-early_printkc-setup_early_printk-missing-initialization-fix.patch
lib-genallocc-add-check-gen_pool_dma_alloc-if-dma-pointer-is-not-null.patch
mm-document-improved-handling-of-swappiness==0-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-fix-ocfs2_sync_file-if-filesystem-is-readonly-fix.patch
mm.patch
mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix.patch
ipcmsg-document-barriers-fix.patch
ipcmsg-document-barriers-fix-fix.patch
linux-next.patch
linux-next-git-rejects.patch
block-blk-mq-cpuc-use-hotcpu_notifier.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


From: akpm@linux-foundation.org
Subject: - powerpc-export-copy_page-on-32bit.patch removed from -mm tree
Date: Mon, 28 Jan 2008 17:49:22 -0800
Message-ID: <200801290149.m0T1nMMg027485@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52921 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755691AbYA2B7Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jan 2008 20:59:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jfannin@gmail.com, benh@kernel.crashing.org, ezk@cs.sunysb.edu, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     powerpc: export copy_page() on 32bit
has been removed from the -mm tree.  Its filename was
     powerpc-export-copy_page-on-32bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc: export copy_page() on 32bit
From: Joseph Fannin <jfannin@gmail.com>

Export copy_page() on 32bit powerpc; unionfs needs it.

Unionfs already builds as a module on 64bit powerpc, so the export is
placed within an existing CONFIG_PPC32 #ifdef.

(akpm: targetted at git-unionfs.patch)

Signed-off-by: Joseph Fannin <jfannin@gmail.com>
Cc: Erez Zadok <ezk@cs.sunysb.edu>
Cc: Paul Mackerras <paulus@samba.org>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/ppc_ksyms.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/powerpc/kernel/ppc_ksyms.c~powerpc-export-copy_page-on-32bit arch/powerpc/kernel/ppc_ksyms.c
--- a/arch/powerpc/kernel/ppc_ksyms.c~powerpc-export-copy_page-on-32bit
+++ a/arch/powerpc/kernel/ppc_ksyms.c
@@ -59,6 +59,7 @@ extern void single_step_exception(struct
 extern int sys_sigreturn(struct pt_regs *regs);
 
 EXPORT_SYMBOL(clear_pages);
+EXPORT_SYMBOL(copy_page);
 EXPORT_SYMBOL(ISA_DMA_THRESHOLD);
 EXPORT_SYMBOL(DMA_MODE_READ);
 EXPORT_SYMBOL(DMA_MODE_WRITE);
_

Patches currently in -mm which might be from jfannin@gmail.com are

git-powerpc.patch

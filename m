From: akpm@linux-foundation.org
Subject: + powerpc-export-copy_page-on-32bit.patch added to -mm tree
Date: Fri, 11 Jan 2008 17:10:24 -0800
Message-ID: <200801120110.m0C1AOCv007163@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48692 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932083AbYALBKh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jan 2008 20:10:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jfannin@gmail.com, benh@kernel.crashing.org, ezk@cs.sunysb.edu, paulus@samba.org


The patch titled
     powerpc: export copy_page() on 32bit
has been added to the -mm tree.  Its filename is
     powerpc-export-copy_page-on-32bit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
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

powerpc-export-copy_page-on-32bit.patch

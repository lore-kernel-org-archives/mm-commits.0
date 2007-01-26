From: akpm@osdl.org
Subject: + i386-kwatch-kernel-watchpoints-using-cpu-debug-registers-fix.patch added to -mm tree
Date: Fri, 26 Jan 2007 12:51:33 -0800
Message-ID: <200701262051.l0QKpXC3026187@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:54678 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595AbXAZUwW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 15:52:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michal.k.k.piotrowski@gmail.com, ak@suse.de, hch@infradead.org, mingo@elte.hu, prasanna@in.ibm.com, roland@redhat.com, stern@rowland.harvard.edu


The patch titled
     i386-kwatch-kernel-watchpoints-using-cpu-debug-registers fix
has been added to the -mm tree.  Its filename is
     i386-kwatch-kernel-watchpoints-using-cpu-debug-registers-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386-kwatch-kernel-watchpoints-using-cpu-debug-registers fix
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

In file included from arch/i386/kernel/process.c:56:
include/asm/debugreg.h:84: error: expected identifier or '(' before '{' token
make[1]: *** [arch/i386/kernel/process.o] Error 1
make: *** [arch/i386/kernel] Error 2

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Roland McGrath <roland@redhat.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/asm-i386/debugreg.h |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-i386/debugreg.h~i386-kwatch-kernel-watchpoints-using-cpu-debug-registers-fix include/asm-i386/debugreg.h
--- a/include/asm-i386/debugreg.h~i386-kwatch-kernel-watchpoints-using-cpu-debug-registers-fix
+++ a/include/asm-i386/debugreg.h
@@ -80,7 +80,7 @@ extern int enable_debugreg(unsigned long
 
 #else
 
-static inline void set_process_debugreg7(unsigned long new_dr7);
+static inline void set_process_debugreg7(unsigned long new_dr7)
 {
 	set_debugreg(new_dr7, 7);
 }
_

Patches currently in -mm which might be from michal.k.k.piotrowski@gmail.com are

drivers-scsi-pcmcia-nsp_csh-removal-of-old.patch
i386-kwatch-kernel-watchpoints-using-cpu-debug-registers-fix.patch
touchkit-ps-2-touchscreen-driver.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
reiser4-configh.patch

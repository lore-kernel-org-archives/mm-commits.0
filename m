From: akpm@osdl.org
Subject: - use-constant-instead-of-raw-number-in-x86_64-iopermc.patch removed from -mm tree
Date: Wed, 10 Jan 2007 15:03:50 -0800
Message-ID: <200701102303.l0AN3owY010860@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33487 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965280AbXAJXED (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jan 2007 18:04:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gcosta@redhat.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     Use constant instead of raw number in x86_64 ioperm.c
has been removed from the -mm tree.  Its filename was
     use-constant-instead-of-raw-number-in-x86_64-iopermc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Use constant instead of raw number in x86_64 ioperm.c
From: Glauber de Oliveira Costa <gcosta@redhat.com>

This is a tiny cleanup to increase readability

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/x86_64/kernel/ioport.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86_64/kernel/ioport.c~use-constant-instead-of-raw-number-in-x86_64-iopermc arch/x86_64/kernel/ioport.c
--- a/arch/x86_64/kernel/ioport.c~use-constant-instead-of-raw-number-in-x86_64-iopermc
+++ a/arch/x86_64/kernel/ioport.c
@@ -114,6 +114,6 @@ asmlinkage long sys_iopl(unsigned int le
 		if (!capable(CAP_SYS_RAWIO))
 			return -EPERM;
 	}
-	regs->eflags = (regs->eflags &~ 0x3000UL) | (level << 12);
+	regs->eflags = (regs->eflags &~ X86_EFLAGS_IOPL) | (level << 12);
 	return 0;
 }
_

Patches currently in -mm which might be from gcosta@redhat.com are

From: akpm@linux-foundation.org
Subject: + unicore32-remove-unnecessary-kern_err-in-fpu-ucf64c.patch added to -mm tree
Date: Thu, 26 Feb 2015 15:25:29 -0800
Message-ID: <54efab69.i8KNBgc/lFAKOFLY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60383 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976AbbBZXZ3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Feb 2015 18:25:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: standby24x7@gmail.com, gxt@mprc.pku.edu.cn, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/unicore32/kernel/fpu-ucf64.c: remove unnecessary KERN_ERR
has been added to the -mm tree.  Its filename is
     unicore32-remove-unnecessary-kern_err-in-fpu-ucf64c.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/unicore32-remove-unnecessary-kern_err-in-fpu-ucf64c.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/unicore32-remove-unnecessary-kern_err-in-fpu-ucf64c.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Masanari Iida <standby24x7@gmail.com>
Subject: arch/unicore32/kernel/fpu-ucf64.c: remove unnecessary KERN_ERR

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/unicore32/kernel/fpu-ucf64.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/unicore32/kernel/fpu-ucf64.c~unicore32-remove-unnecessary-kern_err-in-fpu-ucf64c arch/unicore32/kernel/fpu-ucf64.c
--- a/arch/unicore32/kernel/fpu-ucf64.c~unicore32-remove-unnecessary-kern_err-in-fpu-ucf64c
+++ a/arch/unicore32/kernel/fpu-ucf64.c
@@ -90,8 +90,8 @@ void ucf64_exchandler(u32 inst, u32 fpex
 			tmp &= ~(FPSCR_CON);
 		exc &= ~(FPSCR_CMPINSTR_BIT | FPSCR_CON);
 	} else {
-		pr_debug(KERN_ERR "UniCore-F64 Error: unhandled exceptions\n");
-		pr_debug(KERN_ERR "UniCore-F64 FPSCR 0x%08x INST 0x%08x\n",
+		pr_debug("UniCore-F64 Error: unhandled exceptions\n");
+		pr_debug("UniCore-F64 FPSCR 0x%08x INST 0x%08x\n",
 				cff(FPSCR), inst);
 
 		ucf64_raise_sigfpe(0, regs);
_

Patches currently in -mm which might be from standby24x7@gmail.com are

linux-next.patch
unicore32-remove-unnecessary-kern_err-in-fpu-ucf64c.patch


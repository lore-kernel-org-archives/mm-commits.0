From: akpm@linux-foundation.org
Subject: + mips-vpe-remove-leftover-unlock_kernel.patch added to -mm tree
Date: Mon, 02 Nov 2009 23:01:38 -0800
Message-ID: <200911030701.nA371cAP019835@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37280 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753248AbZKCHCX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Nov 2009 02:02:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jkacur@redhat.com, ralf@linux-mips.org


The patch titled
     mips: vpe: remove leftover unlock_kernel()
has been added to the -mm tree.  Its filename is
     mips-vpe-remove-leftover-unlock_kernel.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mips: vpe: remove leftover unlock_kernel()
From: John Kacur <jkacur@redhat.com>

commit 1bbfc20d0161cd94b1b8111566be2fa41b41b608 ("MIPS: VPE: Get rid of
BKL.") was supposed to have removed the BKL, but there is a leftover and
unpaired unlock_kernel call in the function vpe_open.  Remove it.

Signed-off-by: John Kacur <jkacur@redhat.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/vpe.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN arch/mips/kernel/vpe.c~mips-vpe-remove-leftover-unlock_kernel arch/mips/kernel/vpe.c
--- a/arch/mips/kernel/vpe.c~mips-vpe-remove-leftover-unlock_kernel
+++ a/arch/mips/kernel/vpe.c
@@ -38,7 +38,6 @@
 #include <linux/vmalloc.h>
 #include <linux/elf.h>
 #include <linux/seq_file.h>
-#include <linux/smp_lock.h>
 #include <linux/syscalls.h>
 #include <linux/moduleloader.h>
 #include <linux/interrupt.h>
@@ -1116,8 +1115,6 @@ static int vpe_open(struct inode *inode,
 	v->shared_ptr = NULL;
 	v->__start = 0;
 
-	unlock_kernel();

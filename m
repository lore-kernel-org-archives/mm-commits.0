From: akpm@linux-foundation.org
Subject: + voyager-include-asm-smph-to-fix-compile-error.patch added to -mm tree
Date: Mon, 10 Sep 2007 22:35:28 -0700
Message-ID: <200709110535.l8B5ZScx027559@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47632 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753283AbXIKFfj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Sep 2007 01:35:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tklauser@distanz.ch, James.Bottomley@steeleye.com, ak@suse.de


The patch titled
     voyager: #include <asm/smp.h> to fix compile error
has been added to the -mm tree.  Its filename is
     voyager-include-asm-smph-to-fix-compile-error.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: voyager: #include <asm/smp.h> to fix compile error
From: Tobias Klauser <tklauser@distanz.ch>

Include smp.h to fix the following error when compiling with
CONFIG_X86_VOYAGER=y and CONFIG_SMP not set (found using 'make
randconfig').

arch/i386/mach-voyager/setup.c: In function 'time_init_hook':
arch/i386/mach-voyager/setup.c:52: error: implicit declaration of function 'safe_smp_processor_id'

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/mach-voyager/setup.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/i386/mach-voyager/setup.c~voyager-include-asm-smph-to-fix-compile-error arch/i386/mach-voyager/setup.c
--- a/arch/i386/mach-voyager/setup.c~voyager-include-asm-smph-to-fix-compile-error
+++ a/arch/i386/mach-voyager/setup.c
@@ -9,6 +9,7 @@
 #include <asm/e820.h>
 #include <asm/io.h>
 #include <asm/setup.h>
+#include <asm/smp.h>
 
 void __init pre_intr_init_hook(void)
 {
_

Patches currently in -mm which might be from tklauser@distanz.ch are

voyager-include-asm-smph-to-fix-compile-error.patch

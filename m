From: akpm@linux-foundation.org
Subject: + kvmclockc-fix-section-mismatch-warning.patch added to -mm tree
Date: Mon, 20 Oct 2008 16:56:44 -0700
Message-ID: <200810202356.m9KNuiLK015579@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40182 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755222AbYJTX47 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 19:56:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rakib.mullick@gmail.com, avi@qumranet.com, mingo@elte.hu


The patch titled
     kvmclock.c: fix section mismatch warning
has been added to the -mm tree.  Its filename is
     kvmclockc-fix-section-mismatch-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kvmclock.c: fix section mismatch warning
From: "Rakib Mullick" <rakib.mullick@gmail.com>

WARNING: arch/x86/kernel/built-in.o(.text+0x1722c): Section mismatch
in reference from the function kvm_setup_secondary_clock() to the
function .devinit.text:setup_secondary_APIC_clock()
The function kvm_setup_secondary_clock() references
the function __devinit setup_secondary_APIC_clock().
This is often because kvm_setup_secondary_clock lacks a __devinit
annotation or the annotation of setup_secondary_APIC_clock is wrong.

Signed-off-by: Md.Rakib H. Mullick <rakib.mullick@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/kvmclock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/kernel/kvmclock.c~kvmclockc-fix-section-mismatch-warning arch/x86/kernel/kvmclock.c
--- a/arch/x86/kernel/kvmclock.c~kvmclockc-fix-section-mismatch-warning
+++ a/arch/x86/kernel/kvmclock.c
@@ -128,7 +128,7 @@ static int kvm_register_clock(char *txt)
 }
 
 #ifdef CONFIG_X86_LOCAL_APIC
-static void kvm_setup_secondary_clock(void)
+static void __devinit kvm_setup_secondary_clock(void)
 {
 	/*
 	 * Now that the first cpu already had this clocksource initialized,
_

Patches currently in -mm which might be from rakib.mullick@gmail.com are

origin.patch
kvmclockc-fix-section-mismatch-warning.patch
init-properly-placing-noinline-keyword.patch


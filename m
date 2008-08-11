From: akpm@linux-foundation.org
Subject: + gcov-architecture-specific-compile-flag-adjustments-x86_64-fix-2.patch added to -mm tree
Date: Mon, 11 Aug 2008 14:10:27 -0700
Message-ID: <200808112110.m7BLASEe021542@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42635 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754464AbYHKVMI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Aug 2008 17:12:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.kozlowski@tuxland.pl, peter.oberparleiter@de.ibm.com


The patch titled
     unable to boot with gcov on x86_64
has been added to the -mm tree.  Its filename is
     gcov-architecture-specific-compile-flag-adjustments-x86_64-fix-2.patch

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
Subject: unable to boot with gcov on x86_64
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

I'm seeing similar GCOV problems as with 2.6.26-rc5-mm1 that you fixed. 
This is the same x86_64 box and again it was unable to boot with gcov
enabled.  A quick look revealed that arch/x86/kernel/tsc_64.c and
arch/x86/kernel/tsc_32.ccode was unified.  Unfortunately simple change of

GCOV_tsc_32.o := n
GCOV_tsc_64.o := n

to

GCOV_tsc.o := n

did not help.  Given the amount of combinations of which set of files with
GCOV might cause failures I was rather fortunate and after a few hours I
was able to pinpoint exactly two files which need GCOV disabled to make my
x86_64 boot.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/x86/kernel/Makefile~gcov-architecture-specific-compile-flag-adjustments-x86_64-fix-2 arch/x86/kernel/Makefile
--- a/arch/x86/kernel/Makefile~gcov-architecture-specific-compile-flag-adjustments-x86_64-fix-2
+++ a/arch/x86/kernel/Makefile
@@ -13,8 +13,8 @@ CFLAGS_REMOVE_rtc.o = -pg
 CFLAGS_REMOVE_paravirt.o = -pg
 endif
 
-GCOV_tsc_32.o := n
-GCOV_tsc_64.o := n
+GCOV_vsyscall_64.o := n
+GCOV_tsc.o := n
 
 #
 # vsyscalls (which work on the user stack) should have
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

gcov-architecture-specific-compile-flag-adjustments-x86_64-fix.patch
gcov-architecture-specific-compile-flag-adjustments-x86_64-fix-2.patch
reiser4.patch


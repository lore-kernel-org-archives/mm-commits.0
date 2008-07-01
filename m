From: akpm@linux-foundation.org
Subject: + gcov-architecture-specific-compile-flag-adjustments-x86_64-fix.patch added to -mm tree
Date: Tue, 01 Jul 2008 00:55:27 -0700
Message-ID: <200807010755.m617tR0s015997@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39720 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751936AbYGAIBP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 04:01:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peter.oberparleiter@de.ibm.com, balbir@linux.vnet.ibm.com, m.kozlowski@tuxland.pl


The patch titled
     gcov: fix run-time error on x86_64
has been added to the -mm tree.  Its filename is
     gcov-architecture-specific-compile-flag-adjustments-x86_64-fix.patch

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
Subject: gcov: fix run-time error on x86_64
From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>

Disable profiling of tsc_$(BITS).o to fix a run-time error when using
CONFIG_GCOV_PROFILE_ALL on x86_64:

bash[498] segfault at ffffffff80868b58 ip ffffffffff600412
          sp 7fffa3d010f0 error 7
init[1] segfault at ffffffff80868b58 ip ffffffffff600412
        sp 7fff9e97f640 error 7
init[1] segfault at ffffffff80868b58 ip ffffffffff600412
        sp 7fff9e97eed0 error 7
Kernel panic - not syncing: Attemted to kill init!
Pid 1, comm: init Not tainted 2.6.26-rc5-mm1 #1

m.kozlowski@tuxland.pl wrote:
> After a few hours and tons of reboots I narrowed it down to
> arch/x86/kernel/Makefile:
>
> a) works
>	obj-y                   += tsc_$(BITS).o io_delay.o rtc.o
> 	GCOV_tsc_$(BITS).o      := n
> 	#GCOV_io_delay.o        := n
> 	#GCOV_rtc.o     := n
>
> b) doesn't work
> 	obj-y                   += tsc_$(BITS).o io_delay.o rtc.o
> 	#GCOV_tsc_$(BITS).o     := n
> 	#GCOV_io_delay.o        := n
>	#GCOV_rtc.o     := n
>
> and that points to arch/x86/kernel/tsc_64.c

Reported-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Reviewed-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Reviewed-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/Makefile |    3 +++
 1 file changed, 3 insertions(+)

diff -puN arch/x86/kernel/Makefile~gcov-architecture-specific-compile-flag-adjustments-x86_64-fix arch/x86/kernel/Makefile
--- a/arch/x86/kernel/Makefile~gcov-architecture-specific-compile-flag-adjustments-x86_64-fix
+++ a/arch/x86/kernel/Makefile
@@ -13,6 +13,9 @@ CFLAGS_REMOVE_tsc_32.o = -pg
 CFLAGS_REMOVE_rtc.o = -pg
 endif
 
+GCOV_tsc_32.o := n
+GCOV_tsc_64.o := n
+
 #
 # vsyscalls (which work on the user stack) should have
 # no stack-protector checks:
_

Patches currently in -mm which might be from peter.oberparleiter@de.ibm.com are

s390-cio-use-memory_read_from_buffer.patch
kernel-call-constructors.patch
kernel-call-constructors-uml-fix-1.patch
kernel-call-constructors-uml-fix-2.patch
kernel-introduce-gcc_version_lower-macro.patch
seq_file-add-function-to-write-binary-data.patch
gcov-add-gcov-profiling-infrastructure.patch
gcov-add-gcov-profiling-infrastructure-revert-link-changes.patch
gcov-create-links-to-gcda-files-in-build-directory.patch
gcov-architecture-specific-compile-flag-adjustments.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-fix.patch
gcov-architecture-specific-compile-flag-adjustments-x86_64-fix.patch


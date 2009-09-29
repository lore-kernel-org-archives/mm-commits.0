From: akpm@linux-foundation.org
Subject: + xtensa-includecheck-fix-vectorss.patch added to -mm tree
Date: Tue, 29 Sep 2009 16:23:25 -0700
Message-ID: <200909292323.n8TNNPRM013624@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48053 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753237AbZI2XYZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Sep 2009 19:24:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jaswinder@kernel.org, chris@zankel.net, jaswinderrajput@gmail.com


The patch titled
     xtensa: includecheck fix: vectors.S
has been added to the -mm tree.  Its filename is
     xtensa-includecheck-fix-vectorss.patch

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
Subject: xtensa: includecheck fix: vectors.S
From: Jaswinder Singh Rajput <jaswinder@kernel.org>

fix the following 'make includecheck' warnings:

  arch/xtensa/kernel/vectors.S: asm/processor.h is included more than once.
  arch/xtensa/kernel/vectors.S: asm/ptrace.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Chris Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/kernel/vectors.S |    2 --
 1 file changed, 2 deletions(-)

diff -puN arch/xtensa/kernel/vectors.S~xtensa-includecheck-fix-vectorss arch/xtensa/kernel/vectors.S
--- a/arch/xtensa/kernel/vectors.S~xtensa-includecheck-fix-vectorss
+++ a/arch/xtensa/kernel/vectors.S
@@ -44,14 +44,12 @@
 
 #include <linux/linkage.h>
 #include <asm/ptrace.h>
-#include <asm/ptrace.h>
 #include <asm/current.h>
 #include <asm/asm-offsets.h>
 #include <asm/pgtable.h>
 #include <asm/processor.h>
 #include <asm/page.h>
 #include <asm/thread_info.h>
-#include <asm/processor.h>
 
 #define WINDOW_VECTORS_SIZE   0x180
 
_

Patches currently in -mm which might be from jaswinder@kernel.org are

linux-next.patch
kernel-core-add-smp_call_function_any.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
xtensa-includecheck-fix-vectorss.patch
mm-includecheck-fix-vmallocc.patch
fs-includecheck-fix-proc-kcorec.patch
video-includecheck-fix-msm-mddic.patch
video-includecheck-fix-da8xx-fbc.patch
sched-fix-htmldocs-schedc.patch


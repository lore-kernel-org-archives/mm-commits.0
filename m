From: akpm@linux-foundation.org
Subject: +
 lib-kconfigdebug-let-frame_pointer-exclude-score-just-like-exclude-most-of-other-architectures.patch added to -mm tree
Date: Tue, 10 Jun 2014 15:54:47 -0700
Message-ID: <53978cb7.XlMH6DoC9VGmlR1A%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40784 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729AbaFJWys (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jun 2014 18:54:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, liqin.linux@gmail.com, lennox.wu@gmail.com, gang.chen.5i5j@gmail.com

Subject: + lib-kconfigdebug-let-frame_pointer-exclude-score-just-like-exclude-most-of-other-architectures.patch added to -mm tree
To: gang.chen.5i5j@gmail.com,lennox.wu@gmail.com,liqin.linux@gmail.com
From: akpm@linux-foundation.org
Date: Tue, 10 Jun 2014 15:54:47 -0700


The patch titled
     Subject: lib/Kconfig.debug: let FRAME_POINTER exclude SCORE, just like exclude most of other architectures
has been added to the -mm tree.  Its filename is
     lib-kconfigdebug-let-frame_pointer-exclude-score-just-like-exclude-most-of-other-architectures.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-kconfigdebug-let-frame_pointer-exclude-score-just-like-exclude-most-of-other-architectures.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-kconfigdebug-let-frame_pointer-exclude-score-just-like-exclude-most-of-other-architectures.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chen Gang <gang.chen.5i5j@gmail.com>
Subject: lib/Kconfig.debug: let FRAME_POINTER exclude SCORE, just like exclude most of other architectures

The related warning:
  scripts/kconfig/conf --allmodconfig Kconfig
  warning: (FAULT_INJECTION_STACKTRACE_FILTER && LATENCYTOP && KMEMCHECK && LOCKDEP) selects FRAME_POINTER which has unmet direct dependencies (DEBUG_KERNEL && (CRIS || M68K || FRV || UML || AVR32 || SUPERH || BLACKFIN || MN10300 || METAG) || ARCH_WANT_FRAME_POINTERS)

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Chen Liqin <liqin.linux@gmail.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/Kconfig.debug~lib-kconfigdebug-let-frame_pointer-exclude-score-just-like-exclude-most-of-other-architectures lib/Kconfig.debug
--- a/lib/Kconfig.debug~lib-kconfigdebug-let-frame_pointer-exclude-score-just-like-exclude-most-of-other-architectures
+++ a/lib/Kconfig.debug
@@ -930,7 +930,7 @@ config LOCKDEP
 	bool
 	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
 	select STACKTRACE
-	select FRAME_POINTER if !MIPS && !PPC && !ARM_UNWIND && !S390 && !MICROBLAZE && !ARC
+	select FRAME_POINTER if !MIPS && !PPC && !ARM_UNWIND && !S390 && !MICROBLAZE && !ARC && !SCORE
 	select KALLSYMS
 	select KALLSYMS_ALL
 
@@ -1408,7 +1408,7 @@ config FAULT_INJECTION_STACKTRACE_FILTER
 	depends on FAULT_INJECTION_DEBUG_FS && STACKTRACE_SUPPORT
 	depends on !X86_64
 	select STACKTRACE
-	select FRAME_POINTER if !MIPS && !PPC && !S390 && !MICROBLAZE && !ARM_UNWIND && !ARC
+	select FRAME_POINTER if !MIPS && !PPC && !S390 && !MICROBLAZE && !ARM_UNWIND && !ARC && !SCORE
 	help
 	  Provide stacktrace filter for fault-injection capabilities
 
_

Patches currently in -mm which might be from gang.chen.5i5j@gmail.com are

origin.patch
lib-kconfigdebug-let-frame_pointer-exclude-score-just-like-exclude-most-of-other-architectures.patch
linux-next.patch


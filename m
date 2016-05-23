From: akpm@linux-foundation.org
Subject: + kcov-allow-more-fine-grained-coverage-instrumentation.patch
 added to -mm tree
Date: Mon, 23 May 2016 14:27:21 -0700
Message-ID: <574375b9.m+nQD2AaFtoLPNJ2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40990 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbcEWV1W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 17:27:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vegard.nossum@oracle.com, dvyukov@google.com, quentin.casasnovas@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kcov: allow more fine-grained coverage instrumentation
has been added to the -mm tree.  Its filename is
     kcov-allow-more-fine-grained-coverage-instrumentation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kcov-allow-more-fine-grained-coverage-instrumentation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kcov-allow-more-fine-grained-coverage-instrumentation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vegard Nossum <vegard.nossum@oracle.com>
Subject: kcov: allow more fine-grained coverage instrumentation

For more targeted fuzzing, it's better to disable kernel-wide
instrumentation and instead enable it on a per-subsystem basis. This
follows the pattern of UBSAN and allows you to compile in the kcov driver
without instrumenting the whole kernel.

To instrument a part of the kernel, you can use either

    # for a single file in the current directory
    KCOV_INSTRUMENT_filename.o := y

or

    # for all the files in the current directory (excluding subdirectories)
    KCOV_INSTRUMENT := y

or

    # (same as above)
    ccflags-y += $(CFLAGS_KCOV)

or

    # for all the files in the current directory (including subdirectories)
    subdir-ccflags-y += $(CFLAGS_KCOV)

Link: http://lkml.kernel.org/r/1464008380-11405-1-git-send-email-vegard.nossum@oracle.com
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Quentin Casasnovas <quentin.casasnovas@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug    |   11 +++++++++++
 scripts/Makefile.lib |    2 +-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff -puN lib/Kconfig.debug~kcov-allow-more-fine-grained-coverage-instrumentation lib/Kconfig.debug
--- a/lib/Kconfig.debug~kcov-allow-more-fine-grained-coverage-instrumentation
+++ a/lib/Kconfig.debug
@@ -722,6 +722,17 @@ config KCOV
 
 	  For more details, see Documentation/kcov.txt.
 
+config KCOV_INSTRUMENT_ALL
+	bool "Instrument all code by default"
+	depends on KCOV
+	default y if KCOV
+	help
+	  If you are doing generic system call fuzzing (like e.g. syzkaller),
+	  then you will want to instrument the whole kernel and you should
+	  say y here. If you are doing more targeted fuzzing (like e.g.
+	  filesystem fuzzing with AFL) then you will want to enable coverage
+	  for more specific subsets of files, and should say n here.
+
 config DEBUG_SHIRQ
 	bool "Debug shared IRQ handlers"
 	depends on DEBUG_KERNEL
diff -puN scripts/Makefile.lib~kcov-allow-more-fine-grained-coverage-instrumentation scripts/Makefile.lib
--- a/scripts/Makefile.lib~kcov-allow-more-fine-grained-coverage-instrumentation
+++ a/scripts/Makefile.lib
@@ -138,7 +138,7 @@ endif
 
 ifeq ($(CONFIG_KCOV),y)
 _c_flags += $(if $(patsubst n%,, \
-	$(KCOV_INSTRUMENT_$(basetarget).o)$(KCOV_INSTRUMENT)y), \
+	$(KCOV_INSTRUMENT_$(basetarget).o)$(KCOV_INSTRUMENT)$(CONFIG_KCOV_INSTRUMENT_ALL)), \
 	$(CFLAGS_KCOV))
 endif
 
_

Patches currently in -mm which might be from vegard.nossum@oracle.com are

kcov-allow-more-fine-grained-coverage-instrumentation.patch


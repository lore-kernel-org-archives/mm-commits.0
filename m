From: akpm@linux-foundation.org
Subject: [merged]
 ubsan-disable-ubsan_alignment-under-compile_test.patch removed from -mm
 tree
Date: Fri, 08 May 2020 15:32:54 -0700
Message-ID: <20200508223254.nXfSmSzjp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726843AbgEHWcz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 8 May 2020 18:32:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, jpoimboe@redhat.com, keescook@chromium.org, mm-commits@vger.kernel.org, peterz@infradead.org, rdunlap@infradead.org, sfr@canb.auug.org.au


The patch titled
     Subject: ubsan: disable UBSAN_ALIGNMENT under COMPILE_TEST
has been removed from the -mm tree.  Its filename was
     ubsan-disable-ubsan_alignment-under-compile_test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: ubsan: disable UBSAN_ALIGNMENT under COMPILE_TEST

The documentation for UBSAN_ALIGNMENT already mentions that it should not
be used on all*config builds (and for efficient-unaligned-access
architectures), so just refactor the Kconfig to correctly implement this
so randconfigs will stop creating insane images that freak out objtool
under CONFIG_UBSAN_TRAP (due to the false positives producing functions
that never return, etc).

Link: http://lkml.kernel.org/r/202005011433.C42EA3E2D@keescook
Fixes: 0887a7ebc977 ("ubsan: add trap instrumentation option")
Signed-off-by: Kees Cook <keescook@chromium.org>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
  Link: https://lore.kernel.org/linux-next/202004231224.D6B3B650@keescook/
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.ubsan                                   |   15 ++++------
 tools/testing/selftests/wireguard/qemu/debug.config |    1 
 2 files changed, 6 insertions(+), 10 deletions(-)

--- a/lib/Kconfig.ubsan~ubsan-disable-ubsan_alignment-under-compile_test
+++ a/lib/Kconfig.ubsan
@@ -60,18 +60,15 @@ config UBSAN_SANITIZE_ALL
 	  Enabling this option will get kernel image size increased
 	  significantly.
 
-config UBSAN_NO_ALIGNMENT
-	bool "Disable checking of pointers alignment"
-	default y if HAVE_EFFICIENT_UNALIGNED_ACCESS
+config UBSAN_ALIGNMENT
+	bool "Enable checks for pointers alignment"
+	default !HAVE_EFFICIENT_UNALIGNED_ACCESS
+	depends on !X86 || !COMPILE_TEST
 	help
-	  This option disables the check of unaligned memory accesses.
-	  This option should be used when building allmodconfig.
-	  Disabling this option on architectures that support unaligned
+	  This option enables the check of unaligned memory accesses.
+	  Enabling this option on architectures that support unaligned
 	  accesses may produce a lot of false positives.
 
-config UBSAN_ALIGNMENT
-	def_bool !UBSAN_NO_ALIGNMENT

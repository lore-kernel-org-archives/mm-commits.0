From: akpm@linux-foundation.org
Subject: + ubsan-run-time-undefined-behavior-sanity-checker-fix-4.patch
 added to -mm tree
Date: Thu, 10 Dec 2015 14:29:33 -0800
Message-ID: <5669fccd.HlaNELYMvDw/Q488%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39672 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbbLJW3e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Dec 2015 17:29:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, dja@axtens.net, mm-commits@vger.kernel.org


The patch titled
     Subject: ubsan-run-time-undefined-behavior-sanity-checker-fix-4
has been added to the -mm tree.  Its filename is
     ubsan-run-time-undefined-behavior-sanity-checker-fix-4.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ubsan-run-time-undefined-behavior-sanity-checker-fix-4.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ubsan-run-time-undefined-behavior-sanity-checker-fix-4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: ubsan-run-time-undefined-behavior-sanity-checker-fix-4

s/ARCH_HAS_UBSAN_SANTIZE_ALL/ARCH_HAS_UBSAN_SANITIZE_ALL

Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Reported-by: Daniel Axtens <dja@axtens.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig  |    2 +-
 lib/Kconfig.ubsan |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/x86/Kconfig~ubsan-run-time-undefined-behavior-sanity-checker-fix-4 arch/x86/Kconfig
--- a/arch/x86/Kconfig~ubsan-run-time-undefined-behavior-sanity-checker-fix-4
+++ a/arch/x86/Kconfig
@@ -30,7 +30,7 @@ config X86
 	select ARCH_HAS_PMEM_API		if X86_64
 	select ARCH_HAS_MMIO_FLUSH
 	select ARCH_HAS_SG_CHAIN
-	select ARCH_HAS_UBSAN_SANTIZE_ALL
+	select ARCH_HAS_UBSAN_SANITIZE_ALL
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select ARCH_MIGHT_HAVE_ACPI_PDC		if ACPI
 	select ARCH_MIGHT_HAVE_PC_PARPORT
diff -puN lib/Kconfig.ubsan~ubsan-run-time-undefined-behavior-sanity-checker-fix-4 lib/Kconfig.ubsan
--- a/lib/Kconfig.ubsan~ubsan-run-time-undefined-behavior-sanity-checker-fix-4
+++ a/lib/Kconfig.ubsan
@@ -1,4 +1,4 @@
-config ARCH_HAS_UBSAN_SANTIZE_ALL
+config ARCH_HAS_UBSAN_SANITIZE_ALL
 	bool
 
 config UBSAN
@@ -12,7 +12,7 @@ config UBSAN
 config UBSAN_SANITIZE_ALL
 	bool "Enable instrumentation for the entire kernel"
 	depends on UBSAN
-	depends on ARCH_HAS_UBSAN_SANTIZE_ALL
+	depends on ARCH_HAS_UBSAN_SANITIZE_ALL
 	default y
 	help
 	  This option activates instrumentation for the entire kernel.
_

Patches currently in -mm which might be from aryabinin@virtuozzo.com are

kernel-printk-specify-alignment-for-struct-printk_log.patch
mac80211-prevent-build-failure-with-config_ubsan=y.patch
ubsan-run-time-undefined-behavior-sanity-checker.patch
ubsan-run-time-undefined-behavior-sanity-checker-fix-2.patch
ubsan-run-time-undefined-behavior-sanity-checker-fix-4.patch


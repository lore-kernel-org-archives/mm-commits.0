From: akpm@linux-foundation.org
Subject: +
 kernel-watchdog-fix-kconfig-constraints-for-perf-hardlockup-watchdog.patch
 added to -mm tree
Date: Thu, 10 Aug 2017 13:55:27 -0700
Message-ID: <598cc83f.GXQh+B5g0iXsV3Vs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40288 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752890AbdHJUz3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 10 Aug 2017 16:55:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@gmail.com, dzickus@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/watchdog: fix Kconfig constraints for perf hardlockup watchdog
has been added to the -mm tree.  Its filename is
     kernel-watchdog-fix-kconfig-constraints-for-perf-hardlockup-watchdog.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-watchdog-fix-kconfig-constraints-for-perf-hardlockup-watchdog.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-watchdog-fix-kconfig-constraints-for-perf-hardlockup-watchdog.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nicholas Piggin <npiggin@gmail.com>
Subject: kernel/watchdog: fix Kconfig constraints for perf hardlockup watchdog

05a4a9527931 ("kernel/watchdog: split up config options") lost the
perf-based hardlockup detector's dependency on PERF_EVENTS, which can
result in broken builds with some powerpc configurations.

Restore the dependency.  Add it in for x86 too, despite x86 always
selecting PERF_EVENTS it seems reasonable to make the dependency explicit.

Link: http://lkml.kernel.org/r/20170810114452.6673-1-npiggin@gmail.com
Fixes: 05a4a9527931 ("kernel/watchdog: split up config options")
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Acked-by: Don Zickus <dzickus@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig |    2 +-
 arch/x86/Kconfig     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/powerpc/Kconfig~kernel-watchdog-fix-kconfig-constraints-for-perf-hardlockup-watchdog arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~kernel-watchdog-fix-kconfig-constraints-for-perf-hardlockup-watchdog
+++ a/arch/powerpc/Kconfig
@@ -199,7 +199,7 @@ config PPC
 	select HAVE_OPTPROBES			if PPC64
 	select HAVE_PERF_EVENTS
 	select HAVE_PERF_EVENTS_NMI		if PPC64
-	select HAVE_HARDLOCKUP_DETECTOR_PERF	if HAVE_PERF_EVENTS_NMI && !HAVE_HARDLOCKUP_DETECTOR_ARCH
+	select HAVE_HARDLOCKUP_DETECTOR_PERF	if PERF_EVENTS && HAVE_PERF_EVENTS_NMI && !HAVE_HARDLOCKUP_DETECTOR_ARCH
 	select HAVE_PERF_REGS
 	select HAVE_PERF_USER_STACK_DUMP
 	select HAVE_RCU_TABLE_FREE		if SMP
diff -puN arch/x86/Kconfig~kernel-watchdog-fix-kconfig-constraints-for-perf-hardlockup-watchdog arch/x86/Kconfig
--- a/arch/x86/Kconfig~kernel-watchdog-fix-kconfig-constraints-for-perf-hardlockup-watchdog
+++ a/arch/x86/Kconfig
@@ -163,7 +163,7 @@ config X86
 	select HAVE_PCSPKR_PLATFORM
 	select HAVE_PERF_EVENTS
 	select HAVE_PERF_EVENTS_NMI
-	select HAVE_HARDLOCKUP_DETECTOR_PERF	if HAVE_PERF_EVENTS_NMI
+	select HAVE_HARDLOCKUP_DETECTOR_PERF	if PERF_EVENTS && HAVE_PERF_EVENTS_NMI
 	select HAVE_PERF_REGS
 	select HAVE_PERF_USER_STACK_DUMP
 	select HAVE_REGS_AND_STACK_ACCESS_API
_

Patches currently in -mm which might be from npiggin@gmail.com are

kernel-watchdog-fix-kconfig-constraints-for-perf-hardlockup-watchdog.patch


From: akpm@linux-foundation.org
Subject: +
 powerpc-add-running_clock-for-powerpc-to-prevent-spurious-softlockup-warnings-fix.patch added to -mm tree
Date: Thu, 05 Feb 2015 14:31:12 -0800
Message-ID: <54d3ef30.AsSxajsMs/21rnHA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37308 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbbBEWbN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Feb 2015 17:31:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cyrilbur@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc-add-running_clock-for-powerpc-to-prevent-spurious-softlockup-warnings-fix
has been added to the -mm tree.  Its filename is
     powerpc-add-running_clock-for-powerpc-to-prevent-spurious-softlockup-warnings-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-add-running_clock-for-powerpc-to-prevent-spurious-softlockup-warnings-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-add-running_clock-for-powerpc-to-prevent-spurious-softlockup-warnings-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Cyril Bur <cyrilbur@gmail.com>
Subject: powerpc-add-running_clock-for-powerpc-to-prevent-spurious-softlockup-warnings-fix


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/time.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/powerpc/kernel/time.c~powerpc-add-running_clock-for-powerpc-to-prevent-spurious-softlockup-warnings-fix arch/powerpc/kernel/time.c
--- a/arch/powerpc/kernel/time.c~powerpc-add-running_clock-for-powerpc-to-prevent-spurious-softlockup-warnings-fix
+++ a/arch/powerpc/kernel/time.c
@@ -636,8 +636,8 @@ unsigned long long running_clock(void)
 	 * timebase into the VTB when it takes a guest off the CPU, reading the
 	 * VTB would result in reading 'last switched out' guest VTB.
 	 *
-	 * Host kernels are often compiled with CONFIG_PSERIES checked, it would
-	 * be unsafe to rely only on the #ifdef above.
+	 * Host kernels are often compiled with CONFIG_PPC_PSERIES checked, it
+	 * would be unsafe to rely only on the #ifdef above.
 	 */
 	if (firmware_has_feature(FW_FEATURE_LPAR) &&
 	    cpu_has_feature(CPU_FTR_ARCH_207S))
_

Patches currently in -mm which might be from cyrilbur@gmail.com are

add-another-clock-for-use-with-the-soft-lockup-watchdog.patch
powerpc-add-running_clock-for-powerpc-to-prevent-spurious-softlockup-warnings.patch
powerpc-add-running_clock-for-powerpc-to-prevent-spurious-softlockup-warnings-checkpatch-fixes.patch
powerpc-add-running_clock-for-powerpc-to-prevent-spurious-softlockup-warnings-fix.patch
linux-next.patch


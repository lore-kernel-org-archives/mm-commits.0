From: akpm@linux-foundation.org
Subject: [folded-merged]
 powerpc-add-running_clock-for-powerpc-to-prevent-spurious-softlockup-warnings-fix.patch removed from -mm tree
Date: Thu, 12 Feb 2015 14:17:32 -0800
Message-ID: <54dd267c.NF+JTwjKA0h5ovhk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60266 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbbBLWRd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 17:17:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cyrilbur@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc-add-running_clock-for-powerpc-to-prevent-spurious-softlockup-warnings-fix
has been removed from the -mm tree.  Its filename was
     powerpc-add-running_clock-for-powerpc-to-prevent-spurious-softlockup-warnings-fix.patch

This patch was dropped because it was folded into powerpc-add-running_clock-for-powerpc-to-prevent-spurious-softlockup-warnings.patch

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

origin.patch
add-another-clock-for-use-with-the-soft-lockup-watchdog.patch
powerpc-add-running_clock-for-powerpc-to-prevent-spurious-softlockup-warnings.patch


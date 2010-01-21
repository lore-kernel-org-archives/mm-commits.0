From: akpm@linux-foundation.org
Subject: [merged] m68knommu-fix-invalid-flags-on-coldfire-pit-clocksource.patch removed from -mm tree
Date: Thu, 21 Jan 2010 13:27:14 -0800
Message-ID: <201001212127.o0LLRESl030624@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34265 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755315Ab0AUV1Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Jan 2010 16:27:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johnstul@us.ibm.com, gerg@snapgear.com, sfking@fdwdc.com, mm-commits@vger.kernel.org


The patch titled
     m68knommu: fix invalid flags on coldfire pit clocksource
has been removed from the -mm tree.  Its filename was
     m68knommu-fix-invalid-flags-on-coldfire-pit-clocksource.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m68knommu: fix invalid flags on coldfire pit clocksource
From: john stultz <johnstul@us.ibm.com>

The m68knommu coldfire pit clocksource looks like it was incorrectly
marked as a continuous clocksource.  Running with it marked as a
continuous clocksource could cause hangs when the system switches to
highres mode or enables nohz.

This patch removes the CLOCK_SOURCE_IS_CONTINUOUS flag on the coldfire pit
clocksource.  This will disallow systems using this clocksource from
entering oneshot mode (disabling highres timers and nohz).

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Acked-by: Greg Ungerer <gerg@snapgear.com>
Cc: Steven King <sfking@fdwdc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68knommu/platform/coldfire/pit.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/m68knommu/platform/coldfire/pit.c~m68knommu-fix-invalid-flags-on-coldfire-pit-clocksource arch/m68knommu/platform/coldfire/pit.c
--- a/arch/m68knommu/platform/coldfire/pit.c~m68knommu-fix-invalid-flags-on-coldfire-pit-clocksource
+++ a/arch/m68knommu/platform/coldfire/pit.c
@@ -146,7 +146,6 @@ static struct clocksource pit_clk = {
 	.read	= pit_read_clk,
 	.shift	= 20,
 	.mask	= CLOCKSOURCE_MASK(32),
-	.flags	= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
 /***************************************************************************/
_

Patches currently in -mm which might be from johnstul@us.ibm.com are

origin.patch
arm-convert-to-arch_gettimeoffset.patch
clocksource-add-argument-to-resume-callback.patch
clocksource-start-cmt-at-clocksource-resume.patch
clocksource-add-suspend-callback.patch
genirq-warn-about-irqf_sharedirqf_disabled-at-the-right-place.patch
convert-sparc-to-arch_gettimeoffset.patch
convert-sparc-to-arch_gettimeoffset-fix.patch
cris-convert-to-use-arch_gettimeoffset.patch


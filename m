From: akpm@linux-foundation.org
Subject: + m68knommu-fix-invalid-flags-on-coldfire-pit-clocksource.patch added to -mm tree
Date: Wed, 30 Dec 2009 13:41:23 -0800
Message-ID: <200912302141.nBULfNLB003866@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57588 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751764AbZL3VmG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Dec 2009 16:42:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johnstul@us.ibm.com, gerg@snapgear.com, sfking@fdwdc.com


The patch titled
     m68knommu: fix invalid flags on coldfire pit clocksource
has been added to the -mm tree.  Its filename is
     m68knommu-fix-invalid-flags-on-coldfire-pit-clocksource.patch

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
Cc: Greg Ungerer <gerg@snapgear.com>
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

m68knommu-fix-invalid-flags-on-coldfire-pit-clocksource.patch
convert-arm-to-arch_gettimeoffset.patch
clocksource-add-argument-to-resume-callback.patch
clocksource-start-cmt-at-clocksource-resume.patch
clocksource-add-suspend-callback.patch
convert-sparc-to-arch_gettimeoffset.patch
cris-convert-to-use-arch_gettimeoffset.patch


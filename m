From: akpm@linux-foundation.org
Subject: + forcedeth-new-backoff-implementation-update.patch added to -mm tree
Date: Thu, 10 Apr 2008 16:01:42 -0700
Message-ID: <200804102301.m3AN1gaC021799@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38912 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752926AbYDJXBq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Apr 2008 19:01:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aabdulla@nvidia.com


The patch titled
     forcedeth: new backoff implementation (update)
has been added to the -mm tree.  Its filename is
     forcedeth-new-backoff-implementation-update.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: forcedeth: new backoff implementation (update)
From: Ayaz Abdulla <aabdulla@nvidia.com>

This patch adds support for a new backoff algorithm for half duplex
supported in newer hardware. The old method is will be designated as
legacy mode.

Re-seeding random values for the backoff algorithms are performed when a
transmit has failed due to a maximum retry count (1 to 15, where max is
considered the wraparound case of 0).

Signed-off-by: Ayaz Abdulla <aabdulla@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/forcedeth.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/net/forcedeth.c~forcedeth-new-backoff-implementation-update drivers/net/forcedeth.c
--- a/drivers/net/forcedeth.c~forcedeth-new-backoff-implementation-update
+++ a/drivers/net/forcedeth.c
@@ -1873,7 +1873,7 @@ static void nv_legacybackoff_reseed(stru
 #define BACKOFF_SEEDSET_LFSRS	15
 
 /* Known Good seed sets */
-u32 gMainSeedSet[BACKOFF_SEEDSET_ROWS][BACKOFF_SEEDSET_LFSRS] = {
+static const u32 main_seedset[BACKOFF_SEEDSET_ROWS][BACKOFF_SEEDSET_LFSRS] = {
     {145, 155, 165, 175, 185, 196, 235, 245, 255, 265, 275, 285, 660, 690, 874},
     {245, 255, 265, 575, 385, 298, 335, 345, 355, 366, 375, 385, 761, 790, 974},
     {145, 155, 165, 175, 185, 196, 235, 245, 255, 265, 275, 285, 660, 690, 874},
@@ -1883,7 +1883,7 @@ u32 gMainSeedSet[BACKOFF_SEEDSET_ROWS][B
     {366, 365, 376, 686, 497, 308, 447, 455, 466, 476, 485, 496, 871, 800,  84},
     {466, 465, 476, 786, 597, 408, 547, 555, 566, 576, 585, 597, 971, 900, 184}};
 
-u32 gGearSeedSet[BACKOFF_SEEDSET_ROWS][BACKOFF_SEEDSET_LFSRS] = {
+static const u32 gear_seedset[BACKOFF_SEEDSET_ROWS][BACKOFF_SEEDSET_LFSRS] = {
     {251, 262, 273, 324, 319, 508, 375, 364, 341, 371, 398, 193, 375,  30, 295},
     {351, 375, 373, 469, 551, 639, 477, 464, 441, 472, 498, 293, 476, 130, 395},
     {351, 375, 373, 469, 551, 639, 477, 464, 441, 472, 498, 293, 476, 130, 397},
@@ -1947,8 +1947,8 @@ static void nv_gear_backoff_reseed(struc
 	for (i = 1; i <= BACKOFF_SEEDSET_LFSRS; i++)
 	{
 		temp = NVREG_BKOFFCTRL_DEFAULT | (i << NVREG_BKOFFCTRL_SELECT);
-		temp |= gMainSeedSet[seedset][i-1] & 0x3ff;
-		temp |= ((gGearSeedSet[seedset][i-1] & 0x3ff) << NVREG_BKOFFCTRL_GEAR);
+		temp |= main_seedset[seedset][i-1] & 0x3ff;
+		temp |= ((gear_seedset[seedset][i-1] & 0x3ff) << NVREG_BKOFFCTRL_GEAR);
 		writel(temp, base + NvRegBackOffControl);
 	}
 }
_

Patches currently in -mm which might be from aabdulla@nvidia.com are

origin.patch
forcedeth-power-down-phy-when-interface-is-down.patch
forcedeth-fix-mac-address-detection-on-network-card-regression-in-2623.patch
forcedeth-new-backoff-implementation.patch
forcedeth-new-backoff-implementation-update.patch
forcedeth-mac-address-fix.patch


From: akpm@linux-foundation.org
Subject: [merged]
 drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch removed from -mm tree
Date: Thu, 15 Dec 2016 10:46:40 -0800
Message-ID: <5852e510.EFRNlhwb2ed74NT4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48768 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756184AbcLOSqw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2016 13:46:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, emmanuel.grumbach@intel.com, johannes.berg@intel.com, kvalo@codeaurora.org, linuxwifi@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/net/wireless/intel/iwlwifi/dvm/calib.c: simplfy min() expression
has been removed from the -mm tree.  Its filename was
     drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/net/wireless/intel/iwlwifi/dvm/calib.c: simplfy min() expression

This cast is no longer needed.

Cc: Johannes Berg <johannes.berg@intel.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Intel Linux Wireless <linuxwifi@intel.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/intel/iwlwifi/dvm/calib.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/net/wireless/intel/iwlwifi/dvm/calib.c~drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning drivers/net/wireless/intel/iwlwifi/dvm/calib.c
--- a/drivers/net/wireless/intel/iwlwifi/dvm/calib.c~drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning
+++ a/drivers/net/wireless/intel/iwlwifi/dvm/calib.c
@@ -900,8 +900,7 @@ static void iwlagn_gain_computation(stru
 
 		/* bound gain by 2 bits value max, 3rd bit is sign */
 		data->delta_gain_code[i] =
-			min(abs(delta_g),
-			(s32) CHAIN_NOISE_MAX_DELTA_GAIN_CODE);
+			min(abs(delta_g), CHAIN_NOISE_MAX_DELTA_GAIN_CODE);
 
 		if (delta_g < 0)
 			/*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch


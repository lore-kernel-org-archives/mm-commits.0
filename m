From: akpm@linux-foundation.org
Subject: - e1000e-set-interruptthrottlerate-to-default-when-invalid-value-used.patch removed from -mm tree
Date: Thu, 14 Aug 2008 16:54:28 -0700
Message-ID: <200808142354.m7ENsSap003941@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35023 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752042AbYHNXya (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Aug 2008 19:54:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bruce.w.allan@intel.com, jeffrey.t.kirsher@intel.com, mm-commits@vger.kernel.org


The patch titled
     e1000e: set InterruptThrottleRate to default when invalid value used
has been removed from the -mm tree.  Its filename was
     e1000e-set-interruptthrottlerate-to-default-when-invalid-value-used.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: e1000e: set InterruptThrottleRate to default when invalid value used
From: Bruce Allan <bruce.w.allan@intel.com>

During module load, seting the InterruptThrottleRate parameter to an
invalid value would result in the itr/itr_setting pair being set to
unexpected values which would result in poor performance.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/e1000e/param.c |   23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff -puN drivers/net/e1000e/param.c~e1000e-set-interruptthrottlerate-to-default-when-invalid-value-used drivers/net/e1000e/param.c
--- a/drivers/net/e1000e/param.c~e1000e-set-interruptthrottlerate-to-default-when-invalid-value-used
+++ a/drivers/net/e1000e/param.c
@@ -327,11 +327,26 @@ void __devinit e1000e_check_options(stru
 				e1000_validate_option(&adapter->itr, &opt,
 					adapter);
 				/*
-				 * save the setting, because the dynamic bits
-				 * change itr. clear the lower two bits
-				 * because they are used as control
+				 * Save the setting, because the dynamic bits
+				 * change itr.
 				 */
-				adapter->itr_setting = adapter->itr & ~3;
+				if (e1000_validate_option(&adapter->itr, &opt,
+							  adapter) &&
+				    (adapter->itr == 3)) {
+					/*
+					 * In case of invalid user value,
+					 * default to conservative mode.
+					 */
+					adapter->itr_setting = adapter->itr;
+					adapter->itr = 20000;
+				} else {
+					/*
+					 * Clear the lower two bits because
+					 * they are used as control.
+					 */
+					adapter->itr_setting =
+						adapter->itr & ~3;
+				}
 				break;
 			}
 		} else {
_

Patches currently in -mm which might be from bruce.w.allan@intel.com are

git-net.patch
e1000e-remove-inapplicable-test-for-ioport-checkpatch-fixes.patch


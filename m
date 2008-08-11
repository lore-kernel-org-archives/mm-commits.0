From: akpm@linux-foundation.org
Subject: + e1000e-set-interruptthrottlerate-to-default-when-invalid-value-used.patch added to -mm tree
Date: Mon, 11 Aug 2008 16:40:07 -0700
Message-ID: <200808112340.m7BNe7lH028099@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41674 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753807AbYHKXkJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Aug 2008 19:40:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bruce.w.allan@intel.com, jeffrey.t.kirsher@intel.com


The patch titled
     e1000e: set InterruptThrottleRate to default when invalid value used
has been added to the -mm tree.  Its filename is
     e1000e-set-interruptthrottlerate-to-default-when-invalid-value-used.patch

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

origin.patch
e1000e-remove-inapplicable-test-for-ioport-checkpatch-fixes.patch
e1000e-return-1-instead-of-a-non-zero-value-for-link-up-indication.patch
e1000e-set-interruptthrottlerate-to-default-when-invalid-value-used.patch
e1000e-use-skb_copy_to_linear_data_offset-introduced-in-2622.patch
e1000e-increase-tx-timeout-factor-for-10mbps.patch
e1000e-increase-minimum-frame-size-allowed.patch
e1000e-test-for-unusable-msi-support.patch
e1000e-remove-unnecessary-snippet-missed-in-prior-check_options-update.patch


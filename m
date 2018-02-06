From: akpm@linux-foundation.org
Subject: [folded-merged] bitmap-replace-bitmap_fromto_u32array-fix-2.patch removed from -mm tree
Date: Tue, 06 Feb 2018 15:25:01 -0800
Message-ID: <5a7a394d.N+CCIrMss7H5t5U1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48460 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753748AbeBFXZD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:25:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ynorov@caviumnetworks.com, hkallweit1@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Fix 39461af74125 "bitmap: replace bitmap_{from,to}_u32array"
has been removed from the -mm tree.  Its filename was
     bitmap-replace-bitmap_fromto_u32array-fix-2.patch

This patch was dropped because it was folded into bitmap-replace-bitmap_fromto_u32array.patch

------------------------------------------------------
From: Yury Norov <ynorov@caviumnetworks.com>
Subject: Fix 39461af74125 "bitmap: replace bitmap_{from,to}_u32array"

During rework, bitmap_to_arr32() was erroneously passed with
__ETHTOOL_LINK_MODE_MASK_NU32 instead of __ETHTOOL_LINK_MODE_MASK_NBITS.

Link: http://lkml.kernel.org/r/20180205071747.4ekxtsbgxkj5b2fz@yury-thinkpad
Fixes: 39461af74125fd268 (bitmap: replace bitmap_{from,to}_u32array)
Reported-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Yury Norov <ynorov@caviumnetworks.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/core/ethtool.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN net/core/ethtool.c~bitmap-replace-bitmap_fromto_u32array-fix-2 net/core/ethtool.c
--- a/net/core/ethtool.c~bitmap-replace-bitmap_fromto_u32array-fix-2
+++ a/net/core/ethtool.c
@@ -642,13 +642,13 @@ store_link_ksettings_for_user(void __use
 	memcpy(&link_usettings.base, &from->base, sizeof(link_usettings));
 	bitmap_to_arr32(link_usettings.link_modes.supported,
 			from->link_modes.supported,
-			__ETHTOOL_LINK_MODE_MASK_NU32);
+			__ETHTOOL_LINK_MODE_MASK_NBITS);
 	bitmap_to_arr32(link_usettings.link_modes.advertising,
 			from->link_modes.advertising,
-			__ETHTOOL_LINK_MODE_MASK_NU32);
+			__ETHTOOL_LINK_MODE_MASK_NBITS);
 	bitmap_to_arr32(link_usettings.link_modes.lp_advertising,
 			from->link_modes.lp_advertising,
-			__ETHTOOL_LINK_MODE_MASK_NU32);
+			__ETHTOOL_LINK_MODE_MASK_NBITS);
 
 	if (copy_to_user(to, &link_usettings, sizeof(link_usettings)))
 		return -EFAULT;
_

Patches currently in -mm which might be from ynorov@caviumnetworks.com are

bitmap-new-bitmap_copy_safe-and-bitmap_fromto_arr32.patch
bitmap-replace-bitmap_fromto_u32array.patch
lib-test_find_bitc-rename-to-find_bit_benchmarkc.patch
lib-find_bit_benchmarkc-improvements.patch


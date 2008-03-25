From: akpm@linux-foundation.org
Subject: - drivers-net-wireless-iwlwifi-iwl-4965c-correct-use-of-and.patch removed from -mm tree
Date: Mon, 24 Mar 2008 17:19:57 -0700
Message-ID: <200803250019.m2P0Jvqh032746@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54664 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753954AbYCYAV0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Mar 2008 20:21:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, guy.cohen@intel.com, linville@tuxdriver.com, reinette.chatre@intel.com, tomas.winkler@intel.com, yi.zhu@intel.com, mm-commits@vger.kernel.org


The patch titled
     drivers/net/wireless/iwlwifi/iwl-4965.c: correct use of ! and &
has been removed from the -mm tree.  Its filename was
     drivers-net-wireless-iwlwifi-iwl-4965c-correct-use-of-and.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/net/wireless/iwlwifi/iwl-4965.c: correct use of ! and &
From: Julia Lawall <julia@diku.dk>

In commit e6bafba5b4765a5a252f1b8d31cbf6d2459da337, a bug was fixed that
involved converting !x & y to !(x & y).  The code below shows the same
pattern, and thus should perhaps be fixed in the same way.

This is not tested and clearly changes the semantics, so it is only
something to consider.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@ expression E1,E2; @@
(
  !E1 & !E2
|
- !E1 & E2
+ !(E1 & E2)
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Tomas Winkler <tomas.winkler@intel.com>
Cc: Guy Cohen <guy.cohen@intel.com>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>
Cc: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/iwlwifi/iwl-4965.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/wireless/iwlwifi/iwl-4965.c~drivers-net-wireless-iwlwifi-iwl-4965c-correct-use-of-and drivers/net/wireless/iwlwifi/iwl-4965.c
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c~drivers-net-wireless-iwlwifi-iwl-4965c-correct-use-of-and
+++ a/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -4589,7 +4589,7 @@ static u8 iwl4965_is_fat_tx_allowed(stru
 
 	if (sta_ht_inf) {
 		if ((!sta_ht_inf->ht_supported) ||
-		   (!sta_ht_inf->cap & IEEE80211_HT_CAP_SUP_WIDTH))
+		   (!(sta_ht_inf->cap & IEEE80211_HT_CAP_SUP_WIDTH)))
 			return 0;
 	}
 
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
git-alsa-tiwai.patch
git-powerpc.patch
drivers-block-viodasdc-use-field_sizeof.patch
git-udf.patch
drivers-net-ixgb-ixgb_mainc-remove-unused-variable.patch
git-ocfs2.patch
fs-affs-filec-use-bug_on.patch
fbdev-use-div_round_up-or-roundup.patch
fs-ext2-use-bug_on.patch
fs-ext3-use-bug_on.patch
fs-ext4-use-bug_on.patch


From: akpm@linux-foundation.org
Subject: + drivers-net-wireless-iwlwifi-iwl-4965c-correct-use-of-and.patch added to -mm tree
Date: Wed, 27 Feb 2008 23:57:07 -0800
Message-ID: <200802280757.m1S7v7ln022652@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:42191 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752106AbYB1H6O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Feb 2008 02:58:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, guy.cohen@intel.com, linville@tuxdriver.com, reinette.chatre@intel.com, tomas.winkler@intel.com, yi.zhu@intel.com


The patch titled
     drivers/net/wireless/iwlwifi/iwl-4965.c: correct use of ! and &
has been added to the -mm tree.  Its filename is
     drivers-net-wireless-iwlwifi-iwl-4965c-correct-use-of-and.patch

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

sound-use-bug_on.patch
git-powerpc.patch
git-hid.patch
git-net.patch
drivers-net-mv643xx_ethc-use-field_sizeof.patch
git-ocfs2.patch
fs-ocfs2-use-bug_on.patch
drivers-block-viodasdc-use-field_sizeof.patch
git-sh.patch
usb-use-div_round_up.patch
fs-affs-filec-use-bug_on.patch
fbdev-use-div_round_up-or-roundup.patch
fs-ext2-use-bug_on.patch
fs-ext3-use-bug_on.patch
fs-ext4-use-bug_on.patch
drivers-acpi-asus_acpic-correct-use-of-and.patch
drivers-char-isicomc-correct-use-of-and.patch
drivers-isdn-correct-use-of-and.patch
drivers-media-video-em28xx-correct-use-of-and.patch
drivers-media-video-em28xx-correct-use-of-and-fix.patch
drivers-net-wireless-iwlwifi-iwl-4965c-correct-use-of-and.patch
drivers-serial-m32r_sioc-correct-use-of-and.patch
fs-reiserfs-superc-correct-use-of-and.patch

From: akpm@linux-foundation.org
Subject: + drivers-net-wireless-iwlwifi-iwl-agnc-fix-return-value-from-an-unsigned-function.patch added to -mm tree
Date: Tue, 07 Sep 2010 16:47:29 -0700
Message-ID: <201009072347.o87NlUUF013921@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47670 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758376Ab0IGX7O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Sep 2010 19:59:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, linville@tuxdriver.com, reinette.chatre@intel.com, wey-yi.w.guy@intel.com


The patch titled
     drivers/net/wireless/iwlwifi/iwl-agn.c: fix return value from an unsigned function
has been added to the -mm tree.  Its filename is
     drivers-net-wireless-iwlwifi-iwl-agnc-fix-return-value-from-an-unsigned-function.patch

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
Subject: drivers/net/wireless/iwlwifi/iwl-agn.c: fix return value from an unsigned function
From: Julia Lawall <julia@diku.dk>

The function has an unsigned return type, but returns a negative constant
to indicate an error condition.  Another error condition in the same
function is indicated by returning 0, and indeed the only call to the
function checks for 0 to detect errors, so the return of a negative value
it converted to a return of 0.

A sematic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@exists@
identifier f;
constant C;
@@

 unsigned f(...)
 { <+...
*  return -C;
 ...+> }
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Reinette Chatre <reinette.chatre@intel.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/iwlwifi/iwl-agn.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/wireless/iwlwifi/iwl-agn.c~drivers-net-wireless-iwlwifi-iwl-agnc-fix-return-value-from-an-unsigned-function drivers/net/wireless/iwlwifi/iwl-agn.c
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c~drivers-net-wireless-iwlwifi-iwl-agnc-fix-return-value-from-an-unsigned-function
+++ a/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -369,7 +369,7 @@ static unsigned int iwl_hw_get_beacon_cm
 
 	if (!priv->beacon_ctx) {
 		IWL_ERR(priv, "trying to build beacon w/o beacon context!\n");
-		return -EINVAL;
+		return 0;
 	}
 
 	/* Initialize memory */
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch
drivers-mmc-host-imxmmcc-adjust-confusing-if-indentation.patch
fs-btrfs-use-memdup_user.patch
fs-btrfs-use-err_cast.patch
drivers-video-matrox-matroxfb_mavenc-fix-unsigned-return-type.patch
arch-x86-kernel-cpu-cpufreq-fix-unsigned-return-type.patch
net-9p-trans_fdc-fix-unsigned-return-type.patch
drivers-i2c-busses-i2c-pasemic-fix-unsigned-return-type.patch
drivers-atm-firestreamc-fix-unsigned-return-type.patch
drivers-net-wireless-iwlwifi-iwl-agnc-fix-return-value-from-an-unsigned-function.patch


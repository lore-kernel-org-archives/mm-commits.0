From: akpm@linux-foundation.org
Subject: + drivers-net-wireless-ipw2100c-release-mutex-in-error-handling-code.patch added to -mm tree
Date: Mon, 28 Jul 2008 20:56:32 -0700
Message-ID: <200807290356.m6T3uW8k012881@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45152 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751792AbYG2D4v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jul 2008 23:56:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, jketreno@linux.intel.com, linville@tuxdriver.com, venkatesh.pallipadi@intel.com, yi.zhu@intel.com


The patch titled
     drivers/net/wireless/ipw2100.c: release mutex in error handling code
has been added to the -mm tree.  Its filename is
     drivers-net-wireless-ipw2100c-release-mutex-in-error-handling-code.patch

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
Subject: drivers/net/wireless/ipw2100.c: release mutex in error handling code
From: Julia Lawall <julia@diku.dk>

The mutex is released on a successful return, so it would seem that it
should be released on an error return as well.

The semantic patch finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression l;
@@

mutex_lock(l);
... when != mutex_unlock(l)
    when any
    when strict
(
if (...) { ... when != mutex_unlock(l)
+   mutex_unlock(l);
    return ...;
}
|
mutex_unlock(l);
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Zhu Yi <yi.zhu@intel.com>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: James Ketrenos <jketreno@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/ipw2100.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/net/wireless/ipw2100.c~drivers-net-wireless-ipw2100c-release-mutex-in-error-handling-code drivers/net/wireless/ipw2100.c
--- a/drivers/net/wireless/ipw2100.c~drivers-net-wireless-ipw2100c-release-mutex-in-error-handling-code
+++ a/drivers/net/wireless/ipw2100.c
@@ -6442,6 +6442,7 @@ static int ipw2100_resume(struct pci_dev
 	if (err) {
 		printk(KERN_ERR "%s: pci_enable_device failed on resume\n",
 		       dev->name);
+		mutex_unlock(&priv->action_mutex);
 		return err;
 	}
 	pci_restore_state(pci_dev);
@@ -7146,7 +7147,7 @@ static int ipw2100_wx_get_rate(struct ne
 	err = ipw2100_get_ordinal(priv, IPW_ORD_CURRENT_TX_RATE, &val, &len);
 	if (err) {
 		IPW_DEBUG_WX("failed querying ordinals.\n");
-		return err;
+		goto done;
 	}
 
 	switch (val & TX_RATE_MASK) {
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
drivers-net-ehea-ehea_mainc-release-mutex-in-error-handling-code.patch
net-ieee80211-adjust-error-handling.patch
drivers-net-wireless-b43legacy-mainc-release-mutex-in-error-handling-code.patch
drivers-net-wireless-ipw2100c-release-mutex-in-error-handling-code.patch


From: akpm@linux-foundation.org
Subject: + wdev-ath5k-dont-return-int-from-bool-function.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:31:28 -0800
Message-ID: <200802230732.m1N7WHal018070@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:55424 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753816AbYBWH6M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:58:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, mcgrof@gmail.com, mickflemm@gmail.com


The patch titled
     WDEV, ath5k, don't return int from bool function
has been added to the -mm tree.  Its filename is
     wdev-ath5k-dont-return-int-from-bool-function.patch

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
Subject: WDEV, ath5k, don't return int from bool function
From: Jiri Slaby <jirislaby@gmail.com>

sparse sees int -> bool cast as an error:
hw.c:3754:10: warning: cast truncates bits from constant value (ffffffea becomes 0)
Fix it by converting the rettype to int and check appropriately.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>
Cc: Luis R. Rodriguez <mcgrof@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/ath5k/ath5k.h |    2 +-
 drivers/net/wireless/ath5k/base.c  |    5 ++++-
 drivers/net/wireless/ath5k/hw.c    |    8 ++++----
 3 files changed, 9 insertions(+), 6 deletions(-)

diff -puN drivers/net/wireless/ath5k/ath5k.h~wdev-ath5k-dont-return-int-from-bool-function drivers/net/wireless/ath5k/ath5k.h
--- a/drivers/net/wireless/ath5k/ath5k.h~wdev-ath5k-dont-return-int-from-bool-function
+++ a/drivers/net/wireless/ath5k/ath5k.h
@@ -1035,7 +1035,7 @@ struct ath5k_hw {
 		unsigned int, unsigned int, enum ath5k_pkt_type, unsigned int,
 		unsigned int, unsigned int, unsigned int, unsigned int,
 		unsigned int, unsigned int, unsigned int);
-	bool (*ah_setup_xtx_desc)(struct ath5k_hw *, struct ath5k_desc *,
+	int (*ah_setup_xtx_desc)(struct ath5k_hw *, struct ath5k_desc *,
 		unsigned int, unsigned int, unsigned int, unsigned int,
 		unsigned int, unsigned int);
 	int (*ah_proc_tx_desc)(struct ath5k_hw *, struct ath5k_desc *);
diff -puN drivers/net/wireless/ath5k/base.c~wdev-ath5k-dont-return-int-from-bool-function drivers/net/wireless/ath5k/base.c
--- a/drivers/net/wireless/ath5k/base.c~wdev-ath5k-dont-return-int-from-bool-function
+++ a/drivers/net/wireless/ath5k/base.c
@@ -668,7 +668,10 @@ ath5k_attach(struct pci_dev *pdev, struc
 	 * return false w/o doing anything.  MAC's that do
 	 * support it will return true w/o doing anything.
 	 */
-	if (ah->ah_setup_xtx_desc(ah, NULL, 0, 0, 0, 0, 0, 0))
+	ret = ah->ah_setup_xtx_desc(ah, NULL, 0, 0, 0, 0, 0, 0);
+	if (ret < 0)
+		goto err;
+	if (ret > 0)
 		__set_bit(ATH_STAT_MRRETRY, sc->status);
 
 	/*
diff -puN drivers/net/wireless/ath5k/hw.c~wdev-ath5k-dont-return-int-from-bool-function drivers/net/wireless/ath5k/hw.c
--- a/drivers/net/wireless/ath5k/hw.c~wdev-ath5k-dont-return-int-from-bool-function
+++ a/drivers/net/wireless/ath5k/hw.c
@@ -45,7 +45,7 @@ static int ath5k_hw_setup_4word_tx_desc(
 	unsigned int, unsigned int, enum ath5k_pkt_type, unsigned int,
 	unsigned int, unsigned int, unsigned int, unsigned int, unsigned int,
 	unsigned int, unsigned int);
-static bool ath5k_hw_setup_xr_tx_desc(struct ath5k_hw *, struct ath5k_desc *,
+static int ath5k_hw_setup_xr_tx_desc(struct ath5k_hw *, struct ath5k_desc *,
 	unsigned int, unsigned int, unsigned int, unsigned int, unsigned int,
 	unsigned int);
 static int ath5k_hw_proc_4word_tx_status(struct ath5k_hw *, struct ath5k_desc *);
@@ -3743,7 +3743,7 @@ static int ath5k_hw_setup_4word_tx_desc(
 /*
  * Initialize a 4-word multirate tx descriptor on 5212
  */
-static bool
+static int
 ath5k_hw_setup_xr_tx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
 	unsigned int tx_rate1, u_int tx_tries1, u_int tx_rate2, u_int tx_tries2,
 	unsigned int tx_rate3, u_int tx_tries3)
@@ -3783,10 +3783,10 @@ ath5k_hw_setup_xr_tx_desc(struct ath5k_h
 
 #undef _XTX_TRIES
 
-		return true;
+		return 1;
 	}
 
-	return false;
+	return 0;
 }
 
 /*
_

Patches currently in -mm which might be from jirislaby@gmail.com are

git-drm.patch
drm-i915-fix-oops-after-killing-x.patch
git-dvb.patch
git-watchdog.patch
wdev-ath5k-fix-lock-imbalance.patch
wdev-ath5k-dont-return-int-from-bool-function.patch
wdev-ath5k-typecheck-on-nondebug.patch
mxser-prepare-for-bkl-pushdown.patch
tty-bkl-pushdown-fix.patch
tty-bkl-pushdown-fix1.patch
mxser-convert-large-macros-to-functions.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

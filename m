From: akpm@linux-foundation.org
Subject: + net-ath5k-no-printk-after-sta-ibss-switch.patch added to -mm tree
Date: Wed, 22 Aug 2007 16:12:31 -0700
Message-ID: <200708222312.l7MNCVE0009744@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35206 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762710AbXHVXMk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Aug 2007 19:12:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Net: ath5k, no printk after STA->IBSS switch
has been added to the -mm tree.  Its filename is
     net-ath5k-no-printk-after-sta-ibss-switch.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Net: ath5k, no printk after STA->IBSS switch
From: Jiri Slaby <jirislaby@gmail.com>

If STA->IBSS switch was done, but beacon_update weas not called so far, do not
emit a warning about non-existent skbuf.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/ath5k_base.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/net/wireless/ath5k_base.c~net-ath5k-no-printk-after-sta-ibss-switch drivers/net/wireless/ath5k_base.c
--- a/drivers/net/wireless/ath5k_base.c~net-ath5k-no-printk-after-sta-ibss-switch
+++ a/drivers/net/wireless/ath5k_base.c
@@ -655,7 +655,9 @@ static void ath_beacon_config(struct ath
 	DPRINTF(sc, ATH_DEBUG_BEACON, "%s: intval %u hw tsftu %u\n", __func__,
 			intval, tsftu);
 
-	if (sc->opmode == IEEE80211_IF_TYPE_STA) {
+	if (sc->opmode == IEEE80211_IF_TYPE_STA ||
+			(sc->opmode == IEEE80211_IF_TYPE_IBSS &&
+				!sc->bbuf->skb)) {
 		ath5k_hw_set_intr(ah, 0);
 		sc->imask |= AR5K_INT_BMISS;
 		sc->bmisscount = 0;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

net-add-ath5k-wireless-driver.patch
net-add-ath5k-wireless-driver-fix.patch
ath5k-printk-fix.patch
ath5k-kconfig-fix.patch
ath5k-needs-pci.patch
net-ath5k-no-printk-after-sta-ibss-switch.patch
net-ath5k-remove-sysctls.patch
epcac-reformat-comments-and-coding-style-improvements.patch
char-mxser_new-upgrade-to-110.patch
char-mxser_new-move-to-pci_vdevice.patch
char-mxser_new-remove-useless-comments-in-mxser_cards.patch
char-moxa-fix-and-optimise-empty-timer.patch
char-cyclades-remove-bottom-half-processing.patch
char-cyclades-make-the-isr-code-readable.patch
char-cyclades-move-spin_lock-to-one-place.patch
char-cyclades-fix-some-w-warnings.patch
char-moxa-cleanup-prints.patch
char-moxa-function-names-cleanup.patch
char-moxa-remove-sleep_on.patch
fs-select-remove-unused-macros.patch
cyber2000fb-rename-bit-macro.patch
i2c-pxa-rename-bit-macro-to-pxa_bit.patch
s2io-rename-bit-macro.patch
amba-pl011-rename-bit-macro.patch
define-first-set-of-bit-macros.patch
get-rid-of-input-bit-duplicate-defines.patch
define-global-bit-macro.patch
flashpoint-use-bit-instead-of-bitw.patch
shrink_slab-handle-bad-shrinkers.patch

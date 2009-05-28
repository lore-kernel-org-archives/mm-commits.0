From: akpm@linux-foundation.org
Subject: + wmm_paramac_aci_acm_aifsn-tested-twice.patch added to -mm tree
Date: Wed, 27 May 2009 17:22:43 -0700
Message-ID: <200905280022.n4S0MhAj008021@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59071 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757268AbZE1AXp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 May 2009 20:23:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, andreamrl@tiscali.it, gregkh@suse.de


The patch titled
     rtl8187se/ieee80211/ieee80211_rx.c: wmm_param[1].ac_aci_acm_aifsn tested twice
has been added to the -mm tree.  Its filename is
     wmm_paramac_aci_acm_aifsn-tested-twice.patch

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
Subject: rtl8187se/ieee80211/ieee80211_rx.c: wmm_param[1].ac_aci_acm_aifsn tested twice
From: Roel Kluin <roel.kluin@gmail.com>

wmm_param[1].ac_aci_acm_aifsn was tested twice, the second should have been
wmm_param[3].ac_aci_acm_aifsn.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Andrea Merello <andreamrl@tiscali.it>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c~wmm_paramac_aci_acm_aifsn-tested-twice drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c~wmm_paramac_aci_acm_aifsn-tested-twice
+++ a/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
@@ -1680,7 +1680,7 @@ inline void update_network(struct ieee80
 	if(src->wmm_param[0].ac_aci_acm_aifsn|| \
 	   src->wmm_param[1].ac_aci_acm_aifsn|| \
 	   src->wmm_param[2].ac_aci_acm_aifsn|| \
-	   src->wmm_param[1].ac_aci_acm_aifsn) {
+	   src->wmm_param[3].ac_aci_acm_aifsn) {
 	  memcpy(dst->wmm_param, src->wmm_param, WME_AC_PRAM_LEN);
 	}
 	dst->QoS_Enable = src->QoS_Enable;
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
drivers-serial-mpc52xx_uartc-fix-array-overindexing-check.patch
linux-next.patch
soc-correct-print-specifiers-for-unsigneds.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
fsldma-fix-check-on-potential-fdev-chan-overflow.patch
drm-fix-lock_test_with_return-macro.patch
uwb-event_size-should-be-signed.patch
irda-count-reaches-1.patch
drivers-isdn-i4l-isdn_ttyc-fix-check-for-array-overindexing.patch
scsi-ncr53c8xx-div-reaches-1.patch
scsi-pcmcia-nsp_cs-time_out-reaches-1.patch
wis-sony-tunerc-typo.patch
otus-80211core-coidc-fix-array-range-check.patch
wmm_paramac_aci_acm_aifsn-tested-twice.patch
lguest-fix-array-indexing-check.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
alpha-bad-macro-expansion-parameter-is-member.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
uml-bad-macro-expansion-parameter-is-member.patch
serial-z85c30-bcm1480-loops-reach-1.patch
spi_bfin5xx-limit-reaches-1.patch
carminefb-fix-possible-access-beyond-end-of-carmine_modedb.patch
ufs-sector_t-cannot-be-negative.patch
dtlk-off-by-one-in-readwrite_tts.patch


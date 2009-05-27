From: akpm@linux-foundation.org
Subject: + otus-80211core-coidc-fix-array-range-check.patch added to -mm tree
Date: Wed, 27 May 2009 00:17:29 -0700
Message-ID: <200905270717.n4R7HTr9007115@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43633 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760523AbZE0HRe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 May 2009 03:17:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, greg@kroah.com, lrodriguez@atheros.com


The patch titled
     otus/80211core/coid.c: fix array range check
has been added to the -mm tree.  Its filename is
     otus-80211core-coidc-fix-array-range-check.patch

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
Subject: otus/80211core/coid.c: fix array range check
From: Roel Kluin <roel.kluin@gmail.com>

The test for an overindexing of wd->ap.wds.encryMode[] has an off-by-one.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Luis R. Rodriguez <lrodriguez@atheros.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/otus/80211core/coid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/staging/otus/80211core/coid.c~otus-80211core-coidc-fix-array-range-check drivers/staging/otus/80211core/coid.c
--- a/drivers/staging/otus/80211core/coid.c~otus-80211core-coidc-fix-array-range-check
+++ a/drivers/staging/otus/80211core/coid.c
@@ -2013,7 +2013,7 @@ u16_t zfiConfigWdsPort(zdev_t* dev, u8_t
 
     zmw_get_wlan_dev(dev);
 
-    if (wdsPortId > ZM_MAX_WDS_SUPPORT)
+    if (wdsPortId >= ZM_MAX_WDS_SUPPORT)
     {
         return ZM_ERR_WDS_PORT_ID;
     }
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
drm-fix-lock_test_with_return-macro.patch
v4l-dvb-cimax2c-fix-typo.patch
zoran-fix-error.patch
uwb-event_size-should-be-signed.patch
irda-count-reaches-1.patch
scsi-ncr53c8xx-div-reaches-1.patch
scsi-pcmcia-nsp_cs-time_out-reaches-1.patch
wis-sony-tunerc-typo.patch
otus-80211core-coidc-fix-array-range-check.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
sh-fix-access-beyond-array_size-of-onchip_ops.patch
alpha-bad-macro-expansion-parameter-is-member.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
uml-bad-macro-expansion-parameter-is-member.patch
serial-z85c30-bcm1480-loops-reach-1.patch
spi_bfin5xx-limit-reaches-1.patch
carminefb-fix-possible-access-beyond-end-of-carmine_modedb.patch
ufs-sector_t-cannot-be-negative.patch
dtlk-off-by-one-in-readwrite_tts.patch


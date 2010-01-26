From: akpm@linux-foundation.org
Subject: + rtc-at91sam9-correct-size-given-to-memset.patch added to -mm tree
Date: Tue, 26 Jan 2010 14:28:06 -0800
Message-ID: <201001262228.o0QMS65r024610@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60970 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751788Ab0AZW2q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jan 2010 17:28:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, a.zummo@towertech.it


The patch titled
     rtc-at91sam9: Correct size given to memset
has been added to the -mm tree.  Its filename is
     rtc-at91sam9-correct-size-given-to-memset.patch

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
Subject: rtc-at91sam9: Correct size given to memset
From: Julia Lawall <julia@diku.dk>

Memset should be given the size of the structure, not the size of the
pointer.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
type T;
T *x;
expression E;
@@

memset(x, E, sizeof(
+ *
 x))
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-at91sam9.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-at91sam9.c~rtc-at91sam9-correct-size-given-to-memset drivers/rtc/rtc-at91sam9.c
--- a/drivers/rtc/rtc-at91sam9.c~rtc-at91sam9-correct-size-given-to-memset
+++ a/drivers/rtc/rtc-at91sam9.c
@@ -161,7 +161,7 @@ static int at91_rtc_readalarm(struct dev
 	if (offset == 0)
 		return -EILSEQ;
 
-	memset(alrm, 0, sizeof(alrm));
+	memset(alrm, 0, sizeof(*alrm));
 	if (alarm != ALARM_DISABLED && offset != 0) {
 		rtc_time_to_tm(offset + alarm, tm);
 
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch
drivers-scsi-sesc-eliminate-double-free.patch
kernel-credc-use-kmem_cache_free.patch
arch-arm-plat-pxa-dmac-correct-null-test.patch
drivers-gpu-drm-nouveau-nouveau_grctxc-correct-null-test.patch
drivers-media-video-move-dereference-after-null-test.patch
net-ipv4-correct-the-size-argument-to-kzalloc.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-bfa-bfad_imc-eliminate-useless-code.patch
drivers-staging-tm6000-tm6000-videoc-correct-null-test.patch
drivers-staging-go7007-s2250-loaderc-eliminate-useless-code.patch
drivers-usb-serial-eliminate-useless-code.patch
drivers-misc-iwmc3200top-mainc-eliminate-useless-code.patch
rtc-at91sam9-correct-size-given-to-memset.patch
drivers-edac-introduce-missing-kfree.patch
drivers-char-mmtimerc-eliminate-useless-code.patch


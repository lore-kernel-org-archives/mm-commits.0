From: akpm@linux-foundation.org
Subject: - misc-fix-integer-as-null-pointer-warnings.patch removed from -mm tree
Date: Fri, 09 May 2008 14:46:26 -0700
Message-ID: <200805092146.m49LkQPn027110@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47198 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755353AbYEIVrJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 May 2008 17:47:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, mchehab@infradead.org, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     misc: fix integer as NULL pointer warnings
has been removed from the -mm tree.  Its filename was
     misc-fix-integer-as-null-pointer-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: misc: fix integer as NULL pointer warnings
From: Harvey Harrison <harvey.harrison@gmail.com>

drivers/md/raid10.c:889:17: warning: Using plain integer as NULL pointer
drivers/media/video/cx18/cx18-driver.c:616:12: warning: Using plain integer as NULL pointer
sound/oss/kahlua.c:70:12: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/raid10.c                    |    2 +-
 drivers/media/video/cx18/cx18-driver.c |    2 +-
 sound/oss/kahlua.c                     |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/md/raid10.c~misc-fix-integer-as-null-pointer-warnings drivers/md/raid10.c
--- a/drivers/md/raid10.c~misc-fix-integer-as-null-pointer-warnings
+++ a/drivers/md/raid10.c
@@ -886,7 +886,7 @@ static int make_request(struct request_q
 	 */
 	raid10_find_phys(conf, r10_bio);
  retry_write:
-	blocked_rdev = 0;
+	blocked_rdev = NULL;
 	rcu_read_lock();
 	for (i = 0;  i < conf->copies; i++) {
 		int d = r10_bio->devs[i].devnum;
diff -puN drivers/media/video/cx18/cx18-driver.c~misc-fix-integer-as-null-pointer-warnings drivers/media/video/cx18/cx18-driver.c
--- a/drivers/media/video/cx18/cx18-driver.c~misc-fix-integer-as-null-pointer-warnings
+++ a/drivers/media/video/cx18/cx18-driver.c
@@ -613,7 +613,7 @@ static int __devinit cx18_probe(struct p
 	}
 
 	cx = kzalloc(sizeof(struct cx18), GFP_ATOMIC);
-	if (cx == 0) {
+	if (!cx) {
 		spin_unlock(&cx18_cards_lock);
 		return -ENOMEM;
 	}
diff -puN sound/oss/kahlua.c~misc-fix-integer-as-null-pointer-warnings sound/oss/kahlua.c
--- a/sound/oss/kahlua.c~misc-fix-integer-as-null-pointer-warnings
+++ a/sound/oss/kahlua.c
@@ -67,7 +67,7 @@ static int __devinit probe_one(struct pc
 		return 1;
 	
 	mem = ioremap(base, 128);
-	if(mem == 0UL)
+	if(!mem)
 		return 1;
 	map = readw(mem + 0x18);	/* Read the SMI enables */
 	iounmap(mem);
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
mmc-make-one-bit-signed-bitfields-unsigned.patch
linux-next.patch
kgdb-use-put_unaligned_be32-helper.patch
cifs-remove-global_extern-macro.patch
media-use-get_unaligned_-helpers.patch
hid-use-get-put_unaligned_-helpers.patch
git-input.patch
ata-remove-fit-macro.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-use-get_unaligned_-helpers.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
block-use-get_unaligned_-helpers.patch
git-watchdog.patch
mac80211-michaelc-use-kernel-provided-infrastructure.patch
mac80211-introduce-struct-michael_mic_ctx-and-static-helpers.patch
mac80211-tkipc-use-kernel-provided-infrastructure.patch
mac80211-add-const-remove-unused-function-make-one-function-static.patch
mac80211-add-a-struct-to-hold-tkip-context.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-1-key-mixing.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-2-key-mixing.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
wireless-use-get-put_unaligned_-helpers.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
lib-add-ascii-hex-helper-functions.patch
lib-add-ascii-hex-helper-functions-update.patch
fs-ldm-use-get_unaligned_-helpers.patch
include-use-get-put_unaligned_-helpers.patch
lzo-use-get-put_unaligned_-helpers.patch
video-fix-integer-as-null-pointer-warnings.patch
aacraid-linitc-make-aac_show_serial_number-static.patch


From: akpm@linux-foundation.org
Subject: + misc-fix-integer-as-null-pointer-warnings.patch added to -mm tree
Date: Thu, 01 May 2008 16:03:54 -0700
Message-ID: <200805012303.m41N3sep030071@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46806 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758507AbYEAXEP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 19:04:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, bfields@fieldses.org, mchehab@infradead.org, neilb@suse.de


The patch titled
     misc: fix integer as NULL pointer warnings
has been added to the -mm tree.  Its filename is
     misc-fix-integer-as-null-pointer-warnings.patch

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
Subject: misc: fix integer as NULL pointer warnings
From: Harvey Harrison <harvey.harrison@gmail.com>

drivers/md/raid10.c:889:17: warning: Using plain integer as NULL pointer
drivers/media/video/cx18/cx18-driver.c:616:12: warning: Using plain integer as NULL pointer
sound/oss/kahlua.c:70:12: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Neil Brown <neilb@suse.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
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
frv-unbreak-misalignment-handling-changes.patch
pcmcia-replace-remaining-__function__-occurrences.patch
autofs4-fix-sparse-warning-in-waitqc-autofs4_expire_indirect.patch
fuse-use-clamp-rather-than-nested-min-max.patch
block-remove-remaining-__function__-occurances.patch
drivers-scsi-ncr53c8xxc-fix-warning.patch
misc-fix-integer-as-null-pointer-warnings.patch
git-acpi.patch
cifs-remove-global_extern-macro.patch
input-replace-remaining-__function__-occurrences.patch
input-make-one-bit-signed-bitfields-unsigned.patch
git-kvm.patch
git-mips.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
git-sched.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
usb-fix-integer-as-null-pointer-sparse-warnings.patch
git-watchdog.patch
mac80211-michaelc-use-kernel-provided-infrastructure.patch
mac80211-introduce-struct-michael_mic_ctx-and-static-helpers.patch
mac80211-tkipc-use-kernel-provided-infrastructure.patch
mac80211-add-const-remove-unused-function-make-one-function-static.patch
mac80211-add-a-struct-to-hold-tkip-context.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-1-key-mixing.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-2-key-mixing.patch
git-xfs.patch
xtensa-replace-remaining-__function__-occurences.patch
mmc-make-one-bit-signed-bitfields-unsigned.patch
ide-eliminate-fit-macro.patch
ata-remove-fit-macro.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
input-ff-memlessc-use-clamp_val-macro.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch


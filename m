From: akpm@linux-foundation.org
Subject: - cycladesc-fix-sparse-shadowed-variable-warnings.patch removed from -mm tree
Date: Thu, 01 May 2008 02:29:42 -0700
Message-ID: <200805010929.m419Tgm7030703@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43768 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756268AbYEAJ3o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:29:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, mm-commits@vger.kernel.org


The patch titled
     cyclades.c: fix sparse shadowed variable warnings
has been removed from the -mm tree.  Its filename was
     cycladesc-fix-sparse-shadowed-variable-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cyclades.c: fix sparse shadowed variable warnings
From: Harvey Harrison <harvey.harrison@gmail.com>

Nested min() macros.
drivers/char/cyclades.c:2750:7: warning: symbol '_x' shadows an earlier one
drivers/char/cyclades.c:2750:7: originally declared here
drivers/char/cyclades.c:2750:7: warning: symbol '_x' shadows an earlier one
drivers/char/cyclades.c:2750:7: originally declared here
drivers/char/cyclades.c:2750:7: warning: symbol '_y' shadows an earlier one
drivers/char/cyclades.c:2750:7: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/char/cyclades.c~cycladesc-fix-sparse-shadowed-variable-warnings drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~cycladesc-fix-sparse-shadowed-variable-warnings
+++ a/drivers/char/cyclades.c
@@ -2747,8 +2747,8 @@ static int cy_write(struct tty_struct *t
 
 	spin_lock_irqsave(&info->card->card_lock, flags);
 	while (1) {
-		c = min(count, min((int)(SERIAL_XMIT_SIZE - info->xmit_cnt - 1),
-				   (int)(SERIAL_XMIT_SIZE - info->xmit_head)));
+		c = min(count, (int)(SERIAL_XMIT_SIZE - info->xmit_cnt - 1));
+		c = min(c, (int)(SERIAL_XMIT_SIZE - info->xmit_head));
 
 		if (c <= 0)
 			break;
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
frv-unbreak-misalignment-handling-changes.patch
git-acpi.patch
cifs-remove-global_extern-macro.patch
input-replace-remaining-__function__-occurrences.patch
input-make-one-bit-signed-bitfields-unsigned.patch
git-kvm.patch
git-mips.patch
mmc-make-one-bit-signed-bitfields-unsigned.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
git-sched.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
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
pcmcia-replace-remaining-__function__-occurrences.patch
autofs4-fix-sparse-warning-in-waitqc-autofs4_expire_indirect.patch
ide-eliminate-fit-macro.patch
ata-remove-fit-macro.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
fuse-use-clamp-rather-than-nested-min-max.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
input-ff-memlessc-use-clamp_val-macro.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
block-remove-remaining-__function__-occurances.patch


From: akpm@linux-foundation.org
Subject: - input-ff-memlessc-use-clamp_val-macro.patch removed from -mm tree
Date: Mon, 05 May 2008 12:16:34 -0700
Message-ID: <200805051916.m45JGYrp000310@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49964 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754370AbYEETQl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 May 2008 15:16:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, dtor@mail.ru, jkosina@suse.cz, mm-commits@vger.kernel.org


The patch titled
     input: ff-memless.c use clamp_val() macro
has been removed from the -mm tree.  Its filename was
     input-ff-memlessc-use-clamp_val-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: input: ff-memless.c use clamp_val() macro
From: Harvey Harrison <harvey.harrison@gmail.com>

Replace two opencoded nested min/max macros with clamp_val().

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/ff-memless.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/input/ff-memless.c~input-ff-memlessc-use-clamp_val-macro drivers/input/ff-memless.c
--- a/drivers/input/ff-memless.c~input-ff-memlessc-use-clamp_val-macro
+++ a/drivers/input/ff-memless.c
@@ -247,9 +247,9 @@ static void ml_combine_effects(struct ff
 		 * in s8, this should be changed to something more generic
 		 */
 		effect->u.ramp.start_level =
-			max(min(effect->u.ramp.start_level + x, 0x7f), -0x80);
+			clamp_val(effect->u.ramp.start_level + x, -0x80, 0x7f);
 		effect->u.ramp.end_level =
-			max(min(effect->u.ramp.end_level + y, 0x7f), -0x80);
+			clamp_val(effect->u.ramp.end_level + y, -0x80, 0x7f);
 		break;
 
 	case FF_RUMBLE:
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
linux-next.patch
misc-fix-integer-as-null-pointer-warnings.patch
cifs-remove-global_extern-macro.patch
media-use-get_unaligned_-helpers.patch
hid-use-get-put_unaligned_-helpers.patch
git-input.patch
ata-remove-fit-macro.patch
git-mips.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-use-get_unaligned_-helpers.patch
block-use-get_unaligned_-helpers.patch
usb-fix-integer-as-null-pointer-sparse-warnings.patch
usb-use-get_unaligned_-helpers.patch
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
mmc-make-one-bit-signed-bitfields-unsigned.patch
fs-ldm-use-get_unaligned_-helpers.patch
include-use-get-put_unaligned_-helpers.patch
lzo-use-get-put_unaligned_-helpers.patch
video-fix-integer-as-null-pointer-warnings.patch


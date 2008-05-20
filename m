From: akpm@linux-foundation.org
Subject: - hid-use-get-put_unaligned_-helpers.patch removed from -mm tree
Date: Tue, 20 May 2008 14:14:09 -0700
Message-ID: <200805202114.m4KLE9dt011439@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36020 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761209AbYETVWY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 17:22:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, jkosina@suse.cz, mm-commits@vger.kernel.org


The patch titled
     hid: use get/put_unaligned_* helpers
has been removed from the -mm tree.  Its filename was
     hid-use-get-put_unaligned_-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hid: use get/put_unaligned_* helpers
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hid/hid-core.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/hid/hid-core.c~hid-use-get-put_unaligned_-helpers drivers/hid/hid-core.c
--- a/drivers/hid/hid-core.c~hid-use-get-put_unaligned_-helpers
+++ a/drivers/hid/hid-core.c
@@ -780,7 +780,7 @@ static __inline__ __u32 extract(__u8 *re
  */
 static __inline__ void implement(__u8 *report, unsigned offset, unsigned n, __u32 value)
 {
-	__le64 x;
+	u64 x;
 	u64 m = (1ULL << n) - 1;
 
 	if (n > 32)
@@ -796,10 +796,10 @@ static __inline__ void implement(__u8 *r
 	report += offset >> 3;
 	offset &= 7;
 
-	x = get_unaligned((__le64 *)report);
-	x &= cpu_to_le64(~(m << offset));
-	x |= cpu_to_le64(((u64) value) << offset);
-	put_unaligned(x, (__le64 *) report);
+	x = get_unaligned_le64(report);
+	x &= ~(m << offset);
+	x |= ((u64)value) << offset;
+	put_unaligned_le64(x, report);
 }
 
 /*
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
linux-next.patch
kgdb-use-put_unaligned_be32-helper.patch
cifs-remove-global_extern-macro.patch
media-use-get_unaligned_-helpers.patch
git-input.patch
mtd-mtdcharc-silence-sparse-warning.patch
mtd-mtdcharc-remove-shadowed-variable-warnings.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-use-get_unaligned_-helpers.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
block-use-get_unaligned_-helpers.patch
usb-host-use-get-put_unaligned_-helpers-to-fix-more-potential-unaligned-issues.patch
git-watchdog.patch
mac80211-michaelc-use-kernel-provided-infrastructure.patch
mac80211-introduce-struct-michael_mic_ctx-and-static-helpers.patch
mac80211-add-const-remove-unused-function-make-one-function-static.patch
mac80211-add-a-struct-to-hold-tkip-context.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-1-key-mixing.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-2-key-mixing.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
fs-ldm-use-get_unaligned_-helpers.patch
include-use-get-put_unaligned_-helpers.patch
lzo-use-get-put_unaligned_-helpers.patch
asm-generic-int-ll64h-always-provide-__su64.patch
video-fix-integer-as-null-pointer-warnings.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
isdn-use-the-common-ascii-hex-helpers.patch
net-use-the-common-ascii-hex-helpers.patch
kgdb-use-the-common-ascii-hex-helpers.patch
cris-use-the-common-ascii-hex-helpers.patch
frv-use-the-common-ascii-hex-helpers.patch
mips-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
mn10300-use-the-common-ascii-hex-helpers.patch


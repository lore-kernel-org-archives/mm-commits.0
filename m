From: akpm@linux-foundation.org
Subject: + hid-use-get-put_unaligned_-helpers.patch added to -mm tree
Date: Fri, 02 May 2008 16:09:34 -0700
Message-ID: <200805022309.m42N9YNZ019866@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50164 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932424AbYEBXKF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 19:10:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, jkosina@suse.cz


The patch titled
     hid: use get/put_unaligned_* helpers
has been added to the -mm tree.  Its filename is
     hid-use-get-put_unaligned_-helpers.patch

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
misc-fix-integer-as-null-pointer-warnings.patch
cifs-remove-global_extern-macro.patch
input-replace-remaining-__function__-occurrences.patch
input-make-one-bit-signed-bitfields-unsigned.patch
input-ff-memlessc-use-clamp_val-macro.patch
ata-remove-fit-macro.patch
ide-eliminate-fit-macro.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
git-mips.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
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
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
xtensa-replace-remaining-__function__-occurences.patch
mmc-make-one-bit-signed-bitfields-unsigned.patch
lib-add-ascii-hex-helper-functions.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
cris-use-the-common-ascii-hex-helpers.patch
kgdb-use-the-common-ascii-hex-helpers.patch
frv-gdb-stubc-use-the-common-ascii-hex-helpers.patch
mn10300-gdb-stubc-use-the-common-ascii-hex-helpers.patch
mips-gdb-stubc-use-the-common-ascii-hex-helpers.patch
sh-kgdb-stubc-sh-scic-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers.patch
isdn-use-the-common-ascii-hex-helpers.patch
net-use-the-common-ascii-hex-helpers.patch
video-fix-integer-as-null-pointer-warnings.patch
block-use-get_unaligned_-helpers.patch
ide-use-get_unaligned_-helpers.patch
media-use-get_unaligned_-helpers.patch
scsi-use-get_unaligned_-helpers.patch
usb-use-get_unaligned_-helpers.patch
xfs-use-get_unaligned_-helpers.patch
fs-ldm-use-get_unaligned_-helpers.patch
irda-use-get_unaligned_-helpers.patch
hid-use-get-put_unaligned_-helpers.patch
include-use-get-put_unaligned_-helpers.patch
lzo-use-get-put_unaligned_-helpers.patch
bluetooth-use-get-put_unaligned_-helpers.patch
wireless-use-get-put_unaligned_-helpers.patch
net-use-get-put_unaligned_-helpers.patch


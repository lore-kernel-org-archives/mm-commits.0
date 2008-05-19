From: akpm@linux-foundation.org
Subject: + lib-add-byteorder-helpers-for-the-aligned-case.patch added to -mm tree
Date: Mon, 19 May 2008 16:44:19 -0700
Message-ID: <200805192344.m4JNiJtt027351@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58627 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756688AbYESXoo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 May 2008 19:44:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, stern@rowland.harvard.edu


The patch titled
     lib: add byteorder helpers for the aligned case
has been added to the -mm tree.  Its filename is
     lib-add-byteorder-helpers-for-the-aligned-case.patch

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
Subject: lib: add byteorder helpers for the aligned case
From: Harvey Harrison <harvey.harrison@gmail.com>

Some users know the pointer they are writing to are aligned, rather than
doing *(__le16 *)ptr = cpu_to_le16(val) add helpers wrapping this up that
have the same convention as put_unaligned_le/be.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/byteorder/generic.h |   30 ++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff -puN include/linux/byteorder/generic.h~lib-add-byteorder-helpers-for-the-aligned-case include/linux/byteorder/generic.h
--- a/include/linux/byteorder/generic.h~lib-add-byteorder-helpers-for-the-aligned-case
+++ a/include/linux/byteorder/generic.h
@@ -119,6 +119,36 @@
 #define cpu_to_be16s __cpu_to_be16s
 #define be16_to_cpus __be16_to_cpus
 
+static inline void put_le16(u16 val, void *ptr)
+{
+	*(__le16 *)ptr = cpu_to_le16(val);
+}
+
+static inline void put_le32(u32 val, void *ptr)
+{
+	*(__le32 *)ptr = cpu_to_le32(val);
+}
+
+static inline void put_le64(u64 val, void *ptr)
+{
+	*(__le64 *)ptr = cpu_to_le64(val);
+}
+
+static inline void put_be16(u16 val, void *ptr)
+{
+	*(__be16 *)ptr = cpu_to_be16(val);
+}
+
+static inline void put_be32(u32 val, void *ptr)
+{
+	*(__be32 *)ptr = cpu_to_be32(val);
+}
+
+static inline void put_be64(u64 val, void *ptr)
+{
+	*(__be64 *)ptr = cpu_to_be64(val);
+}
+
 /*
  * They have to be macros in order to do the constant folding
  * correctly - if the argument passed into a inline function
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

linux-next.patch
kgdb-use-put_unaligned_be32-helper.patch
cifs-remove-global_extern-macro.patch
media-use-get_unaligned_-helpers.patch
hid-use-get-put_unaligned_-helpers.patch
git-input.patch
ata-remove-fit-macro.patch
mtd-mtdcharc-silence-sparse-warning.patch
mtd-mtdcharc-remove-shadowed-variable-warnings.patch
nfs-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-use-get_unaligned_-helpers.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
block-use-get_unaligned_-helpers.patch
usb-host-use-get-put_unaligned_-helpers-to-fix-more-potential-unaligned-issues.patch
usb-file-storagec-use-unaligned-access-helpers.patch
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
video-fix-integer-as-null-pointer-warnings.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
isdn-use-the-common-ascii-hex-helpers.patch
net-use-the-common-ascii-hex-helpers.patch
kgdb-use-the-common-ascii-hex-helpers.patch
cris-use-the-common-ascii-hex-helpers.patch
frv-use-the-common-ascii-hex-helpers.patch
mips-use-the-common-ascii-hex-helpers.patch
sh-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
mn10300-use-the-common-ascii-hex-helpers.patch
lib-add-byteorder-helpers-for-the-aligned-case.patch


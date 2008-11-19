From: akpm@linux-foundation.org
Subject: + unaligned-introduce-common-header-fix.patch added to -mm tree
Date: Wed, 19 Nov 2008 11:26:25 -0800
Message-ID: <200811191926.mAJJQPVH029639@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35264 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751223AbYKST07 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Nov 2008 14:26:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com


The patch titled
     unaligned: fix return type for get_unaligned_le64/be64
has been added to the -mm tree.  Its filename is
     unaligned-introduce-common-header-fix.patch

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
Subject: unaligned: fix return type for get_unaligned_le64/be64
From: Harvey Harrison <harvey.harrison@gmail.com>

With my apologies, compiler didn't warn about the truncation.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/unaligned.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/asm-generic/unaligned.h~unaligned-introduce-common-header-fix include/asm-generic/unaligned.h
--- a/include/asm-generic/unaligned.h~unaligned-introduce-common-header-fix
+++ a/include/asm-generic/unaligned.h
@@ -120,7 +120,7 @@ static inline u32 get_unaligned_le32(con
 #endif
 }
 
-static inline u16 get_unaligned_le64(const void *p)
+static inline u64 get_unaligned_le64(const void *p)
 {
 #ifdef __LITTLE_ENDIAN
 	return ((const struct __una_u64 *)p)->x;
@@ -147,7 +147,7 @@ static inline u32 get_unaligned_be32(con
 #endif
 }
 
-static inline u16 get_unaligned_be64(const void *p)
+static inline u64 get_unaligned_be64(const void *p)
 {
 #ifdef __BIG_ENDIAN
 	return ((const struct __una_u64 *)p)->x;
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

linux-next.patch
arm-use-the-new-byteorder-headers.patch
dvb-cinergyt2-annotate-struct-endiannes-remove-unused-variable-add-static.patch
v4l-s2255drv-fix-firmware-test-on-big-endian.patch
ia64-use-the-new-byteorder-headers.patch
input-ads7846c-sparse-lock-annotation.patch
m32r-use-the-new-byteorder-headers.patch
blackfin-remove-__function__-in-new-serial-driver.patch
blackfin-use-the-new-byteorder-headers.patch
parisc-use-the-new-byteorder-headers.patch
s390-use-the-new-byteorder-headers.patch
scsi-replace-__inline-with-inline.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-annotate-gdth_rdcap_data-gdth_rdcap16_data-endianness.patch
frv-use-the-new-byteorder-headers.patch
m68knommu-use-the-new-byteorder-headers.patch
h8300-use-the-new-byteorder-headers.patch
alpha-use-the-new-byteorder-headers.patch
lib-fix-sparse-shadowed-variable-warning.patch
lib-radix_treec-make-percpu-variable-static.patch
lib-proportionsc-trivial-sparse-lock-annotation.patch
ibmpex-add-endian-annotation-to-extract_data-helper.patch
blackfin-remove-__function__-in-video-driver.patch
fb-carminefb-trivial-annotation-packing-color-register.patch
memstick-annotate-endianness-of-attribute-structs.patch
unaligned-introduce-common-header.patch
unaligned-introduce-common-header-fix.patch
unaligned-convert-arches-where-unaligned-access-is-ok.patch
unaligned-use-generic-implementation-on-packed-struct-arches.patch
unaligned-remove-packed-struct-and-unaligned-access_ok-headers.patch
unaligned-pack-the-struct-not-the-struct-members.patch
unaligned-move-arm-m32r-h8300-to-the-asm-generic-version.patch
unaligned-remove-last-bits-of-the-unaligned-access-helpers.patch


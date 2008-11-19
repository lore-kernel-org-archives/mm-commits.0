From: akpm@linux-foundation.org
Subject: + unaligned-pack-the-struct-not-the-struct-members.patch added to -mm tree
Date: Tue, 18 Nov 2008 22:15:10 -0800
Message-ID: <200811190615.mAJ6FAGr007473@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55682 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752388AbYKSGQN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Nov 2008 01:16:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, linux-arch@vger.kernel.org


The patch titled
     unaligned: pack the struct, not the struct members
has been added to the -mm tree.  Its filename is
     unaligned-pack-the-struct-not-the-struct-members.patch

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
Subject: unaligned: pack the struct, not the struct members
From: Harvey Harrison <harvey.harrison@gmail.com>

This is safe for the arches that currently use this as gcc says that
defining a struct as packed is equivalent to putting packed on each struct
member.

The reason this is needed is that there are some arches that define
structs to be aligned to something greater than a byte...so even if the
first member of the struct is marked as packed, gcc will still treat it as
having the default stuct alignment which will allow it to choose
_builtin_memcpy...  see the comments in the memmove-using arches.  This
also turned out to be the issue with ARM (needs confirmation) because
_some_ ARM compilers have this alignment set to 4 bytes.

If the struct _itself_ is marked as packed, the compiler cannot assume
this default alignment and _must_ do the bytewise access in whatever way
the arch does it.  By making this change, the last 3 arches could move to
the new asm-generic version and the bits in linux/unaligned/ can be
removed.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/unaligned.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN include/asm-generic/unaligned.h~unaligned-pack-the-struct-not-the-struct-members include/asm-generic/unaligned.h
--- a/include/asm-generic/unaligned.h~unaligned-pack-the-struct-not-the-struct-members
+++ a/include/asm-generic/unaligned.h
@@ -68,9 +68,9 @@ static inline void put_unaligned_be64(u6
 
 #else /* _UNALIGNED_ACCESS_OK */
 
-struct __una_u16 { u16 x __attribute__((packed)); };
-struct __una_u32 { u32 x __attribute__((packed)); };
-struct __una_u64 { u64 x __attribute__((packed)); };
+struct __una_u16 { u16 x; } __attribute__((packed));
+struct __una_u32 { u32 x; } __attribute__((packed));
+struct __una_u64 { u64 x; } __attribute__((packed));
 
 static inline u16 __get_le16_noalign(const u8 *p)
 {
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
unaligned-convert-arches-where-unaligned-access-is-ok.patch
unaligned-use-generic-implementation-on-packed-struct-arches.patch
unaligned-remove-packed-struct-and-unaligned-access_ok-headers.patch
unaligned-pack-the-struct-not-the-struct-members.patch
unaligned-move-arm-m32r-h8300-to-the-asm-generic-version.patch
unaligned-remove-last-bits-of-the-unaligned-access-helpers.patch


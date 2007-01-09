From: akpm@osdl.org
Subject: + remove-a-couple-final-references-to-obsolete-verify_area.patch added to -mm tree
Date: Mon, 08 Jan 2007 20:15:17 -0800
Message-ID: <200701090415.l094FHeh028120@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39351 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017AbXAIEPX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 8 Jan 2007 23:15:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, hskinnemoen@atmel.com, jesper.juhl@gmail.com


The patch titled
     Remove a couple final references to obsolete verify_area()
has been added to the -mm tree.  Its filename is
     remove-a-couple-final-references-to-obsolete-verify_area.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Remove a couple final references to obsolete verify_area()
From: "Robert P. J. Day" <rpjday@mindspring.com>

Remove a couple final references to the obsolete verify_area() call, which
was long ago replaced by access_ok().

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Acked-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Acked-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/asm-avr32/checksum.h |    2 +-
 include/asm-avr32/uaccess.h  |    6 ------
 2 files changed, 1 insertion(+), 7 deletions(-)

diff -puN include/asm-avr32/checksum.h~remove-a-couple-final-references-to-obsolete-verify_area include/asm-avr32/checksum.h
--- a/include/asm-avr32/checksum.h~remove-a-couple-final-references-to-obsolete-verify_area
+++ a/include/asm-avr32/checksum.h
@@ -38,7 +38,7 @@ __wsum csum_partial_copy_generic(const v
  *	passed in an incorrect kernel address to one of these functions.
  *
  *	If you use these functions directly please don't forget the
- *	verify_area().
+ *	access_ok().
  */
 static inline
 __wsum csum_partial_copy_nocheck(const void *src, void *dst,
diff -puN include/asm-avr32/uaccess.h~remove-a-couple-final-references-to-obsolete-verify_area include/asm-avr32/uaccess.h
--- a/include/asm-avr32/uaccess.h~remove-a-couple-final-references-to-obsolete-verify_area
+++ a/include/asm-avr32/uaccess.h
@@ -68,12 +68,6 @@ static inline void set_fs(mm_segment_t s
 
 #define access_ok(type, addr, size) (likely(__range_ok(addr, size) == 0))
 
-static inline int
-verify_area(int type, const void __user *addr, unsigned long size)
-{
-	return access_ok(type, addr, size) ? 0 : -EFAULT;
-}
-
 /* Generic arbitrary sized copy. Return the number of bytes NOT copied */
 extern __kernel_size_t __copy_user(void *to, const void *from,
 				   __kernel_size_t n);
_

Patches currently in -mm which might be from rpjday@mindspring.com are

git-alsa.patch
ppc-use-syslog-macro-for-the-printk-log-level.patch
rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch
transform-kmem_cache_allocmemset0-kmem_cache_zalloc.patch
get-rid-of-double-zeroing-of-allocated-pages.patch
remove-unnecessary-memset0-calls-after-kzalloc-calls.patch
discuss-a-couple-common-errors-in-kernel-doc-usage.patch
numerous-fixes-to-kernel-doc-info-in-source-files.patch
remove-a-couple-final-references-to-obsolete-verify_area.patch
oss-replace-kmallocmemset-combos-with-kzalloc.patch

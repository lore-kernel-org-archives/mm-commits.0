From: akpm@linux-foundation.org
Subject: + include-linux-unaligned-lbe_byteshifth-fix-usage-for-compressed-kernels.patch added to -mm tree
Date: Tue, 04 Aug 2009 16:02:37 -0700
Message-ID: <200908042302.n74N2cbk019437@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37629 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933562AbZHDXEK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Aug 2009 19:04:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: albin.tonnerre@free-electrons.com, hpa@zytor.com, mingo@elte.hu, phillip@lougher.demon.co.uk, rmk@arm.linux.org.uk, sam@ravnborg.org, tglx@linutronix.de


The patch titled
     include/linux/unaligned/{l,b}e_byteshift.h: fix usage for compressed kernels
has been added to the -mm tree.  Its filename is
     include-linux-unaligned-lbe_byteshifth-fix-usage-for-compressed-kernels.patch

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
Subject: include/linux/unaligned/{l,b}e_byteshift.h: fix usage for compressed kernels
From: Albin Tonnerre <albin.tonnerre@free-electrons.com>

When unaligned accesses are required for uncompressing a kernel (such as
for LZO decompression on ARM in a patch that follows), including
<linux/kernel.h> causes issues as it brings in a lot of things that are
not available in the decompression environment.

However, those files apparently use nothing from <linux/kernel.h>, all
they need is the declaration of types such as u32 or u64, so
<linux/types.h> should be enough

Signed-off-by: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/unaligned/be_byteshift.h |    2 +-
 include/linux/unaligned/le_byteshift.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/unaligned/be_byteshift.h~include-linux-unaligned-lbe_byteshifth-fix-usage-for-compressed-kernels include/linux/unaligned/be_byteshift.h
--- a/include/linux/unaligned/be_byteshift.h~include-linux-unaligned-lbe_byteshifth-fix-usage-for-compressed-kernels
+++ a/include/linux/unaligned/be_byteshift.h
@@ -1,7 +1,7 @@
 #ifndef _LINUX_UNALIGNED_BE_BYTESHIFT_H
 #define _LINUX_UNALIGNED_BE_BYTESHIFT_H
 
-#include <linux/kernel.h>
+#include <linux/types.h>
 
 static inline u16 __get_unaligned_be16(const u8 *p)
 {
diff -puN include/linux/unaligned/le_byteshift.h~include-linux-unaligned-lbe_byteshifth-fix-usage-for-compressed-kernels include/linux/unaligned/le_byteshift.h
--- a/include/linux/unaligned/le_byteshift.h~include-linux-unaligned-lbe_byteshifth-fix-usage-for-compressed-kernels
+++ a/include/linux/unaligned/le_byteshift.h
@@ -1,7 +1,7 @@
 #ifndef _LINUX_UNALIGNED_LE_BYTESHIFT_H
 #define _LINUX_UNALIGNED_LE_BYTESHIFT_H
 
-#include <linux/kernel.h>
+#include <linux/types.h>
 
 static inline u16 __get_unaligned_le16(const u8 *p)
 {
_

Patches currently in -mm which might be from albin.tonnerre@free-electrons.com are

lib-decompress_-only-include-linux-slabh-if-static-is-not-defined.patch
include-linux-unaligned-lbe_byteshifth-fix-usage-for-compressed-kernels.patch
lzo-add-support-for-lzo-compressed-kernels.patch
lzo-arm-add-support-for-lzo-compressed-kernels.patch
lzo-x86-add-support-for-lzo-compressed-kernels.patch
lzo-add-lzo-compression-support-for-initramfs-and-old-style-initrd.patch


From: akpm@linux-foundation.org
Subject: [merged] include-linux-unaligned-lbe_byteshifth-fix-usage-for-compressed-kernels.patch removed from -mm tree
Date: Thu, 24 Sep 2009 12:37:23 -0700
Message-ID: <200909241937.n8OJbNov004476@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51863 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754531AbZIXTih (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 15:38:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: albin.tonnerre@free-electrons.com, hpa@zytor.com, mingo@elte.hu, phillip@lougher.demon.co.uk, rmk@arm.linux.org.uk, sam@ravnborg.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     include/linux/unaligned/{l,b}e_byteshift.h: fix usage for compressed kernels
has been removed from the -mm tree.  Its filename was
     include-linux-unaligned-lbe_byteshifth-fix-usage-for-compressed-kernels.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: include/linux/unaligned/{l,b}e_byteshift.h: fix usage for compressed kernels
From: Albin Tonnerre <albin.tonnerre@free-electrons.com>

When unaligned accesses are required for uncompressing a kernel (such as
for LZO decompression on ARM in a patch that follows), including
<linux/kernel.h> causes issues as it brings in a lot of things that are
not available in the decompression environment.

linux/kernel.h brings at least:
extern int console_printk[];
extern const char hex_asc[];
which causes errors at link-time as they are not available when
compiling the pre-boot environement. There are also a few others:

arch/arm/boot/compressed/misc.o: In function `valid_user_regs':
/home/albin/devel/free-electrons/gits/linux-2.6/arch/arm/include/asm/ptrace.h:158: undefined reference to `elf_hwcap'
arch/arm/boot/compressed/misc.o: In function `console_silent':
/home/albin/devel/free-electrons/gits/linux-2.6/include/linux/kernel.h:292: undefined reference to `console_printk'
arch/arm/boot/compressed/misc.o: In function `console_verbose':
/home/albin/devel/free-electrons/gits/linux-2.6/include/linux/kernel.h:297: undefined reference to `console_printk'
arch/arm/boot/compressed/misc.o: In function `pack_hex_byte':
/home/albin/devel/free-electrons/gits/linux-2.6/include/linux/kernel.h:360: undefined reference to `hex_asc'
arch/arm/boot/compressed/misc.o: In function `hweight_long':
/home/albin/devel/free-electrons/gits/linux-2.6/include/linux/bitops.h:45: undefined reference to `hweight32'
arch/arm/boot/compressed/misc.o: In function `__cmpxchg_local_generic':
/home/albin/devel/free-electrons/gits/linux-2.6/include/asm-generic/cmpxchg-local.h:21: undefined reference to `wrong_size_cmpxchg'
/home/albin/devel/free-electrons/gits/linux-2.6/include/asm-generic/cmpxchg-local.h:42: undefined reference to `wrong_size_cmpxchg'
arch/arm/boot/compressed/misc.o: In function `__xchg':
/home/albin/devel/free-electrons/gits/linux-2.6/arch/arm/include/asm/system.h:309: undefined reference to `__bad_xchg'

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

origin.patch


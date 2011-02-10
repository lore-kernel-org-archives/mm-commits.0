From: akpm@linux-foundation.org
Subject: + arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch added to -mm tree
Date: Thu, 10 Feb 2011 13:37:14 -0800
Message-ID: <201102102211.p1AMBVPW021422@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50002 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757161Ab1BJWLt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Feb 2011 17:11:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, hpa@zytor.com, linux-arch@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de


The patch titled
     arch/x86/include/asm/delay.h: fix udelay() and ndelay() for 8-bit args
has been added to the -mm tree.  Its filename is
     arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch

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
Subject: arch/x86/include/asm/delay.h: fix udelay() and ndelay() for 8-bit args
From: Andrew Morton <akpm@linux-foundation.org>

With a non-constant 8-bit argument, a call to udelay() generates a warning:

drivers/gpu/drm/radeon/atom.c: In function 'atom_op_delay':
drivers/gpu/drm/radeon/atom.c:654: warning: comparison is always false due to limited range of data type

The code looks like it works OK with an 8-bit arg, and the calling code is
doing nothing wrong, so udelay() needs fixing.

Fixing it was rather tricky.  Simply typecasting `n' in the comparison with
20000 didn't change anything.  Hence the divide-by-20000 trick.

Using a do{}while loop didn't work because udelay() is used in ?: statements,
hence the ({...}) construct.

While I was there I replaced the brain-bending ?:?:?: mess with nice if/else
code.

Probably other architectures are generating the same warning and can use a
similar change.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/delay.h |   33 +++++++++++++++++++++++++++------
 1 file changed, 27 insertions(+), 6 deletions(-)

diff -puN arch/x86/include/asm/delay.h~arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args arch/x86/include/asm/delay.h
--- a/arch/x86/include/asm/delay.h~arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args
+++ a/arch/x86/include/asm/delay.h
@@ -16,15 +16,36 @@ extern void __ndelay(unsigned long nsecs
 extern void __const_udelay(unsigned long xloops);
 extern void __delay(unsigned long loops);
 
+/*
+ * The weird n/20000 thing suppresses a "comparison is always false due to
+ * limited range of data type" warning with non-const 8-bit arguments.
+ */
+
 /* 0x10c7 is 2**32 / 1000000 (rounded up) */
-#define udelay(n) (__builtin_constant_p(n) ? \
-	((n) > 20000 ? __bad_udelay() : __const_udelay((n) * 0x10c7ul)) : \
-	__udelay(n))
+#define udelay(n)							\
+	({								\
+		if (__builtin_constant_p(n)) {				\
+			if ((n) / 20000 >= 1)				\
+				 __bad_udelay();			\
+			else						\
+				__const_udelay((n) * 0x10c7ul);		\
+		} else {						\
+			__udelay(n);					\
+		}							\
+	})
 
 /* 0x5 is 2**32 / 1000000000 (rounded up) */
-#define ndelay(n) (__builtin_constant_p(n) ? \
-	((n) > 20000 ? __bad_ndelay() : __const_udelay((n) * 5ul)) : \
-	__ndelay(n))
+#define ndelay(n)							\
+	({								\
+		if (__builtin_constant_p(n)) {				\
+			if ((n) / 20000 >= 1)				\
+				__bad_ndelay();				\
+			else						\
+				__const_udelay((n) * 5ul);		\
+		} else {						\
+			__ndelay(n);					\
+		}							\
+	})
 
 void use_tsc_delay(void);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-vmap-area-cache.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-convert-bd2802-driver-to-dev_pm_ops-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch
fs-ocfs2-dlm-dlmdomainc-avoid-a-gfp_atomic-allocation.patch
drivers-message-fusion-mptsasc-fix-warning.patch
drbd-fix-warning.patch
mm.patch
mm-allow-gup-to-fail-instead-of-waiting-on-a-page-fix.patch
mm-batch-free-pcp-list-if-possible-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
kernel-cpuc-fix-many-errors-related-to-style-fix.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
scatterlist-new-helper-functions.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch


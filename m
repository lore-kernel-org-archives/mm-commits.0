From: akpm@linux-foundation.org
Subject: + replace-__attribute_pure__-with-__pure.patch added to -mm tree
Date: Fri, 05 Oct 2007 17:05:22 -0700
Message-ID: <200710060005.l9605M2Z031851@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37931 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752666AbXJFAF6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2007 20:05:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ralf@linux-mips.org, benh@kernel.crashing.org, bryan.wu@analog.com, mchehab@infradead.org, paulus@samba.org, rmk@arm.linux.org.uk


The patch titled
     Replace __attribute_pure__ with __pure
has been added to the -mm tree.  Its filename is
     replace-__attribute_pure__-with-__pure.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Replace __attribute_pure__ with __pure
From: Ralf Baechle <ralf@linux-mips.org>

To be consistent with the use of attributes in the rest of the kernel
replace all use of __attribute_pure__ with __pure and delete the definition
of __attribute_pure__.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Acked-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Bryan Wu <bryan.wu@analog.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN arch/arm/nwfpe/fpopcode.h~replace-__attribute_pure__-with-__pure arch/arm/nwfpe/fpopcode.h
--- a/arch/arm/nwfpe/fpopcode.h~replace-__attribute_pure__-with-__pure
+++ a/arch/arm/nwfpe/fpopcode.h
@@ -369,20 +369,20 @@ TABLE 5
 #define getRoundingMode(opcode)		((opcode & MASK_ROUNDING_MODE) >> 5)
 
 #ifdef CONFIG_FPE_NWFPE_XP
-static inline __attribute_pure__ floatx80 getExtendedConstant(const unsigned int nIndex)
+static inline floatx80 __pure getExtendedConstant(const unsigned int nIndex)
 {
 	extern const floatx80 floatx80Constant[];
 	return floatx80Constant[nIndex];
 }
 #endif
 
-static inline __attribute_pure__ float64 getDoubleConstant(const unsigned int nIndex)
+static inline float64 __pure getDoubleConstant(const unsigned int nIndex)
 {
 	extern const float64 float64Constant[];
 	return float64Constant[nIndex];
 }
 
-static inline __attribute_pure__ float32 getSingleConstant(const unsigned int nIndex)
+static inline float32 __pure getSingleConstant(const unsigned int nIndex)
 {
 	extern const float32 float32Constant[];
 	return float32Constant[nIndex];
diff -puN drivers/media/video/v4l1-compat.c~replace-__attribute_pure__-with-__pure drivers/media/video/v4l1-compat.c
--- a/drivers/media/video/v4l1-compat.c~replace-__attribute_pure__-with-__pure
+++ a/drivers/media/video/v4l1-compat.c
@@ -144,7 +144,7 @@ const static unsigned int palette2pixelf
 	[VIDEO_PALETTE_YUV422P] = V4L2_PIX_FMT_YUV422P,
 };
 
-static unsigned int __attribute_pure__
+static unsigned int __pure
 palette_to_pixelformat(unsigned int palette)
 {
 	if (palette < ARRAY_SIZE(palette2pixelformat))
diff -puN include/asm-blackfin/processor.h~replace-__attribute_pure__-with-__pure include/asm-blackfin/processor.h
--- a/include/asm-blackfin/processor.h~replace-__attribute_pure__-with-__pure
+++ a/include/asm-blackfin/processor.h
@@ -104,13 +104,13 @@ unsigned long get_wchan(struct task_stru
 #define cpu_relax()    	barrier()
 
 /* Get the Silicon Revision of the chip */
-static inline __attribute_pure__ uint32_t bfin_revid(void)
+static inline uint32_t __pure bfin_revid(void)
 {
 	/* stored in the upper 4 bits */
 	return bfin_read_CHIPID() >> 28;
 }
 
-static inline __attribute_pure__ uint32_t bfin_compiled_revid(void)
+static inline uint32_t __pure bfin_compiled_revid(void)
 {
 #if defined(CONFIG_BF_REV_0_0)
 	return 0;
diff -puN include/asm-ppc/time.h~replace-__attribute_pure__-with-__pure include/asm-ppc/time.h
--- a/include/asm-ppc/time.h~replace-__attribute_pure__-with-__pure
+++ a/include/asm-ppc/time.h
@@ -57,7 +57,7 @@ static __inline__ void set_dec(unsigned 
 /* Accessor functions for the timebase (RTC on 601) registers. */
 /* If one day CONFIG_POWER is added just define __USE_RTC as 1 */
 #ifdef CONFIG_6xx
-extern __inline__ int __attribute_pure__ __USE_RTC(void) {
+extern __inline__ int __pure __USE_RTC(void) {
 	return (mfspr(SPRN_PVR)>>16) == 1;
 }
 #else
diff -puN include/linux/compiler-gcc.h~replace-__attribute_pure__-with-__pure include/linux/compiler-gcc.h
--- a/include/linux/compiler-gcc.h~replace-__attribute_pure__-with-__pure
+++ a/include/linux/compiler-gcc.h
@@ -36,10 +36,20 @@
 #define __weak				__attribute__((weak))
 #define __naked				__attribute__((naked))
 #define __noreturn			__attribute__((noreturn))
+
+/*
+ * From the GCC manual:
+ *
+ * Many functions have no effects except the return value and their
+ * return value depends only on the parameters and/or global
+ * variables.  Such a function can be subject to common subexpression
+ * elimination and loop optimization just as an arithmetic operator
+ * would be.
+ * [...]
+ */
 #define __pure				__attribute__((pure))
 #define __aligned(x)			__attribute__((aligned(x)))
 #define __printf(a,b)			__attribute__((format(printf,a,b)))
 #define  noinline			__attribute__((noinline))
-#define __attribute_pure__		__attribute__((pure))
 #define __attribute_const__		__attribute__((__const__))
 #define __maybe_unused			__attribute__((unused))
diff -puN include/linux/compiler.h~replace-__attribute_pure__-with-__pure include/linux/compiler.h
--- a/include/linux/compiler.h~replace-__attribute_pure__-with-__pure
+++ a/include/linux/compiler.h
@@ -132,20 +132,6 @@ extern void __chk_io_ptr(const volatile 
 # define __maybe_unused		/* unimplemented */
 #endif
 
-/*
- * From the GCC manual:
- *
- * Many functions have no effects except the return value and their
- * return value depends only on the parameters and/or global
- * variables.  Such a function can be subject to common subexpression
- * elimination and loop optimization just as an arithmetic operator
- * would be.
- * [...]
- */
-#ifndef __attribute_pure__
-# define __attribute_pure__	/* unimplemented */
-#endif
-
 #ifndef noinline
 #define noinline
 #endif
diff -puN lib/crc32.c~replace-__attribute_pure__-with-__pure lib/crc32.c
--- a/lib/crc32.c~replace-__attribute_pure__-with-__pure
+++ a/lib/crc32.c
@@ -49,7 +49,7 @@ MODULE_LICENSE("GPL");
  * @p: pointer to buffer over which CRC is run
  * @len: length of buffer @p
  */
-u32 __attribute_pure__ crc32_le(u32 crc, unsigned char const *p, size_t len);
+u32 __pure crc32_le(u32 crc, unsigned char const *p, size_t len);
 
 #if CRC_LE_BITS == 1
 /*
@@ -57,7 +57,7 @@ u32 __attribute_pure__ crc32_le(u32 crc,
  * simplified by inlining the table in ?: form.
  */
 
-u32 __attribute_pure__ crc32_le(u32 crc, unsigned char const *p, size_t len)
+u32 __pure crc32_le(u32 crc, unsigned char const *p, size_t len)
 {
 	int i;
 	while (len--) {
@@ -69,7 +69,7 @@ u32 __attribute_pure__ crc32_le(u32 crc,
 }
 #else				/* Table-based approach */
 
-u32 __attribute_pure__ crc32_le(u32 crc, unsigned char const *p, size_t len)
+u32 __pure crc32_le(u32 crc, unsigned char const *p, size_t len)
 {
 # if CRC_LE_BITS == 8
 	const u32      *b =(u32 *)p;
@@ -145,7 +145,7 @@ u32 __attribute_pure__ crc32_le(u32 crc,
  * @p: pointer to buffer over which CRC is run
  * @len: length of buffer @p
  */
-u32 __attribute_pure__ crc32_be(u32 crc, unsigned char const *p, size_t len);
+u32 __pure crc32_be(u32 crc, unsigned char const *p, size_t len);
 
 #if CRC_BE_BITS == 1
 /*
@@ -153,7 +153,7 @@ u32 __attribute_pure__ crc32_be(u32 crc,
  * simplified by inlining the table in ?: form.
  */
 
-u32 __attribute_pure__ crc32_be(u32 crc, unsigned char const *p, size_t len)
+u32 __pure crc32_be(u32 crc, unsigned char const *p, size_t len)
 {
 	int i;
 	while (len--) {
@@ -167,7 +167,7 @@ u32 __attribute_pure__ crc32_be(u32 crc,
 }
 
 #else				/* Table-based approach */
-u32 __attribute_pure__ crc32_be(u32 crc, unsigned char const *p, size_t len)
+u32 __pure crc32_be(u32 crc, unsigned char const *p, size_t len)
 {
 # if CRC_BE_BITS == 8
 	const u32      *b =(u32 *)p;
diff -puN lib/libcrc32c.c~replace-__attribute_pure__-with-__pure lib/libcrc32c.c
--- a/lib/libcrc32c.c~replace-__attribute_pure__-with-__pure
+++ a/lib/libcrc32c.c
@@ -66,7 +66,7 @@ EXPORT_SYMBOL(crc32c_le);
  * loop below with crc32 and vary the POLY if we don't find value in terms
  * of space and maintainability in keeping the two modules separate.
  */
-u32 __attribute_pure__
+u32 __pure
 crc32c_le(u32 crc, unsigned char const *p, size_t len)
 {
 	int i;
@@ -160,7 +160,7 @@ static const u32 crc32c_table[256] = {
  * crc using table.
  */
 
-u32 __attribute_pure__
+u32 __pure
 crc32c_le(u32 seed, unsigned char const *data, size_t length)
 {
 	u32 crc = __cpu_to_le32(seed);
@@ -177,7 +177,7 @@ crc32c_le(u32 seed, unsigned char const 
 EXPORT_SYMBOL(crc32c_be);
 
 #if CRC_BE_BITS == 1
-u32 __attribute_pure__
+u32 __pure
 crc32c_be(u32 crc, unsigned char const *p, size_t len)
 {
 	int i;
_

Patches currently in -mm which might be from ralf@linux-mips.org are

origin.patch
clockevents-fix-bogus-next_event-reset-for-oneshot-broadcast-devices.patch
fix-amd-mips-alchemy-au1550-i2c-interface.patch
git-leds.patch
git-mips.patch
git-mtd.patch
git-net.patch
move-a-few-definitions-to-au1000_xxs1500c.patch
move-a-few-definitions-to-au1000_xxs1500c-fix.patch
serial_txx9-cleanup-includes.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
clean-up-duplicate-includes-in-drivers-char.patch
spelling-fix-weired-weird.patch
remove-dma_cache_wbackinvwback_inv-functions.patch
lk201-remove-obsolete-driver.patch
fix-wrong-filename-reference-in-drivers-testingtxt.patch
completely-remove-deprecated-irq-flags-sa_.patch
compile-handle_percpu_irq-even-for-uniprocessor-kernels.patch
break-elf_platform-and-stack-pointer-randomization-dependency.patch
rtc-make-rtc-ds1742-driver-hotplug-aware-take-2.patch
fbcon-convert-struct-font_desc-to-use-iso-c-initializers.patch
fbcon-convert-struct-font_desc-to-use-iso-c-initializers-update.patch
vt-fix-warnings-in-selectionh.patch
export-font_vga_8x16.patch
drivers-video-pmag-ba-fbc-improve-diagnostics.patch
drivers-video-pmag-ba-fbc-improve-diagnostics-fix.patch
add-a-00-index-file-to-documentation-mips.patch
define-global-bit-macro.patch
bitops-introduce-lock-ops.patch
mips-fix-bitops.patch
mips-lock-bitops.patch
replace-__attribute_pure__-with-__pure.patch

From: akpm@linux-foundation.org
Subject: +
 scripts-spellingtxt-add-aligment-pattern-and-fix-typo-instances.patch added to -mm tree
Date: Mon, 19 Dec 2016 14:26:19 -0800
Message-ID: <58585e8b.QsyzbN1RuopywUBa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43868 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751979AbcLSWZU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Dec 2016 17:25:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yamada.masahiro@socionext.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: add "aligment" pattern and fix typo instances
has been added to the -mm tree.  Its filename is
     scripts-spellingtxt-add-aligment-pattern-and-fix-typo-instances.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-spellingtxt-add-aligment-pattern-and-fix-typo-instances.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-spellingtxt-add-aligment-pattern-and-fix-typo-instances.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: scripts/spelling.txt: add "aligment" pattern and fix typo instances

Fix typos and add the following to the scripts/spelling.txt:

  aligment||alignment

I did not touch the "N_BYTE_ALIGMENT" macro in
drivers/net/wireless/realtek/rtlwifi/wifi.h to avoid unpredictable
impact.

I fixed "_aligment_handler" in arch/openrisc/kernel/entry.S because
it is surrounded by #if 0 ... #endif.  It is surely safe and I
confirmed "_alignment_handler" is correct.

I also fixed the "controler" I found in the same hunk in
arch/openrisc/kernel/head.S.

Link: http://lkml.kernel.org/r/1481573103-11329-8-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/kernel/unwind.c                            |    4 ++--
 arch/openrisc/kernel/entry.S                        |    4 ++--
 arch/openrisc/kernel/head.S                         |    6 +++---
 arch/openrisc/kernel/vmlinux.lds.S                  |    4 ++--
 drivers/acpi/acpica/acmacros.h                      |    2 +-
 drivers/gpu/drm/amd/include/atombios.h              |    6 +++---
 drivers/gpu/drm/i915/i915_gem_render_state.c        |    2 +-
 drivers/gpu/drm/radeon/atombios.h                   |    4 ++--
 drivers/media/platform/exynos4-is/fimc-core.h       |    2 +-
 drivers/net/wireless/ath/ath9k/ani.c                |    4 ++--
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/fw.c |    4 ++--
 drivers/scsi/bfa/bfi_ms.h                           |    2 +-
 net/netfilter/x_tables.c                            |    2 +-
 scripts/spelling.txt                                |    1 +
 14 files changed, 24 insertions(+), 23 deletions(-)

diff -puN arch/arc/kernel/unwind.c~scripts-spellingtxt-add-aligment-pattern-and-fix-typo-instances arch/arc/kernel/unwind.c
--- a/arch/arc/kernel/unwind.c~scripts-spellingtxt-add-aligment-pattern-and-fix-typo-instances
+++ a/arch/arc/kernel/unwind.c
@@ -1051,9 +1051,9 @@ int arc_unwind(struct unwind_frame_info
 		++ptr;
 	}
 	if (cie != NULL) {
-		/* get code aligment factor */
+		/* get code alignment factor */
 		state.codeAlign = get_uleb128(&ptr, end);
-		/* get data aligment factor */
+		/* get data alignment factor */
 		state.dataAlign = get_sleb128(&ptr, end);
 		if (state.codeAlign == 0 || state.dataAlign == 0 || ptr >= end)
 			cie = NULL;
diff -puN arch/openrisc/kernel/entry.S~scripts-spellingtxt-add-aligment-pattern-and-fix-typo-instances arch/openrisc/kernel/entry.S
--- a/arch/openrisc/kernel/entry.S~scripts-spellingtxt-add-aligment-pattern-and-fix-typo-instances
+++ a/arch/openrisc/kernel/entry.S
@@ -310,7 +310,7 @@ EXCEPTION_ENTRY(_timer_handler)
 	l.j    _ret_from_intr
 	 l.nop
 
-/* ---[ 0x600: Aligment exception ]-------------------------------------- */
+/* ---[ 0x600: Alignment exception ]-------------------------------------- */
 
 EXCEPTION_ENTRY(_alignment_handler)
 	/* r4: EA of fault (set by EXCEPTION_HANDLE) */
@@ -321,7 +321,7 @@ EXCEPTION_ENTRY(_alignment_handler)
 	 l.nop
 
 #if 0
-EXCEPTION_ENTRY(_aligment_handler)
+EXCEPTION_ENTRY(_alignment_handler)
 //        l.mfspr r2,r0,SPR_EEAR_BASE     /* Load the efective addres */
 	l.addi	r2,r4,0
 //        l.mfspr r5,r0,SPR_EPCR_BASE     /* Load the insn address */
diff -puN arch/openrisc/kernel/head.S~scripts-spellingtxt-add-aligment-pattern-and-fix-typo-instances arch/openrisc/kernel/head.S
--- a/arch/openrisc/kernel/head.S~scripts-spellingtxt-add-aligment-pattern-and-fix-typo-instances
+++ a/arch/openrisc/kernel/head.S
@@ -324,7 +324,7 @@ _dispatch_do_ipage_fault:
     .org 0x500
 	EXCEPTION_HANDLE(_timer_handler)
 
-/* ---[ 0x600: Aligment exception ]-------------------------------------- */
+/* ---[ 0x600: Alignment exception ]-------------------------------------- */
     .org 0x600
 	EXCEPTION_HANDLE(_alignment_handler)
 
@@ -629,8 +629,8 @@ jump_start_kernel:
 
 /* ========================================[ cache ]=== */
 
-	/* aligment here so we don't change memory offsets with
-	 * memory controler defined
+	/* alignment here so we don't change memory offsets with
+	 * memory controller defined
 	 */
 	.align 0x2000
 
diff -puN arch/openrisc/kernel/vmlinux.lds.S~scripts-spellingtxt-add-aligment-pattern-and-fix-typo-instances arch/openrisc/kernel/vmlinux.lds.S
--- a/arch/openrisc/kernel/vmlinux.lds.S~scripts-spellingtxt-add-aligment-pattern-and-fix-typo-instances
+++ a/arch/openrisc/kernel/vmlinux.lds.S
@@ -19,8 +19,8 @@
 
 /* TODO
  *		- clean up __offset & stuff
- *		- change all 8192 aligment to PAGE !!!
- *		- recheck if all aligments are really needed
+ *		- change all 8192 alignment to PAGE !!!
+ *		- recheck if all alignments are really needed
  */
 
 #  define LOAD_OFFSET  PAGE_OFFSET
diff -puN drivers/acpi/acpica/acmacros.h~scripts-spellingtxt-add-aligment-pattern-and-fix-typo-instances drivers/acpi/acpica/acmacros.h
--- a/drivers/acpi/acpica/acmacros.h~scripts-spellingtxt-add-aligment-pattern-and-fix-typo-instances
+++ a/drivers/acpi/acpica/acmacros.h
@@ -46,7 +46,7 @@
 
 /*
  * Extract data using a pointer. Any more than a byte and we
- * get into potential aligment issues -- see the STORE macros below.
+ * get into potential alignment issues -- see the STORE macros below.
  * Use with care.
  */
 #define ACPI_CAST8(ptr)                 ACPI_CAST_PTR (u8, (ptr))
diff -puN drivers/gpu/drm/amd/include/atombios.h~scripts-spellingtxt-add-aligment-pattern-and-fix-typo-instances drivers/gpu/drm/amd/include/atombios.h
--- a/drivers/gpu/drm/amd/include/atombios.h~scripts-spellingtxt-add-aligment-pattern-and-fix-typo-instances
+++ a/drivers/gpu/drm/amd/include/atombios.h
@@ -188,7 +188,7 @@
 #define HW_ASSISTED_I2C_STATUS_FAILURE     2
 #define HW_ASSISTED_I2C_STATUS_SUCCESS     1
 
-#pragma pack(1)                                       // BIOS data must use byte aligment
+#pragma pack(1)                                       // BIOS data must use byte alignment
 
 // Define offset to location of ROM header.
 #define OFFSET_TO_POINTER_TO_ATOM_ROM_HEADER         0x00000048L
@@ -9180,7 +9180,7 @@ typedef struct  _ATOM_POWERPLAY_INFO_V3
 
 /*********************************************************************************/
 
-#pragma pack() // BIOS data must use byte aligment
+#pragma pack() // BIOS data must use byte alignment
 
 #pragma pack(1)
 
@@ -9211,7 +9211,7 @@ typedef struct _ATOM_SERVICE_INFO
 
 
 
-#pragma pack() // BIOS data must use byte aligment
+#pragma pack() // BIOS data must use byte alignment
 
 //
 // AMD ACPI Table
diff -puN drivers/gpu/drm/i915/i915_gem_render_state.c~scripts-spellingtxt-add-aligment-pattern-and-fix-typo-instances drivers/gpu/drm/i915/i915_gem_render_state.c
--- a/drivers/gpu/drm/i915/i915_gem_render_state.c~scripts-spellingtxt-add-aligment-pattern-and-fix-typo-instances
+++ a/drivers/gpu/drm/i915/i915_gem_render_state.c
@@ -60,7 +60,7 @@ render_state_get_rodata(const struct int
  * this is sufficient as the null state generator makes the final batch
  * with two passes to build command and state separately. At this point
  * the size of both are known and it compacts them by relocating the state
- * right after the commands taking care of aligment so we should sufficient
+ * right after the commands taking care of alignment so we should sufficient
  * space below them for adding new commands.
  */
 #define OUT_BATCH(batch, i, val)				\
diff -puN drivers/gpu/drm/radeon/atombios.h~scripts-spellingtxt-add-aligment-pattern-and-fix-typo-instances drivers/gpu/drm/radeon/atombios.h
--- a/drivers/gpu/drm/radeon/atombios.h~scripts-spellingtxt-add-aligment-pattern-and-fix-typo-instances
+++ a/drivers/gpu/drm/radeon/atombios.h
@@ -181,7 +181,7 @@
 #define HW_ASSISTED_I2C_STATUS_FAILURE          2
 #define HW_ASSISTED_I2C_STATUS_SUCCESS          1
 
-#pragma pack(1)                                       /* BIOS data must use byte aligment */
+#pragma pack(1)                                       /* BIOS data must use byte alignment */
 
 /*  Define offset to location of ROM header. */
 
@@ -7909,7 +7909,7 @@ typedef struct  _ATOM_POWERPLAY_INFO_V3
 
 /*********************************************************************************/
 
-#pragma pack() // BIOS data must use byte aligment
+#pragma pack() // BIOS data must use byte alignment
 
 //
 // AMD ACPI Table
diff -puN drivers/media/platform/exynos4-is/fimc-core.h~scripts-spellingtxt-add-aligment-pattern-and-fix-typo-instances drivers/media/platform/exynos4-is/fimc-core.h
--- a/drivers/media/platform/exynos4-is/fimc-core.h~scripts-spellingtxt-add-aligment-pattern-and-fix-typo-instances
+++ a/drivers/media/platform/exynos4-is/fimc-core.h
@@ -358,7 +358,7 @@ struct fimc_pix_limit {
  * @pix_limit: pixel size constraints for the scaler
  * @min_inp_pixsize: minimum input pixel size
  * @min_out_pixsize: minimum output pixel size
- * @hor_offs_align: horizontal pixel offset aligment
+ * @hor_offs_align: horizontal pixel offset alignment
  * @min_vsize_align: minimum vertical pixel size alignment
  */
 struct fimc_variant {
diff -puN drivers/net/wireless/ath/ath9k/ani.c~scripts-spellingtxt-add-aligment-pattern-and-fix-typo-instances drivers/net/wireless/ath/ath9k/ani.c
--- a/drivers/net/wireless/ath/ath9k/ani.c~scripts-spellingtxt-add-aligment-pattern-and-fix-typo-instances
+++ a/drivers/net/wireless/ath/ath9k/ani.c
@@ -59,13 +59,13 @@ static const struct ani_ofdm_level_entry
 /*
  * MRC (Maximal Ratio Combining) has always been used with multi-antenna ofdm.
  * With OFDM for single stream you just add up all antenna inputs, you're
- * only interested in what you get after FFT. Signal aligment is also not
+ * only interested in what you get after FFT. Signal alignment is also not
  * required for OFDM because any phase difference adds up in the frequency
  * domain.
  *
  * MRC requires extra work for use with CCK. You need to align the antenna
  * signals from the different antenna before you can add the signals together.
- * You need aligment of signals as CCK is in time domain, so addition can cancel
+ * You need alignment of signals as CCK is in time domain, so addition can cancel
  * your signal completely if phase is 180 degrees (think of adding sine waves).
  * You also need to remove noise before the addition and this is where ANI
  * MRC CCK comes into play. One of the antenna inputs may be stronger but
diff -puN drivers/net/wireless/realtek/rtlwifi/rtl8192se/fw.c~scripts-spellingtxt-add-aligment-pattern-and-fix-typo-instances drivers/net/wireless/realtek/rtlwifi/rtl8192se/fw.c
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/fw.c~scripts-spellingtxt-add-aligment-pattern-and-fix-typo-instances
+++ a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/fw.c
@@ -467,7 +467,7 @@ static u32 _rtl92s_fill_h2c_cmd(struct s
 	u8 i = 0;
 
 	do {
-		/* 8 - Byte aligment */
+		/* 8 - Byte alignment */
 		len = H2C_TX_CMD_HDR_LEN + N_BYTE_ALIGMENT(pcmd_len[i], 8);
 
 		/* Buffer length is not enough */
@@ -516,7 +516,7 @@ static u32 _rtl92s_get_h2c_cmdlen(u32 h2
 	u8 i = 0;
 
 	do {
-		/* 8 - Byte aligment */
+		/* 8 - Byte alignment */
 		len = H2C_TX_CMD_HDR_LEN + N_BYTE_ALIGMENT(pcmd_len[i], 8);
 
 		/* Buffer length is not enough */
diff -puN drivers/scsi/bfa/bfi_ms.h~scripts-spellingtxt-add-aligment-pattern-and-fix-typo-instances drivers/scsi/bfa/bfi_ms.h
--- a/drivers/scsi/bfa/bfi_ms.h~scripts-spellingtxt-add-aligment-pattern-and-fix-typo-instances
+++ a/drivers/scsi/bfa/bfi_ms.h
@@ -680,7 +680,7 @@ struct bfi_ioim_req_s {
 
 	/*
 	 * SG elements array within the IO request must be double word
-	 * aligned. This aligment is required to optimize SGM setup for the IO.
+	 * aligned. This alignment is required to optimize SGM setup for the IO.
 	 */
 	struct bfi_sge_s	sges[BFI_SGE_INLINE_MAX];
 	u8	io_timeout;
diff -puN net/netfilter/x_tables.c~scripts-spellingtxt-add-aligment-pattern-and-fix-typo-instances net/netfilter/x_tables.c
--- a/net/netfilter/x_tables.c~scripts-spellingtxt-add-aligment-pattern-and-fix-typo-instances
+++ a/net/netfilter/x_tables.c
@@ -616,7 +616,7 @@ int xt_compat_check_entry_offsets(const
 	    COMPAT_XT_ALIGN(target_offset + sizeof(struct compat_xt_standard_target)) != next_offset)
 		return -EINVAL;
 
-	/* compat_xt_entry match has less strict aligment requirements,
+	/* compat_xt_entry match has less strict alignment requirements,
 	 * otherwise they are identical.  In case of padding differences
 	 * we need to add compat version of xt_check_entry_match.
 	 */
diff -puN scripts/spelling.txt~scripts-spellingtxt-add-aligment-pattern-and-fix-typo-instances scripts/spelling.txt
--- a/scripts/spelling.txt~scripts-spellingtxt-add-aligment-pattern-and-fix-typo-instances
+++ a/scripts/spelling.txt
@@ -71,6 +71,7 @@ algoritm||algorithm
 algoritms||algorithms
 algorrithm||algorithm
 algorritm||algorithm
+aligment||alignment
 allign||align
 allocatrd||allocated
 allocte||allocate
_

Patches currently in -mm which might be from yamada.masahiro@socionext.com are

scripts-spellingtxt-add-swith-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-swithc-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-an-user-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-an-union-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-an-one-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-partiton-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-aligment-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-algined-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-efective-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-varible-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-embeded-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-againt-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-neded-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-unneded-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-intialization-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-initialiazation-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-intialised-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-comsumer-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overide-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overrided-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-configuartion-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-applys-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-explictely-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-omited-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-disassocation-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-deintialized-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overwritting-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overwriten-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-therfore-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances.patch


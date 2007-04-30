From: akpm@linux-foundation.org
Subject: - blackfin-arch-fix-bug-data-cannot-be-put-into-l1-data.patch removed from -mm tree
Date: Mon, 30 Apr 2007 12:10:52 -0700
Message-ID: <200704301910.l3UJAqmj012460@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40184 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946681AbXD3TK5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 15:10:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bryan.wu@analog.com, aubrey.li@analog.com, jie.zhang@analog.com, mm-commits@vger.kernel.org


The patch titled
     blackfin arch: fix bug data cannot be put into L1 DATA SRAM bank B
has been removed from the -mm tree.  Its filename was
     blackfin-arch-fix-bug-data-cannot-be-put-into-l1-data.patch

This patch was dropped because it was folded into blackfin-arch.patch

------------------------------------------------------
Subject: blackfin arch: fix bug data cannot be put into L1 DATA SRAM bank B
From: "Wu, Bryan" <bryan.wu@analog.com>

Don't allocate Bank B data sram in l1_data_A_sram_alloc ().  Add
l1_data_sram_alloc (), which allocates data sram from either Bank A or Bank B.
 Change all the code which call to l1_data_A_sram_alloc () to use
l1_data_sram_alloc () if appropriate.  Likewise for l1_data_A_sram_free ().

Signed-off-by: Jie Zhang <jie.zhang@analog.com>
Signed-off-by: Aubrey Li <aubrey.li@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/kernel/bfin_ksyms.c  |    2 
 arch/blackfin/kernel/module.c      |    8 +--
 arch/blackfin/kernel/setup.c       |   35 +++++++++-----
 arch/blackfin/mm/blackfin_sram.c   |   64 ++++++++++++++-------------
 include/asm-blackfin/bfin-global.h |    3 -
 5 files changed, 65 insertions(+), 47 deletions(-)

diff -puN arch/blackfin/kernel/bfin_ksyms.c~blackfin-arch-fix-bug-data-cannot-be-put-into-l1-data arch/blackfin/kernel/bfin_ksyms.c
--- a/arch/blackfin/kernel/bfin_ksyms.c~blackfin-arch-fix-bug-data-cannot-be-put-into-l1-data
+++ a/arch/blackfin/kernel/bfin_ksyms.c
@@ -115,3 +115,5 @@ EXPORT_SYMBOL(_ebss_l1);
 EXPORT_SYMBOL(_stext_l1);
 EXPORT_SYMBOL(_etext_l1);
 EXPORT_SYMBOL(_sdata_l1);
+EXPORT_SYMBOL(_ebss_b_l1);
+EXPORT_SYMBOL(_sdata_b_l1);
diff -puN arch/blackfin/kernel/module.c~blackfin-arch-fix-bug-data-cannot-be-put-into-l1-data arch/blackfin/kernel/module.c
--- a/arch/blackfin/kernel/module.c~blackfin-arch-fix-bug-data-cannot-be-put-into-l1-data
+++ a/arch/blackfin/kernel/module.c
@@ -183,7 +183,7 @@ module_frob_arch_sections(Elf_Ehdr * hdr
 			((strcmp(".data", secstrings + s->sh_name)==0) &&
 			 (hdr->e_flags & FLG_DATA_IN_L1) && (s->sh_size > 0))) {
 			mod->arch.data_a_l1 = s;
-			dest = l1_data_A_sram_alloc(s->sh_size);
+			dest = l1_data_sram_alloc(s->sh_size);
 			if (dest == NULL) {
 				printk(KERN_ERR
 					"module %s: L1 data memory allocation failed\n",
@@ -198,7 +198,7 @@ module_frob_arch_sections(Elf_Ehdr * hdr
 			((strcmp(".bss", secstrings + s->sh_name)==0) &&
 			 (hdr->e_flags & FLG_DATA_IN_L1) && (s->sh_size > 0))) {
 			mod->arch.bss_a_l1 = s;
-			dest = l1_data_A_sram_alloc(s->sh_size);
+			dest = l1_data_sram_alloc(s->sh_size);
 			if (dest == NULL) {
 				printk(KERN_ERR
 					"module %s: L1 data memory allocation failed\n",
@@ -419,9 +419,9 @@ void module_arch_cleanup(struct module *
 	if ((mod->arch.text_l1) && (mod->arch.text_l1->sh_addr))
 		l1_inst_sram_free((void*)mod->arch.text_l1->sh_addr);
 	if ((mod->arch.data_a_l1) && (mod->arch.data_a_l1->sh_addr))
-		l1_data_A_sram_free((void*)mod->arch.data_a_l1->sh_addr);
+		l1_data_sram_free((void*)mod->arch.data_a_l1->sh_addr);
 	if ((mod->arch.bss_a_l1) && (mod->arch.bss_a_l1->sh_addr))
-		l1_data_A_sram_free((void*)mod->arch.bss_a_l1->sh_addr);
+		l1_data_sram_free((void*)mod->arch.bss_a_l1->sh_addr);
 	if ((mod->arch.data_b_l1) && (mod->arch.data_b_l1->sh_addr))
 		l1_data_B_sram_free((void*)mod->arch.data_b_l1->sh_addr);
 	if ((mod->arch.bss_b_l1) && (mod->arch.bss_b_l1->sh_addr))
diff -puN arch/blackfin/kernel/setup.c~blackfin-arch-fix-bug-data-cannot-be-put-into-l1-data arch/blackfin/kernel/setup.c
--- a/arch/blackfin/kernel/setup.c~blackfin-arch-fix-bug-data-cannot-be-put-into-l1-data
+++ a/arch/blackfin/kernel/setup.c
@@ -90,25 +90,34 @@ void __init bf53x_cache_init(void)
 
 void bf53x_relocate_l1_mem(void)
 {
-	unsigned long l1_length;
-
-	l1_length = _etext_l1 - _stext_l1;
-	if (l1_length > L1_CODE_LENGTH)
-		l1_length = L1_CODE_LENGTH;
+	unsigned long l1_code_length;
+	unsigned long l1_data_a_length;
+	unsigned long l1_data_b_length;
+
+	l1_code_length = _etext_l1 - _stext_l1;
+	if (l1_code_length > L1_CODE_LENGTH)
+		l1_code_length = L1_CODE_LENGTH;
 	/* cannot complain as printk is not available as yet.
 	 * But we can continue booting and complain later!
 	 */
 
 	/* Copy _stext_l1 to _etext_l1 to L1 instruction SRAM */
-	dma_memcpy(_stext_l1, _l1_lma_start, l1_length);
-
-	l1_length = _ebss_l1 - _sdata_l1;
-	if (l1_length > L1_DATA_A_LENGTH)
-		l1_length = L1_DATA_A_LENGTH;
+	dma_memcpy(_stext_l1, _l1_lma_start, l1_code_length);
 
-	/* Copy _sdata_l1 to _ebss_l1 to L1 instruction SRAM */
-	dma_memcpy(_sdata_l1, _l1_lma_start + (_etext_l1 - _stext_l1),
-		   l1_length);
+	l1_data_a_length = _ebss_l1 - _sdata_l1;
+	if (l1_data_a_length > L1_DATA_A_LENGTH)
+		l1_data_a_length = L1_DATA_A_LENGTH;
+
+	/* Copy _sdata_l1 to _ebss_l1 to L1 data bank A SRAM */
+	dma_memcpy(_sdata_l1, _l1_lma_start + l1_code_length, l1_data_a_length);
+
+	l1_data_b_length = _ebss_b_l1 - _sdata_b_l1;
+	if (l1_data_b_length > L1_DATA_B_LENGTH)
+		l1_data_b_length = L1_DATA_B_LENGTH;
+
+	/* Copy _sdata_b_l1 to _ebss_b_l1 to L1 data bank B SRAM */
+	dma_memcpy(_sdata_b_l1, _l1_lma_start + l1_code_length +
+			l1_data_a_length, l1_data_b_length);
 
 }
 
diff -puN arch/blackfin/mm/blackfin_sram.c~blackfin-arch-fix-bug-data-cannot-be-put-into-l1-data arch/blackfin/mm/blackfin_sram.c
--- a/arch/blackfin/mm/blackfin_sram.c~blackfin-arch-fix-bug-data-cannot-be-put-into-l1-data
+++ a/arch/blackfin/mm/blackfin_sram.c
@@ -283,12 +283,6 @@ void *l1_data_A_sram_alloc(size_t size)
 	addr = _l1_sram_alloc(size, l1_data_A_sram, ARRAY_SIZE(l1_data_A_sram));
 #endif
 
-#if L1_DATA_B_LENGTH != 0
-	if (!addr)
-		addr = _l1_sram_alloc(size, l1_data_B_sram,
-				   ARRAY_SIZE(l1_data_B_sram));
-#endif
-
 	/* add mutex operation */
 	spin_unlock_irqrestore(&l1_data_sram_lock, flags);
 
@@ -307,17 +301,11 @@ int l1_data_A_sram_free(const void *addr
 	/* add mutex operation */
 	spin_lock_irqsave(&l1_data_sram_lock, flags);
 
-#if L1_DATA_B_LENGTH != 0
-	if (L1_DATA_B_START == ((unsigned long)addr & ~0x0000FFFF))
-		ret = _l1_sram_free(addr,
-				   l1_data_B_sram, ARRAY_SIZE(l1_data_B_sram));
-	else
-#endif
 #if L1_DATA_A_LENGTH != 0
-		ret = _l1_sram_free(addr,
-				   l1_data_A_sram, ARRAY_SIZE(l1_data_A_sram));
+	ret = _l1_sram_free(addr,
+			   l1_data_A_sram, ARRAY_SIZE(l1_data_A_sram));
 #else
-		ret = -1;
+	ret = -1;
 #endif
 
 	/* add mutex operation */
@@ -327,20 +315,6 @@ int l1_data_A_sram_free(const void *addr
 }
 EXPORT_SYMBOL(l1_data_A_sram_free);
 
-void *l1_data_sram_zalloc(size_t size)
-{
-	void *addr = l1_data_A_sram_alloc(size);
-	memset(addr, 0x00, size);
-	return addr;
-}
-EXPORT_SYMBOL(l1_data_sram_zalloc);
-
-int l1_data_sram_free(const void *addr)
-{
-	return l1_data_A_sram_free(addr);
-}
-EXPORT_SYMBOL(l1_data_sram_free);
-
 void *l1_data_B_sram_alloc(size_t size)
 {
 #if L1_DATA_B_LENGTH != 0
@@ -386,6 +360,38 @@ int l1_data_B_sram_free(const void *addr
 }
 EXPORT_SYMBOL(l1_data_B_sram_free);
 
+void *l1_data_sram_alloc(size_t size)
+{
+	void *addr = l1_data_A_sram_alloc(size);
+
+	if (!addr)
+		addr = l1_data_B_sram_alloc(size);
+
+	return addr;
+}
+EXPORT_SYMBOL(l1_data_sram_alloc);
+
+void *l1_data_sram_zalloc(size_t size)
+{
+	void *addr = l1_data_sram_alloc(size);
+
+	if (addr)
+		memset(addr, 0x00, size);
+
+	return addr;
+}
+EXPORT_SYMBOL(l1_data_sram_zalloc);
+
+int l1_data_sram_free(const void *addr)
+{
+	int ret;
+	ret = l1_data_A_sram_free(addr);
+	if (ret == -1)
+		ret = l1_data_B_sram_free(addr);
+	return ret;
+}
+EXPORT_SYMBOL(l1_data_sram_free);
+
 void *l1_inst_sram_alloc(size_t size)
 {
 #if L1_DATA_A_LENGTH != 0
diff -puN include/asm-blackfin/bfin-global.h~blackfin-arch-fix-bug-data-cannot-be-put-into-l1-data include/asm-blackfin/bfin-global.h
--- a/include/asm-blackfin/bfin-global.h~blackfin-arch-fix-bug-data-cannot-be-put-into-l1-data
+++ a/include/asm-blackfin/bfin-global.h
@@ -70,6 +70,7 @@ extern void bfin_gpio_interrupt_setup(in
 extern void *l1_data_A_sram_alloc(size_t);
 extern void *l1_data_B_sram_alloc(size_t);
 extern void *l1_inst_sram_alloc(size_t);
+extern void *l1_data_sram_alloc(size_t);
 extern void *l1_data_sram_zalloc(size_t);
 extern int l1_data_A_sram_free(const void*);
 extern int l1_data_B_sram_free(const void*);
@@ -108,7 +109,7 @@ extern char _start;
 extern unsigned long _ramstart, _ramend, _rambase;
 extern unsigned long memory_start, memory_end, physical_mem_end;
 extern char _stext_l1[], _etext_l1[], _sdata_l1[], _edata_l1[], _sbss_l1[],
-    _ebss_l1[], _l1_lma_start[];
+    _ebss_l1[], _l1_lma_start[], _sdata_b_l1[], _ebss_b_l1[];
 
 #ifdef CONFIG_MTD_UCLINUX
 extern unsigned long memory_mtd_start, memory_mtd_end, mtd_size;
_

Patches currently in -mm which might be from bryan.wu@analog.com are

origin.patch
blackfin-Documentation.patch
blackfin-arch.patch
blackfin-arch-fix-bug-data-cannot-be-put-into-l1-data.patch
blackfin-arch-source-kernel-preemption-option.patch
blackfin-arch-workaround-bf561-anomaly-05000266.patch
blackfin-arch-define-a-new-cacheline_aligned-attribute-to-put-it-in-l1-data-memory-with-linkscript-update.patch
blackfin-arch-fix-bug-asserting-gpio-requested-doesnt-make-sense-with-gpio-whole-port-accesses.patch
blackfin-arch-04-and-05-silicon-doesnt-exist-for-bf534-bf536-adn-bf537-so-dont-let-people-select-the-option.patch
blackfin-arch-fix-coding-style-in-ints-priority-sc-c-file.patch
blackfin-arch-fix-bug-refuse-to-boot-if-rootfs-image-is-not-attached-when-mtd_uclinux-is-selected.patch
blackfin-arch-move-revid-function-into-global-headers-as-inline-functions.patch
blackfin-arch-need-linux-ttyh-header-for-console_init-prototype.patch
blackfin-arch-convert-most-blackfin-specific-spi-register-settings-to-common-spi-framework-settings.patch
driver_bfin_serial_core.patch
driver_bfin_serial_core-update.patch
blackfin-on-chip-ethernet-mac-controller-driver.patch
blackfin-on-chip-ethernet-mac-controller-driver-update.patch
blackfin-patch-add-blackfin-support-in-smc91x.patch
blackfin-on-chip-rtc-controller-driver.patch
blackfin-on-chip-rtc-controller-driver-fix-rtc_update_irq-augument.patch
blackfin-blackfin-on-chip-spi-controller-driver.patch
blackfin-blackfin-on-chip-spi-controller-driver-cleanup-and-coding-style-fixing.patch
blackfin-blackfin-on-chip-spi-controller-driver-fix-reboot-kernel-mounting-spi-flash-print-error-bug.patch
blackfin-spi-controller-driver-update-according-to-david-brownells-review.patch
blackfin-serial-core-driver-uart1-should-depend-on-bf534-bf536-bf537-remove-experimental-marking-from-on-chip-serial-core-driver-and-make-options-less-wordy.patch
move-die-notifier-handling-to-common-code-fix.patch
revoke-core-code-revoke-no-revoke-for-nommu.patch
revoke-core-code-generic_file_revoke-stub-for-nommu.patch
vdso-print-fatal-signals-fix-compiling-error-bug-in.patch

Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E203EC7EE23
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jun 2023 21:49:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233207AbjFAVtS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Jun 2023 17:49:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233171AbjFAVsz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jun 2023 17:48:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B052E45
        for <mm-commits@vger.kernel.org>; Thu,  1 Jun 2023 14:48:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 046FF64A2B
        for <mm-commits@vger.kernel.org>; Thu,  1 Jun 2023 21:48:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55DFAC433EF;
        Thu,  1 Jun 2023 21:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685656121;
        bh=0pxXKZ9erDJzFsIPE0/9ho4aHFKxH41aKTEgXp1eEk8=;
        h=Date:To:From:Subject:From;
        b=BctpCAyKhbljE0Puzl48fUAjdWuvQH3t1mC1ziQ/npL09qTH8E4Dazhc3Er28KLv5
         15GzIczPXQjhZUyb9/jJEDGAdLvGpiMilXBeaYo6qp1atpd/hSV4dq4MvkOobzvLQr
         cQAG8tH1fLKkJSURl7T61/196KVuzv3M6beCuxwY=
Date:   Thu, 01 Jun 2023 14:48:40 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        tim.gardner@canonical.com, thomas.lendacky@amd.com,
        tglx@linutronix.de, seanjc@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, rppt@linux.ibm.com,
        rientjes@google.com, peterz@infradead.org, peterx@redhat.com,
        pbonzini@redhat.com, mingo@redhat.com, mgorman@techsingularity.net,
        marcelo.cerri@canonical.com, luto@kernel.org,
        liam.merwick@oracle.com, jroedel@suse.de, dfaggioli@suse.com,
        david@redhat.com, dave.hansen@linux.intel.com,
        dave.hansen@intel.com, bp@suse.de, bp@alien8.de, ardb@kernel.org,
        ak@linux.intel.com, aarcange@redhat.com,
        kirill.shutemov@linux.intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-boot-compressed-handle-unaccepted-memory.patch added to mm-unstable branch
Message-Id: <20230601214841.55DFAC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86/boot/compressed: handle unaccepted memory
has been added to the -mm mm-unstable branch.  Its filename is
     x86-boot-compressed-handle-unaccepted-memory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-boot-compressed-handle-unaccepted-memory.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: x86/boot/compressed: handle unaccepted memory
Date: Thu, 1 Jun 2023 21:25:38 +0300

The firmware will pre-accept the memory used to run the stub.  But, the
stub is responsible for accepting the memory into which it decompresses
the main kernel.  Accept memory just before decompression starts.

The stub is also responsible for choosing a physical address in which to
place the decompressed kernel image.  The KASLR mechanism will randomize
this physical address.  Since the accepted memory region is relatively
small, KASLR would be quite ineffective if it only used the pre-accepted
area (EFI_CONVENTIONAL_MEMORY).  Ensure that KASLR randomizes among the
entire physical address space by also including EFI_UNACCEPTED_MEMORY.

Link: https://lkml.kernel.org/r/20230601182543.19036-5-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Liam Merwick <liam.merwick@oracle.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Borislav Petkov <bp@suse.de>
Cc: Dario Faggioli <dfaggioli@suse.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Cc: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tim Gardner <tim.gardner@canonical.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/boot/compressed/efi.h   |   10 ++++++++
 arch/x86/boot/compressed/kaslr.c |   35 +++++++++++++++++++----------
 arch/x86/boot/compressed/mem.c   |   31 +++++++++++++++++++++++++
 arch/x86/boot/compressed/misc.c  |    7 +++++
 arch/x86/boot/compressed/misc.h  |    6 ++++
 5 files changed, 77 insertions(+), 12 deletions(-)

--- a/arch/x86/boot/compressed/efi.h~x86-boot-compressed-handle-unaccepted-memory
+++ a/arch/x86/boot/compressed/efi.h
@@ -16,6 +16,7 @@ typedef guid_t efi_guid_t __aligned(__al
 #define ACPI_TABLE_GUID				EFI_GUID(0xeb9d2d30, 0x2d88, 0x11d3,  0x9a, 0x16, 0x00, 0x90, 0x27, 0x3f, 0xc1, 0x4d)
 #define ACPI_20_TABLE_GUID			EFI_GUID(0x8868e871, 0xe4f1, 0x11d3,  0xbc, 0x22, 0x00, 0x80, 0xc7, 0x3c, 0x88, 0x81)
 #define EFI_CC_BLOB_GUID			EFI_GUID(0x067b1f5f, 0xcf26, 0x44c5, 0x85, 0x54, 0x93, 0xd7, 0x77, 0x91, 0x2d, 0x42)
+#define LINUX_EFI_UNACCEPTED_MEM_TABLE_GUID	EFI_GUID(0xd5d1de3c, 0x105c, 0x44f9,  0x9e, 0xa9, 0xbc, 0xef, 0x98, 0x12, 0x00, 0x31)
 
 #define EFI32_LOADER_SIGNATURE	"EL32"
 #define EFI64_LOADER_SIGNATURE	"EL64"
@@ -32,6 +33,7 @@ typedef	struct {
 } efi_table_hdr_t;
 
 #define EFI_CONVENTIONAL_MEMORY		 7
+#define EFI_UNACCEPTED_MEMORY		15
 
 #define EFI_MEMORY_MORE_RELIABLE \
 				((u64)0x0000000000010000ULL)	/* higher reliability */
@@ -104,6 +106,14 @@ struct efi_setup_data {
 	u64 reserved[8];
 };
 
+struct efi_unaccepted_memory {
+	u32 version;
+	u32 unit_size;
+	u64 phys_base;
+	u64 size;
+	unsigned long bitmap[];
+};
+
 static inline int efi_guidcmp (efi_guid_t left, efi_guid_t right)
 {
 	return memcmp(&left, &right, sizeof (efi_guid_t));
--- a/arch/x86/boot/compressed/kaslr.c~x86-boot-compressed-handle-unaccepted-memory
+++ a/arch/x86/boot/compressed/kaslr.c
@@ -672,6 +672,28 @@ static bool process_mem_region(struct me
 }
 
 #ifdef CONFIG_EFI
+
+/*
+ * Only EFI_CONVENTIONAL_MEMORY and EFI_UNACCEPTED_MEMORY (if supported) are
+ * guaranteed to be free.
+ *
+ * It is more conservative in picking free memory than the EFI spec allows:
+ *
+ * According to the spec, EFI_BOOT_SERVICES_{CODE|DATA} are also free memory
+ * and thus available to place the kernel image into, but in practice there's
+ * firmware where using that memory leads to crashes.
+ */
+static inline bool memory_type_is_free(efi_memory_desc_t *md)
+{
+	if (md->type == EFI_CONVENTIONAL_MEMORY)
+		return true;
+
+	if (md->type == EFI_UNACCEPTED_MEMORY)
+		return IS_ENABLED(CONFIG_UNACCEPTED_MEMORY);
+
+	return false;
+}
+
 /*
  * Returns true if we processed the EFI memmap, which we prefer over the E820
  * table if it is available.
@@ -716,18 +738,7 @@ process_efi_entries(unsigned long minimu
 	for (i = 0; i < nr_desc; i++) {
 		md = efi_early_memdesc_ptr(pmap, e->efi_memdesc_size, i);
 
-		/*
-		 * Here we are more conservative in picking free memory than
-		 * the EFI spec allows:
-		 *
-		 * According to the spec, EFI_BOOT_SERVICES_{CODE|DATA} are also
-		 * free memory and thus available to place the kernel image into,
-		 * but in practice there's firmware where using that memory leads
-		 * to crashes.
-		 *
-		 * Only EFI_CONVENTIONAL_MEMORY is guaranteed to be free.
-		 */
-		if (md->type != EFI_CONVENTIONAL_MEMORY)
+		if (!memory_type_is_free(md))
 			continue;
 
 		if (efi_soft_reserve_enabled() &&
--- a/arch/x86/boot/compressed/mem.c~x86-boot-compressed-handle-unaccepted-memory
+++ a/arch/x86/boot/compressed/mem.c
@@ -1,9 +1,40 @@
 // SPDX-License-Identifier: GPL-2.0-only
 
 #include "error.h"
+#include "misc.h"
 
 void arch_accept_memory(phys_addr_t start, phys_addr_t end)
 {
 	/* Platform-specific memory-acceptance call goes here */
 	error("Cannot accept memory");
 }
+
+void init_unaccepted_memory(void)
+{
+	guid_t guid =  LINUX_EFI_UNACCEPTED_MEM_TABLE_GUID;
+	struct efi_unaccepted_memory *unaccepted_table;
+	unsigned long cfg_table_pa;
+	unsigned int cfg_table_len;
+	enum efi_type et;
+	int ret;
+
+	et = efi_get_type(boot_params);
+	if (et == EFI_TYPE_NONE)
+		return;
+
+	ret = efi_get_conf_table(boot_params, &cfg_table_pa, &cfg_table_len);
+	if (ret)
+		error("EFI config table not found.");
+
+	unaccepted_table = (void *)efi_find_vendor_table(boot_params,
+							 cfg_table_pa,
+							 cfg_table_len,
+							 guid);
+	if (!unaccepted_table)
+		return;
+
+	if (unaccepted_table->version != 1)
+		error("Unknown version of unaccepted memory table\n");
+
+	set_unaccepted_table(unaccepted_table);
+}
--- a/arch/x86/boot/compressed/misc.c~x86-boot-compressed-handle-unaccepted-memory
+++ a/arch/x86/boot/compressed/misc.c
@@ -455,6 +455,13 @@ asmlinkage __visible void *extract_kerne
 #endif
 
 	debug_putstr("\nDecompressing Linux... ");
+
+	if (IS_ENABLED(CONFIG_UNACCEPTED_MEMORY)) {
+		debug_putstr("Accepting memory... ");
+		init_unaccepted_memory();
+		accept_memory(__pa(output), __pa(output) + needed_size);
+	}
+
 	__decompress(input_data, input_len, NULL, NULL, output, output_len,
 			NULL, error);
 	entry_offset = parse_elf(output);
--- a/arch/x86/boot/compressed/misc.h~x86-boot-compressed-handle-unaccepted-memory
+++ a/arch/x86/boot/compressed/misc.h
@@ -247,4 +247,10 @@ static inline unsigned long efi_find_ven
 }
 #endif /* CONFIG_EFI */
 
+void init_unaccepted_memory(void);
+
+/* Implemented in EFI stub */
+void set_unaccepted_table(struct efi_unaccepted_memory *table);
+void accept_memory(phys_addr_t start, phys_addr_t end);
+
 #endif /* BOOT_COMPRESSED_MISC_H */
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-add-support-for-unaccepted-memory.patch
efi-x86-get-full-memory-map-in-allocate_e820.patch
efi-libstub-implement-support-for-unaccepted-memory.patch
x86-boot-compressed-handle-unaccepted-memory.patch
efi-add-unaccepted-memory-support.patch
efi-unaccepted-avoid-load_unaligned_zeropad-stepping-into-unaccepted-memory.patch
x86-tdx-make-_tdx_hypercall-and-__tdx_module_call-available-in-boot-stub.patch
x86-tdx-refactor-try_accept_one.patch
x86-tdx-add-unaccepted-memory-support.patch


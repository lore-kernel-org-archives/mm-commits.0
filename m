From: akpm@linux-foundation.org
Subject: + arm64-support-initrd-outside-kernel-linear-map.patch added to
 -mm tree
Date: Fri, 07 Aug 2015 15:19:50 -0700
Message-ID: <55c52f06.jh0OrC3XoQvrTkgL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46865 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946302AbbHGWTw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Aug 2015 18:19:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: msalter@redhat.com, ard.biesheuvel@linaro.org, arnd@arndb.de, catalin.marinas@arm.com, hpa@zytor.com, mark.rutland@arm.com, mingo@elte.hu, rmk@arm.linux.org.uk, tglx@linutronix.de, will.deacon@arm.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: support initrd outside kernel linear map
has been added to the -mm tree.  Its filename is
     arm64-support-initrd-outside-kernel-linear-map.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm64-support-initrd-outside-kernel-linear-map.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm64-support-initrd-outside-kernel-linear-map.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mark Salter <msalter@redhat.com>
Subject: arm64: support initrd outside kernel linear map

The use of mem= could leave part or all of the initrd outside of the
kernel linear map.  This will lead to an error when unpacking the initrd
and a probable failure to boot.  This patch catches that situation and
relocates the initrd to be fully within the linear map.

Signed-off-by: Mark Salter <msalter@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/kernel/setup.c |   55 ++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff -puN arch/arm64/kernel/setup.c~arm64-support-initrd-outside-kernel-linear-map arch/arm64/kernel/setup.c
--- a/arch/arm64/kernel/setup.c~arm64-support-initrd-outside-kernel-linear-map
+++ a/arch/arm64/kernel/setup.c
@@ -359,6 +359,60 @@ static void __init request_standard_reso
 	}
 }
 
+/*
+ * Relocate initrd if it is not completely within the linear mapping.
+ * This would be the case if mem= cuts out all or part of it.
+ */
+static void __init relocate_initrd(void)
+{
+#ifdef CONFIG_BLK_DEV_INITRD
+	phys_addr_t orig_start = __virt_to_phys(initrd_start);
+	phys_addr_t orig_end = __virt_to_phys(initrd_end);
+	phys_addr_t ram_end = memblock_end_of_DRAM();
+	phys_addr_t new_start;
+	unsigned long size, to_free = 0;
+	void *dest;
+
+	if (orig_end <= ram_end)
+		return;
+
+	/* Note if any of original initrd will freeing below */
+	if (orig_start < ram_end)
+		to_free = ram_end - orig_start;
+
+	size = orig_end - orig_start;
+
+	/* initrd needs to be relocated completely inside linear mapping */
+	new_start = memblock_find_in_range(0, PFN_PHYS(max_pfn),
+					   size, PAGE_SIZE);
+	if (!new_start)
+		panic("Cannot relocate initrd of size %ld\n", size);
+	memblock_reserve(new_start, size);
+
+	initrd_start = __phys_to_virt(new_start);
+	initrd_end   = initrd_start + size;
+
+	pr_info("Moving initrd from [%llx-%llx] to [%llx-%llx]\n",
+		orig_start, orig_start + size - 1,
+		new_start, new_start + size - 1);
+
+	dest = (void *)initrd_start;
+
+	if (to_free) {
+		memcpy(dest, (void *)__phys_to_virt(orig_start), to_free);
+		dest += to_free;
+	}
+
+	copy_from_early_mem(dest, orig_start + to_free, size - to_free);
+
+	if (to_free) {
+		pr_info("Freeing original RAMDISK from [%llx-%llx]\n",
+			orig_start, orig_start + to_free - 1);
+		memblock_free(orig_start, to_free);
+	}
+#endif
+}
+
 u64 __cpu_logical_map[NR_CPUS] = { [0 ... NR_CPUS-1] = INVALID_HWID };
 
 void __init setup_arch(char **cmdline_p)
@@ -392,6 +446,7 @@ void __init setup_arch(char **cmdline_p)
 	acpi_boot_table_init();
 
 	paging_init();
+	relocate_initrd();
 	request_standard_resources();
 
 	early_ioremap_reset();
_

Patches currently in -mm which might be from msalter@redhat.com are

mm-add-utility-for-early-copy-from-unmapped-ram.patch
arm64-support-initrd-outside-kernel-linear-map.patch
x86-use-generic-early-mem-copy.patch
linux-next.patch
mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff-fix.patch


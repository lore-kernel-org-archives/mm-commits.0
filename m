From: akpm@linux-foundation.org
Subject: - acpi-acpi_numa_init-build-fix.patch removed from -mm tree
Date: Wed, 14 May 2008 12:38:41 -0700
Message-ID: <200805141949.m4EJnk1h017745@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59824 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763717AbYENTuK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 May 2008 15:50:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     acpi: acpi_numa_init() build fix
has been removed from the -mm tree.  Its filename was
     acpi-acpi_numa_init-build-fix.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: acpi_numa_init() build fix
From: Ingo Molnar <mingo@elte.hu>

x86.git testing found the following build error on latest -git:

 drivers/acpi/numa.c: In function 'acpi_numa_init':
 drivers/acpi/numa.c:226: error: 'NR_NODE_MEMBLKS' undeclared (first use in this function)
 drivers/acpi/numa.c:226: error: (Each undeclared identifier is reported only once
 drivers/acpi/numa.c:226: error: for each function it appears in.)

with this config:

 http://redhat.com/~mingo/misc/config-Wed_Apr_30_22_42_42_CEST_2008.bad

i suspect we dont want SRAT parsing when CONFIG_HAVE_ARCH_PARSE_SRAT
is unset - but the fix looks a bit ugly. Perhaps we should define
NR_NODE_MEMBLKS even in this case and just let the code fall back
to some sane behavior?

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/numa.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/acpi/numa.c~acpi-acpi_numa_init-build-fix drivers/acpi/numa.c
--- a/drivers/acpi/numa.c~acpi-acpi_numa_init-build-fix
+++ a/drivers/acpi/numa.c
@@ -176,6 +176,7 @@ acpi_parse_processor_affinity(struct acp
 	return 0;
 }
 
+#ifdef CONFIG_HAVE_ARCH_PARSE_SRAT
 static int __init
 acpi_parse_memory_affinity(struct acpi_subtable_header * header,
 			   const unsigned long end)
@@ -193,6 +194,7 @@ acpi_parse_memory_affinity(struct acpi_s
 
 	return 0;
 }
+#endif
 
 static int __init acpi_parse_srat(struct acpi_table_header *table)
 {
@@ -221,9 +223,11 @@ int __init acpi_numa_init(void)
 	if (!acpi_table_parse(ACPI_SIG_SRAT, acpi_parse_srat)) {
 		acpi_table_parse_srat(ACPI_SRAT_TYPE_CPU_AFFINITY,
 				      acpi_parse_processor_affinity, NR_CPUS);
+#ifdef CONFIG_HAVE_ARCH_PARSE_SRAT
 		acpi_table_parse_srat(ACPI_SRAT_TYPE_MEMORY_AFFINITY,
 				      acpi_parse_memory_affinity,
 				      NR_NODE_MEMBLKS);
+#endif
 	}
 
 	/* SLIT: System Locality Information Table */
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
linux-next.patch
acpi-acpi_numa_init-build-fix.patch
acpi-fix-drivers-acpi-gluec-build-error.patch
git-x86-fixup.patch
kgdb-use-put_unaligned_be32-helper.patch
arch-x86-mm-patc-use-boot_cpu_has.patch
x86-setup_force_cpu_cap-dont-do-clear_bitnon-unsigned-long.patch
lguest-use-cpu-capability-accessors.patch
x86-set_restore_sigmask-avoid-bitop-on-a-u32.patch
x86-early_init_centaur-use-set_cpu_cap.patch
x86-bitops-take-an-unsigned-long.patch
x86-use-explicit-copy-in-vdso_gettimeofday.patch
mutex-debug-check-mutex-magic-before-owner.patch
show_schedstat-fix-memleak.patch
git-block.patch
aes-x86_64-asm-implementation-optimization.patch
cgroups-fix-compile-warning.patch
lib-create-common-ascii-hex-array.patch
mprotect-prevent-alteration-of-the-pat-bits.patch
mm-add-a-basic-debugging-framework-for-memory-initialisation.patch
mm-add-a-basic-debugging-framework-for-memory-initialisation-fix.patch
mm-verify-the-page-links-and-memory-model.patch
mm-make-defensive-checks-around-pfn-values-registered-for-memory-usage.patch
mm-print-out-the-zonelists-on-request-for-manual-verification.patch
mm-move-bootmem-descriptors-definition-to-a-single-place.patch
mm-fix-free_all_bootmem_core-alignment-check.patch
mm-normalize-internal-argument-passing-of-bootmem-data.patch
mm-unexport-__alloc_bootmem_core.patch
accounting-account-for-user-time-when-updating-memory-integrals.patch
split-the-typecheck-macros-out-of-include-linux-kernelh.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-fix.patch
introduce-have_efficient_unaligned_access-kconfig-symbol.patch
rtc-remove-and-clarify-unneeded-externs.patch
kgdb-use-the-common-ascii-hex-helpers.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch


From: akpm@linux-foundation.org
Subject: - acpi-fix-a-cast-of-a-32-bit-int-to-a-pointer.patch removed from -mm tree
Date: Fri, 18 Jul 2008 16:24:03 -0700
Message-ID: <200807182324.m6INO3QL004163@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35226 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757231AbYGRXY5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jul 2008 19:24:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, andi@firstfloor.org, len.brown@intel.com, ming.m.lin@intel.com, robert.moore@intel.com, mm-commits@vger.kernel.org


The patch titled
     acpi: fix a cast of a 32-bit int to a pointer
has been removed from the -mm tree.  Its filename was
     acpi-fix-a-cast-of-a-32-bit-int-to-a-pointer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: fix a cast of a 32-bit int to a pointer
From: David Howells <dhowells@redhat.com>

Fix a cast of a 32-bit int to a pointer in ACPI to avoid a compiler warning.

This problem was introduced by the following patch:

	commit 1f3ee987b56d6354cdbbe8faa90079886a464b9c
	Author: Bob Moore <robert.moore@intel.com>
	Date:   Tue Jun 10 13:42:13 2008 +0800

	    ACPICA: Eliminate acpi_native_uint type

	    No longer needed; replaced mostly with u32, but also acpi_size
	    where a type that changes 32/64 bit on 32/64-bit platforms is
	    required.

	    Signed-off-by: Bob Moore <robert.moore@intel.com>
	    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
	    Signed-off-by: Len Brown <len.brown@intel.com>

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Bob Moore <robert.moore@intel.com>
Cc: Lin Ming <ming.m.lin@intel.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/executer/exconfig.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/acpi/executer/exconfig.c~acpi-fix-a-cast-of-a-32-bit-int-to-a-pointer drivers/acpi/executer/exconfig.c
--- a/drivers/acpi/executer/exconfig.c~acpi-fix-a-cast-of-a-32-bit-int-to-a-pointer
+++ a/drivers/acpi/executer/exconfig.c
@@ -96,7 +96,8 @@ acpi_ex_add_table(u32 table_index,
 
 	/* Install the new table into the local data structures */
 
-	obj_desc->reference.object = ACPI_CAST_PTR(void, table_index);
+	obj_desc->reference.object =
+		ACPI_CAST_PTR(void, (unsigned long) table_index);
 
 	/* Add the table to the namespace */
 
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
linux-next.patch
calgary-fix-a-comparison-warning-the-pci-calgary-64-driver.patch
cifs-fix-range-check.patch
sis-drm-fix-the-memory-allocator-if-the-sis-fb-is-built-as-a-module.patch
sis-drm-fix-a-pointer-cast-warning.patch
netfilter-fix-xt_times-time_mts-use-of-do_div.patch
atm-fix-const-assignment-discard-warnings-in-the-atm-networking-driver.patch
atm-fix-direct-casts-of-pointers-to-u32-in-the-interphase-driver.patch
hysdn-remove-the-packed-attribute-from-poftimstamp_tag.patch
sched-fix-inc_rt_tasks-to-not-declare-variable-rq-if-its-not-needed.patch
git-unionfs.patch
clocksource-fix-a-print-format-error-in-the-acpi-pm-clocksource-driver-and-check-range.patch
pm-fix-try_to_freeze_taskss-use-of-do_div.patch
mn10300-move-sg_dma_addresslen-to-asm-scatterlisth.patch
inflate-refactor-inflate-malloc-code.patch
inflate-refactor-inflate-malloc-code-checkpatch-fixes.patch
pnpacpi-fix-pnpacpi_parse_irq_options-test-against-pnp_irq_nr.patch
pnp-fix-the-fcpnp_driver-declaration-to-only-exist-if-config_pnp=y.patch
include-asm-ptraceh-userspace-headers-cleanup.patch
coredump-elf_fdpic_core_dump-use-core_state-dumper-list.patch
coredump-binfmt_elf_fdpic-dont-use-sub-threads-mm.patch
coredump-exit_mm-clear-mm-first-then-play-with-core_state.patch
coredump-exit_mm-clear-mm-first-then-play-with-core_state-checkpatch-fixes.patch
ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch
tsacct-fix-bacct_add_tsks-use-of-do_div.patch
frv-use-the-common-ascii-hex-helpers.patch
mn10300-use-the-common-ascii-hex-helpers.patch
mutex-subsystem-synchro-test-module.patch


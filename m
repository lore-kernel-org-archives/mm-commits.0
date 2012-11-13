From: akpm@linux-foundation.org
Subject: + mm-export-a-function-to-get-vm-committed-memory-fix.patch added to -mm tree
Date: Tue, 13 Nov 2012 11:41:46 -0800
Message-ID: <20121113194147.859FC20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:50073 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329Ab2KMTlu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Nov 2012 14:41:50 -0500
Received: by mail-lb0-f202.google.com with SMTP id i15so107695lbo.1
        for <mm-commits@vger.kernel.org>; Tue, 13 Nov 2012 11:41:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, kys@microsoft.com


The patch titled
     Subject: mm-export-a-function-to-get-vm-committed-memory-fix
has been added to the -mm tree.  Its filename is
     mm-export-a-function-to-get-vm-committed-memory-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-export-a-function-to-get-vm-committed-memory-fix

coding-style tweak

Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c  |    1 -
 mm/nommu.c |    1 -
 2 files changed, 2 deletions(-)

diff -puN mm/mmap.c~mm-export-a-function-to-get-vm-committed-memory-fix mm/mmap.c
--- a/mm/mmap.c~mm-export-a-function-to-get-vm-committed-memory-fix
+++ a/mm/mmap.c
@@ -97,7 +97,6 @@ struct percpu_counter vm_committed_as __
  * Several metrics drive this policy engine including the guest reported
  * memory commitment.
  */
-
 unsigned long vm_memory_committed(void)
 {
 	return percpu_counter_read_positive(&vm_committed_as);
diff -puN mm/nommu.c~mm-export-a-function-to-get-vm-committed-memory-fix mm/nommu.c
--- a/mm/nommu.c~mm-export-a-function-to-get-vm-committed-memory-fix
+++ a/mm/nommu.c
@@ -74,7 +74,6 @@ atomic_long_t mmap_pages_allocated;
  * Several metrics drive this policy engine including the guest reported
  * memory commitment.
  */
-
 unsigned long vm_memory_committed(void)
 {
 	return percpu_counter_read_positive(&vm_committed_as);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
irq-tsk-comm-is-an-array.patch
drivers-tty-serial-serial_corec-fix-uart_get_attr_port-shift.patch
mm.patch
mm-introduce-mm_find_pmd-fix.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
mmvmscan-only-evict-file-pages-when-we-have-plenty-fix.patch
slub-slub-specific-propagation-changes-fix.patch
dmapool-make-dmapool_debug-detect-corruption-of-free-marker-fix.patch
mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix.patch
mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix.patch
mm-check-rb_subtree_gap-correctness-fix.patch
mm-rearrange-vm_area_struct-for-fewer-cache-misses-checkpatch-fixes.patch
mm-vm_unmapped_area-lookup-function-checkpatch-fixes.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-i386-architecture-fix.patch
mm-use-vm_unmapped_area-on-mips-architecture-fix.patch
mm-use-vm_unmapped_area-on-arm-architecture-fix.patch
mm-use-vm_unmapped_area-on-sh-architecture-fix.patch
mm-use-vm_unmapped_area-on-sparc64-architecture-fix.patch
mm-adjust-address_space_operationsmigratepage-return-code-fix.patch
mm-introduce-a-common-interface-for-balloon-pages-mobility-fix.patch
virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix-fix.patch
bootmem-fix-wrong-call-parameter-for-free_bootmem-fix.patch
mm-export-a-function-to-get-vm-committed-memory-fix.patch
drop_caches-add-some-documentation-and-info-messsge-checkpatch-fixes.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
binfmt_elf-fix-corner-case-kfree-of-uninitialized-data-checkpatch-fixes.patch
rtc-avoid-calling-platform_device_put-twice-in-test_init-fix.patch
hfsplus-add-support-of-manipulation-by-attributes-file-checkpatch-fixes.patch
procfs-add-vmflags-field-in-smaps-output-v4.patch
procfs-add-vmflags-field-in-smaps-output-v4-fix.patch
procfs-add-ability-to-plug-in-auxiliary-fdinfo-providers-fix.patch
ipc-add-sysctl-to-specify-desired-next-object-id-checkpatch-fixes.patch
ipc-message-queue-receive-cleanup-checkpatch-fixes.patch
ipc-convert-prepare_copy-from-macro-to-function-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


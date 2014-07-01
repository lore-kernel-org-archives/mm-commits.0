From: akpm@linux-foundation.org
Subject: + kexec-support-kexec-kdump-on-efi-systems-fix.patch added to -mm tree
Date: Tue, 01 Jul 2014 13:14:25 -0700
Message-ID: <53b316a1.dlsfHHagfpNHBd0T%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:41868 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758761AbaGAUO0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2014 16:14:26 -0400
Received: by mail-ob0-f202.google.com with SMTP id va2so2334551obc.5
        for <mm-commits@vger.kernel.org>; Tue, 01 Jul 2014 13:14:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, matt@console-pimps.org, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec-support-kexec-kdump-on-efi-systems-fix
has been added to the -mm tree.  Its filename is
     kexec-support-kexec-kdump-on-efi-systems-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kexec-support-kexec-kdump-on-efi-systems-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kexec-support-kexec-kdump-on-efi-systems-fix.patch

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
Subject: kexec-support-kexec-kdump-on-efi-systems-fix

s/get_efi/efi_get/g, per Matt

Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Matt Fleming <matt@console-pimps.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/kexec-bzimage64.c  |    4 ++--
 drivers/firmware/efi/runtime-map.c |    6 +++---
 include/linux/efi.h                |    8 ++++----
 3 files changed, 9 insertions(+), 9 deletions(-)

diff -puN arch/x86/kernel/kexec-bzimage64.c~kexec-support-kexec-kdump-on-efi-systems-fix arch/x86/kernel/kexec-bzimage64.c
--- a/arch/x86/kernel/kexec-bzimage64.c~kexec-support-kexec-kdump-on-efi-systems-fix
+++ a/arch/x86/kernel/kexec-bzimage64.c
@@ -181,7 +181,7 @@ setup_efi_state(struct boot_params *para
 	ei->efi_systab_hi = current_ei->efi_systab_hi;
 
 	ei->efi_memdesc_version = current_ei->efi_memdesc_version;
-	ei->efi_memdesc_size = get_efi_runtime_map_desc_size();
+	ei->efi_memdesc_size = efi_get_runtime_map_desc_size();
 
 	setup_efi_info_memmap(params, params_load_addr, efi_map_offset,
 			      efi_map_sz);
@@ -397,7 +397,7 @@ void *bzImage64_load(struct kimage *imag
 	 * have to create separate segment for each. Keeps things
 	 * little bit simple
 	 */
-	efi_map_sz = get_efi_runtime_map_size();
+	efi_map_sz = efi_get_runtime_map_size();
 	efi_map_sz = ALIGN(efi_map_sz, 16);
 	params_cmdline_sz = sizeof(struct boot_params) + cmdline_len +
 				MAX_ELFCOREHDR_STR_LEN;
diff -puN drivers/firmware/efi/runtime-map.c~kexec-support-kexec-kdump-on-efi-systems-fix drivers/firmware/efi/runtime-map.c
--- a/drivers/firmware/efi/runtime-map.c~kexec-support-kexec-kdump-on-efi-systems-fix
+++ a/drivers/firmware/efi/runtime-map.c
@@ -138,19 +138,19 @@ add_sysfs_runtime_map_entry(struct kobje
 	return entry;
 }
 
-int get_efi_runtime_map_size(void)
+int efi_get_runtime_map_size(void)
 {
 	return nr_efi_runtime_map * efi_memdesc_size;
 }
 
-int get_efi_runtime_map_desc_size(void)
+int efi_get_runtime_map_desc_size(void)
 {
 	return efi_memdesc_size;
 }
 
 int efi_runtime_map_copy(void *buf, size_t bufsz)
 {
-	size_t sz = get_efi_runtime_map_size();
+	size_t sz = efi_get_runtime_map_size();
 
 	if (sz > bufsz)
 		sz = bufsz;
diff -puN include/linux/efi.h~kexec-support-kexec-kdump-on-efi-systems-fix include/linux/efi.h
--- a/include/linux/efi.h~kexec-support-kexec-kdump-on-efi-systems-fix
+++ a/include/linux/efi.h
@@ -1151,8 +1151,8 @@ int efivars_sysfs_init(void);
 #ifdef CONFIG_EFI_RUNTIME_MAP
 int efi_runtime_map_init(struct kobject *);
 void efi_runtime_map_setup(void *, int, u32);
-int get_efi_runtime_map_size(void);
-int get_efi_runtime_map_desc_size(void);
+int efi_get_runtime_map_size(void);
+int efi_get_runtime_map_desc_size(void);
 int efi_runtime_map_copy(void *buf, size_t bufsz);
 #else
 static inline int efi_runtime_map_init(struct kobject *kobj)
@@ -1163,12 +1163,12 @@ static inline int efi_runtime_map_init(s
 static inline void
 efi_runtime_map_setup(void *map, int nr_entries, u32 desc_size) {}
 
-static inline int get_efi_runtime_map_size(void)
+static inline int efi_get_runtime_map_size(void)
 {
 	return 0;
 }
 
-static inline int get_efi_runtime_map_desc_size(void)
+static inline int efi_get_runtime_map_desc_size(void)
 {
 	return 0;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
kernel-printk-printkc-revert-printk-enable-interrupts-before-calling-console_trylock_for_printk.patch
x86-numa-setup_node_data-drop-dead-code-and-rename-function-checkpatch-fixes.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-free-inode-when-i_count-becomes-zero-checkpatch-fixes.patch
mm.patch
slub-use-new-node-functions-checkpatch-fixes.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2-fix.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
dma-cma-support-arbitrary-bitmap-granularity-fix.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc-fix.patch
include-linux-mmdebugh-add-vm_warn_once.patch
mm-catch-memory-commitment-underflow-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-zpool-implement-common-zpool-api-to-zbud-zsmalloc-fix.patch
mm-zpool-prevent-zbud-zsmalloc-from-unloading-when-used-checkpatch-fixes.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.patch
add-lib-globc-fix.patch
lib-list_sortc-convert-to-pr_foo.patch
lib-list_sortc-convert-to-pr_foo-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting-fix.patch
fs-isofs-logging-clean-up-fix.patch
kexec-implementation-of-new-syscall-kexec_file_load-checkpatch-fixes.patch
kexec-support-kexec-kdump-on-efi-systems-fix.patch
panic-add-taint_softlockup-fix.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
drivers-staging-emxx_udc-emxx_udcc-replace-strict_strto-with-kstrto.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


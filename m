From: akpm@linux-foundation.org
Subject: [folded-merged]
 kexec-support-kexec-kdump-on-efi-systems-fix.patch removed from -mm tree
Date: Fri, 08 Aug 2014 14:03:56 -0700
Message-ID: <53e53b3c.2FLKwnxGJ7lEJ/Ol%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yk0-f201.google.com ([209.85.160.201]:60910 "EHLO
	mail-yk0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933574AbaHHVD5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Aug 2014 17:03:57 -0400
Received: by mail-yk0-f201.google.com with SMTP id 142so808921ykq.0
        for <mm-commits@vger.kernel.org>; Fri, 08 Aug 2014 14:03:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, matt@console-pimps.org, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec-support-kexec-kdump-on-efi-systems-fix
has been removed from the -mm tree.  Its filename was
     kexec-support-kexec-kdump-on-efi-systems-fix.patch

This patch was dropped because it was folded into kexec-support-kexec-kdump-on-efi-systems.patch

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
@@ -1156,8 +1156,8 @@ int efivars_sysfs_init(void);
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
@@ -1168,12 +1168,12 @@ static inline int efi_runtime_map_init(s
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

origin.patch
rtc-add-pcf85063-support.patch
proc-remove-proc_tty_ldisc-variable.patch
mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors.patch
panic-add-taint_softlockup.patch
kexec-implementation-of-new-syscall-kexec_file_load.patch
kexec-support-kexec-kdump-on-efi-systems.patch


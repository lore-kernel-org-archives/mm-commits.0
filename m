From: akpm@linux-foundation.org
Subject: + ksm-add-get_pte-helper-function-fetching-pte-for-va-fix.patch added to -mm tree
Date: Tue, 21 Apr 2009 18:53:48 -0700
Message-ID: <200904220153.n3M1rmlU017587@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40886 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753040AbZDVB6m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Apr 2009 21:58:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, aarcange@redhat.com, avi@redhat.com, chrisw@redhat.com, hugh@veritas.com, ieidus@redhat.com, nickpiggin@yahoo.com.au


The patch titled
     ksm-add-get_pte-helper-function-fetching-pte-for-va-fix
has been added to the -mm tree.  Its filename is
     ksm-add-get_pte-helper-function-fetching-pte-for-va-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ksm-add-get_pte-helper-function-fetching-pte-for-va-fix
From: Andrew Morton <akpm@linux-foundation.org>

In file included from include/linux/suspend.h:8,
                 from arch/x86/kernel/asm-offsets_32.c:11,
                 from arch/x86/kernel/asm-offsets.c:2:
include/linux/mm.h: In function 'get_pte':
include/linux/mm.h:906: error: implicit declaration of function 'kmap_atomic_pte'

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Chris Wright <chrisw@redhat.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Izik Eidus <ieidus@redhat.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   25 +------------------------
 mm/util.c          |   26 ++++++++++++++++++++++++++
 2 files changed, 27 insertions(+), 24 deletions(-)

diff -puN include/linux/mm.h~ksm-add-get_pte-helper-function-fetching-pte-for-va-fix include/linux/mm.h
--- a/include/linux/mm.h~ksm-add-get_pte-helper-function-fetching-pte-for-va-fix
+++ a/include/linux/mm.h
@@ -883,30 +883,7 @@ extern void unregister_shrinker(struct s
 int vma_wants_writenotify(struct vm_area_struct *vma);
 
 extern pte_t *get_locked_pte(struct mm_struct *mm, unsigned long addr, spinlock_t **ptl);
-
-static inline pte_t *get_pte(struct mm_struct *mm, unsigned long addr)
-{
-	pgd_t *pgd;
-	pud_t *pud;
-	pmd_t *pmd;
-	pte_t *ptep = NULL;
-
-	pgd = pgd_offset(mm, addr);
-	if (!pgd_present(*pgd))
-		goto out;
-
-	pud = pud_offset(pgd, addr);
-	if (!pud_present(*pud))
-		goto out;
-
-	pmd = pmd_offset(pud, addr);
-	if (!pmd_present(*pmd))
-		goto out;
-
-	ptep = pte_offset_map(pmd, addr);
-out:
-	return ptep;
-}
+extern pte_t *get_pte(struct mm_struct *mm, unsigned long addr);
 
 #ifdef __PAGETABLE_PUD_FOLDED
 static inline int __pud_alloc(struct mm_struct *mm, pgd_t *pgd,
diff -puN mm/util.c~ksm-add-get_pte-helper-function-fetching-pte-for-va-fix mm/util.c
--- a/mm/util.c~ksm-add-get_pte-helper-function-fetching-pte-for-va-fix
+++ a/mm/util.c
@@ -1,4 +1,5 @@
 #include <linux/mm.h>
+#include <linux/highmem.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/module.h>
@@ -264,6 +265,31 @@ int __attribute__((weak)) get_user_pages
 }
 EXPORT_SYMBOL_GPL(get_user_pages_fast);
 
+pte_t *get_pte(struct mm_struct *mm, unsigned long addr)
+{
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *ptep = NULL;
+
+	pgd = pgd_offset(mm, addr);
+	if (!pgd_present(*pgd))
+		goto out;
+
+	pud = pud_offset(pgd, addr);
+	if (!pud_present(*pud))
+		goto out;
+
+	pmd = pmd_offset(pud, addr);
+	if (!pmd_present(*pmd))
+		goto out;
+
+	ptep = pte_offset_map(pmd, addr);
+out:
+	return ptep;
+}
+EXPORT_SYMBOL_GPL(get_pte);
+
 /* Tracepoints definitions. */
 EXPORT_TRACEPOINT_SYMBOL(kmalloc);
 EXPORT_TRACEPOINT_SYMBOL(kmem_cache_alloc);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
pxafb-lcsr1-is-unused-without-config_fb_pxa_overlay.patch
clocksource-pass-clocksource-to-read-callback.patch
i2c-too-much-compiler-noise.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
arch-x86-kernel-apic-io_apicc-conditionally-compile-eoi_ioapic_irq.patch
drivers-gpu-drm-i915-intel_fbc-remove-sysrq-g-handler.patch
input-bcm5974-declare-alignment-usage.patch
input-keyboard-introduce-lm8323-driver.patch
drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-checkpatch-fixes.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality-checkpatch-fixes.patch
mtd-flex-onenand-support.patch
misdn-l1oip-reduce-stack-memory-footprint.patch
drivers-net-82596c-suppress-warnings.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
vfs-kill-vfs_stat_fd-vfs_lstat_fd-fix.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
drivers-platform-x86-toshiba_acpic-fix-acpi_install_notify_handler-arg.patch
squashfs-fix-breakage-when-pagesize-blocksize-checkpatch-fixes.patch
mm-consolidate-init_mm-definition-fix.patch
readahead-record-mmap-read-around-states-in-file_ra_state-checkpatch-fixes.patch
mm-clean-up-get_user_pages_fast-documentation-checkpatch-fixes.patch
ksm-add-get_pte-helper-function-fetching-pte-for-va-fix.patch
ksm-add-ksm-kernel-shared-memory-driver-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
flat-fix-data-sections-alignment.patch
rtc-add-stand-alone-driver-for-rx8025-chip-is-broken.patch
drivers-char-memc-memory_open-cleanup-lookup-minor-device-number-from-devlist-checkpatch-fixes.patch
edac-add-cpc925-memory-controller-driver-cleanup.patch
edac-add-edac_device_alloc_index-cleanup.patch
gru-support-for-asynchronous-gru-instructions-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch


From: akpm@linux-foundation.org
Subject: + vfs-implement-posix-o_sync-and-o_dsync-semantics-checkpatch-fixes.patch added to -mm tree
Date: Thu, 24 Sep 2009 16:42:34 -0700
Message-ID: <200909242342.n8ONgZX0005114@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43471 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752744AbZIXXmc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 19:42:32 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n8ONgZeK003807
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Thu, 24 Sep 2009 16:42:36 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     vfs-implement-posix-o_sync-and-o_dsync-semantics-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     vfs-implement-posix-o_sync-and-o_dsync-semantics-checkpatch-fixes.patch

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
Subject: vfs-implement-posix-o_sync-and-o_dsync-semantics-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: braces {} are not necessary for single statement blocks
#269: FILE: arch/x86/mm/pat.c:708:
+	if (file->f_flags & O_DSYNC) {
 		flags = _PAGE_CACHE_UC_MINUS;
 	}

WARNING: line over 80 characters
#281: FILE: drivers/char/mem.c:47:
+	 * On ia64, we ignore O_DSYNC because we cannot tolerate memory attribute aliases.

total: 0 errors, 2 warnings, 359 lines checked

./patches/vfs-implement-posix-o_sync-and-o_dsync-semantics.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/pat.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN arch/x86/mm/pat.c~vfs-implement-posix-o_sync-and-o_dsync-semantics-checkpatch-fixes arch/x86/mm/pat.c
--- a/arch/x86/mm/pat.c~vfs-implement-posix-o_sync-and-o_dsync-semantics-checkpatch-fixes
+++ a/arch/x86/mm/pat.c
@@ -705,9 +705,8 @@ int phys_mem_access_prot_allowed(struct 
 	if (!range_is_allowed(pfn, size))
 		return 0;
 
-	if (file->f_flags & O_DSYNC) {
+	if (file->f_flags & O_DSYNC)
 		flags = _PAGE_CACHE_UC_MINUS;
-	}
 
 #ifdef CONFIG_X86_32
 	/*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
procfs-disable-per-task-stack-usage-on-nommu.patch
hugetlb_file_setup-use-c-not-cpp.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
e100c-use-pci_dma_bidirectional-in-e100_rx_indicate.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
serial167-fix-read-buffer-overflow.patch
st-fix-test-of-value-range-in-st_set_options.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
fs-improve-remountro-vs-buffercache-coherency.patch
vfs-implement-posix-o_sync-and-o_dsync-semantics-checkpatch-fixes.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
drivers-net-wireless-ath-ar9170-phyc-fix-uninitialised-variable.patch
readahead-add-blk_run_backing_dev.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
reiser4-disable.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch


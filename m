From: akpm@linux-foundation.org
Subject: [folded] mm-unify-some-pmd_-functions-fix-s390.patch removed from -mm tree
Date: Tue, 03 Feb 2009 12:17:49 -0800
Message-ID: <200902032017.n13KHoY5026068@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45172 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751341AbZBCUS3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Feb 2009 15:18:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, heiko.carstens@de.ibm.com, righi.andrea@gmail.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     mm-unify-some-pmd_-functions-fix-s390
has been removed from the -mm tree.  Its filename was
     mm-unify-some-pmd_-functions-fix-s390.patch

This patch was dropped because it was folded into mm-unify-some-pmd_-functions.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-unify-some-pmd_-functions-fix-s390
From: Andrew Morton <akpm@linux-foundation.org>

revert s390 bits

Cc: Andrea Righi <righi.andrea@gmail.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/pgalloc.h |    3 ++-
 x86/include/asm/pgalloc.h       |    0 
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/alpha/include/asm/pgalloc.h~mm-unify-some-pmd_-functions-fix-s390 arch/alpha/include/asm/pgalloc.h
diff -puN arch/arm/include/asm/pgalloc.h~mm-unify-some-pmd_-functions-fix-s390 arch/arm/include/asm/pgalloc.h
diff -puN arch/ia64/include/asm/pgalloc.h~mm-unify-some-pmd_-functions-fix-s390 arch/ia64/include/asm/pgalloc.h
diff -puN arch/mips/include/asm/pgalloc.h~mm-unify-some-pmd_-functions-fix-s390 arch/mips/include/asm/pgalloc.h
diff -puN arch/parisc/include/asm/pgalloc.h~mm-unify-some-pmd_-functions-fix-s390 arch/parisc/include/asm/pgalloc.h
diff -puN arch/powerpc/include/asm/pgalloc-32.h~mm-unify-some-pmd_-functions-fix-s390 arch/powerpc/include/asm/pgalloc-32.h
diff -puN arch/powerpc/include/asm/pgalloc-64.h~mm-unify-some-pmd_-functions-fix-s390 arch/powerpc/include/asm/pgalloc-64.h
diff -puN arch/s390/include/asm/pgalloc.h~mm-unify-some-pmd_-functions-fix-s390 arch/s390/include/asm/pgalloc.h
--- a/arch/s390/include/asm/pgalloc.h~mm-unify-some-pmd_-functions-fix-s390
+++ a/arch/s390/include/asm/pgalloc.h
@@ -63,7 +63,8 @@ static inline unsigned long pgd_entry_ty
 #define pud_alloc_one(mm,address)		({ BUG(); ((pud_t *)2); })
 #define pud_free(mm, x)				do { } while (0)
 
-#define pmd_alloc_one	pmd_alloc_one_bug
+#define pmd_alloc_one(mm,address)		({ BUG(); ((pmd_t *)2); })
+#define pmd_free(mm, x)				do { } while (0)
 
 #define pgd_populate(mm, pgd, pud)		BUG()
 #define pgd_populate_kernel(mm, pgd, pud)	BUG()
diff -puN arch/sh/include/asm/pgalloc.h~mm-unify-some-pmd_-functions-fix-s390 arch/sh/include/asm/pgalloc.h
diff -puN arch/sparc/include/asm/pgalloc_64.h~mm-unify-some-pmd_-functions-fix-s390 arch/sparc/include/asm/pgalloc_64.h
diff -puN arch/um/include/asm/pgalloc.h~mm-unify-some-pmd_-functions-fix-s390 arch/um/include/asm/pgalloc.h
diff -puN arch/um/include/asm/pgtable-3level.h~mm-unify-some-pmd_-functions-fix-s390 arch/um/include/asm/pgtable-3level.h
diff -puN arch/x86/include/asm/pgalloc.h~mm-unify-some-pmd_-functions-fix-s390 arch/x86/include/asm/pgalloc.h
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
kernel-asyncc-fix-printk-warnings.patch
revert-rlimit-permit-setting-rlimit_nofile-to-rlim_infinity.patch
hp-wmi-fix-error-path-in-hp_wmi_bios_setup.patch
wait-prevent-exclusive-waiter-starvation-checkpatch-fixes.patch
i-need-old-gcc.patch
linux-next.patch
next-remove-localversion.patch
linux-next-git-rejects.patch
kvm-unbork.patch
fix-sparseirq-use-kstat_irqs_cpu-on-non-x86-architectures-too.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code-checkpatch-fixes.patch
x86-define-arch_want_frame_pointers-fix.patch
kernel-auditscc-fix-warning.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-fix.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-checkpatch-fixes.patch
sysfs-reference-sysfs_dirent-from-sysfs-inodes-fix.patch
early-platform-driver-v3-checkpatch-fixes.patch
clocksource-pass-clocksource-to-read-callback.patch
input-bcm5974-declare-alignment-usage-checkpatch-fixes.patch
mtd-rbtx4939-add-mtd-support-fix.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
drivers-ata-sata_silc-needs-dmih.patch
net-dont-use-in_atomic-in-gfp_any.patch
documentation-connector-cn_testc-dont-use-gfp_any.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
mm-unify-some-pmd_-functions.patch
mm-unify-some-pmd_-functions-fix-s390.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
do_pipe-drop-its-last-user-in-arch-alpha-checkpatch-fixes.patch
epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key-checkpatch-fixes.patch
rtc-convert-leap_year-into-an-inline.patch
rtc-add-platform-driver-for-efi-fix.patch
drivers-video-uvesafbc-dont-use-gfp_any.patch
cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set.patch
cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set-fix-2.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
nbd-add-locking-to-nbd_ioctl-checkpatch-fixes.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
arch-x86-kernel-acpi-cstatec-avoid-using-work_on_cpu.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-using-work_on_cpu.patch
arch-x86-kernel-cpu-mcheck-mce_amd_64c-avoid-using-work_on_cpu.patch
work_on_cpu-rewrite-it-to-create-a-kernel-thread-on-demand.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
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
w1-build-fix.patch


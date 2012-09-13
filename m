From: akpm@linux-foundation.org
Subject: + atomic-implement-generic-atomic_dec_if_positive-fix.patch added to -mm tree
Date: Thu, 13 Sep 2012 12:36:44 -0700
Message-ID: <20120913193645.A3A20200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:35786 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419Ab2IMTgt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Sep 2012 15:36:49 -0400
Received: by fass10 with SMTP id s10so212798fas.1
        for <mm-commits@vger.kernel.org>; Thu, 13 Sep 2012 12:36:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, benh@kernel.crashing.org, davem@davemloft.net, hpa@zytor.com, mingo@elte.hu, monstr@monstr.eu, riel@redhat.com, sfr@canb.auug.org.au, shli@fusionio.com, shli@kernel.org, tglx@linutronix.de


The patch titled
     Subject: atomic-implement-generic-atomic_dec_if_positive-fix
has been added to the -mm tree.  Its filename is
     atomic-implement-generic-atomic_dec_if_positive-fix.patch

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
Subject: atomic-implement-generic-atomic_dec_if_positive-fix

do the "#define foo foo" trick in the conventional manner

Cc: "David S. Miller" <davem@davemloft.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Rik van Riel <riel@redhat.com>
Cc: Shaohua Li <shli@fusionio.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/microblaze/include/asm/atomic.h |    4 ++--
 arch/powerpc/include/asm/atomic.h    |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/microblaze/include/asm/atomic.h~atomic-implement-generic-atomic_dec_if_positive-fix arch/microblaze/include/asm/atomic.h
--- a/arch/microblaze/include/asm/atomic.h~atomic-implement-generic-atomic_dec_if_positive-fix
+++ a/arch/microblaze/include/asm/atomic.h
@@ -9,7 +9,7 @@
  * Atomically test *v and decrement if it is greater than 0.
  * The function returns the old value of *v minus 1.
  */
-static inline int __atomic_dec_if_positive(atomic_t *v)
+static inline int atomic_dec_if_positive(atomic_t *v)
 {
 	unsigned long flags;
 	int res;
@@ -22,6 +22,6 @@ static inline int __atomic_dec_if_positi
 
 	return res;
 }
-#define atomic_dec_if_positive __atomic_dec_if_positive
+#define atomic_dec_if_positive atomic_dec_if_positive
 
 #endif /* _ASM_MICROBLAZE_ATOMIC_H */
diff -puN arch/powerpc/include/asm/atomic.h~atomic-implement-generic-atomic_dec_if_positive-fix arch/powerpc/include/asm/atomic.h
--- a/arch/powerpc/include/asm/atomic.h~atomic-implement-generic-atomic_dec_if_positive-fix
+++ a/arch/powerpc/include/asm/atomic.h
@@ -247,7 +247,7 @@ static __inline__ int atomic_inc_not_zer
  * The function returns the old value of *v minus 1, even if
  * the atomic variable, v, was not decremented.
  */
-static __inline__ int __atomic_dec_if_positive(atomic_t *v)
+static __inline__ int atomic_dec_if_positive(atomic_t *v)
 {
 	int t;
 
@@ -268,7 +268,7 @@ static __inline__ int __atomic_dec_if_po
 
 	return t;
 }
-#define atomic_dec_if_positive __atomic_dec_if_positive
+#define atomic_dec_if_positive atomic_dec_if_positive
 
 #define smp_mb__before_atomic_dec()     smp_mb()
 #define smp_mb__after_atomic_dec()      smp_mb()
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

idr-rename-max_level-to-max_idr_level-fix.patch
idr-rename-max_level-to-max_idr_level-fix-fix-2.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
idr-rename-max_level-to-max_idr_level-fix-3.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
audith-replace-defines-with-c-stubs.patch
slab-fix-debug==0-warning.patch
mm.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn-fix.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix-fix.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures-fix.patch
mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host-fix.patch
rbtree-performance-and-correctness-test-fix.patch
mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock-fix.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failng-fix.patch
atomic-implement-generic-atomic_dec_if_positive-fix.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix.patch
mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc-checkpatch-fixes.patch
backlight-add-backlight-driver-for-lm3630-chip-fix.patch
backlight-add-new-lm3639-backlight-driver-fix.patch
lib-parserc-avoid-overflow-in-match_number-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
rtc-add-dallas-ds2404-driver-fix.patch
rtc-snvs-add-freescale-rtc-snvs-driver-fix.patch
fs-fat-fix-all-other-checkpatch-issues-in-dirc-fix.patch
fat-simplify-writeback_inode-checkpatch-fixes.patch
fat-simplify-writeback_inode-checkpatch-fixes-fix.patch
coredump-make-core-dump-functionality-optional-fix-fix.patch
proc-use-kzalloc-instead-of-kmalloc-and-memset-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


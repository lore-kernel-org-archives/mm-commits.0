From: akpm@linux-foundation.org
Subject: [folded-merged]
 include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch removed
 from -mm tree
Date: Mon, 07 Apr 2014 15:16:24 -0700
Message-ID: <534323b8.wPtn8gV6zm/8wRDo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40082 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174AbaDGWQ0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Apr 2014 18:16:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rashika.kheria@gmail.com, josh@joshtriplett.org, benh@kernel.crashing.org, akpm@linux-foundation.org

Subject: [folded-merged] include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,benh@kernel.crashing.org,josh@joshtriplett.org,rashika.kheria@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 07 Apr 2014 15:16:24 -0700


The patch titled
     Subject: include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix
has been removed from the -mm tree.  Its filename was
     include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch

This patch was dropped because it was folded into include-linux-crash_dumph-add-vmcore_cleanup-prototype.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix

clean up powerpc, remove unneeded EXPORT_SYMBOL

Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Rashika Kheria <rashika.kheria@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/fadump.h |    1 -
 fs/proc/vmcore.c                  |    1 -
 2 files changed, 2 deletions(-)

diff -puN arch/powerpc/include/asm/fadump.h~include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix arch/powerpc/include/asm/fadump.h
--- a/arch/powerpc/include/asm/fadump.h~include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix
+++ a/arch/powerpc/include/asm/fadump.h
@@ -210,7 +210,6 @@ extern int is_fadump_active(void);
 extern void crash_fadump(struct pt_regs *, const char *);
 extern void fadump_cleanup(void);
 
-extern void vmcore_cleanup(void);
 #else	/* CONFIG_FA_DUMP */
 static inline int is_fadump_active(void) { return 0; }
 static inline void crash_fadump(struct pt_regs *regs, const char *str) { }
diff -puN fs/proc/vmcore.c~include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix
+++ a/fs/proc/vmcore.c
@@ -1118,4 +1118,3 @@ void vmcore_cleanup(void)
 	}
 	free_elfcorebuf();
 }
-EXPORT_SYMBOL_GPL(vmcore_cleanup);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mmnuma-reorganize-change_pmd_range.patch
drivers-lguest-page_tablesc-rename-do_set_pte.patch
mm-add-debugfs-tunable-for-fault_around_order.patch
mm-per-thread-vma-caching.patch
mm-use-macros-from-compilerh-instead-of-__attribute__.patch
mm-vmallocc-enhance-vm_map_ram-comment.patch
mm-readaheadc-inline-ra_submit.patch
zram-use-zcomp-compressing-backends.patch
zram-return-error-valued-pointer-from-zcomp_create.patch
zram-propagate-error-to-user.patch
zram-support-req_discard.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype.patch
kernel-panicc-display-reason-at-end-pr_emerg-fix.patch
fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts-fix.patch
initramfs-debug-detected-compression-method-fix.patch
slub-use-raw_cpu_inc-for-incrementing-statistics-fix.patch
vmstat-use-raw_cpu_ops-to-avoid-false-positives-on-preemption-checks-fix.patch
percpu-add-preemption-checks-to-__this_cpu-ops-fix-checkpatch-fixes.patch


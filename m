From: akpm@linux-foundation.org
Subject: [folded-merged]
 kallsyms-add-support-for-relative-offsets-in-kallsyms-address-table-fix.patch removed from -mm tree
Date: Mon, 25 Jan 2016 13:42:59 -0800
Message-ID: <56a696e3.LD4dnE/BJJie6XrP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33204 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758071AbcAYVnA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jan 2016 16:43:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ard.biesheuvel@linaro.org, arnd@arndb.de, benh@kernel.crashing.org, heiko.carstens@de.ibm.com, hpa@zytor.com, keescook@chromium.org, mingo@kernel.org, mmarek@suse.cz, mpe@ellerman.id.au, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: kallsyms-add-support-for-relative-offsets-in-kallsyms-address-table-fix
has been removed from the -mm tree.  Its filename was
     kallsyms-add-support-for-relative-offsets-in-kallsyms-address-table-fix.patch

This patch was dropped because it was folded into kallsyms-add-support-for-relative-offsets-in-kallsyms-address-table.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kallsyms-add-support-for-relative-offsets-in-kallsyms-address-table-fix

ULLONG_MAX doesn't work with ancient glibc-headers-2.5-3 - just use -1ULL

Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Kees Cook <keescook@chromium.org> # x86_64
Cc: Michael Ellerman <mpe@ellerman.id.au> # powerpc
Cc: Michal Marek <mmarek@suse.cz>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kallsyms.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/kallsyms.c~kallsyms-add-support-for-relative-offsets-in-kallsyms-address-table-fix scripts/kallsyms.c
--- a/scripts/kallsyms.c~kallsyms-add-support-for-relative-offsets-in-kallsyms-address-table-fix
+++ a/scripts/kallsyms.c
@@ -741,7 +741,7 @@ static void record_relative_base(void)
 		 */
 		relative_base = kernel_start_addr;
 	} else {
-		relative_base = ULLONG_MAX;
+		relative_base = -1ULL;
 		for (i = 0; i < table_cnt; i++)
 			if (!symbol_absolute(&table[i]) &&
 			    table[i].addr < relative_base)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
kallsyms-add-support-for-relative-offsets-in-kallsyms-address-table.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
mm.patch
fs-mpagec-mpage_readpages-use-lru_to_page-helper.patch
mm-page_allocc-introduce-kernelcore=mirror-option-fix.patch
mm-page_allocc-rework-code-layout-in-memmap_init_zone.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
sched-add-schedule_timeout_idle.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
include-linux-huge_mmh-pmd_trans_huge_lock-returns-a-spinlock_t.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch


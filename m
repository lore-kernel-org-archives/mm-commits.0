From: akpm@linux-foundation.org
Subject: [folded-merged]
 stringh-work-around-for-increased-stack-usage-fix.patch removed from -mm
 tree
Date: Thu, 14 Dec 2017 15:27:28 -0800
Message-ID: <5a3308e0.uyMXh98BI6LDqvZF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53782 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754342AbdLNX13 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Dec 2017 18:27:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, keescook@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: stringh-work-around-for-increased-stack-usage-fix
has been removed from the -mm tree.  Its filename was
     stringh-work-around-for-increased-stack-usage-fix.patch

This patch was dropped because it was folded into stringh-work-around-for-increased-stack-usage.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: stringh-work-around-for-increased-stack-usage-fix

add comment

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/string.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/string.h~stringh-work-around-for-increased-stack-usage-fix include/linux/string.h
--- a/include/linux/string.h~stringh-work-around-for-increased-stack-usage-fix
+++ a/include/linux/string.h
@@ -259,6 +259,8 @@ __FORTIFY_INLINE __kernel_size_t strlen(
 {
 	__kernel_size_t ret;
 	size_t p_size = __builtin_object_size(p, 0);
+
+	/* Work around gcc excess stack consumption issue */
 	if (p_size == (size_t)-1 ||
 	    (__builtin_constant_p(p[p_size - 1]) && p[p_size - 1] == '\0'))
 		return __builtin_strlen(p);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-kmemleakc-make-cond_resched-rate-limiting-more-efficient.patch
stringh-work-around-for-increased-stack-usage.patch
mm-memoryc-mark-wp_huge_pmd-inline-to-prevent-build-failure-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-terminate-shrink_slab-loop-if-signal-is-pending-fix.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-split-deferred_init_range-into-initializing-and-freeing-parts-fix.patch
mm-do-not-stall-register_shrinker-fix.patch
selftest-vm-move-128tb-mmap-boundary-test-to-generic-directory-fix.patch
list_lru-prefetch-neighboring-list-entries-before-acquiring-lock-fix.patch
mm-oom-cgroup-aware-oom-killer-fix.patch
sparc64-update-pmdp_invalidate-to-return-old-pmd-value-fix.patch
x86-mm-provide-pmdp_establish-helper-fix.patch
fs-elf-drop-map_fixed-usage-from-elf_map-checkpatch-fixes.patch
mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix.patch
mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix-checkpatch-fixes.patch
lib-ubsanc-s-missaligned-misaligned.patch
linux-next-rejects.patch
tools-objtool-makefile-dont-assume-sync-checksh-is-executable.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch


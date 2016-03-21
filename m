From: akpm@linux-foundation.org
Subject: [merged]
 mn10300-c6x-config_generic_bug-must-depend-on-config_bug.patch removed from -mm tree
Date: Mon, 21 Mar 2016 11:41:01 -0700
Message-ID: <56f0403d.subeDT2GG6bPjgib%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53457 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932328AbcCUT42 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:56:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fengguang.wu@intel.com, josh@joshtriplett.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mn10300, c6x: CONFIG_GENERIC_BUG must depend on CONFIG_BUG
has been removed from the -mm tree.  Its filename was
     mn10300-c6x-config_generic_bug-must-depend-on-config_bug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mn10300, c6x: CONFIG_GENERIC_BUG must depend on CONFIG_BUG

CONFIG_BUG=n && CONFIG_GENERIC_BUG=y make no sense and things break:

   In file included from include/linux/page-flags.h:9:0,
                    from kernel/bounds.c:9:
   include/linux/bug.h:91:47: warning: 'struct bug_entry' declared inside parameter list
    static inline int is_warning_bug(const struct bug_entry *bug)
                                                  ^
   include/linux/bug.h:91:47: warning: its scope is only this definition or declaration, which is probably not what you want
   include/linux/bug.h: In function 'is_warning_bug':
>> include/linux/bug.h:93:12: error: dereferencing pointer to incomplete type
     return bug->flags & BUGFLAG_WARNING;

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/c6x/Kconfig     |    1 +
 arch/mn10300/Kconfig |    1 +
 2 files changed, 2 insertions(+)

diff -puN arch/c6x/Kconfig~mn10300-c6x-config_generic_bug-must-depend-on-config_bug arch/c6x/Kconfig
--- a/arch/c6x/Kconfig~mn10300-c6x-config_generic_bug-must-depend-on-config_bug
+++ a/arch/c6x/Kconfig
@@ -36,6 +36,7 @@ config GENERIC_HWEIGHT
 
 config GENERIC_BUG
 	def_bool y
+	depends on BUG
 
 config C6X_BIG_KERNEL
 	bool "Build a big kernel"
diff -puN arch/mn10300/Kconfig~mn10300-c6x-config_generic_bug-must-depend-on-config_bug arch/mn10300/Kconfig
--- a/arch/mn10300/Kconfig~mn10300-c6x-config_generic_bug-must-depend-on-config_bug
+++ a/arch/mn10300/Kconfig
@@ -53,6 +53,7 @@ config GENERIC_HWEIGHT
 
 config GENERIC_BUG
 	def_bool y
+	depends on BUG
 
 config QUICKLIST
 	def_bool y
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-code-clean-up-for-direct-io-fix.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
ocfs2-dlm-move-lock-to-the-tail-of-grant-queue-while-doing-in-place-convert-fix.patch
mm.patch
sched-add-schedule_timeout_idle.patch
mm-oom_reaper-report-success-failure-fix.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
mm-kasan-stackdepot-implementation-enable-stackdepot-for-slab-fix.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix-fix.patch
rapidio-add-mport-char-device-driver-fix.patch
kernel-add-kcov-code-coverage-fix.patch
kernel-add-kcov-code-coverage-fix-2.patch
kernel-add-kcov-code-coverage-makefile-tweaks.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
dma-rename-dma__writecombine-to-dma__wc-checkpatch-fixes.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch


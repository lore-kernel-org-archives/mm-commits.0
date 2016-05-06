From: akpm@linux-foundation.org
Subject: + lib-gcd-use-binary-gcd-algorithm-instead-of-euclidean-fix.patch added to -mm tree
Date: Fri, 06 May 2016 16:01:06 -0700
Message-ID: <572d2232.mj4WPsa8G6zm8blw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55357 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759028AbcEFXBH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 May 2016 19:01:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, linux@horizon.com, zhaoxiu.zeng@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-gcd-use-binary-gcd-algorithm-instead-of-euclidean-fix
has been added to the -mm tree.  Its filename is
     lib-gcd-use-binary-gcd-algorithm-instead-of-euclidean-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-gcd-use-binary-gcd-algorithm-instead-of-euclidean-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-gcd-use-binary-gcd-algorithm-instead-of-euclidean-fix.patch

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
Subject: lib-gcd-use-binary-gcd-algorithm-instead-of-euclidean-fix

avoid #defining a CONFIG_ variable

Cc: George Spelvin <linux@horizon.com>
Cc: Zhaoxiu Zeng <zhaoxiu.zeng@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/cpu-features.h |    2 +-
 lib/gcd.c                            |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/mips/include/asm/cpu-features.h~lib-gcd-use-binary-gcd-algorithm-instead-of-euclidean-fix arch/mips/include/asm/cpu-features.h
--- a/arch/mips/include/asm/cpu-features.h~lib-gcd-use-binary-gcd-algorithm-instead-of-euclidean-fix
+++ a/arch/mips/include/asm/cpu-features.h
@@ -187,7 +187,7 @@
 	  (defined(cpu_has_mips64r1) && cpu_has_mips64r1) || \
 	  (defined(cpu_has_mips64r2) && cpu_has_mips64r2) || \
 	  (defined(cpu_has_mips64r6) && cpu_has_mips64r6))
-#define CONFIG_CPU_NO_EFFICIENT_FFS 1
+#define CPU_NO_EFFICIENT_FFS 1
 #endif
 
 #ifndef cpu_has_mips_1
diff -puN lib/gcd.c~lib-gcd-use-binary-gcd-algorithm-instead-of-euclidean-fix lib/gcd.c
--- a/lib/gcd.c~lib-gcd-use-binary-gcd-algorithm-instead-of-euclidean-fix
+++ a/lib/gcd.c
@@ -10,7 +10,7 @@
  * has decent hardware division.
  */
 
-#if !defined(CONFIG_CPU_NO_EFFICIENT_FFS)
+#if !defined(CONFIG_CPU_NO_EFFICIENT_FFS) && !defined(CPU_NO_EFFICIENT_FFS)
 
 /* If __ffs is available, the even/odd algorithm benchmarks slower. */
 unsigned long gcd(unsigned long a, unsigned long b)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
fsnotify-avoid-spurious-emfile-errors-from-inotify_init-checkpatch-fixes.patch
kernel-padata-hide-unused-functions-checkpatch-fixes.patch
mm.patch
mm-slab-freelist-randomization-v5-fix.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix-fix.patch
include-linux-apply-__malloc-attribute-checkpatch-fixes.patch
include-linux-nodemaskh-create-next_node_in-helper.patch
include-linux-nodemaskh-create-next_node_in-helper-fix-fix.patch
mm-hugetlbc-use-first_memory_node.patch
mm-mempolicyc-offset_il_node-document-and-clarify.patch
mm-uninline-page_mapped.patch
mm-uninline-page_mapped-checkpatch-fixes.patch
memory_hotplug-introduce-config_memory_hotplug_default_online-fix.patch
oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path-try-to-reap-tasks-which-skip-regular-memcg-oom-killer-path-fix.patch
mm-page_alloc-only-check-pagecompound-for-high-order-pages-fix.patch
mm-page_alloc-remove-unnecessary-initialisation-from-__alloc_pages_nodemask-fix.patch
mm-page_alloc-shorten-the-page-allocator-fast-path-fix.patch
mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice-fix.patch
mm-page_alloc-un-inline-the-bad-part-of-free_pages_check-fix.patch
mm-page_alloc-defer-debugging-checks-of-freed-pages-until-a-pcp-drain-fix.patch
mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare-fix.patch
mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare-fix-fix.patch
mm-compaction-abstract-compaction-feedback-to-helpers-fix.patch
mm-oom-compaction-prevent-from-should_compact_retry-looping-for-ever-for-costly-orders-fix.patch
mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix.patch
procfs-fixes-pthread-cross-thread-naming-if-pr_dumpable-fix.patch
exit_thread-remove-empty-bodies-fix.patch
exit_thread-accept-a-task-parameter-to-be-exited-checkpatch-fixes.patch
lib-gcd-use-binary-gcd-algorithm-instead-of-euclidean-fix.patch
fs-execc-fix-minor-memory-leak.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch


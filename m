From: akpm@linux-foundation.org
Subject: + mm-zsmalloc-simplify-zs_max_alloc_size-handling-fix.patch added to -mm tree
Date: Wed, 05 Jul 2017 16:14:52 -0700
Message-ID: <595d72ec.W2tcrQPsuFhwdjPo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36542 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752467AbdGEXO6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jul 2017 19:14:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jmarchan@redhat.com, minchan@kernel.org, opensource.ganesh@gmail.com, sergey.senozhatsky.work@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-zsmalloc-simplify-zs_max_alloc_size-handling-fix
has been added to the -mm tree.  Its filename is
     mm-zsmalloc-simplify-zs_max_alloc_size-handling-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zsmalloc-simplify-zs_max_alloc_size-handling-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zsmalloc-simplify-zs_max_alloc_size-handling-fix.patch

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
Subject: mm-zsmalloc-simplify-zs_max_alloc_size-handling-fix

use min_t

Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Mahendran Ganesh <opensource.ganesh@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/zsmalloc.c~mm-zsmalloc-simplify-zs_max_alloc_size-handling-fix mm/zsmalloc.c
--- a/mm/zsmalloc.c~mm-zsmalloc-simplify-zs_max_alloc_size-handling-fix
+++ a/mm/zsmalloc.c
@@ -548,7 +548,7 @@ static int get_size_class_index(int size
 		idx = DIV_ROUND_UP(size - ZS_MIN_ALLOC_SIZE,
 				ZS_SIZE_CLASS_DELTA);
 
-	return min((int)ZS_SIZE_CLASSES - 1, idx);
+	return min_t(int, ZS_SIZE_CLASSES - 1, idx);
 }
 
 static inline void zs_stat_inc(struct size_class *class,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-slub-wrap-cpu_slab-partial-in-config_slub_cpu_partial-fix.patch
mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online-fix-2-fix.patch
swap-add-block-io-poll-in-swapin-path-checkpatch-fixes.patch
mm-oom_kill-count-global-and-memory-cgroup-oom-kills-fix.patch
mm-oom_kill-count-global-and-memory-cgroup-oom-kills-fix-fix.patch
mm-swap-sort-swap-entries-before-free-fix.patch
mm-vmscan-avoid-thrashing-anon-lru-when-free-file-is-low-fix.patch
mm-hwpoison-dissolve-in-use-hugepage-in-unrecoverable-memory-error-fix.patch
mm-hugetlb-warn-the-user-when-issues-arise-on-boot-due-to-hugepages-fix.patch
mm-improve-readability-of-transparent_hugepage_enabled-fix.patch
mm-improve-readability-of-transparent_hugepage_enabled-fix-fix.patch
hugetlb-memory_hotplug-prefer-to-use-reserved-pages-for-migration-fix.patch
mm-page_allocc-eliminate-unsigned-confusion-in-__rmqueue_fallback-fix.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix-fix.patch
mm-zsmalloc-simplify-zs_max_alloc_size-handling-fix.patch
signal-avoid-undefined-behaviour-in-kill_something_info-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
fault-inject-support-systematic-fault-injection-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
powerpc-64s-implement-arch-specific-hardlockup-watchdog-checkpatch-fixes.patch
mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch


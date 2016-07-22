From: akpm@linux-foundation.org
Subject: + kexec-add-resriction-on-the-kexec_load-fix.patch added to -mm
 tree
Date: Fri, 22 Jul 2016 12:59:05 -0700
Message-ID: <57927b09.kF232JXpytEyWTJ0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54653 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754494AbcGVT7L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Jul 2016 15:59:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, zhongjiang@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec-add-resriction-on-the-kexec_load-fix
has been added to the -mm tree.  Its filename is
     kexec-add-resriction-on-the-kexec_load-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kexec-add-resriction-on-the-kexec_load-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kexec-add-resriction-on-the-kexec_load-fix.patch

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
Subject: kexec-add-resriction-on-the-kexec_load-fix

Cc: zhong jiang <zhongjiang@huawei.com>
Cc: zhongjiang <zhongjiang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN kernel/kexec_core.c~kexec-add-resriction-on-the-kexec_load-fix kernel/kexec_core.c
--- a/kernel/kexec_core.c~kexec-add-resriction-on-the-kexec_load-fix
+++ a/kernel/kexec_core.c
@@ -215,10 +215,10 @@ int sanity_check_segment_list(struct kim
 			return -EINVAL;
 	}
 
-	/* Verity all segment size donnot exceed the specified size.
-	 * if segment size from user space is too large,  a large
-	 * amount of time will be wasted when allocating page. so,
-	 * softlockup may be come up.
+	/*
+	 * Verify that no segment is larger than half of memory.  If a segment
+	 * from userspace is too large,  a large amount of time will be wasted
+	 * allocating pages, which can cause a soft lockup.
 	 */
 	for (i = 0; i < nr_segments; i++) {
 		if (image->segment[i].memsz > (totalram_pages / 2))
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-improve-recovery-performance-v2-fix.patch
ocfs2-dlm-disable-bug_on-when-dlm_lock_res_dropping_ref-is-cleared-before-dlm_deref_lockres_done_handler-fix.patch
mm.patch
mm-reorganize-slab-freelist-randomization-fix.patch
mm-balloon-use-general-non-lru-movable-page-feature-fix.patch
mm-compaction-split-freepages-without-holding-the-zone-lock-fix-2.patch
mm-frontswap-convert-frontswap_enabled-to-static-key-checkpatch-fixes.patch
mm-add-nr_zsmalloc-to-vmstat-fix.patch
mm-memcg-use-consistent-gfp-flags-during-readahead-checkpatch-fixes.patch
mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix-2-fix.patch
mm-fix-build-warnings-in-linux-compactionh-fix.patch
mm-update-the-comment-in-__isolate_free_page-checkpatch-fixes.patch
revert-mm-mempool-only-set-__gfp_nomemalloc-if-there-are-free-elements-checkpatch-fixes.patch
treewide-replace-obsolete-_refok-by-__ref-checkpatch-fixes.patch
printk-create-pr_level-functions-fix.patch
kexec-ensure-user-memory-sizes-do-not-wrap-fix.patch
kexec-allow-architectures-to-override-boot-mapping-fix.patch
allow-kdump-with-crash_kexec_post_notifiers-fix.patch
kexec-add-resriction-on-the-kexec_load-fix.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
bitmap-bitmap_equal-memcmp-optimization-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch


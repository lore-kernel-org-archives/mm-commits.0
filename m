From: akpm@linux-foundation.org
Subject: +
 printk-add-kernel-parameter-to-control-writes-to-dev-kmsg-checkpatch-fixes.patch added to -mm tree
Date: Mon, 18 Jul 2016 14:27:48 -0700
Message-ID: <578d49d4.fkc8q9Hf3hiC1Mky%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48291 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbcGRV1t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 18 Jul 2016 17:27:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bp@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: printk-add-kernel-parameter-to-control-writes-to-dev-kmsg-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     printk-add-kernel-parameter-to-control-writes-to-dev-kmsg-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-add-kernel-parameter-to-control-writes-to-dev-kmsg-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-add-kernel-parameter-to-control-writes-to-dev-kmsg-checkpatch-fixes.patch

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
Subject: printk-add-kernel-parameter-to-control-writes-to-dev-kmsg-checkpatch-fixes

ERROR: else should follow close brace '}'
#160: FILE: kernel/printk/printk.c:120:
+	}
+	else

WARNING: line over 80 characters
#263: FILE: kernel/printk/printk.c:745:
+	if ((system_state != SYSTEM_BOOTING) && !(devkmsg_log & DEVKMSG_LOG_MASK_ON)) {

total: 1 errors, 1 warnings, 250 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/printk-add-kernel-parameter-to-control-writes-to-dev-kmsg.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Borislav Petkov <bp@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN kernel/printk/printk.c~printk-add-kernel-parameter-to-control-writes-to-dev-kmsg-checkpatch-fixes kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-add-kernel-parameter-to-control-writes-to-dev-kmsg-checkpatch-fixes
+++ a/kernel/printk/printk.c
@@ -117,8 +117,7 @@ static int __control_devkmsg(char *str)
 		devkmsg_log = DEVKMSG_LOG_MASK_DEFAULT;
 		return 9;
 	}
-	else
-		return -EINVAL;
+	return -EINVAL;
 }
 
 static int __init control_devkmsg(char *str)
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
treewide-replace-obsolete-_refok-by-__ref-checkpatch-fixes.patch
printk-create-pr_level-functions-fix.patch
printk-add-kernel-parameter-to-control-writes-to-dev-kmsg-checkpatch-fixes.patch
kexec-ensure-user-memory-sizes-do-not-wrap-fix.patch
kexec-allow-architectures-to-override-boot-mapping-fix.patch
allow-kdump-with-crash_kexec_post_notifiers-fix.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
bitmap-bitmap_equal-memcmp-optimization-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch


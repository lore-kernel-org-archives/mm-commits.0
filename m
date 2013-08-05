From: akpm@linux-foundation.org
Subject: + block-support-embedded-device-command-line-partition-fix.patch
 added to -mm tree
Date: Mon, 05 Aug 2013 15:22:17 -0700
Message-ID: <52002599.tecLRHVNP847FHCN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43328 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755639Ab3HEWWS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Aug 2013 18:22:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mag@sysgo.de, kzak@redhat.com, dwmw2@infradead.org, caizhiyong@huawei.com, axboe@kernel.dk, albert.wanglin@huawei.com, akpm@linux-foundation.org

Subject: + block-support-embedded-device-command-line-partition-fix.patch added to -mm tree
To: akpm@linux-foundation.org,albert.wanglin@huawei.com,axboe@kernel.dk,caizhiyong@huawei.com,dwmw2@infradead.org,kzak@redhat.com,mag@sysgo.de
From: akpm@linux-foundation.org
Date: Mon, 05 Aug 2013 15:22:17 -0700


The patch titled
     Subject: block-support-embedded-device-command-line-partition-fix
has been added to the -mm tree.  Its filename is
     block-support-embedded-device-command-line-partition-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/block-support-embedded-device-command-line-partition-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/block-support-embedded-device-command-line-partition-fix.patch

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
Subject: block-support-embedded-device-command-line-partition-fix

fix printk text

Cc: "Wanglin (Albert)" <albert.wanglin@huawei.com>
Cc: Cai Zhiyong <caizhiyong@huawei.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Karel Zak <kzak@redhat.com>
Cc: Marius Groeger <mag@sysgo.de>");
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/partitions/cmdline.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN block/partitions/cmdline.c~block-support-embedded-device-command-line-partition-fix block/partitions/cmdline.c
--- a/block/partitions/cmdline.c~block-support-embedded-device-command-line-partition-fix
+++ a/block/partitions/cmdline.c
@@ -134,7 +134,7 @@ static int parse_parts(struct cmdline_pa
 
 	next = strchr(cmdline, ':');
 	if (!next) {
-		pr_warn("cmdline partition has not block device.");
+		pr_warn("cmdline partition has no block device.");
 		goto fail;
 	}
 
@@ -162,7 +162,7 @@ static int parse_parts(struct cmdline_pa
 	}
 
 	if (!newparts->subpart) {
-		pr_warn("cmdline partition has not valid partition.");
+		pr_warn("cmdline partition has no valid partition.");
 		goto fail;
 	}
 
@@ -207,7 +207,7 @@ static int parse_cmdline(struct cmdline_
 	}
 
 	if (!*parts) {
-		pr_warn("cmdline partition has not valid partition.");
+		pr_warn("cmdline partition has no valid partition.");
 		ret = -EINVAL;
 		goto fail;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
block-support-embedded-device-command-line-partition-fix.patch
mm.patch
swap-warn-when-a-swap-area-overflows-the-maximum-size-fix.patch
mm-swapfilec-convert-to-pr_foo.patch
mm-vmstats-track-tlb-flush-stats-on-up-too-fix.patch
swap-make-swap-discard-async-checkpatch-fixes.patch
swap-make-cluster-allocation-per-cpu-checkpatch-fixes.patch
mm-page_alloc-restructure-free-page-stealing-code-and-fix-a-bug-fix.patch
mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache-fix.patch
memcg-trivial-cleanups.patch
lib-crc32-update-the-comments-of-crc32_bele_generic-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs-fix.patch
initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-checkpatch-fixes.patch
ipc-drop-ipcctl_pre_down-fix.patch
ipcshm-make-shmctl_nolock-lockless-checkpatch-fixes.patch
linux-next.patch
revert-selinux-do-not-handle-seclabel-as-a-special-flag.patch
shrinker-convert-superblock-shrinkers-to-new-api-fix.patch
xfs-convert-buftarg-lru-to-generic-code-fix.patch
xfs-convert-dquot-cache-lru-to-list_lru-fix.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix-2.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api-fix.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api-fix.patch
shrinker-kill-old-shrink-api-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


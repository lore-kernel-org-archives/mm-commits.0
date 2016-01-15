From: akpm@linux-foundation.org
Subject: + zram-dont-call-idr_remove-from-zram_remove-fix.patch added to
 -mm tree
Date: Thu, 14 Jan 2016 16:45:47 -0800
Message-ID: <5698413b.38zkuvyejdo2J6tN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53212 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756938AbcAOAps (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jan 2016 19:45:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jmarchan@redhat.com, minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram-dont-call-idr_remove-from-zram_remove-fix
has been added to the -mm tree.  Its filename is
     zram-dont-call-idr_remove-from-zram_remove-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-dont-call-idr_remove-from-zram_remove-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-dont-call-idr_remove-from-zram_remove-fix.patch

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
Subject: zram-dont-call-idr_remove-from-zram_remove-fix

fix coding stype, per Sergey

Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/block/zram/zram_drv.c~zram-dont-call-idr_remove-from-zram_remove-fix drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-dont-call-idr_remove-from-zram_remove-fix
+++ a/drivers/block/zram/zram_drv.c
@@ -1369,8 +1369,9 @@ static ssize_t hot_remove_store(struct c
 	if (zram) {
 		ret = zram_remove(zram);
 		idr_remove(&zram_index_idr, dev_id);
-	} else
+	} else {
 		ret = -ENODEV;
+	}
 
 	mutex_unlock(&zram_index_mutex);
 	return ret ? ret : count;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-dcacheh-remove-semicolons-from-hash_len_declare.patch
fs-block_devc-bdev_write_page-use-blk_queue_enter-gfp_noio.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
zram-dont-call-idr_remove-from-zram_remove-fix.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
mm.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
mm-support-madvisemadv_free-fix-2-fix.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix-fix-2.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix-fix-2-fix-3.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
sched-add-schedule_timeout_idle.patch
mm-mlockc-change-can_do_mlock-return-value-type-to-boolean-fix.patch
mm-page_allocc-introduce-kernelcore=mirror-option-fix.patch
mm-page_allocc-rework-code-layout-in-memmap_init_zone.patch
mm-hugetlbfs-unmap-pages-if-page-fault-raced-with-hole-punch-fix.patch
mm-soft-offline-exit-with-failure-for-non-anonymous-thp-fix.patch
kernel-stop_machinec-remove-config_smp-dependencies.patch
kernel-stop_machinec-remove-config_smp-dependencies-fix.patch
lib-vsprintfc-expand-field_width-to-24-bits-fix.patch
lib-test_printfc-test-dentry-printing-fix.patch
printk-help-pr_debug-and-pr_devel-to-optimize-out-arguments-fix.patch
printk-nmi-generic-solution-for-safe-printk-in-nmi-v4-fix-fix.patch
printk-nmi-warn-when-some-message-has-been-lost-in-nmi-context-fix.patch
ptrace-task_stopped_codeptrace-=-true-cant-see-task_stopped-task-fix.patch
ptrace-use-fsuid-fsgid-effective-creds-for-fs-access-checks-fix.patch
fs-coredump-prevent-core-path-components-fix.patch
ubsan-run-time-undefined-behavior-sanity-checker-fix.patch
ubsan-run-time-undefined-behavior-sanity-checker-fix-3.patch
linux-next-rejects.patch
fs-overlayfs-superc-needs-pagemaph.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
fs-adfs-adfsh-tidy-up-comments.patch
net-drop-tcp_memcontrolc-fix.patch
mm-memcontrol-reign-in-the-config-space-madness-fix.patch
mm-memcontrol-reign-in-the-config-space-madness-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch


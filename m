From: akpm@linux-foundation.org
Subject: + genalloc-add-devres-support-allow-to-find-a-managed-pool-by-device-fix.patch added to -mm tree
Date: Tue, 09 Apr 2013 15:49:52 -0700
Message-ID: <20130409224952.9D7B55A415E@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f201.google.com ([209.85.223.201]:45193 "EHLO
	mail-ie0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743Ab3DIWtz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Apr 2013 18:49:55 -0400
Received: by mail-ie0-f201.google.com with SMTP id a11so1897861iee.0
        for <mm-commits@vger.kernel.org>; Tue, 09 Apr 2013 15:49:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, dong.aisheng@linaro.org, fabio.estevam@freescale.com, grant.likely@secretlab.ca, gregkh@linuxfoundation.org, javier.martin@vista-silicon.com, monstr@monstr.eu, mporter@ti.com, p.zabel@pengutronix.de, paul.gortmaker@windriver.com, rob.herring@calxeda.com, shijie8@gmail.com


The patch titled
     Subject: genalloc-add-devres-support-allow-to-find-a-managed-pool-by-device-fix
has been added to the -mm tree.  Its filename is
     genalloc-add-devres-support-allow-to-find-a-managed-pool-by-device-fix.patch

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
Subject: genalloc-add-devres-support-allow-to-find-a-managed-pool-by-device-fix

make the of_get_named_gen_pool() stub static, fixing a zillion link errors

Cc: Dong Aisheng <dong.aisheng@linaro.org>
Cc: Fabio Estevam <fabio.estevam@freescale.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Huang Shijie <shijie8@gmail.com>
Cc: Javier Martin <javier.martin@vista-silicon.com>
Cc: Matt Porter <mporter@ti.com>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Rob Herring <rob.herring@calxeda.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/genalloc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/genalloc.h~genalloc-add-devres-support-allow-to-find-a-managed-pool-by-device-fix include/linux/genalloc.h
--- a/include/linux/genalloc.h~genalloc-add-devres-support-allow-to-find-a-managed-pool-by-device-fix
+++ a/include/linux/genalloc.h
@@ -114,7 +114,7 @@ struct device_node;
 extern struct gen_pool *of_get_named_gen_pool(struct device_node *np,
 	const char *propname, int index);
 #else
-inline struct gen_pool *of_get_named_gen_pool(struct device_node *np,
+static inline struct gen_pool *of_get_named_gen_pool(struct device_node *np,
 	const char *propname, int index)
 {
 	return NULL;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
revert-ipc-dont-allocate-a-copy-larger-than-max.patch
mips-define-kvm_user_mem_slots.patch
auditsc-use-kzalloc-instead-of-kmallocmemset-fix.patch
drivers-video-implement-a-simple-framebuffer-driver-fix.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
mm.patch
mm-shmemc-remove-an-ifdef.patch
xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module-fix.patch
memcg-relax-memcg-iter-caching-checkpatch-fixes.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation.patch
kexec-vmalloc-export-additional-vmalloc-layer-information-fix.patch
mm-hugetlb-include-hugepages-in-meminfo-checkpatch-fixes.patch
mm-speedup-in-__early_pfn_to_nid.patch
mm-speedup-in-__early_pfn_to_nid-fix.patch
include-linux-memoryh-implement-register_hotmemory_notifier.patch
mm-limit-growth-of-3%-hardcoded-other-user-reserve.patch
mm-replace-hardcoded-3%-with-admin_reserve_pages-knob.patch
mm-reinititalise-user-and-admin-reserves-if-memory-is-added-or-removed-fix.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
genalloc-add-devres-support-allow-to-find-a-managed-pool-by-device-fix.patch
misc-generic-on-chip-sram-allocation-driver-fix.patch
kernel-smpc-cleanups.patch
early_printk-consolidate-random-copies-of-identical-code-v3-fix.patch
include-linux-printkh-include-stdargh.patch
get_maintainer-use-filename-only-regex-match-for-tegra-fix.patch
argv_split-teach-it-to-handle-mutable-strings-fix.patch
kernel-timerc-ove-some-non-timer-related-syscalls-to-kernel-sysc-checkpatch-fixes.patch
epoll-trim-epitem-by-one-cache-line-on-x86_64-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
init-mainc-convert-to-pr_foo.patch
rtc-ds1307-long-block-operations-bugfix.patch
hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid-fix.patch
usermodehelper-export-_exec-and-_setup-functions-fix.patch
kexec-use-min_t-to-simplify-logic-fix.patch
ipc-introduce-obtaining-a-lockless-ipc-object-fix.patch
ipcsem-open-code-and-rename-sem_lock-fix.patch
kernel-pidc-improve-flow-of-a-loop-inside-alloc_pidmap-fix.patch
pid_namespacec-h-simplify-defines-fix.patch
drivers-net-rename-random32-to-prandom_u32-fix.patch
gadget-remove-only-user-of-aio-retry-checkpatch-fixes.patch
aio-remove-retry-based-aio-checkpatch-fixes.patch
aio-add-kiocb_cancel.patch
aio-make-aio_put_req-lockless-checkpatch-fixes.patch
aio-refcounting-cleanup-checkpatch-fixes.patch
wait-add-wait_event_hrtimeout.patch
aio-make-aio_read_evt-more-efficient-convert-to-hrtimers-checkpatch-fixes.patch
aio-use-cancellation-list-lazily.patch
aio-give-shared-kioctx-fields-their-own-cachelines.patch
generic-dynamic-per-cpu-refcounting.patch
generic-dynamic-per-cpu-refcounting-checkpatch-fixes.patch
aio-dont-include-aioh-in-schedh.patch
aio-dont-include-aioh-in-schedh-fix.patch
aio-kill-ki_retry.patch
aio-kill-ki_retry-fix.patch
aio-kill-ki_retry-checkpatch-fixes.patch
block-prep-work-for-batch-completion-checkpatch-fixes.patch
block-prep-work-for-batch-completion-fix-2.patch
block-prep-work-for-batch-completion-fix-3.patch
block-prep-work-for-batch-completion-fix-3-fix.patch
block-aio-batch-completion-for-bios-kiocbs.patch
block-aio-batch-completion-for-bios-kiocbs-checkpatch-fixes.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


From: akpm@linux-foundation.org
Subject: + resource-add-release_mem_region_adjustable-fix-fix.patch added to -mm tree
Date: Wed, 10 Apr 2013 15:24:47 -0700
Message-ID: <20130410222447.E908431C022@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ia0-f201.google.com ([209.85.210.201]:60107 "EHLO
	mail-ia0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935132Ab3DJWYt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Apr 2013 18:24:49 -0400
Received: by mail-ia0-f201.google.com with SMTP id k25so237689iah.2
        for <mm-commits@vger.kernel.org>; Wed, 10 Apr 2013 15:24:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, jiang.liu@huawei.com, linuxram@us.ibm.com, rientjes@google.com, tangchen@cn.fujitsu.com, tmac@hp.com, toshi.kani@hp.com, wency@cn.fujitsu.com


The patch titled
     Subject: resource-add-release_mem_region_adjustable-fix-fix
has been added to the -mm tree.  Its filename is
     resource-add-release_mem_region_adjustable-fix-fix.patch

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
Subject: resource-add-release_mem_region_adjustable-fix-fix

switch back to GFP_KERNEL, less buggily

Cc: David Rientjes <rientjes@google.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: T Makphaibulchoke <tmac@hp.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |   29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff -puN kernel/resource.c~resource-add-release_mem_region_adjustable-fix-fix kernel/resource.c
--- a/kernel/resource.c~resource-add-release_mem_region_adjustable-fix-fix
+++ a/kernel/resource.c
@@ -1046,7 +1046,8 @@ int release_mem_region_adjustable(struct
 			resource_size_t start, resource_size_t size)
 {
 	struct resource **p;
-	struct resource *res, *new;
+	struct resource *res;
+	struct resource *new_res;
 	resource_size_t end;
 	int ret = -EINVAL;
 
@@ -1054,6 +1055,9 @@ int release_mem_region_adjustable(struct
 	if ((start < parent->start) || (end > parent->end))
 		return ret;
 
+	/* The kzalloc() result gets checked later */
+	new_res = kzalloc(sizeof(struct resource), GFP_KERNEL);
+
 	p = &parent->child;
 	write_lock(&resource_lock);
 
@@ -1091,32 +1095,33 @@ int release_mem_region_adjustable(struct
 						start - res->start);
 		} else {
 			/* split into two entries */
-			new = kzalloc(sizeof(struct resource), GFP_ATOMIC);
-			if (!new) {
+			if (!new_res) {
 				ret = -ENOMEM;
 				break;
 			}
-			new->name = res->name;
-			new->start = end + 1;
-			new->end = res->end;
-			new->flags = res->flags;
-			new->parent = res->parent;
-			new->sibling = res->sibling;
-			new->child = NULL;
+			new_res->name = res->name;
+			new_res->start = end + 1;
+			new_res->end = res->end;
+			new_res->flags = res->flags;
+			new_res->parent = res->parent;
+			new_res->sibling = res->sibling;
+			new_res->child = NULL;
 
 			ret = __adjust_resource(res, res->start,
 						start - res->start);
 			if (ret) {
-				kfree(new);
+				kfree(new_res);
 				break;
 			}
-			res->sibling = new;
+			res->sibling = new_res;
+			new_res = NULL;
 		}
 
 		break;
 	}
 
 	write_unlock(&resource_lock);
+	kfree(new_res);
 	return ret;
 }
 #endif	/* CONFIG_MEMORY_HOTPLUG */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
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
ipc-utilc-use-register_hotmemory_notifier.patch
mm-slubc-use-register_hotmemory_notifier.patch
a.patch
mm-limit-growth-of-3%-hardcoded-other-user-reserve.patch
mm-limit-growth-of-3%-hardcoded-other-user-reserve-fix.patch
mm-replace-hardcoded-3%-with-admin_reserve_pages-knob.patch
mm-replace-hardcoded-3%-with-admin_reserve_pages-knob-fix.patch
mm-reinititalise-user-and-admin-reserves-if-memory-is-added-or-removed-fix.patch
mm-reinititalise-user-and-admin-reserves-if-memory-is-added-or-removed-fix-fix.patch
resource-add-release_mem_region_adjustable-fix.patch
resource-add-release_mem_region_adjustable-fix-fix.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
genalloc-add-devres-support-allow-to-find-a-managed-pool-by-device-fix.patch
genalloc-add-devres-support-allow-to-find-a-managed-pool-by-device-fix-fix.patch
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


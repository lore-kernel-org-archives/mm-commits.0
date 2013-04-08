From: akpm@linux-foundation.org
Subject: [merged] drivers-staging-zcache-zcache-mainc-fix-build.patch removed from -mm tree
Date: Mon, 08 Apr 2013 12:18:04 -0700
Message-ID: <20130408191804.8823331C2E8@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:44905 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935467Ab3DHTSG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Apr 2013 15:18:06 -0400
Received: by mail-ob0-f202.google.com with SMTP id va7so418190obc.3
        for <mm-commits@vger.kernel.org>; Mon, 08 Apr 2013 12:18:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dan.magenheimer@oracle.com, gregkh@linuxfoundation.org, konrad.wilk@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/staging/zcache/zcache-main.c: fix build
has been removed from the -mm tree.  Its filename was
     drivers-staging-zcache-zcache-mainc-fix-build.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/staging/zcache/zcache-main.c: fix build

flush_dcache_page() takes a page*, not a void*.  It breaks ia64.

Remove this and another unused function.  Warnings remain:

drivers/staging/zcache/zcache-main.c: In function '__check_disable_cleancache':
drivers/staging/zcache/zcache-main.c:1837: warning: return from incompatible pointer type
drivers/staging/zcache/zcache-main.c: In function '__check_disable_frontswap':
drivers/staging/zcache/zcache-main.c:1838: warning: return from incompatible pointer type
drivers/staging/zcache/zcache-main.c: In function '__check_disable_frontswap_ignore_nonactive':
drivers/staging/zcache/zcache-main.c:1842: warning: return from incompatible pointer type

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/zcache/zcache-main.c |   26 -------------------------
 1 file changed, 26 deletions(-)

diff -puN drivers/staging/zcache/zcache-main.c~drivers-staging-zcache-zcache-mainc-fix-build drivers/staging/zcache/zcache-main.c
--- a/drivers/staging/zcache/zcache-main.c~drivers-staging-zcache-zcache-mainc-fix-build
+++ a/drivers/staging/zcache/zcache-main.c
@@ -277,32 +277,6 @@ static void zcache_obj_free(struct tmem_
 	kmem_cache_free(zcache_obj_cache, obj);
 }
 
-static bool page_is_zero_filled(void *ptr)
-{
-	unsigned int pos;
-	unsigned long *page;
-
-	page = (unsigned long *)ptr;
-
-	for (pos = 0; pos < PAGE_SIZE / sizeof(*page); pos++) {
-		if (page[pos])
-			return false;
-	}
-
-	return true;
-}
-
-static void handle_zero_filled_page(void *page)
-{
-	void *user_mem;
-
-	user_mem = kmap_atomic(page);
-	memset(user_mem, 0, PAGE_SIZE);
-	kunmap_atomic(user_mem);
-
-	flush_dcache_page(page);
-}
-
 static struct tmem_hostops zcache_hostops = {
 	.obj_alloc = zcache_obj_alloc,
 	.obj_free = zcache_obj_free,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
revert-ipc-dont-allocate-a-copy-larger-than-max.patch
mips-define-kvm_user_mem_slots.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
mm.patch
mm-shmemc-remove-an-ifdef.patch
xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module-fix.patch
memcg-relax-memcg-iter-caching-checkpatch-fixes.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-fix.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-fix-fix.patch
kexec-vmalloc-export-additional-vmalloc-layer-information-fix.patch
mm-hugetlb-include-hugepages-in-meminfo-checkpatch-fixes.patch
mm-speedup-in-__early_pfn_to_nid.patch
mm-speedup-in-__early_pfn_to_nid-fix.patch
mm-limit-growth-of-3%-hardcoded-other-user-reserve-checkpatch-fixes.patch
mm-replace-hardcoded-3%-with-admin_reserve_pages-knob-checkpatch-fixes.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
misc-generic-on-chip-sram-allocation-driver-fix.patch
kernel-smpc-cleanups.patch
early_printk-consolidate-random-copies-of-identical-code-v3-fix.patch
include-linux-printkh-include-stdargh.patch
get_maintainer-use-filename-only-regex-match-for-tegra-fix.patch
argv_split-teach-it-to-handle-mutable-strings-fix.patch
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


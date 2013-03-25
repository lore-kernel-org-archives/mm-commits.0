From: akpm@linux-foundation.org
Subject: [folded-merged] mm-speedup-in-__early_pfn_to_nid-fix-fix-2.patch removed from -mm tree
Date: Mon, 25 Mar 2013 14:56:40 -0700
Message-ID: <20130325215640.CBB8B5A419C@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:49399 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933353Ab3CYV4m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Mar 2013 17:56:42 -0400
Received: by mail-vb0-f74.google.com with SMTP id r6so667762vbi.1
        for <mm-commits@vger.kernel.org>; Mon, 25 Mar 2013 14:56:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hpa@zytor.com, kosaki.motohiro@gmail.com, linfeng@cn.fujitsu.com, mingo@elte.hu, rientjes@google.com, rja@sgi.com, tglx@linutronix.de, tony.luck@intel.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-speedup-in-__early_pfn_to_nid-fix-fix-2
has been removed from the -mm tree.  Its filename was
     mm-speedup-in-__early_pfn_to_nid-fix-fix-2.patch

This patch was dropped because it was folded into mm-speedup-in-__early_pfn_to_nid.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-speedup-in-__early_pfn_to_nid-fix-fix-2

fix comment formatting

Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Lin Feng <linfeng@cn.fujitsu.com>
Cc: Russ Anderson <rja@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/numa.c |    6 +++---
 mm/page_alloc.c     |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -puN arch/ia64/mm/numa.c~mm-speedup-in-__early_pfn_to_nid-fix-fix-2 arch/ia64/mm/numa.c
--- a/arch/ia64/mm/numa.c~mm-speedup-in-__early_pfn_to_nid-fix-fix-2
+++ a/arch/ia64/mm/numa.c
@@ -62,9 +62,9 @@ int __meminit __early_pfn_to_nid(unsigne
 {
 	int i, section = pfn >> PFN_SECTION_SHIFT, ssec, esec;
 	/*
-	   NOTE: The following SMP-unsafe globals are only used early
-	   in boot when the kernel is running single-threaded.
-	*/
+	 * NOTE: The following SMP-unsafe globals are only used early in boot
+	 * when the kernel is running single-threaded.
+	 */
 	static unsigned long __meminitdata last_start_pfn, last_end_pfn;
 	static int __meminitdata last_nid;
 
diff -puN mm/page_alloc.c~mm-speedup-in-__early_pfn_to_nid-fix-fix-2 mm/page_alloc.c
--- a/mm/page_alloc.c~mm-speedup-in-__early_pfn_to_nid-fix-fix-2
+++ a/mm/page_alloc.c
@@ -4187,8 +4187,8 @@ int __meminit __early_pfn_to_nid(unsigne
 	unsigned long start_pfn, end_pfn;
 	int i, nid;
 	/*
-	   NOTE: The following SMP-unsafe globals are only used early
-	   in boot when the kernel is running single-threaded.
+	 * NOTE: The following SMP-unsafe globals are only used early in boot
+	 * when the kernel is running single-threaded.
 	 */
 	static unsigned long __meminitdata last_start_pfn, last_end_pfn;
 	static int __meminitdata last_nid;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mips-define-kvm_user_mem_slots.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v3-fix.patch
mm.patch
mm-shmemc-remove-an-ifdef.patch
xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module-fix.patch
memcg-relax-memcg-iter-caching-checkpatch-fixes.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-fix.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-fix-fix.patch
kexec-vmalloc-export-additional-vmalloc-layer-information-fix.patch
mm-hugetlb-include-hugepages-in-meminfo-checkpatch-fixes.patch
mm-speedup-in-__early_pfn_to_nid.patch
mm-speedup-in-__early_pfn_to_nid-fix-fix-2-fix.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
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
aio-kill-ki_retry.patch
aio-kill-ki_retry-checkpatch-fixes.patch
block-prep-work-for-batch-completion-checkpatch-fixes.patch
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


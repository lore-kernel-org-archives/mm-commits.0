From: akpm@linux-foundation.org
Subject: + linux-next-rejects.patch added to -mm tree
Date: Mon, 07 Apr 2014 15:48:36 -0700
Message-ID: <53432b44.AeQHcDKRQoPGmdzL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40210 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044AbaDGWsh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Apr 2014 18:48:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, akpm@linux-foundation.org

Subject: + linux-next-rejects.patch added to -mm tree
To: akpm@linux-foundation.org
From: akpm@linux-foundation.org
Date: Mon, 07 Apr 2014 15:48:36 -0700


The patch titled
     Subject: linux-next-rejects
has been added to the -mm tree.  Its filename is
     linux-next-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-rejects.patch

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
Subject: linux-next-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/kernel/head.S |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN arch/arm64/kernel/head.S~linux-next-rejects arch/arm64/kernel/head.S
--- a/arch/arm64/kernel/head.S~linux-next-rejects
+++ a/arch/arm64/kernel/head.S
@@ -482,6 +482,17 @@ __create_page_tables:
 	ldr	x5, =FIXADDR_TOP		// Fixed mapping virtual address
 	add	x0, x26, #2 * PAGE_SIZE		// section table address
 	create_pgd_entry x26, x0, x5, x6, x7
+
+	/*
+	 * Since the page tables have been populated with non-cacheable
+	 * accesses (MMU disabled), invalidate the idmap and swapper page
+	 * tables again to remove any speculatively loaded cache lines.
+	 */
+	mov	x0, x25
+	add	x1, x26, #SWAPPER_DIR_SIZE
+	bl	__inval_cache_range
+
+	mov	lr, x27
 	ret
 ENDPROC(__create_page_tables)
 	.ltorg
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mmnuma-reorganize-change_pmd_range.patch
drivers-lguest-page_tablesc-rename-do_set_pte.patch
mm-add-debugfs-tunable-for-fault_around_order.patch
mm-per-thread-vma-caching.patch
mm-use-macros-from-compilerh-instead-of-__attribute__.patch
mm-vmallocc-enhance-vm_map_ram-comment.patch
mm-readaheadc-inline-ra_submit.patch
zram-use-zcomp-compressing-backends.patch
zram-return-error-valued-pointer-from-zcomp_create.patch
zram-propagate-error-to-user.patch
zram-support-req_discard.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype.patch
kernel-panicc-display-reason-at-end-pr_emerg.patch
fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts.patch
initramfs-debug-detected-compression-method.patch
slub-use-raw_cpu_inc-for-incrementing-statistics.patch
vmstat-use-raw_cpu_ops-to-avoid-false-positives-on-preemption-checks.patch
percpu-add-preemption-checks-to-__this_cpu-ops.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
maintainers-akpm-maintenance.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
mm.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagemap-redefine-callback-functions-for-page-table-walker-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
ufs-sb-mutex-merge-mutex_destroy-fix-v2-fix.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


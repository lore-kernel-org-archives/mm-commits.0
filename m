From: akpm@linux-foundation.org
Subject: + mm-reinititalise-user-and-admin-reserves-if-memory-is-added-or-removed-v9-checkpatch-fixes-fix.patch added to -mm tree
Date: Mon, 22 Apr 2013 16:48:57 -0700
Message-ID: <20130422234857.6C1545A4219@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:49560 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474Ab3DVXs6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 22 Apr 2013 19:48:58 -0400
Received: by mail-vc0-f201.google.com with SMTP id hz11so4881vcb.2
        for <mm-commits@vger.kernel.org>; Mon, 22 Apr 2013 16:48:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, agshew@gmail.com


The patch titled
     Subject: mm-reinititalise-user-and-admin-reserves-if-memory-is-added-or-removed-v9-checkpatch-fixes-fix
has been added to the -mm tree.  Its filename is
     mm-reinititalise-user-and-admin-reserves-if-memory-is-added-or-removed-v9-checkpatch-fixes-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fengguang Wu <fengguang.wu@intel.com>
Subject: mm-reinititalise-user-and-admin-reserves-if-memory-is-added-or-removed-v9-checkpatch-fixes-fix

make init_reserve_notifier() static

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Andrew Shewmaker <agshew@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mmap.c~mm-reinititalise-user-and-admin-reserves-if-memory-is-added-or-removed-v9-checkpatch-fixes-fix mm/mmap.c
--- a/mm/mmap.c~mm-reinititalise-user-and-admin-reserves-if-memory-is-added-or-removed-v9-checkpatch-fixes-fix
+++ a/mm/mmap.c
@@ -3205,7 +3205,7 @@ static struct notifier_block reserve_mem
 	.notifier_call = reserve_mem_notifier,
 };
 
-int __meminit init_reserve_notifier(void)
+static int __meminit init_reserve_notifier(void)
 {
 	if (register_hotmemory_notifier(&reserve_mem_nb))
 		printk("Failed registering memory add/remove notifier for admin reserve");
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

linux-next.patch
drivers-video-add-hyper-v-synthetic-video-frame-buffer-driver-fix.patch
hwpoison-check-dirty-flag-to-match-against-clean-page.patch
staging-zcache-enable-ramster-to-be-built-loaded-as-a-module-fix.patch
sparse-vmemmap-specify-vmemmap-population-range-in-bytes-fix.patch
x86-64-use-vmemmap_populate_basepages-for-pse-setups-fix.patch
mm-reinititalise-user-and-admin-reserves-if-memory-is-added-or-removed-v9-checkpatch-fixes-fix.patch
smp-give-warning-when-calling-smp_call_function_many-single-in-serving-irq.patch
x86-dont-show-trace-beyond-show_stacknull-null.patch
sparc32-make-show_stack-acquire-%fp-if-_ksp-is-not-specified.patch
dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors.patch
dmi-morph-dmi_dump_ids-into-dmi_format_ids-which-formats-into-a-buffer.patch
dump_stack-implement-arch-specific-hardware-description-in-task-dumps.patch
dump_stack-unify-debug-information-printed-by-show_regs.patch
arc-print-fatal-signals-reduce-duplicated-information.patch
drivers-rtc-rtc-max6902c-use-register-defines-instead-of-magic-numbers.patch
nilfs2-fix-issue-with-flush-kernel-thread-after-remount-in-ro-mode-because-of-drivers-internal-error-or-metadata-corruption-fix.patch
fat-additions-to-support-fat_fallocate-fix.patch
ipc-refactor-msg-list-search-into-separate-function-fix.patch
block-prep-work-for-batch-completion-fix-3-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
debugging-keep-track-of-page-owner-now-depends-on-stacktrace_support.patch


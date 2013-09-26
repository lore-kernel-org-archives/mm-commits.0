From: akpm@linux-foundation.org
Subject: + memblock-factor-out-of-top-down-allocation-hack.patch added to
 -mm tree
Date: Thu, 26 Sep 2013 15:54:04 -0700
Message-ID: <5244bb0c.IeJwWRdZ9+a2+Zkt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35560 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142Ab3IZWyF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Sep 2013 18:54:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, tangchen@cn.fujitsu.com, akpm@linux-foundation.org

Subject: + memblock-factor-out-of-top-down-allocation-hack.patch added to -mm tree
To: akpm@linux-foundation.org,tangchen@cn.fujitsu.com,zhangyanfei@cn.fujitsu.com
From: akpm@linux-foundation.org
Date: Thu, 26 Sep 2013 15:54:04 -0700


The patch titled
     Subject: memblock-factor-out-of-top-down-allocation-hack
has been added to the -mm tree.  Its filename is
     memblock-factor-out-of-top-down-allocation-hack.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memblock-factor-out-of-top-down-allocation-hack.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memblock-factor-out-of-top-down-allocation-hack.patch

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
Subject: memblock-factor-out-of-top-down-allocation-hack

make it build on non-x86

Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/memblock.c~memblock-factor-out-of-top-down-allocation-hack mm/memblock.c
--- a/mm/memblock.c~memblock-factor-out-of-top-down-allocation-hack
+++ a/mm/memblock.c
@@ -187,8 +187,11 @@ phys_addr_t __init_memblock memblock_fin
 	/* avoid allocating the first page */
 	start = max_t(phys_addr_t, start, PAGE_SIZE);
 	end = max(start, end);
+#ifdef CONFIG_X86
 	kernel_end = __pa_symbol(_end);
-
+#else
+	kernel_end = __pa(RELOC_HIDE((unsigned long)(_end), 0));
+#endif
 	/*
 	 * try bottom-up allocation only when bottom-up mode
 	 * is set and @end is above the kernel image.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix.patch
fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix-fix.patch
include-asm-generic-vtimeh-avoid-zero-length-file.patch
mm-avoid-reinserting-isolated-balloon-pages-into-lru-lists-fix.patch
ipc-semc-update-sem_otime-for-all-operations-checkpatch-fixes.patch
sound-soc-atmel-atmel-pcmc-fix-warning.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
mm.patch
memblock-factor-out-of-top-down-allocation-hack.patch
mm-thp-khugepaged-add-policy-for-finding-target-node-fix.patch
kernel-printk-printkc-convert-to-pr_foo.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
checkpatch-add-test-for-defines-of-arch_has_foo.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate.patch
fat-additions-to-support-fat_fallocate-v6-checkpatch-fixes.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
kernel-modulec-use-pr_foo.patch
kernel-gcov-fsc-use-pr_warn.patch
linux-next.patch
linux-next-rejects.patch
x86-mm-factor-out-of-top-down-direct-mapping-setup-next-fix.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


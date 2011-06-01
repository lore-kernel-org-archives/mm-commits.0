From: akpm@linux-foundation.org
Subject: + cris-fix-a-build-error-in-kernel-forkc-checkpatch-fixes.patch added to -mm tree
Date: Wed, 01 Jun 2011 15:08:40 -0700
Message-ID: <201106012208.p51M8eeW012525@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60018 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752033Ab1FAWJM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jun 2011 18:09:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, xiyou.wangcong@gmail.com


The patch titled
     cris-fix-a-build-error-in-kernel-forkc-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     cris-fix-a-build-error-in-kernel-forkc-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cris-fix-a-build-error-in-kernel-forkc-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#37: FILE: arch/cris/include/asm/thread_info.h:70:
+#define alloc_thread_info_node(tsk, node) ((struct thread_info *) __get_free_pages(GFP_KERNEL,1))

ERROR: space required after that ',' (ctx:VxV)
#37: FILE: arch/cris/include/asm/thread_info.h:70:
+#define alloc_thread_info_node(tsk, node) ((struct thread_info *) __get_free_pages(GFP_KERNEL,1))
                                                                                              ^

total: 1 errors, 1 warnings, 18 lines checked

./patches/cris-fix-a-build-error-in-kernel-forkc.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/include/asm/thread_info.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/cris/include/asm/thread_info.h~cris-fix-a-build-error-in-kernel-forkc-checkpatch-fixes arch/cris/include/asm/thread_info.h
--- a/arch/cris/include/asm/thread_info.h~cris-fix-a-build-error-in-kernel-forkc-checkpatch-fixes
+++ a/arch/cris/include/asm/thread_info.h
@@ -67,7 +67,8 @@ struct thread_info {
 
 #define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
 /* thread information allocation */
-#define alloc_thread_info_node(tsk, node) ((struct thread_info *) __get_free_pages(GFP_KERNEL,1))
+#define alloc_thread_info_node(tsk, node)	\
+	((struct thread_info *) __get_free_pages(GFP_KERNEL, 1))
 #define free_thread_info(ti) free_pages((unsigned long) (ti), 1)
 
 #endif /* !__ASSEMBLY__ */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
backlight-add-backlight-type-fix.patch
vmscanmemcg-memcg-aware-swap-token-fix.patch
vmscanmemcg-memcg-aware-swap-token-fix-checkpatch-fixes.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cris-fix-a-build-error-in-kernel-forkc-checkpatch-fixes.patch
drivers-base-platformc-dont-mark-platform_device_register_resndata-as-__init_or_module.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
slab-use-numa_no_node.patch
mm.patch
writeback-sync-expired-inodes-first-in-background-writeback-fix.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix-fix.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix-fix-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
checkpatch-suggest-using-min_t-or-max_t-v2.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
rtc-driver-for-pt7c4338-chip-checkpatch-fixes.patch
rtc-driver-for-pt7c4338-chip-fix.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
kexec-remove-kmsg_dump_kexec-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch


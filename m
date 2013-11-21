From: akpm@linux-foundation.org
Subject: + arch-um-kernel-sysrqc-rename-print_stack_trace.patch added to
 -mm tree
Date: Thu, 21 Nov 2013 15:20:01 -0800
Message-ID: <528e9521.A+vOgbjoLJjLdyzn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49762 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452Ab3KUXUC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Nov 2013 18:20:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, richrd@nod.at, fengguang.wu@intel.com, akpm@linux-foundation.org

Subject: + arch-um-kernel-sysrqc-rename-print_stack_trace.patch added to -mm tree
To: akpm@linux-foundation.org,fengguang.wu@intel.com,richrd@nod.at
From: akpm@linux-foundation.org
Date: Thu, 21 Nov 2013 15:20:01 -0800


The patch titled
     Subject: arch/um/kernel/sysrq.c: rename print_stack_trace()
has been added to the -mm tree.  Its filename is
     arch-um-kernel-sysrqc-rename-print_stack_trace.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-um-kernel-sysrqc-rename-print_stack_trace.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-um-kernel-sysrqc-rename-print_stack_trace.patch

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
Subject: arch/um/kernel/sysrq.c: rename print_stack_trace()

This symbol conflicts with include/linux/stacktrace.h:print_stack_trace().
If sysrq.c sees stacktrace.h, the build blows up.  I have a local debug
patch whcih triggers this.

So s/print_stack_trace/um_print_stack_trace/

Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Richard Weinberger <richrd@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/sysrq.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/um/kernel/sysrq.c~arch-um-kernel-sysrqc-rename-print_stack_trace arch/um/kernel/sysrq.c
--- a/arch/um/kernel/sysrq.c~arch-um-kernel-sysrqc-rename-print_stack_trace
+++ a/arch/um/kernel/sysrq.c
@@ -19,7 +19,7 @@ struct stack_frame {
 	unsigned long return_address;
 };
 
-static void print_stack_trace(unsigned long *sp, unsigned long bp)
+static void um_print_stack_trace(unsigned long *sp, unsigned long bp)
 {
 	int reliable;
 	unsigned long addr;
@@ -94,5 +94,5 @@ void show_stack(struct task_struct *task
 	}
 	printk(KERN_CONT "\n");
 
-	print_stack_trace(sp, bp);
+	um_print_stack_trace(sp, bp);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm-thp-give-transparent-hugepage-code-a-separate-copy_page.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
block-blk-mq-cpuc-use-hotcpu_notifier.patch
posix_acl-uninlining.patch
mm.patch
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch
mm-swapc-reorganize-put_compound_page.patch
mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve-fix.patch
arch-um-kernel-sysrqc-rename-print_stack_trace.patch
lib-parserc-put-export_symbols-in-the-conventional-place.patch
kernel-paramsc-improve-standard-definitions-checkpatch-fixes.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
linux-next.patch
linux-next-rejects.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


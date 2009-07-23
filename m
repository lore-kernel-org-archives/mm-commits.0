From: akpm@linux-foundation.org
Subject: + linux-futexh-place-kernel-types-behind-__kernel__.patch added to -mm tree
Date: Thu, 23 Jul 2009 15:20:24 -0700
Message-ID: <200907232220.n6NMKOEI012409@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49697 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753895AbZGWWUr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Jul 2009 18:20:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, mingo@elte.hu, tglx@linutronix.de


The patch titled
     linux/futex.h: place kernel types behind __KERNEL__
has been added to the -mm tree.  Its filename is
     linux-futexh-place-kernel-types-behind-__kernel__.patch

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
Subject: linux/futex.h: place kernel types behind __KERNEL__
From: Mike Frysinger <vapier@gentoo.org>

The forward decls for some kernel types are only needed by the code behind
__KERNEL__, so don't bleed these types to userspace.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/futex.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN include/linux/futex.h~linux-futexh-place-kernel-types-behind-__kernel__ include/linux/futex.h
--- a/include/linux/futex.h~linux-futexh-place-kernel-types-behind-__kernel__
+++ a/include/linux/futex.h
@@ -4,11 +4,6 @@
 #include <linux/compiler.h>
 #include <linux/types.h>
 
-struct inode;
-struct mm_struct;
-struct task_struct;
-union ktime;
-
 /* Second argument to futex syscall */
 
 
@@ -129,6 +124,11 @@ struct robust_list_head {
 #define FUTEX_BITSET_MATCH_ANY	0xffffffff
 
 #ifdef __KERNEL__
+struct inode;
+struct mm_struct;
+struct task_struct;
+union ktime;
+
 long do_futex(u32 __user *uaddr, int op, u32 val, union ktime *timeout,
 	      u32 __user *uaddr2, u32 val2, u32 val3);
 
_

Patches currently in -mm which might be from vapier@gentoo.org are

linux-next.patch
pcmcia-yenta-add-missing-__devexit-marking.patch
preempt_active-add-default-defines.patch
flat-fix-uninitialized-ptr-with-shared-libs.patch
serial-bfin_5xx-fix-building-as-module-when-early-printk-is-enabled.patch
asm-sections-add-text-data-checking-functions-for-arches-to-override.patch
kallsyms-use-new-arch_is_kernel_text.patch
lockdep-use-new-arch_is_kernel_data.patch
blackfin-override-text-data-checking-functions.patch
rtc-update-documentation-wrt-rtc_pie-irq_set_state.patch
rtc-bfin-do-not-share-rtc-irq.patch
fdpic-ignore-the-loaders-pt_gnu_stack-when-calculating-the-stack-size.patch
flat-use-is_err_value-helper-macro.patch
linux-futexh-place-kernel-types-behind-__kernel__.patch


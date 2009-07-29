From: akpm@linux-foundation.org
Subject: + generic-ipi-fix-hotplug_cfd.patch added to -mm tree
Date: Wed, 29 Jul 2009 16:31:39 -0700
Message-ID: <200907292331.n6TNVd2j031567@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57103 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754690AbZG2Xb6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jul 2009 19:31:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiaoguangrong@cn.fujitsu.com, jens.axboe@oracle.com, mingo@elte.hu, nickpiggin@yahoo.com.au, peterz@infradead.org, rusty@rustcorp.com.au


The patch titled
     generic-ipi: fix hotplug_cfd()
has been added to the -mm tree.  Its filename is
     generic-ipi-fix-hotplug_cfd.patch

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
Subject: generic-ipi: fix hotplug_cfd()
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

Use CONFIG_HOTPLUG_CPU, not CONFIG_CPU_HOTPLUG

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/smp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/smp.c~generic-ipi-fix-hotplug_cfd kernel/smp.c
--- a/kernel/smp.c~generic-ipi-fix-hotplug_cfd
+++ a/kernel/smp.c
@@ -57,7 +57,7 @@ hotplug_cfd(struct notifier_block *nfb, 
 			return NOTIFY_BAD;
 		break;
 
-#ifdef CONFIG_CPU_HOTPLUG
+#ifdef CONFIG_HOTPLUG_CPU
 	case CPU_UP_CANCELED:
 	case CPU_UP_CANCELED_FROZEN:
 
_

Patches currently in -mm which might be from xiaoguangrong@cn.fujitsu.com are

generic-ipi-fix-hotplug_cfd.patch
generic-ipi-cleanup-for-generic_smp_call_function_interrupt.patch
kernel-smpc-relocate-some-code.patch
generic-ipi-fix-the-race-between-generic_smp_call_function_-and-hotplug_cfd.patch
generic-ipi-make-struct-call_function_data-lockless.patch
generic-ipi-make-struct-call_function_data-lockless-cleanup.patch


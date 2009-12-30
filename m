From: akpm@linux-foundation.org
Subject: + kernel-cpuc-delete-deprecated-definition-in-cpu_up.patch added to -mm tree
Date: Wed, 30 Dec 2009 15:25:01 -0800
Message-ID: <200912302325.nBUNP109008053@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44381 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751416AbZL3XZw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Dec 2009 18:25:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gong.chen@linux.intel.com, mingo@elte.hu, rusty@rustcorp.com.au


The patch titled
     kernel/cpu.c: delete deprecated definition in cpu_up()
has been added to the -mm tree.  Its filename is
     kernel-cpuc-delete-deprecated-definition-in-cpu_up.patch

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
Subject: kernel/cpu.c: delete deprecated definition in cpu_up()
From: Chen Gong <gong.chen@linux.intel.com>

Additional_cpus is only supported for IA64 now.  X86_64 should not be
included.

Signed-off-by: Chen Gong <gong.chen@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/cpu.c~kernel-cpuc-delete-deprecated-definition-in-cpu_up kernel/cpu.c
--- a/kernel/cpu.c~kernel-cpuc-delete-deprecated-definition-in-cpu_up
+++ a/kernel/cpu.c
@@ -338,7 +338,7 @@ int __cpuinit cpu_up(unsigned int cpu)
 	if (!cpu_possible(cpu)) {
 		printk(KERN_ERR "can't online cpu %d because it is not "
 			"configured as may-hotadd at boot time\n", cpu);
-#if defined(CONFIG_IA64) || defined(CONFIG_X86_64)
+#if defined(CONFIG_IA64)
 		printk(KERN_ERR "please check additional_cpus= boot "
 				"parameter\n");
 #endif
_

Patches currently in -mm which might be from gong.chen@linux.intel.com are

kernel-cpuc-delete-deprecated-definition-in-cpu_up.patch


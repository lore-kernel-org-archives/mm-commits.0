From: akpm@linux-foundation.org
Subject: + x86-mce-use-new-printk-recursion-disabling-interface.patch added to -mm tree
Date: Fri, 22 Jun 2012 16:41:58 -0700
Message-ID: <20120622234158.CD33AA01BD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:47062 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756463Ab2FVXmA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Jun 2012 19:42:00 -0400
Received: by vcbfl13 with SMTP id fl13so266959vcb.1
        for <mm-commits@vger.kernel.org>; Fri, 22 Jun 2012 16:41:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shuox.liu@intel.com, hpa@zytor.com, mingo@elte.hu, tglx@tglx.de, tony.luck@intel.com, yanmin_zhang@linux.intel.com


The patch titled
     Subject: x86 mce: use new printk recursion disabling interface
has been added to the -mm tree.  Its filename is
     x86-mce-use-new-printk-recursion-disabling-interface.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: ShuoX Liu <shuox.liu@intel.com>
Subject: x86 mce: use new printk recursion disabling interface

Disable printk recursion to make sure the MCE logs are printed out.  We
hit it when running a MTBF testing on a Android atom mobile.

Signed-off-by: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Signed-off-by: ShuoX Liu <shuox.liu@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@tglx.de>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/mcheck/mce.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/x86/kernel/cpu/mcheck/mce.c~x86-mce-use-new-printk-recursion-disabling-interface arch/x86/kernel/cpu/mcheck/mce.c
--- a/arch/x86/kernel/cpu/mcheck/mce.c~x86-mce-use-new-printk-recursion-disabling-interface
+++ a/arch/x86/kernel/cpu/mcheck/mce.c
@@ -307,6 +307,7 @@ static void mce_panic(char *msg, struct 
 {
 	int i, apei_err = 0;
 
+	printk_recursion_check_disable();
 	if (!fake_panic) {
 		/*
 		 * Make sure only one CPU runs in machine check panic
@@ -361,6 +362,7 @@ static void mce_panic(char *msg, struct 
 		panic(msg);
 	} else
 		pr_emerg(HW_ERR "Fake kernel panic: %s\n", msg);
+	printk_recursion_check_enable();
 }
 
 /* Support code for software error injection */
_
Subject: Subject: x86 mce: use new printk recursion disabling interface

Patches currently in -mm which might be from shuox.liu@intel.com are

cpuidle-move-field-disable-from-per-driver-to-per-cpu.patch
printk-add-interface-for-disabling-recursion-check.patch
x86-mce-use-new-printk-recursion-disabling-interface.patch
x86-mce-use-new-printk-recursion-disabling-interface-fix.patch


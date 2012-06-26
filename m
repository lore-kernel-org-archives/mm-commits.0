From: akpm@linux-foundation.org
Subject: [to-be-updated] x86-mce-use-new-printk-recursion-disabling-interface.patch removed from -mm tree
Date: Tue, 26 Jun 2012 13:54:47 -0700
Message-ID: <20120626205447.54A57A02C5@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:45069 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531Ab2FZUyt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jun 2012 16:54:49 -0400
Received: by eaao13 with SMTP id o13so17252eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 26 Jun 2012 13:54:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shuox.liu@intel.com, hpa@zytor.com, mingo@elte.hu, tglx@tglx.de, tony.luck@intel.com, yanmin_zhang@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: x86 mce: use new printk recursion disabling interface
has been removed from the -mm tree.  Its filename was
     x86-mce-use-new-printk-recursion-disabling-interface.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

Patches currently in -mm which might be from shuox.liu@intel.com are

cpuidle-move-field-disable-from-per-driver-to-per-cpu.patch
x86-mce-use-new-printk-recursion-disabling-interface-fix.patch


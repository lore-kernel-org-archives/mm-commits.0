From: akpm@linux-foundation.org
Subject: [merged]
 smph-fix-x86cpuc-sparse-warnings-about-arch-nonboot-cpu-calls.patch removed from -mm tree
Date: Tue, 11 Feb 2014 11:23:46 -0800
Message-ID: <52fa78c2.Wxo6hefoh5c+REwS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40912 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754943AbaBKTXr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Feb 2014 14:23:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, paul.gortmaker@windriver.com

Subject: [merged] smph-fix-x86cpuc-sparse-warnings-about-arch-nonboot-cpu-calls.patch removed from -mm tree
To: paul.gortmaker@windriver.com,hpa@zytor.com,mingo@redhat.com,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 11 Feb 2014 11:23:46 -0800


The patch titled
     Subject: smp.h: fix x86+cpu.c sparse warnings about arch nonboot CPU calls
has been removed from the -mm tree.  Its filename was
     smph-fix-x86cpuc-sparse-warnings-about-arch-nonboot-cpu-calls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: smp.h: fix x86+cpu.c sparse warnings about arch nonboot CPU calls

Use what we already do for arch_disable_smp_support() to fix these:

  arch/x86/kernel/smpboot.c:1155:6: warning: symbol 'arch_enable_nonboot_cpus_begin' was not declared. Should it be static?
  arch/x86/kernel/smpboot.c:1160:6: warning: symbol 'arch_enable_nonboot_cpus_end' was not declared. Should it be static?
  kernel/cpu.c:512:13: warning: symbol 'arch_enable_nonboot_cpus_begin' was not declared. Should it be static?
  kernel/cpu.c:516:13: warning: symbol 'arch_enable_nonboot_cpus_end' was not declared. Should it be static?

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/smp.h |    3 +++
 1 file changed, 3 insertions(+)

diff -puN include/linux/smp.h~smph-fix-x86cpuc-sparse-warnings-about-arch-nonboot-cpu-calls include/linux/smp.h
--- a/include/linux/smp.h~smph-fix-x86cpuc-sparse-warnings-about-arch-nonboot-cpu-calls
+++ a/include/linux/smp.h
@@ -188,6 +188,9 @@ static inline void kick_all_cpus_sync(vo
  */
 extern void arch_disable_smp_support(void);
 
+extern void arch_enable_nonboot_cpus_begin(void);
+extern void arch_enable_nonboot_cpus_end(void);
+
 void smp_setup_processor_id(void);
 
 #endif /* __LINUX_SMP_H */
_

Patches currently in -mm which might be from paul.gortmaker@windriver.com are

origin.patch
kernel-audit-fix-non-modular-users-of-module_init-in-core-code.patch
linux-next.patch


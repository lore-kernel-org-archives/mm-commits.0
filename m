From: akpm@linux-foundation.org
Subject: +
 smph-fix-x86cpuc-sparse-warnings-about-arch-nonboot-cpu-calls.patch added
 to -mm tree
Date: Fri, 07 Feb 2014 14:57:08 -0800
Message-ID: <52f564c4.iT8UghN3a3nhFG7H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59809 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaBGW5J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Feb 2014 17:57:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, paul.gortmaker@windriver.com

Subject: + smph-fix-x86cpuc-sparse-warnings-about-arch-nonboot-cpu-calls.patch added to -mm tree
To: paul.gortmaker@windriver.com,hpa@zytor.com,mingo@redhat.com,tglx@linutronix.de
From: akpm@linux-foundation.org
Date: Fri, 07 Feb 2014 14:57:08 -0800


The patch titled
     Subject: smp.h: fix x86+cpu.c sparse warnings about arch nonboot CPU calls
has been added to the -mm tree.  Its filename is
     smph-fix-x86cpuc-sparse-warnings-about-arch-nonboot-cpu-calls.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/smph-fix-x86cpuc-sparse-warnings-about-arch-nonboot-cpu-calls.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/smph-fix-x86cpuc-sparse-warnings-about-arch-nonboot-cpu-calls.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
smph-fix-x86cpuc-sparse-warnings-about-arch-nonboot-cpu-calls.patch
kernel-audit-fix-non-modular-users-of-module_init-in-core-code.patch
linux-next.patch


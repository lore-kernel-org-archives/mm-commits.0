From: akpm@linux-foundation.org
Subject: + kexec-remove-obsolete-flag-in_crash_kexec.patch added to -mm
 tree
Date: Mon, 05 Oct 2015 13:25:26 -0700
Message-ID: <5612dcb6.KsO/ofyyNZTYL/cx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56956 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbbJEUZ1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Oct 2015 16:25:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mnfhuang@gmail.com, dzickus@redhat.com, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: Remove obsolete flag 'in_crash_kexec'
has been added to the -mm tree.  Its filename is
     kexec-remove-obsolete-flag-in_crash_kexec.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kexec-remove-obsolete-flag-in_crash_kexec.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kexec-remove-obsolete-flag-in_crash_kexec.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minfei Huang <mnfhuang@gmail.com>
Subject: kexec: Remove obsolete flag 'in_crash_kexec'

Previously, UV NMI used 'in_crash_kexec' flag to be sure that we are in
kdump kernel or not in commit 5edd19af18a36a4e ("x86, UV: Make kdump avoid
stack dumps").  But this flags is removed in commit 9c48f1c629ecfa114850c0
("x86, nmi: Wire up NMI handlers to new routines").

Since it isn't used any more, remove it.

Signed-off-by: Minfei Huang <mnfhuang@gmail.com>
Acked-by: Don Zickus <dzickus@redhat.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/kdebug.h |    6 ------
 arch/x86/kernel/crash.c       |    3 ---
 2 files changed, 9 deletions(-)

diff -puN arch/x86/include/asm/kdebug.h~kexec-remove-obsolete-flag-in_crash_kexec arch/x86/include/asm/kdebug.h
--- a/arch/x86/include/asm/kdebug.h~kexec-remove-obsolete-flag-in_crash_kexec
+++ a/arch/x86/include/asm/kdebug.h
@@ -29,11 +29,5 @@ extern void show_trace(struct task_struc
 extern void __show_regs(struct pt_regs *regs, int all);
 extern unsigned long oops_begin(void);
 extern void oops_end(unsigned long, struct pt_regs *, int signr);
-#ifdef CONFIG_KEXEC_CORE
-extern int in_crash_kexec;
-#else
-/* no crash dump is ever in progress if no crash kernel can be kexec'd */
-#define in_crash_kexec 0
-#endif
 
 #endif /* _ASM_X86_KDEBUG_H */
diff -puN arch/x86/kernel/crash.c~kexec-remove-obsolete-flag-in_crash_kexec arch/x86/kernel/crash.c
--- a/arch/x86/kernel/crash.c~kexec-remove-obsolete-flag-in_crash_kexec
+++ a/arch/x86/kernel/crash.c
@@ -75,8 +75,6 @@ struct crash_memmap_data {
 	unsigned int type;
 };
 
-int in_crash_kexec;

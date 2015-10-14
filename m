From: akpm@linux-foundation.org
Subject: [merged] kexec-remove-obsolete-flag-in_crash_kexec.patch removed
 from -mm tree
Date: Wed, 14 Oct 2015 12:51:25 -0700
Message-ID: <561eb23d.N8buwv/JCQBZD3m+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47828 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145AbbJNTv0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Oct 2015 15:51:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mnfhuang@gmail.com, dzickus@redhat.com, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: Remove obsolete flag 'in_crash_kexec'
has been removed from the -mm tree.  Its filename was
     kexec-remove-obsolete-flag-in_crash_kexec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

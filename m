From: akpm@linux-foundation.org
Subject: + ptrace-unify-fdpic-implementations.patch added to -mm tree
Date: Fri, 21 May 2010 14:37:35 -0700
Message-ID: <201005212137.o4LLbZKf002827@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41640 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752881Ab0EUVht (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 May 2010 17:37:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, dhowells@redhat.com, lethal@linux-sh.org, oleg@redhat.com, roland@redhat.com


The patch titled
     ptrace: unify FDPIC implementations
has been added to the -mm tree.  Its filename is
     ptrace-unify-fdpic-implementations.patch

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
Subject: ptrace: unify FDPIC implementations
From: Mike Frysinger <vapier@gentoo.org>

The Blackfin/FRV/SuperH guys all have the same exact FDPIC ptrace code in
their arch handlers (since they were probably copied & pasted).  Since
these ptrace interfaces are an arch independent aspect of the FDPIC code,
unify them in the common ptrace code so new FDPIC ports don't need to copy
and paste this fundamental stuff yet again.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Acked-by: Roland McGrath <roland@redhat.com>
Acked-by: David Howells <dhowells@redhat.com>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/kernel/ptrace.c |   33 ++++++++------------------------
 arch/frv/kernel/ptrace.c      |   20 -------------------
 arch/sh/kernel/ptrace_32.c    |   23 ----------------------
 kernel/ptrace.c               |   20 +++++++++++++++++++
 4 files changed, 29 insertions(+), 67 deletions(-)

diff -puN arch/blackfin/kernel/ptrace.c~ptrace-unify-fdpic-implementations arch/blackfin/kernel/ptrace.c
--- a/arch/blackfin/kernel/ptrace.c~ptrace-unify-fdpic-implementations
+++ a/arch/blackfin/kernel/ptrace.c
@@ -292,28 +292,6 @@ long arch_ptrace(struct task_struct *chi
 			break;
 		}
 
-#ifdef CONFIG_BINFMT_ELF_FDPIC
-	case PTRACE_GETFDPIC: {
-		unsigned long tmp = 0;
-
-		switch (addr) {
-		case_PTRACE_GETFDPIC_EXEC:
-		case PTRACE_GETFDPIC_EXEC:
-			tmp = child->mm->context.exec_fdpic_loadmap;
-			break;
-		case_PTRACE_GETFDPIC_INTERP:
-		case PTRACE_GETFDPIC_INTERP:
-			tmp = child->mm->context.interp_fdpic_loadmap;
-			break;
-		default:
-			break;
-		}
-
-		ret = put_user(tmp, datap);
-		break;
-	}
-#endif
-
 		/* when I and D space are separate, this will have to be fixed. */
 	case PTRACE_POKEDATA:
 		pr_debug("ptrace: PTRACE_PEEKDATA\n");
@@ -357,8 +335,14 @@ long arch_ptrace(struct task_struct *chi
 	case PTRACE_PEEKUSR:
 		switch (addr) {
 #ifdef CONFIG_BINFMT_ELF_FDPIC	/* backwards compat */
-		case PT_FDPIC_EXEC:   goto case_PTRACE_GETFDPIC_EXEC;
-		case PT_FDPIC_INTERP: goto case_PTRACE_GETFDPIC_INTERP;
+		case PT_FDPIC_EXEC:
+			request = PTRACE_GETFDPIC;
+			addr = PTRACE_GETFDPIC_EXEC;
+			goto case_default;
+		case PT_FDPIC_INTERP:
+			request = PTRACE_GETFDPIC;
+			addr = PTRACE_GETFDPIC_INTERP;
+			goto case_default;
 #endif
 		default:
 			ret = get_reg(child, addr, datap);
@@ -385,6 +369,7 @@ long arch_ptrace(struct task_struct *chi
 					     0, sizeof(struct pt_regs),
 					     (const void __user *)data);
 
+	case_default:
 	default:
 		ret = ptrace_request(child, request, addr, data);
 		break;
diff -puN arch/frv/kernel/ptrace.c~ptrace-unify-fdpic-implementations arch/frv/kernel/ptrace.c
--- a/arch/frv/kernel/ptrace.c~ptrace-unify-fdpic-implementations
+++ a/arch/frv/kernel/ptrace.c
@@ -344,26 +344,6 @@ long arch_ptrace(struct task_struct *chi
 					     0, sizeof(child->thread.user->f),
 					     (const void __user *)data);
 
-	case PTRACE_GETFDPIC:
-		tmp = 0;
-		switch (addr) {
-		case PTRACE_GETFDPIC_EXEC:
-			tmp = child->mm->context.exec_fdpic_loadmap;
-			break;
-		case PTRACE_GETFDPIC_INTERP:
-			tmp = child->mm->context.interp_fdpic_loadmap;
-			break;
-		default:
-			break;
-		}
-
-		ret = 0;
-		if (put_user(tmp, (unsigned long *) data)) {
-			ret = -EFAULT;
-			break;
-		}
-		break;
-
 	default:
 		ret = ptrace_request(child, request, addr, data);
 		break;
diff -puN arch/sh/kernel/ptrace_32.c~ptrace-unify-fdpic-implementations arch/sh/kernel/ptrace_32.c
--- a/arch/sh/kernel/ptrace_32.c~ptrace-unify-fdpic-implementations
+++ a/arch/sh/kernel/ptrace_32.c
@@ -436,29 +436,6 @@ long arch_ptrace(struct task_struct *chi
 					     0, sizeof(struct pt_dspregs),
 					     (const void __user *)data);
 #endif
-#ifdef CONFIG_BINFMT_ELF_FDPIC
-	case PTRACE_GETFDPIC: {
-		unsigned long tmp = 0;
-
-		switch (addr) {
-		case PTRACE_GETFDPIC_EXEC:
-			tmp = child->mm->context.exec_fdpic_loadmap;
-			break;
-		case PTRACE_GETFDPIC_INTERP:
-			tmp = child->mm->context.interp_fdpic_loadmap;
-			break;
-		default:
-			break;
-		}
-
-		ret = 0;
-		if (put_user(tmp, datap)) {
-			ret = -EFAULT;
-			break;
-		}
-		break;
-	}
-#endif
 	default:
 		ret = ptrace_request(child, request, addr, data);
 		break;
diff -puN kernel/ptrace.c~ptrace-unify-fdpic-implementations kernel/ptrace.c
--- a/kernel/ptrace.c~ptrace-unify-fdpic-implementations
+++ a/kernel/ptrace.c
@@ -594,6 +594,26 @@ int ptrace_request(struct task_struct *c
 		ret = ptrace_detach(child, data);
 		break;
 
+#ifdef CONFIG_BINFMT_ELF_FDPIC
+	case PTRACE_GETFDPIC: {
+		unsigned long tmp = 0;
+
+		switch (addr) {
+		case PTRACE_GETFDPIC_EXEC:
+			tmp = child->mm->context.exec_fdpic_loadmap;
+			break;
+		case PTRACE_GETFDPIC_INTERP:
+			tmp = child->mm->context.interp_fdpic_loadmap;
+			break;
+		default:
+			break;
+		}
+
+		ret = put_user(tmp, (unsigned long __user *) data);
+		break;
+	}
+#endif
+
 #ifdef PTRACE_SINGLESTEP
 	case PTRACE_SINGLESTEP:
 #endif
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
linux-next.patch
nommu-allow-private-mappings-of-read-only-devices.patch
ad525x_dpot-simplify-duplicated-sysfs-defines.patch
ad525x_dpot-extend-write-argument-to-16bits.patch
ad525x_dpot-add-support-for-spi-parts.patch
ad525x_dpot-add-support-for-ad524x-pots.patch
ad525x_dpot-add-support-for-adn2860-and-ad528x-pots.patch
ad525x_dpot-add-support-for-one-time-programmable-pots.patch
fbdev-bfin-lq035q1-fb-respect-new-ppi-mode-platform-field.patch
ptrace-unify-fdpic-implementations.patch
blackfin-use-use-asm-generic-scatterlisth.patch


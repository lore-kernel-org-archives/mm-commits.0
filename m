From: akpm@linux-foundation.org
Subject: + ptrace_peekdata-consolidation.patch added to -mm tree
Date: Tue, 12 Jun 2007 12:51:13 -0700
Message-ID: <200706121951.l5CJpDQd019907@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38766 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752714AbXFLTwn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jun 2007 15:52:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, hch@lst.de, linux-arch@vger.kernel.org


The patch titled
     PTRACE_PEEKDATA consolidation
has been added to the -mm tree.  Its filename is
     ptrace_peekdata-consolidation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: PTRACE_PEEKDATA consolidation
From: Alexey Dobriyan <adobriyan@gmail.com>

Identical implementations of PTRACE_PEEKDATA go into generic_ptrace_peekdata()
function.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/ptrace.c           |    8 +-------
 arch/arm26/kernel/ptrace.c         |    8 +-------
 arch/avr32/kernel/ptrace.c         |    7 +------
 arch/cris/arch-v10/kernel/ptrace.c |   14 ++------------
 arch/frv/kernel/ptrace.c           |   12 ++----------
 arch/i386/kernel/ptrace.c          |   12 ++----------
 arch/m32r/kernel/ptrace.c          |    7 +------
 arch/m68k/kernel/ptrace.c          |    5 +----
 arch/m68knommu/kernel/ptrace.c     |   12 ++----------
 arch/mips/kernel/ptrace.c          |   12 ++----------
 arch/parisc/kernel/ptrace.c        |   13 ++-----------
 arch/powerpc/kernel/ptrace.c       |   12 ++----------
 arch/s390/kernel/ptrace.c          |    6 +-----
 arch/sh/kernel/ptrace.c            |   12 ++----------
 arch/sh64/kernel/ptrace.c          |   12 ++----------
 arch/um/kernel/ptrace.c            |   12 ++----------
 arch/v850/kernel/ptrace.c          |    8 ++------
 arch/x86_64/kernel/ptrace.c        |   12 ++----------
 arch/xtensa/kernel/ptrace.c        |   12 +-----------
 include/linux/ptrace.h             |    1 +
 kernel/ptrace.c                    |   11 +++++++++++
 21 files changed, 43 insertions(+), 165 deletions(-)

diff -puN arch/arm/kernel/ptrace.c~ptrace_peekdata-consolidation arch/arm/kernel/ptrace.c
--- a/arch/arm/kernel/ptrace.c~ptrace_peekdata-consolidation
+++ a/arch/arm/kernel/ptrace.c
@@ -657,7 +657,6 @@ static int ptrace_setcrunchregs(struct t
 
 long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 {
-	unsigned long tmp;
 	int ret;
 
 	switch (request) {
@@ -666,12 +665,7 @@ long arch_ptrace(struct task_struct *chi
 		 */
 		case PTRACE_PEEKTEXT:
 		case PTRACE_PEEKDATA:
-			ret = access_process_vm(child, addr, &tmp,
-						sizeof(unsigned long), 0);
-			if (ret == sizeof(unsigned long))
-				ret = put_user(tmp, (unsigned long __user *) data);
-			else
-				ret = -EIO;
+			ret = generic_ptrace_peekdata(child, addr, data);
 			break;
 
 		case PTRACE_PEEKUSR:
diff -puN arch/arm26/kernel/ptrace.c~ptrace_peekdata-consolidation arch/arm26/kernel/ptrace.c
--- a/arch/arm26/kernel/ptrace.c~ptrace_peekdata-consolidation
+++ a/arch/arm26/kernel/ptrace.c
@@ -531,7 +531,6 @@ static int ptrace_setfpregs(struct task_
 
 long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 {
-	unsigned long tmp;
 	int ret;
 
 	switch (request) {
@@ -540,12 +539,7 @@ long arch_ptrace(struct task_struct *chi
 		 */
 		case PTRACE_PEEKTEXT:
 		case PTRACE_PEEKDATA:
-			ret = access_process_vm(child, addr, &tmp,
-						sizeof(unsigned long), 0);
-			if (ret == sizeof(unsigned long))
-				ret = put_user(tmp, (unsigned long *) data);
-			else
-				ret = -EIO;
+			ret = generic_ptrace_peekdata(child, addr, data);
 			break;
 
 		case PTRACE_PEEKUSR:
diff -puN arch/avr32/kernel/ptrace.c~ptrace_peekdata-consolidation arch/avr32/kernel/ptrace.c
--- a/arch/avr32/kernel/ptrace.c~ptrace_peekdata-consolidation
+++ a/arch/avr32/kernel/ptrace.c
@@ -153,7 +153,6 @@ static int ptrace_setregs(struct task_st
 
 long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 {
-	unsigned long tmp;
 	int ret;
 
 	pr_debug("arch_ptrace(%ld, %d, %#lx, %#lx)\n",
@@ -166,11 +165,7 @@ long arch_ptrace(struct task_struct *chi
 	/* Read the word at location addr in the child process */
 	case PTRACE_PEEKTEXT:
 	case PTRACE_PEEKDATA:
-		ret = access_process_vm(child, addr, &tmp, sizeof(tmp), 0);
-		if (ret == sizeof(tmp))
-			ret = put_user(tmp, (unsigned long __user *)data);
-		else
-			ret = -EIO;
+		ret = generic_ptrace_peekdata(child, addr, data);
 		break;
 
 	case PTRACE_PEEKUSR:
diff -puN arch/cris/arch-v10/kernel/ptrace.c~ptrace_peekdata-consolidation arch/cris/arch-v10/kernel/ptrace.c
--- a/arch/cris/arch-v10/kernel/ptrace.c~ptrace_peekdata-consolidation
+++ a/arch/cris/arch-v10/kernel/ptrace.c
@@ -83,19 +83,9 @@ long arch_ptrace(struct task_struct *chi
 	switch (request) {
 		/* Read word at location address. */ 
 		case PTRACE_PEEKTEXT:
-		case PTRACE_PEEKDATA: {
-			unsigned long tmp;
-			int copied;
-
-			copied = access_process_vm(child, addr, &tmp, sizeof(tmp), 0);
-			ret = -EIO;
-			
-			if (copied != sizeof(tmp))
-				break;
-			
-			ret = put_user(tmp,datap);
+		case PTRACE_PEEKDATA:
+			ret = generic_ptrace_peekdata(child, addr, data);
 			break;
-		}
 
 		/* Read the word at location address in the USER area. */
 		case PTRACE_PEEKUSR: {
diff -puN arch/frv/kernel/ptrace.c~ptrace_peekdata-consolidation arch/frv/kernel/ptrace.c
--- a/arch/frv/kernel/ptrace.c~ptrace_peekdata-consolidation
+++ a/arch/frv/kernel/ptrace.c
@@ -112,20 +112,12 @@ long arch_ptrace(struct task_struct *chi
 	switch (request) {
 		/* when I and D space are separate, these will need to be fixed. */
 	case PTRACE_PEEKTEXT: /* read word at location addr. */
-	case PTRACE_PEEKDATA: {
-		int copied;
-
+	case PTRACE_PEEKDATA:
 		ret = -EIO;
 		if (is_user_addr_valid(child, addr, sizeof(tmp)) < 0)
 			break;
-
-		copied = access_process_vm(child, addr, &tmp, sizeof(tmp), 0);
-		if (copied != sizeof(tmp))
-			break;
-
-		ret = put_user(tmp,(unsigned long *) data);
+		ret = generic_ptrace_peekdata(child, addr, data);
 		break;
-	}
 
 		/* read the word at location addr in the USER area. */
 	case PTRACE_PEEKUSR: {
diff -puN arch/i386/kernel/ptrace.c~ptrace_peekdata-consolidation arch/i386/kernel/ptrace.c
--- a/arch/i386/kernel/ptrace.c~ptrace_peekdata-consolidation
+++ a/arch/i386/kernel/ptrace.c
@@ -358,17 +358,9 @@ long arch_ptrace(struct task_struct *chi
 	switch (request) {
 	/* when I and D space are separate, these will need to be fixed. */
 	case PTRACE_PEEKTEXT: /* read word at location addr. */ 
-	case PTRACE_PEEKDATA: {
-		unsigned long tmp;
-		int copied;
-
-		copied = access_process_vm(child, addr, &tmp, sizeof(tmp), 0);
-		ret = -EIO;
-		if (copied != sizeof(tmp))
-			break;
-		ret = put_user(tmp, datap);
+	case PTRACE_PEEKDATA:
+		ret = generic_ptrace_peekdata(child, addr, data);
 		break;
-	}
 
 	/* read the word at location addr in the USER area. */
 	case PTRACE_PEEKUSR: {
diff -puN arch/m32r/kernel/ptrace.c~ptrace_peekdata-consolidation arch/m32r/kernel/ptrace.c
--- a/arch/m32r/kernel/ptrace.c~ptrace_peekdata-consolidation
+++ a/arch/m32r/kernel/ptrace.c
@@ -595,7 +595,6 @@ void ptrace_disable(struct task_struct *
 static int
 do_ptrace(long request, struct task_struct *child, long addr, long data)
 {
-	unsigned long tmp;
 	int ret;
 
 	switch (request) {
@@ -604,11 +603,7 @@ do_ptrace(long request, struct task_stru
 	 */
 	case PTRACE_PEEKTEXT:
 	case PTRACE_PEEKDATA:
-		ret = access_process_vm(child, addr, &tmp, sizeof(tmp), 0);
-		if (ret == sizeof(tmp))
-			ret = put_user(tmp,(unsigned long __user *) data);
-		else
-			ret = -EIO;
+		ret = generic_ptrace_peekdata(child, addr, data);
 		break;
 
 	/*
diff -puN arch/m68k/kernel/ptrace.c~ptrace_peekdata-consolidation arch/m68k/kernel/ptrace.c
--- a/arch/m68k/kernel/ptrace.c~ptrace_peekdata-consolidation
+++ a/arch/m68k/kernel/ptrace.c
@@ -128,10 +128,7 @@ long arch_ptrace(struct task_struct *chi
 	/* when I and D space are separate, these will need to be fixed. */
 	case PTRACE_PEEKTEXT:	/* read word at location addr. */
 	case PTRACE_PEEKDATA:
-		i = access_process_vm(child, addr, &tmp, sizeof(tmp), 0);
-		if (i != sizeof(tmp))
-			goto out_eio;
-		ret = put_user(tmp, (unsigned long *)data);
+		ret = generic_ptrace_peekdata(child, addr, data);
 		break;
 
 	/* read the word at location addr in the USER area. */
diff -puN arch/m68knommu/kernel/ptrace.c~ptrace_peekdata-consolidation arch/m68knommu/kernel/ptrace.c
--- a/arch/m68knommu/kernel/ptrace.c~ptrace_peekdata-consolidation
+++ a/arch/m68knommu/kernel/ptrace.c
@@ -106,17 +106,9 @@ long arch_ptrace(struct task_struct *chi
 	switch (request) {
 		/* when I and D space are separate, these will need to be fixed. */
 		case PTRACE_PEEKTEXT: /* read word at location addr. */ 
-		case PTRACE_PEEKDATA: {
-			unsigned long tmp;
-			int copied;
-
-			copied = access_process_vm(child, addr, &tmp, sizeof(tmp), 0);
-			ret = -EIO;
-			if (copied != sizeof(tmp))
-				break;
-			ret = put_user(tmp,(unsigned long *) data);
+		case PTRACE_PEEKDATA:
+			ret = generic_ptrace_peekdata(child, addr, data);
 			break;
-		}
 
 		/* read the word at location addr in the USER area. */
 		case PTRACE_PEEKUSR: {
diff -puN arch/mips/kernel/ptrace.c~ptrace_peekdata-consolidation arch/mips/kernel/ptrace.c
--- a/arch/mips/kernel/ptrace.c~ptrace_peekdata-consolidation
+++ a/arch/mips/kernel/ptrace.c
@@ -174,17 +174,9 @@ long arch_ptrace(struct task_struct *chi
 	switch (request) {
 	/* when I and D space are separate, these will need to be fixed. */
 	case PTRACE_PEEKTEXT: /* read word at location addr. */
-	case PTRACE_PEEKDATA: {
-		unsigned long tmp;
-		int copied;
-
-		copied = access_process_vm(child, addr, &tmp, sizeof(tmp), 0);
-		ret = -EIO;
-		if (copied != sizeof(tmp))
-			break;
-		ret = put_user(tmp,(unsigned long __user *) data);
+	case PTRACE_PEEKDATA:
+		ret = generic_ptrace_peekdata(child, addr, data);
 		break;
-	}
 
 	/* Read the word at location addr in the USER area. */
 	case PTRACE_PEEKUSR: {
diff -puN arch/parisc/kernel/ptrace.c~ptrace_peekdata-consolidation arch/parisc/kernel/ptrace.c
--- a/arch/parisc/kernel/ptrace.c~ptrace_peekdata-consolidation
+++ a/arch/parisc/kernel/ptrace.c
@@ -87,10 +87,9 @@ long arch_ptrace(struct task_struct *chi
 	switch (request) {
 	case PTRACE_PEEKTEXT: /* read word at location addr. */ 
 	case PTRACE_PEEKDATA: {
-		int copied;
-
 #ifdef CONFIG_64BIT
 		if (__is_compat_task(child)) {
+			int copied;
 			unsigned int tmp;
 
 			addr &= 0xffffffffL;
@@ -105,15 +104,7 @@ long arch_ptrace(struct task_struct *chi
 		}
 		else
 #endif
-		{
-			unsigned long tmp;
-
-			copied = access_process_vm(child, addr, &tmp, sizeof(tmp), 0);
-			ret = -EIO;
-			if (copied != sizeof(tmp))
-				goto out_tsk;
-			ret = put_user(tmp,(unsigned long *) data);
-		}
+			ret = generic_ptrace_peekdata(child, addr, data);
 		goto out_tsk;
 	}
 
diff -puN arch/powerpc/kernel/ptrace.c~ptrace_peekdata-consolidation arch/powerpc/kernel/ptrace.c
--- a/arch/powerpc/kernel/ptrace.c~ptrace_peekdata-consolidation
+++ a/arch/powerpc/kernel/ptrace.c
@@ -256,17 +256,9 @@ long arch_ptrace(struct task_struct *chi
 	switch (request) {
 	/* when I and D space are separate, these will need to be fixed. */
 	case PTRACE_PEEKTEXT: /* read word at location addr. */
-	case PTRACE_PEEKDATA: {
-		unsigned long tmp;
-		int copied;
-
-		copied = access_process_vm(child, addr, &tmp, sizeof(tmp), 0);
-		ret = -EIO;
-		if (copied != sizeof(tmp))
-			break;
-		ret = put_user(tmp,(unsigned long __user *) data);
+	case PTRACE_PEEKDATA:
+		ret = generic_ptrace_peekdata(child, addr, data);
 		break;
-	}
 
 	/* read the word at location addr in the USER area. */
 	case PTRACE_PEEKUSR: {
diff -puN arch/s390/kernel/ptrace.c~ptrace_peekdata-consolidation arch/s390/kernel/ptrace.c
--- a/arch/s390/kernel/ptrace.c~ptrace_peekdata-consolidation
+++ a/arch/s390/kernel/ptrace.c
@@ -294,7 +294,6 @@ poke_user(struct task_struct *child, add
 static int
 do_ptrace_normal(struct task_struct *child, long request, long addr, long data)
 {
-	unsigned long tmp;
 	ptrace_area parea; 
 	int copied, ret;
 
@@ -304,10 +303,7 @@ do_ptrace_normal(struct task_struct *chi
 		/* Remove high order bit from address (only for 31 bit). */
 		addr &= PSW_ADDR_INSN;
 		/* read word at location addr. */
-		copied = access_process_vm(child, addr, &tmp, sizeof(tmp), 0);
-		if (copied != sizeof(tmp))
-			return -EIO;
-		return put_user(tmp, (unsigned long __force __user *) data);
+		return generic_ptrace_peekdata(child, addr, data);
 
 	case PTRACE_PEEKUSR:
 		/* read the word at location addr in the USER area. */
diff -puN arch/sh/kernel/ptrace.c~ptrace_peekdata-consolidation arch/sh/kernel/ptrace.c
--- a/arch/sh/kernel/ptrace.c~ptrace_peekdata-consolidation
+++ a/arch/sh/kernel/ptrace.c
@@ -91,17 +91,9 @@ long arch_ptrace(struct task_struct *chi
 	switch (request) {
 	/* when I and D space are separate, these will need to be fixed. */
 	case PTRACE_PEEKTEXT: /* read word at location addr. */
-	case PTRACE_PEEKDATA: {
-		unsigned long tmp;
-		int copied;
-
-		copied = access_process_vm(child, addr, &tmp, sizeof(tmp), 0);
-		ret = -EIO;
-		if (copied != sizeof(tmp))
-			break;
-		ret = put_user(tmp,(unsigned long *) data);
+	case PTRACE_PEEKDATA:
+		ret = generic_ptrace_peekdata(child, addr, data);
 		break;
-	}
 
 	/* read the word at location addr in the USER area. */
 	case PTRACE_PEEKUSR: {
diff -puN arch/sh64/kernel/ptrace.c~ptrace_peekdata-consolidation arch/sh64/kernel/ptrace.c
--- a/arch/sh64/kernel/ptrace.c~ptrace_peekdata-consolidation
+++ a/arch/sh64/kernel/ptrace.c
@@ -129,17 +129,9 @@ long arch_ptrace(struct task_struct *chi
 	switch (request) {
 	/* when I and D space are separate, these will need to be fixed. */
 	case PTRACE_PEEKTEXT: /* read word at location addr. */
-	case PTRACE_PEEKDATA: {
-		unsigned long tmp;
-		int copied;
-
-		copied = access_process_vm(child, addr, &tmp, sizeof(tmp), 0);
-		ret = -EIO;
-		if (copied != sizeof(tmp))
-			break;
-		ret = put_user(tmp,(unsigned long *) data);
+	case PTRACE_PEEKDATA:
+		ret = generic_ptrace_peekdata(child, addr, data);
 		break;
-	}
 
 	/* read the word at location addr in the USER area. */
 	case PTRACE_PEEKUSR: {
diff -puN arch/um/kernel/ptrace.c~ptrace_peekdata-consolidation arch/um/kernel/ptrace.c
--- a/arch/um/kernel/ptrace.c~ptrace_peekdata-consolidation
+++ a/arch/um/kernel/ptrace.c
@@ -52,17 +52,9 @@ long arch_ptrace(struct task_struct *chi
 	switch (request) {
 		/* when I and D space are separate, these will need to be fixed. */
 	case PTRACE_PEEKTEXT: /* read word at location addr. */ 
-	case PTRACE_PEEKDATA: {
-		unsigned long tmp;
-		int copied;
-
-		ret = -EIO;
-		copied = access_process_vm(child, addr, &tmp, sizeof(tmp), 0);
-		if (copied != sizeof(tmp))
-			break;
-		ret = put_user(tmp, p);
+	case PTRACE_PEEKDATA:
+		ret = generic_ptrace_peekdata(child, addr, data);
 		break;
-	}
 
 	/* read the word at location addr in the USER area. */
         case PTRACE_PEEKUSR:
diff -puN arch/v850/kernel/ptrace.c~ptrace_peekdata-consolidation arch/v850/kernel/ptrace.c
--- a/arch/v850/kernel/ptrace.c~ptrace_peekdata-consolidation
+++ a/arch/v850/kernel/ptrace.c
@@ -117,15 +117,11 @@ long arch_ptrace(struct task_struct *chi
 	int rval;
 
 	switch (request) {
-		unsigned long val, copied;
+		unsigned long val;
 
 	case PTRACE_PEEKTEXT: /* read word at location addr. */
 	case PTRACE_PEEKDATA:
-		copied = access_process_vm(child, addr, &val, sizeof(val), 0);
-		rval = -EIO;
-		if (copied != sizeof(val))
-			break;
-		rval = put_user(val, (unsigned long *)data);
+		rval = generic_ptrace_peekdata(child, addr, data);
 		goto out;
 
 	case PTRACE_POKETEXT: /* write the word at location addr. */
diff -puN arch/x86_64/kernel/ptrace.c~ptrace_peekdata-consolidation arch/x86_64/kernel/ptrace.c
--- a/arch/x86_64/kernel/ptrace.c~ptrace_peekdata-consolidation
+++ a/arch/x86_64/kernel/ptrace.c
@@ -313,17 +313,9 @@ long arch_ptrace(struct task_struct *chi
 	switch (request) {
 	/* when I and D space are separate, these will need to be fixed. */
 	case PTRACE_PEEKTEXT: /* read word at location addr. */ 
-	case PTRACE_PEEKDATA: {
-		unsigned long tmp;
-		int copied;
-
-		copied = access_process_vm(child, addr, &tmp, sizeof(tmp), 0);
-		ret = -EIO;
-		if (copied != sizeof(tmp))
-			break;
-		ret = put_user(tmp,(unsigned long __user *) data);
+	case PTRACE_PEEKDATA:
+		ret = generic_ptrace_peekdata(child, addr, data);
 		break;
-	}
 
 	/* read the word at location addr in the USER area. */
 	case PTRACE_PEEKUSR: {
diff -puN arch/xtensa/kernel/ptrace.c~ptrace_peekdata-consolidation arch/xtensa/kernel/ptrace.c
--- a/arch/xtensa/kernel/ptrace.c~ptrace_peekdata-consolidation
+++ a/arch/xtensa/kernel/ptrace.c
@@ -50,18 +50,8 @@ long arch_ptrace(struct task_struct *chi
 	switch (request) {
 	case PTRACE_PEEKTEXT: /* read word at location addr. */
 	case PTRACE_PEEKDATA:
-	{
-		unsigned long tmp;
-		int copied;
-
-		copied = access_process_vm(child, addr, &tmp, sizeof(tmp), 0);
-		ret = -EIO;
-		if (copied != sizeof(tmp))
-			break;
-		ret = put_user(tmp,(unsigned long *) data);
-
+		ret = generic_ptrace_peekdata(child, addr, data);
 		goto out;
-	}
 
 	/* Read the word at location addr in the USER area.  */
 
diff -puN include/linux/ptrace.h~ptrace_peekdata-consolidation include/linux/ptrace.h
--- a/include/linux/ptrace.h~ptrace_peekdata-consolidation
+++ a/include/linux/ptrace.h
@@ -110,6 +110,7 @@ static inline void ptrace_unlink(struct 
 		__ptrace_unlink(child);
 }
 
+int generic_ptrace_peekdata(struct task_struct *tsk, long addr, long data);
 
 #ifndef force_successful_syscall_return
 /*
diff -puN kernel/ptrace.c~ptrace_peekdata-consolidation kernel/ptrace.c
--- a/kernel/ptrace.c~ptrace_peekdata-consolidation
+++ a/kernel/ptrace.c
@@ -490,3 +490,14 @@ asmlinkage long sys_ptrace(long request,
 	return ret;
 }
 #endif /* __ARCH_SYS_PTRACE */
+
+int generic_ptrace_peekdata(struct task_struct *tsk, long addr, long data)
+{
+	unsigned long tmp;
+	int copied;
+
+	copied = access_process_vm(tsk, addr, &tmp, sizeof(tmp), 0);
+	if (copied != sizeof(tmp))
+		return -EIO;
+	return put_user(tmp, (unsigned long __user *)data);
+}
_

Patches currently in -mm which might be from adobriyan@gmail.com are

fuse-fs_flags-fixlet.patch
git-parisc.patch
procfs-directory-entry-cleanup-fix.patch
remove-capabilityh-from-mmh.patch
ptrace_peekdata-consolidation.patch
ptrace_pokedata-consolidation.patch

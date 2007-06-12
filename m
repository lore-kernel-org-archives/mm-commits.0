From: akpm@linux-foundation.org
Subject: + ptrace_pokedata-consolidation.patch added to -mm tree
Date: Tue, 12 Jun 2007 12:51:15 -0700
Message-ID: <200706121951.l5CJpFDJ019910@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44901 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752678AbXFLTwn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jun 2007 15:52:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, hch@lst.de, linux-arch@vger.kernel.org


The patch titled
     PTRACE_POKEDATA consolidation
has been added to the -mm tree.  Its filename is
     ptrace_pokedata-consolidation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: PTRACE_POKEDATA consolidation
From: Alexey Dobriyan <adobriyan@gmail.com>

Identical implementations of PTRACE_POKEDATA go into generic_ptrace_pokedata()
function.

AFAICS, fix bug on xtensa where successful PTRACE_POKEDATA will nevertheless
return EPERM.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/ptrace.c         |    4 +---
 arch/arm/kernel/ptrace.c           |    7 +------
 arch/arm26/kernel/ptrace.c         |    7 +------
 arch/avr32/kernel/ptrace.c         |    6 +-----
 arch/cris/arch-v10/kernel/ptrace.c |    7 +------
 arch/cris/arch-v32/kernel/ptrace.c |    7 +------
 arch/frv/kernel/ptrace.c           |    4 +---
 arch/h8300/kernel/ptrace.c         |    5 +----
 arch/i386/kernel/ptrace.c          |    5 +----
 arch/m32r/kernel/ptrace.c          |   12 +++---------
 arch/m68k/kernel/ptrace.c          |    3 +--
 arch/m68knommu/kernel/ptrace.c     |    5 +----
 arch/mips/kernel/ptrace.c          |    6 +-----
 arch/powerpc/kernel/ptrace.c       |    6 +-----
 arch/s390/kernel/ptrace.c          |    5 +----
 arch/sh/kernel/ptrace.c            |    5 +----
 arch/sh64/kernel/ptrace.c          |    5 +----
 arch/um/kernel/ptrace.c            |    6 +-----
 arch/v850/kernel/ptrace.c          |    6 +-----
 arch/x86_64/kernel/ptrace.c        |    5 +----
 arch/xtensa/kernel/ptrace.c        |    5 +----
 include/linux/ptrace.h             |    1 +
 kernel/ptrace.c                    |    8 ++++++++
 23 files changed, 32 insertions(+), 98 deletions(-)

diff -puN arch/alpha/kernel/ptrace.c~ptrace_pokedata-consolidation arch/alpha/kernel/ptrace.c
--- a/arch/alpha/kernel/ptrace.c~ptrace_pokedata-consolidation
+++ a/arch/alpha/kernel/ptrace.c
@@ -315,9 +315,7 @@ do_sys_ptrace(long request, long pid, lo
 	/* When I and D space are separate, this will have to be fixed.  */
 	case PTRACE_POKETEXT: /* write the word at location addr. */
 	case PTRACE_POKEDATA:
-		tmp = data;
-		copied = access_process_vm(child, addr, &tmp, sizeof(tmp), 1);
-		ret = (copied == sizeof(tmp)) ? 0 : -EIO;
+		ret = generic_ptrace_pokedata(child, addr, data);
 		break;
 
 	case PTRACE_POKEUSR: /* write the specified register */
diff -puN arch/arm/kernel/ptrace.c~ptrace_pokedata-consolidation arch/arm/kernel/ptrace.c
--- a/arch/arm/kernel/ptrace.c~ptrace_pokedata-consolidation
+++ a/arch/arm/kernel/ptrace.c
@@ -677,12 +677,7 @@ long arch_ptrace(struct task_struct *chi
 		 */
 		case PTRACE_POKETEXT:
 		case PTRACE_POKEDATA:
-			ret = access_process_vm(child, addr, &data,
-						sizeof(unsigned long), 1);
-			if (ret == sizeof(unsigned long))
-				ret = 0;
-			else
-				ret = -EIO;
+			ret = generic_ptrace_pokedata(child, addr, data);
 			break;
 
 		case PTRACE_POKEUSR:
diff -puN arch/arm26/kernel/ptrace.c~ptrace_pokedata-consolidation arch/arm26/kernel/ptrace.c
--- a/arch/arm26/kernel/ptrace.c~ptrace_pokedata-consolidation
+++ a/arch/arm26/kernel/ptrace.c
@@ -551,12 +551,7 @@ long arch_ptrace(struct task_struct *chi
 		 */
 		case PTRACE_POKETEXT:
 		case PTRACE_POKEDATA:
-			ret = access_process_vm(child, addr, &data,
-						sizeof(unsigned long), 1);
-			if (ret == sizeof(unsigned long))
-				ret = 0;
-			else
-				ret = -EIO;
+			ret = generic_ptrace_pokedata(child, addr, data);
 			break;
 
 		case PTRACE_POKEUSR:
diff -puN arch/avr32/kernel/ptrace.c~ptrace_pokedata-consolidation arch/avr32/kernel/ptrace.c
--- a/arch/avr32/kernel/ptrace.c~ptrace_pokedata-consolidation
+++ a/arch/avr32/kernel/ptrace.c
@@ -176,11 +176,7 @@ long arch_ptrace(struct task_struct *chi
 	/* Write the word in data at location addr */
 	case PTRACE_POKETEXT:
 	case PTRACE_POKEDATA:
-		ret = access_process_vm(child, addr, &data, sizeof(data), 1);
-		if (ret == sizeof(data))
-			ret = 0;
-		else
-			ret = -EIO;
+		ret = generic_ptrace_pokedata(child, addr, data);
 		break;
 
 	case PTRACE_POKEUSR:
diff -puN arch/cris/arch-v10/kernel/ptrace.c~ptrace_pokedata-consolidation arch/cris/arch-v10/kernel/ptrace.c
--- a/arch/cris/arch-v10/kernel/ptrace.c~ptrace_pokedata-consolidation
+++ a/arch/cris/arch-v10/kernel/ptrace.c
@@ -103,12 +103,7 @@ long arch_ptrace(struct task_struct *chi
 		/* Write the word at location address. */
 		case PTRACE_POKETEXT:
 		case PTRACE_POKEDATA:
-			ret = 0;
-			
-			if (access_process_vm(child, addr, &data, sizeof(data), 1) == sizeof(data))
-				break;
-			
-			ret = -EIO;
+			ret = generic_ptrace_pokedata(child, addr, data);
 			break;
  
  		/* Write the word at location address in the USER area. */
diff -puN arch/cris/arch-v32/kernel/ptrace.c~ptrace_pokedata-consolidation arch/cris/arch-v32/kernel/ptrace.c
--- a/arch/cris/arch-v32/kernel/ptrace.c~ptrace_pokedata-consolidation
+++ a/arch/cris/arch-v32/kernel/ptrace.c
@@ -146,12 +146,7 @@ long arch_ptrace(struct task_struct *chi
 		/* Write the word at location address. */
 		case PTRACE_POKETEXT:
 		case PTRACE_POKEDATA:
-			ret = 0;
-
-			if (access_process_vm(child, addr, &data, sizeof(data), 1) == sizeof(data))
-				break;
-
-			ret = -EIO;
+			ret = generic_ptrace_pokedata(child, addr, data);
 			break;
 
  		/* Write the word at location address in the USER area. */
diff -puN arch/frv/kernel/ptrace.c~ptrace_pokedata-consolidation arch/frv/kernel/ptrace.c
--- a/arch/frv/kernel/ptrace.c~ptrace_pokedata-consolidation
+++ a/arch/frv/kernel/ptrace.c
@@ -168,9 +168,7 @@ long arch_ptrace(struct task_struct *chi
 		ret = -EIO;
 		if (is_user_addr_valid(child, addr, sizeof(tmp)) < 0)
 			break;
-		if (access_process_vm(child, addr, &data, sizeof(data), 1) != sizeof(data))
-			break;
-		ret = 0;
+		ret = generic_ptrace_pokedata(child, addr, data);
 		break;
 
 	case PTRACE_POKEUSR: /* write the word at location addr in the USER area */
diff -puN arch/h8300/kernel/ptrace.c~ptrace_pokedata-consolidation arch/h8300/kernel/ptrace.c
--- a/arch/h8300/kernel/ptrace.c~ptrace_pokedata-consolidation
+++ a/arch/h8300/kernel/ptrace.c
@@ -111,10 +111,7 @@ long arch_ptrace(struct task_struct *chi
       /* when I and D space are separate, this will have to be fixed. */
 		case PTRACE_POKETEXT: /* write the word at location addr. */
 		case PTRACE_POKEDATA:
-			ret = 0;
-			if (access_process_vm(child, addr, &data, sizeof(data), 1) == sizeof(data))
-				break;
-			ret = -EIO;
+			ret = generic_ptrace_pokedata(child, addr, data);
 			break;
 
 		case PTRACE_POKEUSR: /* write the word at location addr in the USER area */
diff -puN arch/i386/kernel/ptrace.c~ptrace_pokedata-consolidation arch/i386/kernel/ptrace.c
--- a/arch/i386/kernel/ptrace.c~ptrace_pokedata-consolidation
+++ a/arch/i386/kernel/ptrace.c
@@ -387,10 +387,7 @@ long arch_ptrace(struct task_struct *chi
 	/* when I and D space are separate, this will have to be fixed. */
 	case PTRACE_POKETEXT: /* write the word at location addr. */
 	case PTRACE_POKEDATA:
-		ret = 0;
-		if (access_process_vm(child, addr, &data, sizeof(data), 1) == sizeof(data))
-			break;
-		ret = -EIO;
+		ret = generic_ptrace_pokedata(child, addr, data);
 		break;
 
 	case PTRACE_POKEUSR: /* write the word at location addr in the USER area */
diff -puN arch/m32r/kernel/ptrace.c~ptrace_pokedata-consolidation arch/m32r/kernel/ptrace.c
--- a/arch/m32r/kernel/ptrace.c~ptrace_pokedata-consolidation
+++ a/arch/m32r/kernel/ptrace.c
@@ -619,15 +619,9 @@ do_ptrace(long request, struct task_stru
 	 */
 	case PTRACE_POKETEXT:
 	case PTRACE_POKEDATA:
-		ret = access_process_vm(child, addr, &data, sizeof(data), 1);
-		if (ret == sizeof(data)) {
-			ret = 0;
-			if (request == PTRACE_POKETEXT) {
-				invalidate_cache();
-			}
-		} else {
-			ret = -EIO;
-		}
+		ret = generic_ptrace_pokedata(child, addr, data);
+		if (ret == 0 && request == PTRACE_POKETEXT)
+			invalidate_cache();
 		break;
 
 	/*
diff -puN arch/m68k/kernel/ptrace.c~ptrace_pokedata-consolidation arch/m68k/kernel/ptrace.c
--- a/arch/m68k/kernel/ptrace.c~ptrace_pokedata-consolidation
+++ a/arch/m68k/kernel/ptrace.c
@@ -157,8 +157,7 @@ long arch_ptrace(struct task_struct *chi
 	/* when I and D space are separate, this will have to be fixed. */
 	case PTRACE_POKETEXT:	/* write the word at location addr. */
 	case PTRACE_POKEDATA:
-		if (access_process_vm(child, addr, &data, sizeof(data), 1) != sizeof(data))
-			goto out_eio;
+		ret = generic_ptrace_pokedata(child, addr, data);
 		break;
 
 	case PTRACE_POKEUSR:	/* write the word at location addr in the USER area */
diff -puN arch/m68knommu/kernel/ptrace.c~ptrace_pokedata-consolidation arch/m68knommu/kernel/ptrace.c
--- a/arch/m68knommu/kernel/ptrace.c~ptrace_pokedata-consolidation
+++ a/arch/m68knommu/kernel/ptrace.c
@@ -151,10 +151,7 @@ long arch_ptrace(struct task_struct *chi
 		/* when I and D space are separate, this will have to be fixed. */
 		case PTRACE_POKETEXT: /* write the word at location addr. */
 		case PTRACE_POKEDATA:
-			ret = 0;
-			if (access_process_vm(child, addr, &data, sizeof(data), 1) == sizeof(data))
-				break;
-			ret = -EIO;
+			ret = generic_ptrace_pokedata(child, addr, data);
 			break;
 
 		case PTRACE_POKEUSR: /* write the word at location addr in the USER area */
diff -puN arch/mips/kernel/ptrace.c~ptrace_pokedata-consolidation arch/mips/kernel/ptrace.c
--- a/arch/mips/kernel/ptrace.c~ptrace_pokedata-consolidation
+++ a/arch/mips/kernel/ptrace.c
@@ -305,11 +305,7 @@ long arch_ptrace(struct task_struct *chi
 	/* when I and D space are separate, this will have to be fixed. */
 	case PTRACE_POKETEXT: /* write the word at location addr. */
 	case PTRACE_POKEDATA:
-		ret = 0;
-		if (access_process_vm(child, addr, &data, sizeof(data), 1)
-		    == sizeof(data))
-			break;
-		ret = -EIO;
+		ret = generic_ptrace_pokedata(child, addr, data);
 		break;
 
 	case PTRACE_POKEUSR: {
diff -puN arch/powerpc/kernel/ptrace.c~ptrace_pokedata-consolidation arch/powerpc/kernel/ptrace.c
--- a/arch/powerpc/kernel/ptrace.c~ptrace_pokedata-consolidation
+++ a/arch/powerpc/kernel/ptrace.c
@@ -292,11 +292,7 @@ long arch_ptrace(struct task_struct *chi
 	/* If I and D space are separate, this will have to be fixed. */
 	case PTRACE_POKETEXT: /* write the word at location addr. */
 	case PTRACE_POKEDATA:
-		ret = 0;
-		if (access_process_vm(child, addr, &data, sizeof(data), 1)
-				== sizeof(data))
-			break;
-		ret = -EIO;
+		ret = generic_ptrace_pokedata(child, addr, data);
 		break;
 
 	/* write the word at location addr in the USER area */
diff -puN arch/s390/kernel/ptrace.c~ptrace_pokedata-consolidation arch/s390/kernel/ptrace.c
--- a/arch/s390/kernel/ptrace.c~ptrace_pokedata-consolidation
+++ a/arch/s390/kernel/ptrace.c
@@ -314,10 +314,7 @@ do_ptrace_normal(struct task_struct *chi
 		/* Remove high order bit from address (only for 31 bit). */
 		addr &= PSW_ADDR_INSN;
 		/* write the word at location addr. */
-		copied = access_process_vm(child, addr, &data, sizeof(data),1);
-		if (copied != sizeof(data))
-			return -EIO;
-		return 0;
+		return generic_ptrace_pokedata(child, addr, data);
 
 	case PTRACE_POKEUSR:
 		/* write the word at location addr in the USER area */
diff -puN arch/sh/kernel/ptrace.c~ptrace_pokedata-consolidation arch/sh/kernel/ptrace.c
--- a/arch/sh/kernel/ptrace.c~ptrace_pokedata-consolidation
+++ a/arch/sh/kernel/ptrace.c
@@ -127,10 +127,7 @@ long arch_ptrace(struct task_struct *chi
 	/* when I and D space are separate, this will have to be fixed. */
 	case PTRACE_POKETEXT: /* write the word at location addr. */
 	case PTRACE_POKEDATA:
-		ret = 0;
-		if (access_process_vm(child, addr, &data, sizeof(data), 1) == sizeof(data))
-			break;
-		ret = -EIO;
+		ret = generic_ptrace_pokedata(child, addr, data);
 		break;
 
 	case PTRACE_POKEUSR: /* write the word at location addr in the USER area */
diff -puN arch/sh64/kernel/ptrace.c~ptrace_pokedata-consolidation arch/sh64/kernel/ptrace.c
--- a/arch/sh64/kernel/ptrace.c~ptrace_pokedata-consolidation
+++ a/arch/sh64/kernel/ptrace.c
@@ -158,10 +158,7 @@ long arch_ptrace(struct task_struct *chi
 	/* when I and D space are separate, this will have to be fixed. */
 	case PTRACE_POKETEXT: /* write the word at location addr. */
 	case PTRACE_POKEDATA:
-		ret = 0;
-		if (access_process_vm(child, addr, &data, sizeof(data), 1) == sizeof(data))
-			break;
-		ret = -EIO;
+		ret = generic_ptrace_pokedata(child, addr, data);
 		break;
 
 	case PTRACE_POKEUSR:
diff -puN arch/um/kernel/ptrace.c~ptrace_pokedata-consolidation arch/um/kernel/ptrace.c
--- a/arch/um/kernel/ptrace.c~ptrace_pokedata-consolidation
+++ a/arch/um/kernel/ptrace.c
@@ -64,11 +64,7 @@ long arch_ptrace(struct task_struct *chi
 	/* when I and D space are separate, this will have to be fixed. */
 	case PTRACE_POKETEXT: /* write the word at location addr. */
 	case PTRACE_POKEDATA:
-		ret = -EIO;
-		if (access_process_vm(child, addr, &data, sizeof(data), 
-				      1) != sizeof(data))
-			break;
-		ret = 0;
+		ret = generic_ptrace_pokedata(child, addr, data);
 		break;
 
 	case PTRACE_POKEUSR: /* write the word at location addr in the USER area */
diff -puN arch/v850/kernel/ptrace.c~ptrace_pokedata-consolidation arch/v850/kernel/ptrace.c
--- a/arch/v850/kernel/ptrace.c~ptrace_pokedata-consolidation
+++ a/arch/v850/kernel/ptrace.c
@@ -126,11 +126,7 @@ long arch_ptrace(struct task_struct *chi
 
 	case PTRACE_POKETEXT: /* write the word at location addr. */
 	case PTRACE_POKEDATA:
-		rval = 0;
-		if (access_process_vm(child, addr, &data, sizeof(data), 1)
-		    == sizeof(data))
-			break;
-		rval = -EIO;
+		rval = generic_ptrace_pokedata(child, addr, data);
 		goto out;
 
 	/* Read/write the word at location ADDR in the registers.  */
diff -puN arch/x86_64/kernel/ptrace.c~ptrace_pokedata-consolidation arch/x86_64/kernel/ptrace.c
--- a/arch/x86_64/kernel/ptrace.c~ptrace_pokedata-consolidation
+++ a/arch/x86_64/kernel/ptrace.c
@@ -359,10 +359,7 @@ long arch_ptrace(struct task_struct *chi
 	/* when I and D space are separate, this will have to be fixed. */
 	case PTRACE_POKETEXT: /* write the word at location addr. */
 	case PTRACE_POKEDATA:
-		ret = 0;
-		if (access_process_vm(child, addr, &data, sizeof(data), 1) == sizeof(data))
-			break;
-		ret = -EIO;
+		ret = generic_ptrace_pokedata(child, addr, data);
 		break;
 
 	case PTRACE_POKEUSR: /* write the word at location addr in the USER area */
diff -puN arch/xtensa/kernel/ptrace.c~ptrace_pokedata-consolidation arch/xtensa/kernel/ptrace.c
--- a/arch/xtensa/kernel/ptrace.c~ptrace_pokedata-consolidation
+++ a/arch/xtensa/kernel/ptrace.c
@@ -128,10 +128,7 @@ long arch_ptrace(struct task_struct *chi
 
 	case PTRACE_POKETEXT: /* write the word at location addr. */
 	case PTRACE_POKEDATA:
-		if (access_process_vm(child, addr, &data, sizeof(data), 1)
-		    == sizeof(data))
-			break;
-		ret = -EIO;
+		ret = generic_ptrace_pokedata(child, addr, data);
 		goto out;
 
 	case PTRACE_POKEUSR:
diff -puN include/linux/ptrace.h~ptrace_pokedata-consolidation include/linux/ptrace.h
--- a/include/linux/ptrace.h~ptrace_pokedata-consolidation
+++ a/include/linux/ptrace.h
@@ -111,6 +111,7 @@ static inline void ptrace_unlink(struct 
 }
 
 int generic_ptrace_peekdata(struct task_struct *tsk, long addr, long data);
+int generic_ptrace_pokedata(struct task_struct *tsk, long addr, long data);
 
 #ifndef force_successful_syscall_return
 /*
diff -puN kernel/ptrace.c~ptrace_pokedata-consolidation kernel/ptrace.c
--- a/kernel/ptrace.c~ptrace_pokedata-consolidation
+++ a/kernel/ptrace.c
@@ -501,3 +501,11 @@ int generic_ptrace_peekdata(struct task_
 		return -EIO;
 	return put_user(tmp, (unsigned long __user *)data);
 }
+
+int generic_ptrace_pokedata(struct task_struct *tsk, long addr, long data)
+{
+	int copied;
+
+	copied = access_process_vm(tsk, addr, &data, sizeof(data), 1);
+	return (copied == sizeof(data)) ? 0 : -EIO;
+}
_

Patches currently in -mm which might be from adobriyan@gmail.com are

fuse-fs_flags-fixlet.patch
git-parisc.patch
procfs-directory-entry-cleanup-fix.patch
remove-capabilityh-from-mmh.patch
ptrace_peekdata-consolidation.patch
ptrace_pokedata-consolidation.patch

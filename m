From: akpm@osdl.org
Subject: + arch-i386-kernel-ptracec-trivial-whitespace-cleanup.patch added to -mm tree
Date: Tue, 23 Jan 2007 20:05:15 -0800
Message-ID: <200701240405.l0O45FpW007928@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50264 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030203AbXAXEFw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jan 2007 23:05:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stern@rowland.harvard.edu, ak@suse.de, roland@redhat.com


The patch titled
     arch/i386/kernel/ptrace.c: trivial whitespace cleanup
has been added to the -mm tree.  Its filename is
     arch-i386-kernel-ptracec-trivial-whitespace-cleanup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: arch/i386/kernel/ptrace.c: trivial whitespace cleanup
From: Alan Stern <stern@rowland.harvard.edu>

This patch (as838) makes some trivial whitespace fixes to the i386 ptrace.c
file.  Along with some stylistic issues, an entire section of code was
indented by two extra spaces -- I blame it on stupid automatic editor
indentation!

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Cc: Andi Kleen <ak@suse.de>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/ptrace.c |  110 ++++++++++++++++++------------------
 1 file changed, 55 insertions(+), 55 deletions(-)

diff -puN arch/i386/kernel/ptrace.c~arch-i386-kernel-ptracec-trivial-whitespace-cleanup arch/i386/kernel/ptrace.c
--- a/arch/i386/kernel/ptrace.c~arch-i386-kernel-ptracec-trivial-whitespace-cleanup
+++ a/arch/i386/kernel/ptrace.c
@@ -417,61 +417,61 @@ long arch_ptrace(struct task_struct *chi
 		   have to be selective about what portions we allow someone
 		   to modify. */
 
-		  ret = -EIO;
-		  if(addr >= (long) &dummy->u_debugreg[0] &&
-		     addr <= (long) &dummy->u_debugreg[7]){
-
-			  if(addr == (long) &dummy->u_debugreg[4]) break;
-			  if(addr == (long) &dummy->u_debugreg[5]) break;
-			  if(addr < (long) &dummy->u_debugreg[4] &&
-			     ((unsigned long) data) >= TASK_SIZE-3) break;
-			  
-			  /* Sanity-check data. Take one half-byte at once with
-			   * check = (val >> (16 + 4*i)) & 0xf. It contains the
-			   * R/Wi and LENi bits; bits 0 and 1 are R/Wi, and bits
-			   * 2 and 3 are LENi. Given a list of invalid values,
-			   * we do mask |= 1 << invalid_value, so that
-			   * (mask >> check) & 1 is a correct test for invalid
-			   * values.
-			   *
-			   * R/Wi contains the type of the breakpoint /
-			   * watchpoint, LENi contains the length of the watched
-			   * data in the watchpoint case.
-			   *
-			   * The invalid values are:
-			   * - LENi == 0x10 (undefined), so mask |= 0x0f00.
-			   * - R/Wi == 0x10 (break on I/O reads or writes), so
-			   *   mask |= 0x4444.
-			   * - R/Wi == 0x00 && LENi != 0x00, so we have mask |=
-			   *   0x1110.
-			   *
-			   * Finally, mask = 0x0f00 | 0x4444 | 0x1110 == 0x5f54.
-			   *
-			   * See the Intel Manual "System Programming Guide",
-			   * 15.2.4
-			   *
-			   * Note that LENi == 0x10 is defined on x86_64 in long
-			   * mode (i.e. even for 32-bit userspace software, but
-			   * 64-bit kernel), so the x86_64 mask value is 0x5454.
-			   * See the AMD manual no. 24593 (AMD64 System
-			   * Programming)*/
-
-			  if(addr == (long) &dummy->u_debugreg[7]) {
-				  data &= ~DR_CONTROL_RESERVED;
-				  for(i=0; i<4; i++)
-					  if ((0x5f54 >> ((data >> (16 + 4*i)) & 0xf)) & 1)
-						  goto out_tsk;
-				  if (data)
-					  set_tsk_thread_flag(child, TIF_DEBUG);
-				  else
-					  clear_tsk_thread_flag(child, TIF_DEBUG);
-			  }
-			  addr -= (long) &dummy->u_debugreg;
-			  addr = addr >> 2;
-			  child->thread.debugreg[addr] = data;
-			  ret = 0;
-		  }
-		  break;
+		ret = -EIO;
+		if (addr >= (long) &dummy->u_debugreg[0] &&
+		    addr <= (long) &dummy->u_debugreg[7]) {
+
+			if (addr == (long) &dummy->u_debugreg[4]) break;
+			if (addr == (long) &dummy->u_debugreg[5]) break;
+			if (addr < (long) &dummy->u_debugreg[4] &&
+			    ((unsigned long) data) >= TASK_SIZE-3) break;
+
+			/* Sanity-check data. Take one half-byte at once with
+			 * check = (val >> (16 + 4*i)) & 0xf. It contains the
+			 * R/Wi and LENi bits; bits 0 and 1 are R/Wi, and bits
+			 * 2 and 3 are LENi. Given a list of invalid values,
+			 * we do mask |= 1 << invalid_value, so that
+			 * (mask >> check) & 1 is a correct test for invalid
+			 * values.
+			 *
+			 * R/Wi contains the type of the breakpoint /
+			 * watchpoint, LENi contains the length of the watched
+			 * data in the watchpoint case.
+			 *
+			 * The invalid values are:
+			 * - LENi == 0x10 (undefined), so mask |= 0x0f00.
+			 * - R/Wi == 0x10 (break on I/O reads or writes), so
+			 *   mask |= 0x4444.
+			 * - R/Wi == 0x00 && LENi != 0x00, so we have mask |=
+			 *   0x1110.
+			 *
+			 * Finally, mask = 0x0f00 | 0x4444 | 0x1110 == 0x5f54.
+			 *
+			 * See the Intel Manual "System Programming Guide",
+			 * 15.2.4
+			 *
+			 * Note that LENi == 0x10 is defined on x86_64 in long
+			 * mode (i.e. even for 32-bit userspace software, but
+			 * 64-bit kernel), so the x86_64 mask value is 0x5454.
+			 * See the AMD manual no. 24593 (AMD64 System
+			 * Programming) */
+
+			if (addr == (long) &dummy->u_debugreg[7]) {
+				data &= ~DR_CONTROL_RESERVED;
+				for (i = 0; i < 4; i++)
+					if ((0x5f54 >> ((data >> (16 + 4*i)) & 0xf)) & 1)
+						goto out_tsk;
+				if (data)
+					set_tsk_thread_flag(child, TIF_DEBUG);
+				else
+					clear_tsk_thread_flag(child, TIF_DEBUG);
+			}
+			addr -= (long) &dummy->u_debugreg;
+			addr = addr >> 2;
+			child->thread.debugreg[addr] = data;
+			ret = 0;
+		}
+		break;
 
 	case PTRACE_SYSEMU: /* continue and stop at next syscall, which will not be executed */
 	case PTRACE_SYSCALL:	/* continue and stop at next (return from) syscall */
_

Patches currently in -mm which might be from stern@rowland.harvard.edu are

scsi-handle-bad-inquiry-responses.patch
arch-i386-kernel-ptracec-trivial-whitespace-cleanup.patch

From: akpm@linux-foundation.org
Subject: - arch-i386-kernel-ptracec-trivial-whitespace-cleanup.patch removed from -mm tree
Date: Wed, 07 Feb 2007 13:59:35 -0800
Message-ID: <200702072159.l17LxZKX028486@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40054 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161447AbXBGV75 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 16:59:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stern@rowland.harvard.edu, ak@suse.de, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     arch/i386/kernel/ptrace.c: trivial whitespace cleanup
has been removed from the -mm tree.  Its filename was
     arch-i386-kernel-ptracec-trivial-whitespace-cleanup.patch

This patch was dropped because of rejects against the utrace tree

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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
fix-gregkh-usb-usbcore-remove-unused-bandwith-related-code.patch
usb-p990i-is-an-unusual-device.patch
usb-fix-concurrent-buffer-access-in-the-hub-driver.patch
arch-i386-kernel-ptracec-trivial-whitespace-cleanup.patch

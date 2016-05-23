From: akpm@linux-foundation.org
Subject: [patch 69/84] mm, aout: handle vm_brk failures
Date: Mon, 23 May 2016 16:25:36 -0700
Message-ID: <57439170.abim8p07rtl0SEzv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42377 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027AbcEWXZi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 19:25:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, hpa@zytor.com, mingo@kernel.org, tglx@linutronix.de, vbabka@suse.cz, viro@zeniv.linux.org.uk

From: Michal Hocko <mhocko@suse.com>
Subject: mm, aout: handle vm_brk failures

vm_brk is allowed to fail but load_aout_binary simply ignores the error
and happily continues.  I haven't noticed any problem from that in real
life but later patches will make the failure more likely because vm_brk
will become killable (resp.  mmap_sem for write waiting will become
killable) so we should be more careful now.

The error handling should be quite straightforward because there are calls
to vm_mmap which check the error properly already.  The only notable
exception is set_brk which is called after beyond_if label.  But nothing
indicates that we cannot move it above set_binfmt as the two do not depend
on each other and fail before we do set_binfmt and alter reference
counting.

Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/ia32/ia32_aout.c |   22 +++++++++++++++-------
 fs/binfmt_aout.c          |   11 ++++++++---
 2 files changed, 23 insertions(+), 10 deletions(-)

diff -puN arch/x86/ia32/ia32_aout.c~mm-aout-handle-vm_brk-failures arch/x86/ia32/ia32_aout.c
--- a/arch/x86/ia32/ia32_aout.c~mm-aout-handle-vm_brk-failures
+++ a/arch/x86/ia32/ia32_aout.c
@@ -116,13 +116,13 @@ static struct linux_binfmt aout_format =
 	.min_coredump	= PAGE_SIZE
 };
 
-static void set_brk(unsigned long start, unsigned long end)
+static unsigned long set_brk(unsigned long start, unsigned long end)
 {
 	start = PAGE_ALIGN(start);
 	end = PAGE_ALIGN(end);
 	if (end <= start)
-		return;
-	vm_brk(start, end - start);
+		return start;
+	return vm_brk(start, end - start);
 }
 
 #ifdef CONFIG_COREDUMP
@@ -349,7 +349,10 @@ static int load_aout_binary(struct linux
 #endif
 
 		if (!bprm->file->f_op->mmap || (fd_offset & ~PAGE_MASK) != 0) {
-			vm_brk(N_TXTADDR(ex), ex.a_text+ex.a_data);
+			error = vm_brk(N_TXTADDR(ex), ex.a_text+ex.a_data);
+			if (IS_ERR_VALUE(error))
+				return error;
+
 			read_code(bprm->file, N_TXTADDR(ex), fd_offset,
 					ex.a_text+ex.a_data);
 			goto beyond_if;
@@ -372,10 +375,13 @@ static int load_aout_binary(struct linux
 		if (error != N_DATADDR(ex))
 			return error;
 	}
+
 beyond_if:
-	set_binfmt(&aout_format);
+	error = set_brk(current->mm->start_brk, current->mm->brk);
+	if (IS_ERR_VALUE(error))
+		return error;
 
-	set_brk(current->mm->start_brk, current->mm->brk);
+	set_binfmt(&aout_format);
 
 	current->mm->start_stack =
 		(unsigned long)create_aout_tables((char __user *)bprm->p, bprm);
@@ -434,7 +440,9 @@ static int load_aout_library(struct file
 			error_time = jiffies;
 		}
 #endif
-		vm_brk(start_addr, ex.a_text + ex.a_data + ex.a_bss);
+		retval = vm_brk(start_addr, ex.a_text + ex.a_data + ex.a_bss);
+		if (IS_ERR_VALUE(retval))
+			goto out;
 
 		read_code(file, start_addr, N_TXTOFF(ex),
 			  ex.a_text + ex.a_data);
diff -puN fs/binfmt_aout.c~mm-aout-handle-vm_brk-failures fs/binfmt_aout.c
--- a/fs/binfmt_aout.c~mm-aout-handle-vm_brk-failures
+++ a/fs/binfmt_aout.c
@@ -297,7 +297,10 @@ static int load_aout_binary(struct linux
 		}
 
 		if (!bprm->file->f_op->mmap||((fd_offset & ~PAGE_MASK) != 0)) {
-			vm_brk(N_TXTADDR(ex), ex.a_text+ex.a_data);
+			error = vm_brk(N_TXTADDR(ex), ex.a_text+ex.a_data);
+			if (IS_ERR_VALUE(error))
+				return error;
+
 			read_code(bprm->file, N_TXTADDR(ex), fd_offset,
 				  ex.a_text + ex.a_data);
 			goto beyond_if;
@@ -378,8 +381,10 @@ static int load_aout_library(struct file
 			       "N_TXTOFF is not page aligned. Please convert library: %pD\n",
 			       file);
 		}
-		vm_brk(start_addr, ex.a_text + ex.a_data + ex.a_bss);
-		
+		retval = vm_brk(start_addr, ex.a_text + ex.a_data + ex.a_bss);
+		if (IS_ERR_VALUE(retval))
+			goto out;
+
 		read_code(file, start_addr, N_TXTOFF(ex),
 			  ex.a_text + ex.a_data);
 		retval = 0;
_

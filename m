From: akpm@linux-foundation.org
Subject: [folded-merged]
 all-arches-signal-move-restart_block-to-struct-task_struct-fix.patch
 removed from -mm tree
Date: Thu, 12 Feb 2015 14:16:40 -0800
Message-ID: <54dd2648.ALdCPTEL25PrV0ak%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60262 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbbBLWQl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 17:16:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: james.hogan@imgtec.com, linux@roeck-us.net, luto@amacapital.net, mm-commits@vger.kernel.org


The patch titled
     Subject: metag: align thread_info::supervisor_stack
has been removed from the -mm tree.  Its filename was
     all-arches-signal-move-restart_block-to-struct-task_struct-fix.patch

This patch was dropped because it was folded into all-arches-signal-move-restart_block-to-struct-task_struct.patch

------------------------------------------------------
From: James Hogan <james.hogan@imgtec.com>
Subject: metag: align thread_info::supervisor_stack

Commit a82be12232dc ("all arches, signal: move restart_block to struct
task_struct") removed restart_block from struct thread_info which was the
only thing keeping supervisor_stack and the struct as a whole 64-bit
aligned.  This resulted in the initial stack pointer not being 64-bit
aligned, so when arguments are saved to the stack with a 64-bit SETL
instruction the values are corrupted resulting in a pretty early
unserviced memory fault in printk.

This is fixed by explicitly aligning supervisor_stack to 8 bytes.

Fixes: a82be12232dc ("all arches, signal: move restart_block to struct task_struct")
Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/metag/include/asm/thread_info.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/metag/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct-fix arch/metag/include/asm/thread_info.h
--- a/arch/metag/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct-fix
+++ a/arch/metag/include/asm/thread_info.h
@@ -36,7 +36,7 @@ struct thread_info {
 
 	mm_segment_t addr_limit;	/* thread address space */
 
-	u8 supervisor_stack[0];
+	u8 supervisor_stack[0] __aligned(8);
 };
 
 #else /* !__ASSEMBLY__ */
_

Patches currently in -mm which might be from james.hogan@imgtec.com are

origin.patch
all-arches-signal-move-restart_block-to-struct-task_struct.patch


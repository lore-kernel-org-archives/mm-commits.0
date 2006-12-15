From: akpm@osdl.org
Subject: + x86_64-do-not-always-end-the-stack-trace-with-ulong_max.patch added to -mm tree
Date: Thu, 14 Dec 2006 16:48:43 -0800
Message-ID: <200612150048.kBF0mhqf001916@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:46701 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932263AbWLOAtM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 19:49:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: catalin.marinas@arm.com, ak@suse.de, jbeulich@novell.com


The patch titled
     x86_64: do not always end the stack trace with ULONG_MAX
has been added to the -mm tree.  Its filename is
     x86_64-do-not-always-end-the-stack-trace-with-ulong_max.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: do not always end the stack trace with ULONG_MAX
From: Catalin Marinas <catalin.marinas@arm.com>

It makes more sense to end the stack trace with ULONG_MAX only if
nr_entries < max_entries.  Otherwise, we lose one entry in the long stack
traces and cannot know whether the trace was complete or not.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/x86_64/kernel/stacktrace.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff -puN arch/x86_64/kernel/stacktrace.c~x86_64-do-not-always-end-the-stack-trace-with-ulong_max arch/x86_64/kernel/stacktrace.c
--- a/arch/x86_64/kernel/stacktrace.c~x86_64-do-not-always-end-the-stack-trace-with-ulong_max
+++ a/arch/x86_64/kernel/stacktrace.c
@@ -32,7 +32,7 @@ static void save_stack_address(void *dat
 		trace->skip--;
 		return;
 	}
-	if (trace->nr_entries < trace->max_entries - 1)
+	if (trace->nr_entries < trace->max_entries)
 		trace->entries[trace->nr_entries++] = addr;
 }
 
@@ -49,7 +49,8 @@ static struct stacktrace_ops save_stack_
 void save_stack_trace(struct stack_trace *trace, struct task_struct *task)
 {
 	dump_trace(task, NULL, NULL, &save_stack_ops, trace);
-	trace->entries[trace->nr_entries++] = ULONG_MAX;
+	if (trace->nr_entries < trace->max_entries)
+		trace->entries[trace->nr_entries++] = ULONG_MAX;
 }
 EXPORT_SYMBOL(save_stack_trace);
 
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

x86_64-do-not-always-end-the-stack-trace-with-ulong_max.patch


From: akpm@linux-foundation.org
Subject: [merged] tracing-remove-use-of-seq_printf-return-value.patch
 removed from -mm tree
Date: Thu, 16 Apr 2015 09:55:39 -0700
Message-ID: <552fe98b.YdOU69al99DjcxVs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43209 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbbDPQuK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:50:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, rostedt@goodmis.org, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: tracing: remove use of seq_printf return value
has been removed from the -mm tree.  Its filename was
     tracing-remove-use-of-seq_printf-return-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: tracing: remove use of seq_printf return value

The seq_printf return value, because it's frequently misused,
will eventually be converted to void.

See: commit 1f33c41c03da ("seq_file: Rename seq_overflow() to
     seq_has_overflowed() and make public")

Miscellanea:

o Remove unused return value from trace_lookup_stack

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/trace/trace_stack.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/trace/trace_stack.c~tracing-remove-use-of-seq_printf-return-value kernel/trace/trace_stack.c
--- a/kernel/trace/trace_stack.c~tracing-remove-use-of-seq_printf-return-value
+++ a/kernel/trace/trace_stack.c
@@ -327,11 +327,11 @@ static void t_stop(struct seq_file *m, v
 	local_irq_enable();
 }
 
-static int trace_lookup_stack(struct seq_file *m, long i)
+static void trace_lookup_stack(struct seq_file *m, long i)
 {
 	unsigned long addr = stack_dump_trace[i];
 
-	return seq_printf(m, "%pS\n", (void *)addr);
+	seq_printf(m, "%pS\n", (void *)addr);
 }
 
 static void print_disabled(struct seq_file *m)
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
lib-vsprintfc-even-faster-decimal-conversion.patch
mm-utilc-add-kstrimdup.patch
checkpatch-improve-no-space-is-necessary-after-a-cast-test.patch
checkpatch-add-spell-checking-of-email-subject-line.patch
checkpatch-spell-check-reudce.patch
checkpatch-add-optional-codespell-dictionary-to-find-more-typos.patch
checkpatch-match-more-world-writable-permissions.patch
checkpatch-match-more-world-writable-permissions-fix.patch
checkpatch-improve-return-negative-errno-check.patch
checkpatch-add-test-for-repeated-const-uses.patch
checkpatch-dont-ask-for-asm-fileh-to-linux-fileh-unconditionally.patch
checkpatch-submittingpatches-suggest-line-wrapping-commit-messages-at-75-columns.patch
checkpatch-add-define-foo-string-long-line-exception.patch
checkpatch-add-uart_ops-to-normally-const-structs.patch
checkpatch-add-prefer-array_size-test.patch
checkpatch-improve-operator-spacing-check.patch
checkpatch-add-a-test-for-const-with-__read_mostly-uses.patch
checkpatchpl-new-instances-of-enosys-are-errors.patch
errnoh-improve-enosyss-comment.patch
checkpatch-fix-fix-use-with-a-patch-of-multiple-files.patch
checkpatch-avoid-spaces-required-around-that-false-positive.patch
rtc-use-more-standard-kernel-logging-styles.patch
adfs-returning-correct-return-values.patch
linux-next.patch
proc-show-locks-in-proc-pid-fdinfo-x.patch
proc-show-locks-in-proc-pid-fdinfo-x-v2.patch


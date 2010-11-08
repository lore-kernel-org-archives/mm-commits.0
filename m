From: akpm@linux-foundation.org
Subject: + fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps.patch added to -mm tree
Date: Mon, 08 Nov 2010 14:42:23 -0800
Message-ID: <201011082242.oA8MgNmI014058@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49113 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753310Ab0KHWmk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Nov 2010 17:42:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, trivial@kernel.org


The patch titled
     fs/proc/base.c, kernel/latencytop.c: convert sprintf_symbol() to %ps
has been added to the -mm tree.  Its filename is
     fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps.patch

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
Subject: fs/proc/base.c, kernel/latencytop.c: convert sprintf_symbol() to %ps
From: Joe Perches <joe@perches.com>

Use temporary lr for struct latency_record for improved readability and
fewer columns used.  Removed trailing space from output.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c      |   22 ++++++++--------------
 kernel/latencytop.c |   23 +++++++++--------------
 2 files changed, 17 insertions(+), 28 deletions(-)

diff -puN fs/proc/base.c~fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps fs/proc/base.c
--- a/fs/proc/base.c~fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps
+++ a/fs/proc/base.c
@@ -373,24 +373,18 @@ static int lstats_show_proc(struct seq_f
 		return -ESRCH;
 	seq_puts(m, "Latency Top version : v0.1\n");
 	for (i = 0; i < 32; i++) {
-		if (task->latency_record[i].backtrace[0]) {
+		struct latency_record *lr = &task->latency_record[i];
+		if (lr->backtrace[0]) {
 			int q;
-			seq_printf(m, "%i %li %li ",
-				task->latency_record[i].count,
-				task->latency_record[i].time,
-				task->latency_record[i].max);
+			seq_printf(m, "%i %li %li",
+				   lr->count, lr->time, lr->max);
 			for (q = 0; q < LT_BACKTRACEDEPTH; q++) {
-				char sym[KSYM_SYMBOL_LEN];
-				char *c;
-				if (!task->latency_record[i].backtrace[q])
+				unsigned long bt = lr->backtrace[q]; 
+				if (!bt)
 					break;
-				if (task->latency_record[i].backtrace[q] == ULONG_MAX)
+				if (bt == ULONG_MAX)
 					break;
-				sprint_symbol(sym, task->latency_record[i].backtrace[q]);
-				c = strchr(sym, '+');
-				if (c)
-					*c = 0;
-				seq_printf(m, "%s ", sym);
+				seq_printf(m, " %ps", (void *)bt);
 			}
 			seq_printf(m, "\n");
 		}
diff -puN kernel/latencytop.c~fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps kernel/latencytop.c
--- a/kernel/latencytop.c~fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps
+++ a/kernel/latencytop.c
@@ -242,24 +242,19 @@ static int lstats_show(struct seq_file *
 	seq_puts(m, "Latency Top version : v0.1\n");
 
 	for (i = 0; i < MAXLR; i++) {
-		if (latency_record[i].backtrace[0]) {
+		struct latency_record *lr = &latency_record[i];
+
+		if (lr->backtrace[0]) {
 			int q;
-			seq_printf(m, "%i %lu %lu ",
-				latency_record[i].count,
-				latency_record[i].time,
-				latency_record[i].max);
+			seq_printf(m, "%i %lu %lu",
+				   lr->count, lr->time, lr->max);
 			for (q = 0; q < LT_BACKTRACEDEPTH; q++) {
-				char sym[KSYM_SYMBOL_LEN];
-				char *c;
-				if (!latency_record[i].backtrace[q])
+				unsigned long bt = lr->backtrace[q]; 
+				if (!bt)
 					break;
-				if (latency_record[i].backtrace[q] == ULONG_MAX)
+				if (bt == ULONG_MAX)
 					break;
-				sprint_symbol(sym, latency_record[i].backtrace[q]);
-				c = strchr(sym, '+');
-				if (c)
-					*c = 0;
-				seq_printf(m, "%s ", sym);
+				seq_printf(m, " %ps", (void *)bt);
 			}
 			seq_printf(m, "\n");
 		}
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
mm-convert-sprintf_symbol-to-%ps.patch
scripts-get_maintainerpl-make-rolestats-the-default.patch
maintainers-intel-gfx-is-a-subscribers-only-mailing-list.patch
fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps.patch


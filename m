From: akpm@linux-foundation.org
Subject: [merged] dynamic_debug-use-a-single-printk-to-emit-messages.patch removed from -mm tree
Date: Thu, 27 Oct 2011 16:08:51 -0700
Message-ID: <201110272308.p9RN8pUg014520@wpaz24.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:22385 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789Ab1J0XI6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 27 Oct 2011 19:08:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbaron@redhat.com, arnd@arndb.de, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dynamic_debug: use a single printk() to emit messages
has been removed from the -mm tree.  Its filename was
     dynamic_debug-use-a-single-printk-to-emit-messages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jason Baron <jbaron@redhat.com>
Subject: dynamic_debug: use a single printk() to emit messages

We were using KERN_CONT to combine messages with their prefix.  However,
KERN_CONT is not smp safe, in the sense that it can interleave messages. 
This interleaving can result in printks coming out at the wrong loglevel. 
With the high frequency of printks that dynamic debug can produce this is
not desirable.

So make dynamic_emit_prefix() fill a char buf[64] instead of doing a
printk directly.  If we enable printing out of function, module, line, or
pid info, they are placed in this 64 byte buffer.  In my testing 64 bytes
was enough size to fulfill all requests.  Even if it's not, we can match
up the printk itself to see where it's from, so to me this is no big deal.

[akpm@linux-foundation.org: convert dangerous macro to C]
Signed-off-by: Jason Baron <jbaron@redhat.com>
Cc: Greg KH <greg@kroah.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dynamic_debug.c |   80 +++++++++++++++++++++---------------------
 1 file changed, 41 insertions(+), 39 deletions(-)

diff -puN lib/dynamic_debug.c~dynamic_debug-use-a-single-printk-to-emit-messages lib/dynamic_debug.c
--- a/lib/dynamic_debug.c~dynamic_debug-use-a-single-printk-to-emit-messages
+++ a/lib/dynamic_debug.c
@@ -421,52 +421,60 @@ static int ddebug_exec_query(char *query
 	return 0;
 }
 
-static int dynamic_emit_prefix(const struct _ddebug *descriptor)
+#define PREFIX_SIZE 64
+
+static int remaining(int wrote)
+{
+	if (PREFIX_SIZE - wrote > 0)
+		return PREFIX_SIZE - wrote;
+	return 0;
+}
+
+static char *dynamic_emit_prefix(const struct _ddebug *desc, char *buf)
 {
-	char tid[sizeof(int) + sizeof(int)/2 + 4];
-	char lineno[sizeof(int) + sizeof(int)/2];
+	int pos_after_tid;
+	int pos = 0;
 
-	if (descriptor->flags & _DPRINTK_FLAGS_INCL_TID) {
+	pos += snprintf(buf + pos, remaining(pos), "%s", KERN_DEBUG);
+	if (desc->flags & _DPRINTK_FLAGS_INCL_TID) {
 		if (in_interrupt())
-			snprintf(tid, sizeof(tid), "%s", "<intr> ");
+			pos += snprintf(buf + pos, remaining(pos), "%s ",
+						"<intr>");
 		else
-			snprintf(tid, sizeof(tid), "[%d] ",
-				 task_pid_vnr(current));
-	} else {
-		tid[0] = 0;
+			pos += snprintf(buf + pos, remaining(pos), "[%d] ",
+						task_pid_vnr(current));
 	}
+	pos_after_tid = pos;
+	if (desc->flags & _DPRINTK_FLAGS_INCL_MODNAME)
+		pos += snprintf(buf + pos, remaining(pos), "%s:",
+					desc->modname);
+	if (desc->flags & _DPRINTK_FLAGS_INCL_FUNCNAME)
+		pos += snprintf(buf + pos, remaining(pos), "%s:",
+					desc->function);
+	if (desc->flags & _DPRINTK_FLAGS_INCL_LINENO)
+		pos += snprintf(buf + pos, remaining(pos), "%d:", desc->lineno);
+	if (pos - pos_after_tid)
+		pos += snprintf(buf + pos, remaining(pos), " ");
+	if (pos >= PREFIX_SIZE)
+		buf[PREFIX_SIZE - 1] = '\0';
 
-	if (descriptor->flags & _DPRINTK_FLAGS_INCL_LINENO)
-		snprintf(lineno, sizeof(lineno), "%d", descriptor->lineno);
-	else
-		lineno[0] = 0;
-
-	return printk(KERN_DEBUG "%s%s%s%s%s%s",
-		      tid,
-		      (descriptor->flags & _DPRINTK_FLAGS_INCL_MODNAME) ?
-		      descriptor->modname : "",
-		      (descriptor->flags & _DPRINTK_FLAGS_INCL_MODNAME) ?
-		      ":" : "",
-		      (descriptor->flags & _DPRINTK_FLAGS_INCL_FUNCNAME) ?
-		      descriptor->function : "",
-		      (descriptor->flags & _DPRINTK_FLAGS_INCL_FUNCNAME) ?
-		      ":" : "",
-		      lineno);
+	return buf;
 }
 
 int __dynamic_pr_debug(struct _ddebug *descriptor, const char *fmt, ...)
 {
 	va_list args;
 	int res;
+	struct va_format vaf;
+	char buf[PREFIX_SIZE];
 
 	BUG_ON(!descriptor);
 	BUG_ON(!fmt);
 
 	va_start(args, fmt);
-
-	res = dynamic_emit_prefix(descriptor);
-	res += vprintk(fmt, args);
-
+	vaf.fmt = fmt;
+	vaf.va = &args;
+	res = printk("%s%pV", dynamic_emit_prefix(descriptor, buf), &vaf);
 	va_end(args);
 
 	return res;
@@ -479,18 +487,15 @@ int __dynamic_dev_dbg(struct _ddebug *de
 	struct va_format vaf;
 	va_list args;
 	int res;
+	char buf[PREFIX_SIZE];
 
 	BUG_ON(!descriptor);
 	BUG_ON(!fmt);
 
 	va_start(args, fmt);
-
 	vaf.fmt = fmt;
 	vaf.va = &args;
-
-	res = dynamic_emit_prefix(descriptor);
-	res += __dev_printk(KERN_CONT, dev, &vaf);
-
+	res = __dev_printk(dynamic_emit_prefix(descriptor, buf), dev, &vaf);
 	va_end(args);
 
 	return res;
@@ -503,18 +508,15 @@ int __dynamic_netdev_dbg(struct _ddebug 
 	struct va_format vaf;
 	va_list args;
 	int res;
+	char buf[PREFIX_SIZE];
 
 	BUG_ON(!descriptor);
 	BUG_ON(!fmt);
 
 	va_start(args, fmt);
-
 	vaf.fmt = fmt;
 	vaf.va = &args;
-
-	res = dynamic_emit_prefix(descriptor);
-	res += __netdev_printk(KERN_CONT, dev, &vaf);

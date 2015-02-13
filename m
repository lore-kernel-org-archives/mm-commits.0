From: akpm@linux-foundation.org
Subject: [merged] fs-proc-arrayc-convert-to-use-string_escape_str.patch
 removed from -mm tree
Date: Fri, 13 Feb 2015 12:21:43 -0800
Message-ID: <54de5cd7.ILg6cLCrR985gGkB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49008 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbbBMUVo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:21:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/array.c: convert to use string_escape_str()
has been removed from the -mm tree.  Its filename was
     fs-proc-arrayc-convert-to-use-string_escape_str.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: fs/proc/array.c: convert to use string_escape_str()

Instead of custom approach let's use string_escape_str() to escape a given
string (task_name in this case).

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c |   34 +++++++---------------------------
 1 file changed, 7 insertions(+), 27 deletions(-)

diff -puN fs/proc/array.c~fs-proc-arrayc-convert-to-use-string_escape_str fs/proc/array.c
--- a/fs/proc/array.c~fs-proc-arrayc-convert-to-use-string_escape_str
+++ a/fs/proc/array.c
@@ -81,6 +81,7 @@
 #include <linux/pid_namespace.h>
 #include <linux/ptrace.h>
 #include <linux/tracehook.h>
+#include <linux/string_helpers.h>
 #include <linux/user_namespace.h>
 
 #include <asm/pgtable.h>
@@ -89,39 +90,18 @@
 
 static inline void task_name(struct seq_file *m, struct task_struct *p)
 {
-	int i;
-	char *buf, *end;
-	char *name;
+	char *buf;
 	char tcomm[sizeof(p->comm)];
 
 	get_task_comm(tcomm, p);
 
 	seq_puts(m, "Name:\t");
-	end = m->buf + m->size;
 	buf = m->buf + m->count;
-	name = tcomm;
-	i = sizeof(tcomm);
-	while (i && (buf < end)) {
-		unsigned char c = *name;
-		name++;
-		i--;
-		*buf = c;
-		if (!c)
-			break;
-		if (c == '\\') {
-			buf++;
-			if (buf < end)
-				*buf++ = c;
-			continue;
-		}
-		if (c == '\n') {
-			*buf++ = '\\';
-			if (buf < end)
-				*buf++ = 'n';
-			continue;
-		}
-		buf++;
-	}
+
+	/* Ignore error for now */
+	string_escape_str(tcomm, &buf, m->size - m->count,
+			  ESCAPE_SPACE | ESCAPE_SPECIAL, "\n\\");
+
 	m->count = buf - m->buf;
 	seq_putc(m, '\n');
 }
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

origin.patch
linux-next.patch


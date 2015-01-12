From: akpm@linux-foundation.org
Subject: + fs-proc-arrayc-convert-to-use-string_escape_str.patch added to
 -mm tree
Date: Mon, 12 Jan 2015 13:00:02 -0800
Message-ID: <54b435d2.TnZUcB3p2BOElDJG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35123 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbbALVAD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jan 2015 16:00:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/array.c: convert to use string_escape_str()
has been added to the -mm tree.  Its filename is
     fs-proc-arrayc-convert-to-use-string_escape_str.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-proc-arrayc-convert-to-use-string_escape_str.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-proc-arrayc-convert-to-use-string_escape_str.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

fs-proc-arrayc-convert-to-use-string_escape_str.patch
hexdump-introduce-test-suite.patch
hexdump-fix-ascii-column-for-the-tail-of-a-dump.patch
hexdump-do-few-calculations-ahead.patch
hexdump-makes-it-return-amount-of-bytes-placed-in-buffer.patch
hexdump-makes-it-return-amount-of-bytes-placed-in-buffer-fix.patch
linux-next.patch


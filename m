From: akpm@linux-foundation.org
Subject: [merged] fs-proc-arrayc-set-overflow-flag-in-case-of-error.patch
 removed from -mm tree
Date: Mon, 09 Nov 2015 11:45:38 -0800
Message-ID: <5640f7e2.GpvMjXRheC6I3ljE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57268 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbbKITpi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 14:45:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/array.c: set overflow flag in case of error
has been removed from the -mm tree.  Its filename was
     fs-proc-arrayc-set-overflow-flag-in-case-of-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: fs/proc/array.c: set overflow flag in case of error

For now in task_name() we ignore the return code of string_escape_str()
call.  This is not good if buffer suddenly becomes not big enough.  Do the
proper error handling there.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN fs/proc/array.c~fs-proc-arrayc-set-overflow-flag-in-case-of-error fs/proc/array.c
--- a/fs/proc/array.c~fs-proc-arrayc-set-overflow-flag-in-case-of-error
+++ a/fs/proc/array.c
@@ -91,18 +91,18 @@
 static inline void task_name(struct seq_file *m, struct task_struct *p)
 {
 	char *buf;
+	size_t size;
 	char tcomm[sizeof(p->comm)];
+	int ret;
 
 	get_task_comm(tcomm, p);
 
 	seq_puts(m, "Name:\t");
-	buf = m->buf + m->count;
 
-	/* Ignore error for now */
-	buf += string_escape_str(tcomm, buf, m->size - m->count,
-				 ESCAPE_SPACE | ESCAPE_SPECIAL, "\n\\");
+	size = seq_get_buf(m, &buf);
+	ret = string_escape_str(tcomm, buf, size, ESCAPE_SPACE | ESCAPE_SPECIAL, "\n\\");
+	seq_commit(m, ret < size ? ret : -1);
 
-	m->count = buf - m->buf;
 	seq_putc(m, '\n');
 }
 
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

hexdump-truncate-output-in-case-of-overflow.patch
fs-seq_file-use-seq_-helpers-in-seq_hex_dump.patch
seq_file-re-use-string_escape_str.patch


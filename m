From: akpm@linux-foundation.org
Subject: + fs-proc-arrayc-set-overflow-flag-in-case-of-error.patch added
 to -mm tree
Date: Fri, 18 Sep 2015 13:01:36 -0700
Message-ID: <55fc6da0.zcUtJ6wEqA25iR1H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48169 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134AbbIRUBh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 18 Sep 2015 16:01:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/array.c: set overflow flag in case of error
has been added to the -mm tree.  Its filename is
     fs-proc-arrayc-set-overflow-flag-in-case-of-error.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-proc-arrayc-set-overflow-flag-in-case-of-error.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-proc-arrayc-set-overflow-flag-in-case-of-error.patch

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

fs-proc-arrayc-set-overflow-flag-in-case-of-error.patch


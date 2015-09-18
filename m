From: akpm@linux-foundation.org
Subject: + seq_file-re-use-string_escape_str.patch added to -mm tree
Date: Fri, 18 Sep 2015 13:05:29 -0700
Message-ID: <55fc6e89.bOcy+6xJcyAbSQa5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48655 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675AbbIRUFa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 18 Sep 2015 16:05:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: seq_file: reuse string_escape_str()
has been added to the -mm tree.  Its filename is
     seq_file-re-use-string_escape_str.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/seq_file-re-use-string_escape_str.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/seq_file-re-use-string_escape_str.patch

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
Subject: seq_file: reuse string_escape_str()

strint_escape_str() escapes input string by given criteria.  In case of
seq_escape() the criteria is to convert some characters to their octal
representation.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/seq_file.c |   27 +++++++--------------------
 1 file changed, 7 insertions(+), 20 deletions(-)

diff -puN fs/seq_file.c~seq_file-re-use-string_escape_str fs/seq_file.c
--- a/fs/seq_file.c~seq_file-re-use-string_escape_str
+++ a/fs/seq_file.c
@@ -13,6 +13,7 @@
 #include <linux/cred.h>
 #include <linux/mm.h>
 #include <linux/printk.h>
+#include <linux/string_helpers.h>
 
 #include <asm/uaccess.h>
 #include <asm/page.h>
@@ -377,26 +378,12 @@ EXPORT_SYMBOL(seq_release);
  */
 void seq_escape(struct seq_file *m, const char *s, const char *esc)
 {
-	char *end = m->buf + m->size;
-	char *p;
-	char c;
-
-	for (p = m->buf + m->count; (c = *s) != '\0' && p < end; s++) {
-		if (!strchr(esc, c)) {
-			*p++ = c;
-			continue;
-		}
-		if (p + 3 < end) {
-			*p++ = '\\';
-			*p++ = '0' + ((c & 0300) >> 6);
-			*p++ = '0' + ((c & 070) >> 3);
-			*p++ = '0' + (c & 07);
-			continue;
-		}
-		seq_set_overflow(m);
-		return;
-	}
-	m->count = p - m->buf;
+	char *buf;
+	size_t size = seq_get_buf(m, &buf);
+	int ret;
+
+	ret = string_escape_str(s, buf, size, ESCAPE_OCTAL, esc);
+	seq_commit(m, ret < size ? ret : -1);
 }
 EXPORT_SYMBOL(seq_escape);
 
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

fs-proc-arrayc-set-overflow-flag-in-case-of-error.patch
seq_file-re-use-string_escape_str.patch
fs-seq_file-use-seq_-helpers-in-seq_hex_dump.patch


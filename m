From: akpm@linux-foundation.org
Subject: + fs-seq_file-use-seq_-helpers-in-seq_hex_dump.patch added to -mm tree
Date: Fri, 18 Sep 2015 13:05:31 -0700
Message-ID: <55fc6e8b.CwK2X9IOnD4flQMj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48658 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675AbbIRUFc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 18 Sep 2015 16:05:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/seq_file: use seq_* helpers in seq_hex_dump()
has been added to the -mm tree.  Its filename is
     fs-seq_file-use-seq_-helpers-in-seq_hex_dump.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-seq_file-use-seq_-helpers-in-seq_hex_dump.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-seq_file-use-seq_-helpers-in-seq_hex_dump.patch

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
Subject: fs/seq_file: use seq_* helpers in seq_hex_dump()

This improves code readability.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/seq_file.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff -puN fs/seq_file.c~fs-seq_file-use-seq_-helpers-in-seq_hex_dump fs/seq_file.c
--- a/fs/seq_file.c~fs-seq_file-use-seq_-helpers-in-seq_hex_dump
+++ a/fs/seq_file.c
@@ -760,6 +760,8 @@ void seq_hex_dump(struct seq_file *m, co
 {
 	const u8 *ptr = buf;
 	int i, linelen, remaining = len;
+	char *buffer;
+	size_t size;
 	int ret;
 
 	if (rowsize != 16 && rowsize != 32)
@@ -781,15 +783,12 @@ void seq_hex_dump(struct seq_file *m, co
 			break;
 		}
 
+		size = seq_get_buf(m, &buffer);
 		ret = hex_dump_to_buffer(ptr + i, linelen, rowsize, groupsize,
-					 m->buf + m->count, m->size - m->count,
-					 ascii);
-		if (ret >= m->size - m->count) {
-			seq_set_overflow(m);
-		} else {
-			m->count += ret;
-			seq_putc(m, '\n');
-		}
+					 buffer, size, ascii);
+		seq_commit(m, ret < size ? ret : -1);
+
+		seq_putc(m, '\n');
 	}
 }
 EXPORT_SYMBOL(seq_hex_dump);
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

fs-proc-arrayc-set-overflow-flag-in-case-of-error.patch
seq_file-re-use-string_escape_str.patch
fs-seq_file-use-seq_-helpers-in-seq_hex_dump.patch


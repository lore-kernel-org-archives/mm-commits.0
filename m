From: akpm@linux-foundation.org
Subject: [merged] fs-seq_file-use-seq_-helpers-in-seq_hex_dump.patch
 removed from -mm tree
Date: Mon, 09 Nov 2015 12:13:36 -0800
Message-ID: <5640fe70.7keW76NwrAkVA1hF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57680 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515AbbKIUNg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 15:13:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/seq_file: use seq_* helpers in seq_hex_dump()
has been removed from the -mm tree.  Its filename was
     fs-seq_file-use-seq_-helpers-in-seq_hex_dump.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -773,6 +773,8 @@ void seq_hex_dump(struct seq_file *m, co
 {
 	const u8 *ptr = buf;
 	int i, linelen, remaining = len;
+	char *buffer;
+	size_t size;
 	int ret;
 
 	if (rowsize != 16 && rowsize != 32)
@@ -794,15 +796,12 @@ void seq_hex_dump(struct seq_file *m, co
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



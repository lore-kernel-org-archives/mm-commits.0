From: akpm@linux-foundation.org
Subject: [merged] seq_file-provide-an-analogue-of-print_hex_dump.patch
 removed from -mm tree
Date: Fri, 11 Sep 2015 11:13:01 -0700
Message-ID: <55f319ad.vQN6P93gf3rnAbJY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53957 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588AbbIKSNC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 14:13:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, catalin.marinas@arm.com, deller@gmx.de, ingo.tuchscherer@de.ibm.com, joe@perches.com, qca_vkondrat@qca.qualcomm.com, tadeusz.struk@intel.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: seq_file: provide an analogue of print_hex_dump()
has been removed from the -mm tree.  Its filename was
     seq_file-provide-an-analogue-of-print_hex_dump.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: seq_file: provide an analogue of print_hex_dump()

This introduces a new helper and switches current users to use it.  All
patches are compiled tested. kmemleak is tested via its own test suite.

This patch (of 6):

The new seq_hex_dump() is a complete analogue of print_hex_dump().

We have few users of this functionality already. It allows to reduce their
codebase.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Joe Perches <joe@perches.com>
Cc: Tadeusz Struk <tadeusz.struk@intel.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/seq_file.c            |   42 +++++++++++++++++++++++++++++++++++++
 include/linux/seq_file.h |    4 +++
 2 files changed, 46 insertions(+)

diff -puN fs/seq_file.c~seq_file-provide-an-analogue-of-print_hex_dump fs/seq_file.c
--- a/fs/seq_file.c~seq_file-provide-an-analogue-of-print_hex_dump
+++ a/fs/seq_file.c
@@ -12,6 +12,7 @@
 #include <linux/slab.h>
 #include <linux/cred.h>
 #include <linux/mm.h>
+#include <linux/printk.h>
 
 #include <asm/uaccess.h>
 #include <asm/page.h>
@@ -773,6 +774,47 @@ void seq_pad(struct seq_file *m, char c)
 }
 EXPORT_SYMBOL(seq_pad);
 
+/* A complete analogue of print_hex_dump() */
+void seq_hex_dump(struct seq_file *m, const char *prefix_str, int prefix_type,
+		  int rowsize, int groupsize, const void *buf, size_t len,
+		  bool ascii)
+{
+	const u8 *ptr = buf;
+	int i, linelen, remaining = len;
+	int ret;
+
+	if (rowsize != 16 && rowsize != 32)
+		rowsize = 16;
+
+	for (i = 0; i < len && !seq_has_overflowed(m); i += rowsize) {
+		linelen = min(remaining, rowsize);
+		remaining -= rowsize;
+
+		switch (prefix_type) {
+		case DUMP_PREFIX_ADDRESS:
+			seq_printf(m, "%s%p: ", prefix_str, ptr + i);
+			break;
+		case DUMP_PREFIX_OFFSET:
+			seq_printf(m, "%s%.8x: ", prefix_str, i);
+			break;
+		default:
+			seq_printf(m, "%s", prefix_str);
+			break;
+		}
+
+		ret = hex_dump_to_buffer(ptr + i, linelen, rowsize, groupsize,
+					 m->buf + m->count, m->size - m->count,
+					 ascii);
+		if (ret >= m->size - m->count) {
+			seq_set_overflow(m);
+		} else {
+			m->count += ret;
+			seq_putc(m, '\n');
+		}
+	}
+}
+EXPORT_SYMBOL(seq_hex_dump);
+
 struct list_head *seq_list_start(struct list_head *head, loff_t pos)
 {
 	struct list_head *lh;
diff -puN include/linux/seq_file.h~seq_file-provide-an-analogue-of-print_hex_dump include/linux/seq_file.h
--- a/include/linux/seq_file.h~seq_file-provide-an-analogue-of-print_hex_dump
+++ a/include/linux/seq_file.h
@@ -122,6 +122,10 @@ int seq_write(struct seq_file *seq, cons
 __printf(2, 3) int seq_printf(struct seq_file *, const char *, ...);
 __printf(2, 0) int seq_vprintf(struct seq_file *, const char *, va_list args);
 
+void seq_hex_dump(struct seq_file *m, const char *prefix_str, int prefix_type,
+		  int rowsize, int groupsize, const void *buf, size_t len,
+		  bool ascii);
+
 int seq_path(struct seq_file *, const struct path *, const char *);
 int seq_file_path(struct seq_file *, struct file *, const char *);
 int seq_dentry(struct seq_file *, struct dentry *, const char *);
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are



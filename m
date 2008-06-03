From: akpm@linux-foundation.org
Subject: - seq_file-add-function-to-write-binary-data.patch removed from -mm tree
Date: Tue, 03 Jun 2008 15:51:11 -0700
Message-ID: <200806032251.m53MpBIw023992@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45026 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755141AbYFCWwg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jun 2008 18:52:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peter.oberparleiter@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     seq_file: add function to write binary data
has been removed from the -mm tree.  Its filename was
     seq_file-add-function-to-write-binary-data.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: seq_file: add function to write binary data
From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>

seq_write() can be used to construct seq_files containing arbitrary data. 
Required by the gcov-profiling interface to synthesize binary profiling
data files.

Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/seq_file.c            |   20 ++++++++++++++++++++
 include/linux/seq_file.h |    1 +
 2 files changed, 21 insertions(+)

diff -puN fs/seq_file.c~seq_file-add-function-to-write-binary-data fs/seq_file.c
--- a/fs/seq_file.c~seq_file-add-function-to-write-binary-data
+++ a/fs/seq_file.c
@@ -554,6 +554,26 @@ int seq_puts(struct seq_file *m, const c
 }
 EXPORT_SYMBOL(seq_puts);
 
+/**
+ * seq_write - write arbitrary data to buffer
+ * @seq: seq_file identifying the buffer to which data should be written
+ * @data: data address
+ * @len: number of bytes
+ *
+ * Return 0 on success, non-zero otherwise.
+ */
+int seq_write(struct seq_file *seq, const void *data, size_t len)
+{
+	if (seq->count + len < seq->size) {
+		memcpy(seq->buf + seq->count, data, len);
+		seq->count += len;
+		return 0;
+	}
+	seq->count = seq->size;
+	return -1;
+}
+EXPORT_SYMBOL(seq_write);
+
 struct list_head *seq_list_start(struct list_head *head, loff_t pos)
 {
 	struct list_head *lh;
diff -puN include/linux/seq_file.h~seq_file-add-function-to-write-binary-data include/linux/seq_file.h
--- a/include/linux/seq_file.h~seq_file-add-function-to-write-binary-data
+++ a/include/linux/seq_file.h
@@ -39,6 +39,7 @@ int seq_release(struct inode *, struct f
 int seq_escape(struct seq_file *, const char *, const char *);
 int seq_putc(struct seq_file *m, char c);
 int seq_puts(struct seq_file *m, const char *s);
+int seq_write(struct seq_file *seq, const void *data, size_t len);
 
 int seq_printf(struct seq_file *, const char *, ...)
 	__attribute__ ((format (printf,2,3)));
_

Patches currently in -mm which might be from peter.oberparleiter@de.ibm.com are

origin.patch
linux-next.patch
seq_file-add-function-to-write-binary-data.patch
gcov-add-gcov-profiling-infrastructure.patch
kbuild-make-source-and-include-paths-absolute.patch
gcov-architecture-specific-compile-flag-adjustments.patch
gcov-architecture-specific-compile-flag-adjustments-fix.patch


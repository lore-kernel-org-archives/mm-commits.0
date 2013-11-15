From: akpm@linux-foundation.org
Subject: [merged] seq_file-introduce-seq_setwidth-and-seq_pad.patch
 removed from -mm tree
Date: Fri, 15 Nov 2013 12:08:55 -0800
Message-ID: <52867f57.ZhZx5B+85g94+r8r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35758 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233Ab3KOUI4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Nov 2013 15:08:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, keescook@chromium.org, joe@perches.com, davem@davemloft.net, penguin-kernel@I-love.SAKURA.ne.jp

Subject: [merged] seq_file-introduce-seq_setwidth-and-seq_pad.patch removed from -mm tree
To: penguin-kernel@I-love.SAKURA.ne.jp,davem@davemloft.net,joe@perches.com,keescook@chromium.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 15 Nov 2013 12:08:55 -0800


The patch titled
     Subject: seq_file: introduce seq_setwidth() and seq_pad()
has been removed from the -mm tree.  Its filename was
     seq_file-introduce-seq_setwidth-and-seq_pad.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: seq_file: introduce seq_setwidth() and seq_pad()

There are several users who want to know bytes written by seq_*() for
alignment purpose.  Currently they are using %n format for knowing it
because seq_*() returns 0 on success.

This patch introduces seq_setwidth() and seq_pad() for allowing them to
align without using %n format.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Joe Perches <joe@perches.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/seq_file.c            |   15 +++++++++++++++
 include/linux/seq_file.h |   15 +++++++++++++++
 2 files changed, 30 insertions(+)

diff -puN fs/seq_file.c~seq_file-introduce-seq_setwidth-and-seq_pad fs/seq_file.c
--- a/fs/seq_file.c~seq_file-introduce-seq_setwidth-and-seq_pad
+++ a/fs/seq_file.c
@@ -766,6 +766,21 @@ int seq_write(struct seq_file *seq, cons
 }
 EXPORT_SYMBOL(seq_write);
 
+/**
+ * seq_pad - write padding spaces to buffer
+ * @m: seq_file identifying the buffer to which data should be written
+ * @c: the byte to append after padding if non-zero
+ */
+void seq_pad(struct seq_file *m, char c)
+{
+	int size = m->pad_until - m->count;
+	if (size > 0)
+		seq_printf(m, "%*s", size, "");
+	if (c)
+		seq_putc(m, c);
+}
+EXPORT_SYMBOL(seq_pad);
+
 struct list_head *seq_list_start(struct list_head *head, loff_t pos)
 {
 	struct list_head *lh;
diff -puN include/linux/seq_file.h~seq_file-introduce-seq_setwidth-and-seq_pad include/linux/seq_file.h
--- a/include/linux/seq_file.h~seq_file-introduce-seq_setwidth-and-seq_pad
+++ a/include/linux/seq_file.h
@@ -20,6 +20,7 @@ struct seq_file {
 	size_t size;
 	size_t from;
 	size_t count;
+	size_t pad_until;
 	loff_t index;
 	loff_t read_pos;
 	u64 version;
@@ -79,6 +80,20 @@ static inline void seq_commit(struct seq
 	}
 }
 
+/**
+ * seq_setwidth - set padding width
+ * @m: the seq_file handle
+ * @size: the max number of bytes to pad.
+ *
+ * Call seq_setwidth() for setting max width, then call seq_printf() etc. and
+ * finally call seq_pad() to pad the remaining bytes.
+ */
+static inline void seq_setwidth(struct seq_file *m, size_t size)
+{
+	m->pad_until = m->count + size;
+}
+void seq_pad(struct seq_file *m, char c);
+
 char *mangle_path(char *s, const char *p, const char *esc);
 int seq_open(struct file *, const struct seq_operations *);
 ssize_t seq_read(struct file *, char __user *, size_t, loff_t *);
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are

origin.patch
linux-next.patch


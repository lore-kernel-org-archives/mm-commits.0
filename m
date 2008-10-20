From: akpm@linux-foundation.org
Subject: - seq_file-add-seq_cpumask_list-seq_nodemask_list.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:36:45 -0700
Message-ID: <200810202036.m9KKajsW011445@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44354 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753857AbYJTUhm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:37:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laijs@cn.fujitsu.com, adobriyan@gmail.com, menage@google.com, pj@sgi.com, mm-commits@vger.kernel.org


The patch titled
     seq_file: add seq_cpumask_list(), seq_nodemask_list()
has been removed from the -mm tree.  Its filename was
     seq_file-add-seq_cpumask_list-seq_nodemask_list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: seq_file: add seq_cpumask_list(), seq_nodemask_list()
From: Lai Jiangshan <laijs@cn.fujitsu.com>

seq_cpumask_list(), seq_nodemask_list() are very like seq_cpumask(),
seq_nodemask(), but they print human readable string.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Paul Menage <menage@google.com>
Cc: Paul Jackson <pj@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/seq_file.c            |   16 ++++++++++++++++
 include/linux/seq_file.h |   13 +++++++++++++
 2 files changed, 29 insertions(+)

diff -puN fs/seq_file.c~seq_file-add-seq_cpumask_list-seq_nodemask_list fs/seq_file.c
--- a/fs/seq_file.c~seq_file-add-seq_cpumask_list-seq_nodemask_list
+++ a/fs/seq_file.c
@@ -465,6 +465,22 @@ int seq_bitmap(struct seq_file *m, unsig
 }
 EXPORT_SYMBOL(seq_bitmap);
 
+int seq_bitmap_list(struct seq_file *m, unsigned long *bits,
+		unsigned int nr_bits)
+{
+	if (m->count < m->size) {
+		int len = bitmap_scnlistprintf(m->buf + m->count,
+				m->size - m->count, bits, nr_bits);
+		if (m->count + len < m->size) {
+			m->count += len;
+			return 0;
+		}
+	}
+	m->count = m->size;
+	return -1;
+}
+EXPORT_SYMBOL(seq_bitmap_list);
+
 static void *single_start(struct seq_file *p, loff_t *pos)
 {
 	return NULL + (*pos == 0);
diff -puN include/linux/seq_file.h~seq_file-add-seq_cpumask_list-seq_nodemask_list include/linux/seq_file.h
--- a/include/linux/seq_file.h~seq_file-add-seq_cpumask_list-seq_nodemask_list
+++ a/include/linux/seq_file.h
@@ -60,6 +60,19 @@ static inline int seq_nodemask(struct se
 	return seq_bitmap(m, mask->bits, MAX_NUMNODES);
 }
 
+int seq_bitmap_list(struct seq_file *m, unsigned long *bits,
+		unsigned int nr_bits);
+
+static inline int seq_cpumask_list(struct seq_file *m, cpumask_t *mask)
+{
+	return seq_bitmap_list(m, mask->bits, NR_CPUS);
+}
+
+static inline int seq_nodemask_list(struct seq_file *m, nodemask_t *mask)
+{
+	return seq_bitmap_list(m, mask->bits, MAX_NUMNODES);
+}
+
 int single_open(struct file *, int (*)(struct seq_file *, void *), void *);
 int single_release(struct inode *, struct file *);
 void *__seq_open_private(struct file *, const struct seq_operations *, int);
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

origin.patch
linux-next.patch


From: akpm@linux-foundation.org
Subject: + seq_file-add-seq_cpumask_list-seq_nodemask_list.patch added to -mm tree
Date: Thu, 16 Oct 2008 12:54:42 -0700
Message-ID: <200810161954.m9GJsg2b010545@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42016 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753979AbYJPTzW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 15:55:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: laijs@cn.fujitsu.com, adobriyan@gmail.com, menage@google.com, pj@sgi.com


The patch titled
     seq_file: add seq_cpumask_list(), seq_nodemask_list()
has been added to the -mm tree.  Its filename is
     seq_file-add-seq_cpumask_list-seq_nodemask_list.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

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
cgroups-fix-probable-race-with-put_css_set-and-find_css_set.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set-fix.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set-cgroups-eliminate-race-in-css_set-refcounting.patch
cgroups-convert-tasks-file-to-use-a-seq_file-with-shared-pid-array.patch
devcgroup-remove-spin_lock.patch
seq_file-dont-call-bitmap_scnprintf_len.patch
seq_file-add-seq_cpumask_list-seq_nodemask_list.patch
cpuset-use-seq_mask_-to-print-masks.patch
bitmask-remove-bitmap_scnprintf_len.patch


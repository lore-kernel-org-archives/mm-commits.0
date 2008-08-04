From: akpm@linux-foundation.org
Subject: + seq_file-add-seq_cpumask-seq_nodemask.patch added to -mm tree
Date: Mon, 04 Aug 2008 16:38:28 -0700
Message-ID: <200808042338.m74NcSRA005707@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32893 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756940AbYHDXjC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 19:39:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, pj@sgi.com, travis@sgi.com, viro@zeniv.linux.org.uk


The patch titled
     seq_file: add seq_cpumask(), seq_nodemask()
has been added to the -mm tree.  Its filename is
     seq_file-add-seq_cpumask-seq_nodemask.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: seq_file: add seq_cpumask(), seq_nodemask()
From: Alexey Dobriyan <adobriyan@gmail.com>

Short enough reads from /proc/irq/*/smp_affinity return -EINVAL for no
good reason.

This became noticed with NR_CPUS=4096 patches, when length of printed
representation of cpumask becase 1152, but cat(1) continued to read with
1024-byte chunks.  bitmap_scnprintf() in good faith fills buffer, returns
1023, check returns -EINVAL.

Fix it by switching to seq_file, so handler will just fill buffer and
doesn't care about offsets, length, filling EOF and all this crap.

For that add seq_bitmap(), and wrappers around it -- seq_cpumask() and
seq_nodemask().

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Reviewed-by: Paul Jackson <pj@sgi.com>
Cc: Mike Travis <travis@sgi.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/seq_file.c            |   14 ++++++++++++++
 include/linux/bitmap.h   |    1 +
 include/linux/seq_file.h |   12 ++++++++++++
 lib/bitmap.c             |   11 +++++++++++
 4 files changed, 38 insertions(+)

diff -puN fs/seq_file.c~seq_file-add-seq_cpumask-seq_nodemask fs/seq_file.c
--- a/fs/seq_file.c~seq_file-add-seq_cpumask-seq_nodemask
+++ a/fs/seq_file.c
@@ -454,6 +454,20 @@ int seq_dentry(struct seq_file *m, struc
 	return -1;
 }
 
+int seq_bitmap(struct seq_file *m, unsigned long *bits, unsigned int nr_bits)
+{
+	size_t len = bitmap_scnprintf_len(nr_bits);
+
+	if (m->count + len < m->size) {
+		bitmap_scnprintf(m->buf + m->count, m->size - m->count,
+				 bits, nr_bits);
+		m->count += len;
+		return 0;
+	}
+	m->count = m->size;
+	return -1;
+}
+
 static void *single_start(struct seq_file *p, loff_t *pos)
 {
 	return NULL + (*pos == 0);
diff -puN include/linux/bitmap.h~seq_file-add-seq_cpumask-seq_nodemask include/linux/bitmap.h
--- a/include/linux/bitmap.h~seq_file-add-seq_cpumask-seq_nodemask
+++ a/include/linux/bitmap.h
@@ -110,6 +110,7 @@ extern int __bitmap_weight(const unsigne
 
 extern int bitmap_scnprintf(char *buf, unsigned int len,
 			const unsigned long *src, int nbits);
+extern int bitmap_scnprintf_len(unsigned int nr_bits);
 extern int __bitmap_parse(const char *buf, unsigned int buflen, int is_user,
 			unsigned long *dst, int nbits);
 extern int bitmap_parse_user(const char __user *ubuf, unsigned int ulen,
diff -puN include/linux/seq_file.h~seq_file-add-seq_cpumask-seq_nodemask include/linux/seq_file.h
--- a/include/linux/seq_file.h~seq_file-add-seq_cpumask-seq_nodemask
+++ a/include/linux/seq_file.h
@@ -4,6 +4,8 @@
 #include <linux/types.h>
 #include <linux/string.h>
 #include <linux/mutex.h>
+#include <linux/cpumask.h>
+#include <linux/nodemask.h>
 
 struct seq_operations;
 struct file;
@@ -47,6 +49,16 @@ int seq_path(struct seq_file *, struct p
 int seq_dentry(struct seq_file *, struct dentry *, char *);
 int seq_path_root(struct seq_file *m, struct path *path, struct path *root,
 		  char *esc);
+int seq_bitmap(struct seq_file *m, unsigned long *bits, unsigned int nr_bits);
+static inline int seq_cpumask(struct seq_file *m, cpumask_t *mask)
+{
+	return seq_bitmap(m, mask->bits, NR_CPUS);
+}
+
+static inline int seq_nodemask(struct seq_file *m, nodemask_t *mask)
+{
+	return seq_bitmap(m, mask->bits, MAX_NUMNODES);
+}
 
 int single_open(struct file *, int (*)(struct seq_file *, void *), void *);
 int single_release(struct inode *, struct file *);
diff -puN lib/bitmap.c~seq_file-add-seq_cpumask-seq_nodemask lib/bitmap.c
--- a/lib/bitmap.c~seq_file-add-seq_cpumask-seq_nodemask
+++ a/lib/bitmap.c
@@ -316,6 +316,17 @@ int bitmap_scnprintf(char *buf, unsigned
 EXPORT_SYMBOL(bitmap_scnprintf);
 
 /**
+ * bitmap_scnprintf_len - return buffer length needed to convert
+ * bitmap to an ASCII hex string
+ * @nr_bits: number of bits to be converted
+ */
+int bitmap_scnprintf_len(unsigned int nr_bits)
+{
+	unsigned int nr_nibbles = ALIGN(nr_bits, 4) / 4;
+	return nr_nibbles + ALIGN(nr_nibbles, CHUNKSZ / 4) / (CHUNKSZ / 4) - 1;
+}
+
+/**
  * __bitmap_parse - convert an ASCII hex string into a bitmap.
  * @buf: pointer to buffer containing string.
  * @buflen: buffer size in bytes.  If string is smaller than this
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
vt8623fb-fix-kernel-oops.patch
linux-next.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
cdc-acm-dont-unlock-acm-mutex-on-error-path.patch
seq_file-add-seq_cpumask-seq_nodemask.patch
slb-drop-kmem-cache-argument-from-constructor-fix-fix-logfs.patch
devpts-switch-to-ida-checkpatch-fixes.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch


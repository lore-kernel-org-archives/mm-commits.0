From: Andrew Morton <akpm@linux-foundation.org>
Subject: + seq_file-remove-m-version.patch added to -mm tree
Date: Tue, 17 Mar 2020 19:58:41 -0700
Message-ID: <20200318025841.1bxXYSICi%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726229AbgCRC6n (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 17 Mar 2020 22:58:43 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org, willy@infradead.org


The patch titled
     Subject: seq_file: remove m->version
has been added to the -mm tree.  Its filename is
     seq_file-remove-m-version.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/seq_file-remove-m-version.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/seq_file-remove-m-version.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: seq_file: remove m->version

The process maps file was the only user of version (introduced back in
2005).  Now that it uses ppos instead, we can remove it.

Link: http://lkml.kernel.org/r/20200317193201.9924-4-adobriyan@gmail.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/seq_file.c            |   28 ----------------------------
 include/linux/seq_file.h |    1 -
 2 files changed, 29 deletions(-)

--- a/fs/seq_file.c~seq_file-remove-m-version
+++ a/fs/seq_file.c
@@ -68,13 +68,6 @@ int seq_open(struct file *file, const st
 	p->file = file;
 
 	/*
-	 * Wrappers around seq_open(e.g. swaps_open) need to be
-	 * aware of this. If they set f_version themselves, they
-	 * should call seq_open first and then set f_version.
-	 */
-	file->f_version = 0;
-
-	/*
 	 * seq_files support lseek() and pread().  They do not implement
 	 * write() at all, but we clear FMODE_PWRITE here for historical
 	 * reasons.
@@ -94,7 +87,6 @@ static int traverse(struct seq_file *m,
 	int error = 0;
 	void *p;
 
-	m->version = 0;
 	m->index = 0;
 	m->count = m->from = 0;
 	if (!offset)
@@ -161,25 +153,11 @@ ssize_t seq_read(struct file *file, char
 	mutex_lock(&m->lock);
 
 	/*
-	 * seq_file->op->..m_start/m_stop/m_next may do special actions
-	 * or optimisations based on the file->f_version, so we want to
-	 * pass the file->f_version to those methods.
-	 *
-	 * seq_file->version is just copy of f_version, and seq_file
-	 * methods can treat it simply as file version.
-	 * It is copied in first and copied out after all operations.
-	 * It is convenient to have it as  part of structure to avoid the
-	 * need of passing another argument to all the seq_file methods.
-	 */
-	m->version = file->f_version;
-
-	/*
 	 * if request is to read from zero offset, reset iterator to first
 	 * record as it might have been already advanced by previous requests
 	 */
 	if (*ppos == 0) {
 		m->index = 0;
-		m->version = 0;
 		m->count = 0;
 	}
 
@@ -190,7 +168,6 @@ ssize_t seq_read(struct file *file, char
 		if (err) {
 			/* With prejudice... */
 			m->read_pos = 0;
-			m->version = 0;
 			m->index = 0;
 			m->count = 0;
 			goto Done;
@@ -243,7 +220,6 @@ ssize_t seq_read(struct file *file, char
 		m->buf = seq_buf_alloc(m->size <<= 1);
 		if (!m->buf)
 			goto Enomem;
-		m->version = 0;
 		p = m->op->start(m, &m->index);
 	}
 	m->op->stop(m, p);
@@ -287,7 +263,6 @@ Done:
 		*ppos += copied;
 		m->read_pos += copied;
 	}
-	file->f_version = m->version;
 	mutex_unlock(&m->lock);
 	return copied;
 Enomem:
@@ -313,7 +288,6 @@ loff_t seq_lseek(struct file *file, loff
 	loff_t retval = -EINVAL;
 
 	mutex_lock(&m->lock);
-	m->version = file->f_version;
 	switch (whence) {
 	case SEEK_CUR:
 		offset += file->f_pos;
@@ -329,7 +303,6 @@ loff_t seq_lseek(struct file *file, loff
 				/* with extreme prejudice... */
 				file->f_pos = 0;
 				m->read_pos = 0;
-				m->version = 0;
 				m->index = 0;
 				m->count = 0;
 			} else {
@@ -340,7 +313,6 @@ loff_t seq_lseek(struct file *file, loff
 			file->f_pos = offset;
 		}
 	}
-	file->f_version = m->version;
 	mutex_unlock(&m->lock);
 	return retval;
 }
--- a/include/linux/seq_file.h~seq_file-remove-m-version
+++ a/include/linux/seq_file.h
@@ -21,7 +21,6 @@ struct seq_file {
 	size_t pad_until;
 	loff_t index;
 	loff_t read_pos;
-	u64 version;
 	struct mutex lock;
 	const struct seq_operations *op;
 	int poll_event;
_

Patches currently in -mm which might be from willy@infradead.org are

mm-improve-dump_page-for-compound-pages.patch
mm-add-pagemaph-to-the-fine-documentation.patch
proc-inline-vma_stop-into-m_stop.patch
proc-remove-m_cache_vma.patch
proc-use-ppos-instead-of-m-version.patch
seq_file-remove-m-version.patch
proc-inline-m_next_vma-into-m_next.patch

From: akpm@linux-foundation.org
Subject: - vfs-expand-some-comments-d_path-seq_path.patch removed from -mm tree
Date: Sun, 04 Jan 2009 22:41:25 -0800
Message-ID: <200901050641.n056fPeR005493@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49823 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751396AbZAEGli (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jan 2009 01:41:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjan@infradead.org, arjan@linux.intel.com, hch@lst.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     vfs: expand some comments (d_path / seq_path)
has been removed from the -mm tree.  Its filename was
     vfs-expand-some-comments-d_path-seq_path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: expand some comments (d_path / seq_path)
From: Arjan van de Ven <arjan@infradead.org>

Explain that you really need to use the return value of d_path rather than
the buffer you passed into it.

Also fix the comment for seq_path(), the function arguments changed
recently but the comment hadn't been updated in sync.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c   |    8 ++++++--
 fs/seq_file.c |   10 ++++++++--
 2 files changed, 14 insertions(+), 4 deletions(-)

diff -puN fs/dcache.c~vfs-expand-some-comments-d_path-seq_path fs/dcache.c
--- a/fs/dcache.c~vfs-expand-some-comments-d_path-seq_path
+++ a/fs/dcache.c
@@ -1912,7 +1912,8 @@ static int prepend_name(char **buffer, i
  * Convert a dentry into an ASCII path name. If the entry has been deleted
  * the string " (deleted)" is appended. Note that this is ambiguous.
  *
- * Returns the buffer or an error code if the path was too long.
+ * Returns a pointer into the buffer or an error code if the
+ * path was too long.
  *
  * "buflen" should be positive. Caller holds the dcache_lock.
  *
@@ -1988,7 +1989,10 @@ Elong:
  * Convert a dentry into an ASCII path name. If the entry has been deleted
  * the string " (deleted)" is appended. Note that this is ambiguous.
  *
- * Returns the buffer or an error code if the path was too long.
+ * Returns a pointer into the buffer or an error code if the path was
+ * too long. Note: Callers should use the returned pointer, not the passed
+ * in buffer, to use the name! The implementation often starts at an offset
+ * into the buffer, and may leave 0 bytes at the start.
  *
  * "buflen" should be positive.
  */
diff -puN fs/seq_file.c~vfs-expand-some-comments-d_path-seq_path fs/seq_file.c
--- a/fs/seq_file.c~vfs-expand-some-comments-d_path-seq_path
+++ a/fs/seq_file.c
@@ -389,8 +389,14 @@ char *mangle_path(char *s, char *p, char
 }
 EXPORT_SYMBOL(mangle_path);
 
-/*
- * return the absolute path of 'dentry' residing in mount 'mnt'.
+/**
+ * seq_path - seq_file interface to print a pathname
+ * @m: the seq_file handle
+ * @path: the struct path to print
+ * @esc: set of characters to escape in the output
+ *
+ * return the absolute path of 'path', as represented by the
+ * dentry / mnt pair in the path parameter.
  */
 int seq_path(struct seq_file *m, struct path *path, char *esc)
 {
_

Patches currently in -mm which might be from arjan@infradead.org are

origin.patch
mm-remove-the-might_sleep-from-lock_page.patch
scripts-script-from-kerneloopsorg-to-pretty-print-oops-dumps.patch
documentation-when-to-bug-and-when-to-not-bug.patch
jbd-improve-fsync-batching.patch
jbd-improve-fsync-batching-update.patch


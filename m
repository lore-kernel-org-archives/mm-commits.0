From: akpm@linux-foundation.org
Subject: + vfs-expand-some-comments-d_path-seq_path.patch added to -mm tree
Date: Mon, 24 Nov 2008 16:12:33 -0800
Message-ID: <200811250012.mAP0CXdA016258@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38257 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754029AbYKYANS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Nov 2008 19:13:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@infradead.org, arjan@linux.intel.com, hch@lst.de, viro@zeniv.linux.org.uk


The patch titled
     vfs: expand some comments (d_path / seq_path)
has been added to the -mm tree.  Its filename is
     vfs-expand-some-comments-d_path-seq_path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1914,7 +1914,8 @@ static int prepend_name(char **buffer, i
  * Convert a dentry into an ASCII path name. If the entry has been deleted
  * the string " (deleted)" is appended. Note that this is ambiguous.
  *
- * Returns the buffer or an error code if the path was too long.
+ * Returns a pointer into the buffer or an error code if the
+ * path was too long.
  *
  * "buflen" should be positive. Caller holds the dcache_lock.
  *
@@ -1990,7 +1991,10 @@ Elong:
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
@@ -384,8 +384,14 @@ static char *mangle_path(char *s, char *
 	return NULL;
 }
 
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

mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
jbd-improve-fsync-batching.patch
jbd-improve-fsync-batching-update.patch
scripts-script-from-kerneloopsorg-to-pretty-print-oops-dumps.patch
vfs-expand-some-comments-d_path-seq_path.patch


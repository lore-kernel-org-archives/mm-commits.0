From: akpm@linux-foundation.org
Subject: - add-match_strlcpy-us-it-to-make-v9fs-make-uname-and-remotename-parsing-more-robust.patch removed from -mm tree
Date: Wed, 27 Feb 2008 14:16:59 -0800
Message-ID: <200802272216.m1RMGxfi000765@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:57920 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760036AbYB0WRu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 17:17:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: armbru@redhat.com, ericvh@gmail.com, lucho@ionkov.net, meyering@redhat.com, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     add match_strlcpy() us it to make v9fs make uname and remotename parsing more robust
has been removed from the -mm tree.  Its filename was
     add-match_strlcpy-us-it-to-make-v9fs-make-uname-and-remotename-parsing-more-robust.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: add match_strlcpy() us it to make v9fs make uname and remotename parsing more robust
From: Markus Armbruster <armbru@redhat.com>

match_strcpy() is a somewhat creepy function: the caller needs to make sure
that the destination buffer is big enough, and when he screws up or
forgets, match_strcpy() happily overruns the buffer.

There's exactly one customer: v9fs_parse_options().  I believe it currently
can't overflow its buffer, but that's not exactly obvious.

The source string is a substing of the mount options.  The kernel silently
truncates those to PAGE_SIZE bytes, including the terminating zero.  See
compat_sys_mount() and do_mount().

The destination buffer is obtained from __getname(), which allocates from
name_cachep, which is initialized by vfs_caches_init() for size PATH_MAX.

We're safe as long as PATH_MAX <= PAGE_SIZE.  PATH_MAX is 4096.  As far as
I know, the smallest PAGE_SIZE is also 4096.

Here's a patch that makes the code a bit more obviously correct.  It
doesn't depend on PATH_MAX <= PAGE_SIZE.

Signed-off-by: Markus Armbruster <armbru@redhat.com>
Cc: Latchesar Ionkov <lucho@ionkov.net>
Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Jim Meyering <meyering@redhat.com>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/9p/v9fs.c           |    4 ++--
 include/linux/parser.h |    2 +-
 lib/parser.c           |   32 ++++++++++++++++++++------------
 3 files changed, 23 insertions(+), 15 deletions(-)

diff -puN fs/9p/v9fs.c~add-match_strlcpy-us-it-to-make-v9fs-make-uname-and-remotename-parsing-more-robust fs/9p/v9fs.c
--- a/fs/9p/v9fs.c~add-match_strlcpy-us-it-to-make-v9fs-make-uname-and-remotename-parsing-more-robust
+++ a/fs/9p/v9fs.c
@@ -133,10 +133,10 @@ static int v9fs_parse_options(struct v9f
 			v9ses->afid = option;
 			break;
 		case Opt_uname:
-			match_strcpy(v9ses->uname, &args[0]);
+			match_strlcpy(v9ses->uname, &args[0], PATH_MAX);
 			break;
 		case Opt_remotename:
-			match_strcpy(v9ses->aname, &args[0]);
+			match_strlcpy(v9ses->aname, &args[0], PATH_MAX);
 			break;
 		case Opt_nodevmap:
 			v9ses->nodev = 1;
diff -puN include/linux/parser.h~add-match_strlcpy-us-it-to-make-v9fs-make-uname-and-remotename-parsing-more-robust include/linux/parser.h
--- a/include/linux/parser.h~add-match_strlcpy-us-it-to-make-v9fs-make-uname-and-remotename-parsing-more-robust
+++ a/include/linux/parser.h
@@ -29,5 +29,5 @@ int match_token(char *, match_table_t ta
 int match_int(substring_t *, int *result);
 int match_octal(substring_t *, int *result);
 int match_hex(substring_t *, int *result);
-void match_strcpy(char *, const substring_t *);
+size_t match_strlcpy(char *, const substring_t *, size_t);
 char *match_strdup(const substring_t *);
diff -puN lib/parser.c~add-match_strlcpy-us-it-to-make-v9fs-make-uname-and-remotename-parsing-more-robust lib/parser.c
--- a/lib/parser.c~add-match_strlcpy-us-it-to-make-v9fs-make-uname-and-remotename-parsing-more-robust
+++ a/lib/parser.c
@@ -182,18 +182,25 @@ int match_hex(substring_t *s, int *resul
 }
 
 /**
- * match_strcpy: - copies the characters from a substring_t to a string
- * @to: string to copy characters to.
- * @s: &substring_t to copy
+ * match_strlcpy: - Copy the characters from a substring_t to a sized buffer
+ * @dest: where to copy to
+ * @src: &substring_t to copy
+ * @size: size of destination buffer
  *
- * Description: Copies the set of characters represented by the given
- * &substring_t @s to the c-style string @to. Caller guarantees that @to is
- * large enough to hold the characters of @s.
+ * Description: Copy the characters in &substring_t @src to the
+ * c-style string @dest.  Copy no more than @size - 1 characters, plus
+ * the terminating NUL.  Return length of @src.
  */
-void match_strcpy(char *to, const substring_t *s)
+size_t match_strlcpy(char *dest, const substring_t *src, size_t size)
 {
-	memcpy(to, s->from, s->to - s->from);
-	to[s->to - s->from] = '\0';
+	size_t ret = src->to - src->from;
+
+	if (size) {
+		size_t len = ret >= size ? size - 1 : ret;
+		memcpy(dest, src->from, len);
+		dest[len] = '\0';
+	}
+	return ret;
 }
 
 /**
@@ -206,9 +213,10 @@ void match_strcpy(char *to, const substr
  */
 char *match_strdup(const substring_t *s)
 {
-	char *p = kmalloc(s->to - s->from + 1, GFP_KERNEL);
+	size_t sz = s->to - s->from + 1;
+	char *p = kmalloc(sz, GFP_KERNEL);
 	if (p)
-		match_strcpy(p, s);
+		match_strlcpy(p, s, sz);
 	return p;
 }
 
@@ -216,5 +224,5 @@ EXPORT_SYMBOL(match_token);
 EXPORT_SYMBOL(match_int);
 EXPORT_SYMBOL(match_octal);
 EXPORT_SYMBOL(match_hex);
-EXPORT_SYMBOL(match_strcpy);
+EXPORT_SYMBOL(match_strlcpy);
 EXPORT_SYMBOL(match_strdup);
_

Patches currently in -mm which might be from armbru@redhat.com are

git-v9fs.patch

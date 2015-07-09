From: akpm@linux-foundation.org
Subject: + parse_integer-convert-fs.patch added to -mm tree
Date: Thu, 09 Jul 2015 12:26:19 -0700
Message-ID: <559ecadb.So3Oc9zSvqRk3GTt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48761 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905AbbGIT0U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jul 2015 15:26:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: parse_integer: convert fs/
has been added to the -mm tree.  Its filename is
     parse_integer-convert-fs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/parse_integer-convert-fs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/parse_integer-convert-fs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: parse_integer: convert fs/

Convert random fs/ code away from simple_strto*() interfaces.

Note about "struct simple_attr" conversion:
->set_buf is unneeded because everything can be done from stack.
->get_buf is useless as well, but that's a separate patch.
Mutex is not removed, as it may guard readers from writers,
separate story as well.
(code has been copied to arch/powerpc/.../spufs/, don't forget!)

binfmt_misc: file offset can't really be negative, type changed.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_misc.c |   12 +++++++++---
 fs/dcache.c      |    2 +-
 fs/inode.c       |    2 +-
 fs/libfs.c       |   26 ++++++++++----------------
 fs/namespace.c   |    4 ++--
 5 files changed, 23 insertions(+), 23 deletions(-)

diff -puN fs/binfmt_misc.c~parse_integer-convert-fs fs/binfmt_misc.c
--- a/fs/binfmt_misc.c~parse_integer-convert-fs
+++ a/fs/binfmt_misc.c
@@ -47,7 +47,7 @@ enum {Enabled, Magic};
 typedef struct {
 	struct list_head list;
 	unsigned long flags;		/* type, status, etc. */
-	int offset;			/* offset of magic */
+	unsigned int offset;		/* offset of magic */
 	int size;			/* size of magic/mask */
 	char *magic;			/* magic or filename extension */
 	char *mask;			/* mask, NULL for exact match */
@@ -370,7 +370,13 @@ static Node *create_entry(const char __u
 		if (!s)
 			goto einval;
 		*s++ = '\0';
-		e->offset = simple_strtoul(p, &p, 10);
+		err = parse_integer(p, 10, &e->offset);
+		if (err < 0) {
+			kfree(e);
+			goto out;
+
+		}
+		p += err;
 		if (*p++)
 			goto einval;
 		pr_debug("register: offset: %#x\n", e->offset);
@@ -548,7 +554,7 @@ static void entry_status(Node *e, char *
 	if (!test_bit(Magic, &e->flags)) {
 		sprintf(dp, "extension .%s\n", e->magic);
 	} else {
-		dp += sprintf(dp, "offset %i\nmagic ", e->offset);
+		dp += sprintf(dp, "offset %u\nmagic ", e->offset);
 		dp = bin2hex(dp, e->magic, e->size);
 		if (e->mask) {
 			dp += sprintf(dp, "\nmask ");
diff -puN fs/dcache.c~parse_integer-convert-fs fs/dcache.c
--- a/fs/dcache.c~parse_integer-convert-fs
+++ a/fs/dcache.c
@@ -3366,7 +3366,7 @@ static int __init set_dhash_entries(char
 {
 	if (!str)
 		return 0;
-	dhash_entries = simple_strtoul(str, &str, 0);
+	parse_integer(str, 0, &dhash_entries);
 	return 1;
 }
 __setup("dhash_entries=", set_dhash_entries);
diff -puN fs/inode.c~parse_integer-convert-fs fs/inode.c
--- a/fs/inode.c~parse_integer-convert-fs
+++ a/fs/inode.c
@@ -1828,7 +1828,7 @@ static int __init set_ihash_entries(char
 {
 	if (!str)
 		return 0;
-	ihash_entries = simple_strtoul(str, &str, 0);
+	parse_integer(str, 0, &ihash_entries);
 	return 1;
 }
 __setup("ihash_entries=", set_ihash_entries);
diff -puN fs/libfs.c~parse_integer-convert-fs fs/libfs.c
--- a/fs/libfs.c~parse_integer-convert-fs
+++ a/fs/libfs.c
@@ -747,7 +747,6 @@ struct simple_attr {
 	int (*get)(void *, u64 *);
 	int (*set)(void *, u64);
 	char get_buf[24];	/* enough to store a u64 and "\n\0" */
-	char set_buf[24];
 	void *data;
 	const char *fmt;	/* format for read operation */
 	struct mutex mutex;	/* protects access to these buffers */
@@ -825,31 +824,26 @@ ssize_t simple_attr_write(struct file *f
 			  size_t len, loff_t *ppos)
 {
 	struct simple_attr *attr;
-	u64 val;
-	size_t size;
-	ssize_t ret;
+	s64 val;
+	int ret;
 
 	attr = file->private_data;
 	if (!attr->set)
 		return -EACCES;
 
+	ret = kstrtos64_from_user(buf, len, 0, &val);
+	if (ret < 0)
+		return ret;
+
 	ret = mutex_lock_interruptible(&attr->mutex);
 	if (ret)
 		return ret;
-
-	ret = -EFAULT;
-	size = min(sizeof(attr->set_buf) - 1, len);
-	if (copy_from_user(attr->set_buf, buf, size))
-		goto out;
-
-	attr->set_buf[size] = '\0';
-	val = simple_strtoll(attr->set_buf, NULL, 0);
 	ret = attr->set(attr->data, val);
-	if (ret == 0)
-		ret = len; /* on success, claim we got the whole input */
-out:
 	mutex_unlock(&attr->mutex);
-	return ret;
+	if (ret < 0)
+		return ret;
+	/* on success, claim we got the whole input */
+	return len;
 }
 EXPORT_SYMBOL_GPL(simple_attr_write);
 
diff -puN fs/namespace.c~parse_integer-convert-fs fs/namespace.c
--- a/fs/namespace.c~parse_integer-convert-fs
+++ a/fs/namespace.c
@@ -37,7 +37,7 @@ static int __init set_mhash_entries(char
 {
 	if (!str)
 		return 0;
-	mhash_entries = simple_strtoul(str, &str, 0);
+	parse_integer(str, 0, &mhash_entries);
 	return 1;
 }
 __setup("mhash_entries=", set_mhash_entries);
@@ -47,7 +47,7 @@ static int __init set_mphash_entries(cha
 {
 	if (!str)
 		return 0;
-	mphash_entries = simple_strtoul(str, &str, 0);
+	parse_integer(str, 0, &mphash_entries);
 	return 1;
 }
 __setup("mphash_entries=", set_mphash_entries);
_

Patches currently in -mm which might be from adobriyan@gmail.com are

kstrto-accept-0-for-signed-conversion.patch
add-parse_integer-replacement-for-simple_strto.patch
parse_integer-add-runtime-testsuite.patch
parse-integer-rewrite-kstrto.patch
parse_integer-convert-scanf.patch
scanf-fix-type-range-overflow.patch
parse_integer-convert-lib.patch
parse_integer-convert-mm.patch
parse_integer-convert-fs.patch
parse_integer-convert-fs-cachefiles.patch
parse_integer-convert-ext2-ext3-ext4.patch
parse_integer-convert-fs-ocfs2.patch


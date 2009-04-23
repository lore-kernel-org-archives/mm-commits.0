From: akpm@linux-foundation.org
Subject: + romfs-romfs_lookup-shouldnt-be-doing-a-partial-name-comparison.patch added to -mm tree
Date: Thu, 23 Apr 2009 16:53:36 -0700
Message-ID: <200904232353.n3NNralu000467@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51245 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750898AbZDWX4d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Apr 2009 19:56:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, dwmw2@infradead.org, monstr@monstr.eu


The patch titled
     romfs: romfs_lookup() shouldn't be doing a partial name comparison
has been added to the -mm tree.  Its filename is
     romfs-romfs_lookup-shouldnt-be-doing-a-partial-name-comparison.patch

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
Subject: romfs: romfs_lookup() shouldn't be doing a partial name comparison
From: David Howells <dhowells@redhat.com>

romfs_lookup() should be using a routine akin to strcmp() on the backing
store, rather than one akin to strncmp().  If it uses the latter, it's
liable to match /bin/shutdown when looking up /bin/sh.

Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: Michal Simek <monstr@monstr.eu>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/romfs/internal.h |    4 +-
 fs/romfs/storage.c  |   67 ++++++++++++++++++++++++++++++------------
 fs/romfs/super.c    |    4 +-
 3 files changed, 53 insertions(+), 22 deletions(-)

diff -puN fs/romfs/internal.h~romfs-romfs_lookup-shouldnt-be-doing-a-partial-name-comparison fs/romfs/internal.h
--- a/fs/romfs/internal.h~romfs-romfs_lookup-shouldnt-be-doing-a-partial-name-comparison
+++ a/fs/romfs/internal.h
@@ -43,5 +43,5 @@ extern int romfs_dev_read(struct super_b
 			  void *buf, size_t buflen);
 extern ssize_t romfs_dev_strnlen(struct super_block *sb,
 				 unsigned long pos, size_t maxlen);
-extern int romfs_dev_strncmp(struct super_block *sb, unsigned long pos,
-			     const char *str, size_t size);
+extern int romfs_dev_strcmp(struct super_block *sb, unsigned long pos,
+			    const char *str, size_t size);
diff -puN fs/romfs/storage.c~romfs-romfs_lookup-shouldnt-be-doing-a-partial-name-comparison fs/romfs/storage.c
--- a/fs/romfs/storage.c~romfs-romfs_lookup-shouldnt-be-doing-a-partial-name-comparison
+++ a/fs/romfs/storage.c
@@ -67,26 +67,35 @@ static ssize_t romfs_mtd_strnlen(struct 
  * compare a string to one in a romfs image on MTD
  * - return 1 if matched, 0 if differ, -ve if error
  */
-static int romfs_mtd_strncmp(struct super_block *sb, unsigned long pos,
-			     const char *str, size_t size)
+static int romfs_mtd_strcmp(struct super_block *sb, unsigned long pos,
+			    const char *str, size_t size)
 {
-	u_char buf[16];
+	u_char buf[17];
 	size_t len, segment;
 	int ret;
 
-	/* scan the string up to 16 bytes at a time */
+	/* scan the string up to 16 bytes at a time, and attempt to grab the
+	 * trailing NUL whilst we're at it */
+	buf[0] = 0xff;
+
 	while (size > 0) {
-		segment = min_t(size_t, size, 16);
+		segment = min_t(size_t, size + 1, 17);
 		ret = ROMFS_MTD_READ(sb, pos, segment, &len, buf);
 		if (ret < 0)
 			return ret;
+		len--;
 		if (memcmp(buf, str, len) != 0)
 			return 0;
+		buf[0] = buf[len];
 		size -= len;
 		pos += len;
 		str += len;
 	}
 
+	/* check the trailing NUL was */
+	if (buf[0])
+		return 0;
+
 	return 1;
 }
 #endif /* CONFIG_ROMFS_ON_MTD */
@@ -154,28 +163,48 @@ static ssize_t romfs_blk_strnlen(struct 
  * compare a string to one in a romfs image on a block device
  * - return 1 if matched, 0 if differ, -ve if error
  */
-static int romfs_blk_strncmp(struct super_block *sb, unsigned long pos,
-			     const char *str, size_t size)
+static int romfs_blk_strcmp(struct super_block *sb, unsigned long pos,
+			    const char *str, size_t size)
 {
 	struct buffer_head *bh;
 	unsigned long offset;
 	size_t segment;
-	bool x;
+	bool matched, terminated = false;
 
-	/* scan the string up to 16 bytes at a time */
+	/* compare string up to a block at a time */
 	while (size > 0) {
 		offset = pos & (ROMBSIZE - 1);
 		segment = min_t(size_t, size, ROMBSIZE - offset);
 		bh = sb_bread(sb, pos >> ROMBSBITS);
 		if (!bh)
 			return -EIO;
-		x = (memcmp(bh->b_data + offset, str, segment) != 0);
-		brelse(bh);
-		if (x)
-			return 0;
+		matched = (memcmp(bh->b_data + offset, str, segment) == 0);
+
 		size -= segment;
 		pos += segment;
 		str += segment;
+		if (matched && size == 0 && offset + segment < ROMBSIZE) {
+			if (!bh->b_data[offset + segment])
+				terminated = true;
+			else
+				matched = false;
+		}
+		brelse(bh);
+		if (!matched)
+			return 0;
+	}
+
+	if (!terminated) {
+		/* the terminating NUL must be on the first byte of the next
+		 * block */
+		BUG_ON((pos & (ROMBSIZE - 1)) != 0);
+		bh = sb_bread(sb, pos >> ROMBSBITS);
+		if (!bh)
+			return -EIO;
+		matched = !bh->b_data[0];
+		brelse(bh);
+		if (!matched)
+			return 0;
 	}
 
 	return 1;
@@ -234,10 +263,12 @@ ssize_t romfs_dev_strnlen(struct super_b
 
 /*
  * compare a string to one in romfs
+ * - the string to be compared to, str, may not be NUL-terminated; instead the
+ *   string is of the specified size
  * - return 1 if matched, 0 if differ, -ve if error
  */
-int romfs_dev_strncmp(struct super_block *sb, unsigned long pos,
-		      const char *str, size_t size)
+int romfs_dev_strcmp(struct super_block *sb, unsigned long pos,
+		     const char *str, size_t size)
 {
 	size_t limit;
 
@@ -246,16 +277,16 @@ int romfs_dev_strncmp(struct super_block
 		return -EIO;
 	if (size > ROMFS_MAXFN)
 		return -ENAMETOOLONG;
-	if (size > limit - pos)
+	if (size + 1 > limit - pos)
 		return -EIO;
 
 #ifdef CONFIG_ROMFS_ON_MTD
 	if (sb->s_mtd)
-		return romfs_mtd_strncmp(sb, pos, str, size);
+		return romfs_mtd_strcmp(sb, pos, str, size);
 #endif
 #ifdef CONFIG_ROMFS_ON_BLOCK
 	if (sb->s_bdev)
-		return romfs_blk_strncmp(sb, pos, str, size);
+		return romfs_blk_strcmp(sb, pos, str, size);
 #endif
 	return -EIO;
 }
diff -puN fs/romfs/super.c~romfs-romfs_lookup-shouldnt-be-doing-a-partial-name-comparison fs/romfs/super.c
--- a/fs/romfs/super.c~romfs-romfs_lookup-shouldnt-be-doing-a-partial-name-comparison
+++ a/fs/romfs/super.c
@@ -240,8 +240,8 @@ static struct dentry *romfs_lookup(struc
 			goto error;
 
 		/* try to match the first 16 bytes of name */
-		ret = romfs_dev_strncmp(dir->i_sb, offset + ROMFH_SIZE, name,
-					len);
+		ret = romfs_dev_strcmp(dir->i_sb, offset + ROMFH_SIZE, name,
+				       len);
 		if (ret < 0)
 			goto error;
 		if (ret == 1)
_

Patches currently in -mm which might be from dhowells@redhat.com are

slow-work-delete-timers-properly.patch
mn10300-update-the-asb2303-defconfig.patch
cachefiles-fix-the-documentation-to-use-the-correct-credential-pointer-names.patch
romfs-romfs_lookup-shouldnt-be-doing-a-partial-name-comparison.patch
romfs-advance-destination-buffer-pointer-when-reading-from-a-blockdev.patch
rxrpc-fix-error-handling-for-rxrpc_alloc_connection.patch
frv-duplicate-output_buffer-of-e03.patch
slow_work_thread-should-do-the-exclusive-wait.patch
rework-fix-is_single_threaded.patch
kmap_types-make-most-arches-use-generic-header-file.patch
flat-fix-data-sections-alignment.patch
mutex-subsystem-synchro-test-module.patch


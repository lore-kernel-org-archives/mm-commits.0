From: akpm@linux-foundation.org
Subject: + lib-stringc-introduce-memchr_inv.patch added to -mm tree
Date: Mon, 22 Aug 2011 13:52:38 -0700
Message-ID: <201108222052.p7MKqc0K005820@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47026 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753575Ab1HVUwu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Aug 2011 16:52:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, cl@linux-foundation.org, eric.dumazet@gmail.com, joern@logfs.org, marcin.slusarz@gmail.com, mpm@selenic.com, penberg@kernel.org


The patch titled
     lib/string.c: introduce memchr_inv()
has been added to the -mm tree.  Its filename is
     lib-stringc-introduce-memchr_inv.patch

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
Subject: lib/string.c: introduce memchr_inv()
From: Akinobu Mita <akinobu.mita@gmail.com>

memchr_inv() is mainly used to check whether the whole buffer is filled
with just a specified byte.

The function name and prototype are stolen from logfs and the
implementation is from SLUB.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Matt Mackall <mpm@selenic.com>
Acked-by: Joern Engel <joern@logfs.org>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/logfs/logfs.h       |    1 
 fs/logfs/super.c       |   22 ---------------
 include/linux/string.h |    1 
 lib/string.c           |   54 +++++++++++++++++++++++++++++++++++++++
 mm/slub.c              |   47 +--------------------------------
 5 files changed, 57 insertions(+), 68 deletions(-)

diff -puN fs/logfs/logfs.h~lib-stringc-introduce-memchr_inv fs/logfs/logfs.h
--- a/fs/logfs/logfs.h~lib-stringc-introduce-memchr_inv
+++ a/fs/logfs/logfs.h
@@ -619,7 +619,6 @@ static inline int logfs_buf_recover(stru
 struct page *emergency_read_begin(struct address_space *mapping, pgoff_t index);
 void emergency_read_end(struct page *page);
 void logfs_crash_dump(struct super_block *sb);
-void *memchr_inv(const void *s, int c, size_t n);
 int logfs_statfs(struct dentry *dentry, struct kstatfs *stats);
 int logfs_check_ds(struct logfs_disk_super *ds);
 int logfs_write_sb(struct super_block *sb);
diff -puN fs/logfs/super.c~lib-stringc-introduce-memchr_inv fs/logfs/super.c
--- a/fs/logfs/super.c~lib-stringc-introduce-memchr_inv
+++ a/fs/logfs/super.c
@@ -92,28 +92,6 @@ void logfs_crash_dump(struct super_block
 }
 
 /*
- * TODO: move to lib/string.c
- */
-/**
- * memchr_inv - Find a character in an area of memory.
- * @s: The memory area
- * @c: The byte to search for
- * @n: The size of the area.
- *
- * returns the address of the first character other than @c, or %NULL
- * if the whole buffer contains just @c.
- */
-void *memchr_inv(const void *s, int c, size_t n)
-{
-	const unsigned char *p = s;
-	while (n-- != 0)
-		if ((unsigned char)c != *p++)
-			return (void *)(p - 1);
-
-	return NULL;
-}
-
-/*
  * FIXME: There should be a reserve for root, similar to ext2.
  */
 int logfs_statfs(struct dentry *dentry, struct kstatfs *stats)
diff -puN include/linux/string.h~lib-stringc-introduce-memchr_inv include/linux/string.h
--- a/include/linux/string.h~lib-stringc-introduce-memchr_inv
+++ a/include/linux/string.h
@@ -114,6 +114,7 @@ extern int memcmp(const void *,const voi
 #ifndef __HAVE_ARCH_MEMCHR
 extern void * memchr(const void *,int,__kernel_size_t);
 #endif
+void *memchr_inv(const void *s, int c, size_t n);
 
 extern char *kstrdup(const char *s, gfp_t gfp);
 extern char *kstrndup(const char *s, size_t len, gfp_t gfp);
diff -puN lib/string.c~lib-stringc-introduce-memchr_inv lib/string.c
--- a/lib/string.c~lib-stringc-introduce-memchr_inv
+++ a/lib/string.c
@@ -756,3 +756,57 @@ void *memchr(const void *s, int c, size_
 }
 EXPORT_SYMBOL(memchr);
 #endif
+
+static void *check_bytes8(const u8 *start, u8 value, unsigned int bytes)
+{
+	while (bytes) {
+		if (*start != value)
+			return (void *)start;
+		start++;
+		bytes--;
+	}
+	return NULL;
+}
+
+/**
+ * memchr_inv - Find a character in an area of memory.
+ * @s: The memory area
+ * @c: The byte to search for
+ * @n: The size of the area.
+ *
+ * returns the address of the first character other than @c, or %NULL
+ * if the whole buffer contains just @c.
+ */
+void *memchr_inv(const void *start, int c, size_t bytes)
+{
+	u8 value = c;
+	u64 value64;
+	unsigned int words, prefix;
+
+	if (bytes <= 16)
+		return check_bytes8(start, value, bytes);
+
+	value64 = value | value << 8 | value << 16 | value << 24;
+	value64 = (value64 & 0xffffffff) | value64 << 32;
+	prefix = 8 - ((unsigned long)start) % 8;
+
+	if (prefix) {
+		u8 *r = check_bytes8(start, value, prefix);
+		if (r)
+			return r;
+		start += prefix;
+		bytes -= prefix;
+	}
+
+	words = bytes / 8;
+
+	while (words) {
+		if (*(u64 *)start != value64)
+			return check_bytes8(start, value, 8);
+		start += 8;
+		words--;
+	}
+
+	return check_bytes8(start, value, bytes % 8);
+}
+EXPORT_SYMBOL(memchr_inv);
diff -puN mm/slub.c~lib-stringc-introduce-memchr_inv mm/slub.c
--- a/mm/slub.c~lib-stringc-introduce-memchr_inv
+++ a/mm/slub.c
@@ -681,49 +681,6 @@ static void init_object(struct kmem_cach
 		memset(p + s->objsize, val, s->inuse - s->objsize);
 }
 
-static u8 *check_bytes8(u8 *start, u8 value, unsigned int bytes)
-{
-	while (bytes) {
-		if (*start != value)
-			return start;
-		start++;
-		bytes--;
-	}
-	return NULL;
-}
-
-static u8 *check_bytes(u8 *start, u8 value, unsigned int bytes)
-{
-	u64 value64;
-	unsigned int words, prefix;
-
-	if (bytes <= 16)
-		return check_bytes8(start, value, bytes);
-
-	value64 = value | value << 8 | value << 16 | value << 24;
-	value64 = (value64 & 0xffffffff) | value64 << 32;
-	prefix = 8 - ((unsigned long)start) % 8;
-
-	if (prefix) {
-		u8 *r = check_bytes8(start, value, prefix);
-		if (r)
-			return r;
-		start += prefix;
-		bytes -= prefix;
-	}
-
-	words = bytes / 8;
-
-	while (words) {
-		if (*(u64 *)start != value64)
-			return check_bytes8(start, value, 8);
-		start += 8;
-		words--;
-	}
-
-	return check_bytes8(start, value, bytes % 8);
-}
-
 static void restore_bytes(struct kmem_cache *s, char *message, u8 data,
 						void *from, void *to)
 {
@@ -738,7 +695,7 @@ static int check_bytes_and_report(struct
 	u8 *fault;
 	u8 *end;
 
-	fault = check_bytes(start, value, bytes);
+	fault = memchr_inv(start, value, bytes);
 	if (!fault)
 		return 1;
 
@@ -831,7 +788,7 @@ static int slab_pad_check(struct kmem_ca
 	if (!remainder)
 		return 1;
 
-	fault = check_bytes(end - remainder, POISON_INUSE, remainder);
+	fault = memchr_inv(end - remainder, POISON_INUSE, remainder);
 	if (!fault)
 		return 1;
 	while (end > fault && end[-1] == POISON_INUSE)
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

linux-next.patch
ext4-use-proper-little-endian-bitops.patch
ocfs2-avoid-unaligned-access-to-dqc_bitmap.patch
mm-debug-pageallocc-use-plain-__ratelimit-instead-of-printk_ratelimit.patch
lib-stringc-introduce-memchr_inv.patch


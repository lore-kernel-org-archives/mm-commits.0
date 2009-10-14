From: akpm@linux-foundation.org
Subject: + reiser4-fix-compile-warnings.patch added to -mm tree
Date: Tue, 13 Oct 2009 19:56:40 -0700
Message-ID: <200910140256.n9E2ueFs020602@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46370 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761590AbZJNC5T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Oct 2009 22:57:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: edward.shishkin@gmail.com, cheater1034@gmail.com


The patch titled
     reiser4: fix compile warnings
has been added to the -mm tree.  Its filename is
     reiser4-fix-compile-warnings.patch

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
Subject: reiser4: fix compile warnings
From: Edward Shishkin <edward.shishkin@gmail.com>

This is a multi-part message in MIME format.
--------------020703030905060904070706
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

--------------020703030905060904070706
Content-Type: text/plain;
 name="reiser4-fix-compile-warnings.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="reiser4-fix-compile-warnings.patch"

Fix compile warnings.

Prepared by: Brandon Berhent <cheater1034@gmail.com>
Signed-off-by: Edward Shishkin <edward.shishkin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/plugin/compress/compress.c    |   16 ++++++++--------
 fs/reiser4/plugin/file/cryptcompress.c   |    4 ++--
 fs/reiser4/plugin/file/file_conversion.c |    2 +-
 fs/reiser4/plugin/item/item.h            |    4 ++--
 fs/reiser4/plugin/plugin.h               |    8 ++++----
 5 files changed, 17 insertions(+), 17 deletions(-)

diff -puN fs/reiser4/plugin/compress/compress.c~reiser4-fix-compile-warnings fs/reiser4/plugin/compress/compress.c
--- a/fs/reiser4/plugin/compress/compress.c~reiser4-fix-compile-warnings
+++ a/fs/reiser4/plugin/compress/compress.c
@@ -122,8 +122,8 @@ static int gzip1_min_size_deflate(void)
 }
 
 static void
-gzip1_compress(coa_t coa, __u8 * src_first, unsigned src_len,
-	       __u8 * dst_first, unsigned *dst_len)
+gzip1_compress(coa_t coa, __u8 * src_first, size_t src_len,
+	       __u8 * dst_first, size_t *dst_len)
 {
 #if REISER4_ZLIB
 	int ret = 0;
@@ -166,8 +166,8 @@ gzip1_compress(coa_t coa, __u8 * src_fir
 }
 
 static void
-gzip1_decompress(coa_t coa, __u8 * src_first, unsigned src_len,
-		 __u8 * dst_first, unsigned *dst_len)
+gzip1_decompress(coa_t coa, __u8 * src_first, size_t src_len,
+		 __u8 * dst_first, size_t *dst_len)
 {
 #if REISER4_ZLIB
 	int ret = 0;
@@ -278,8 +278,8 @@ static int lzo1_min_size_deflate(void)
 }
 
 static void
-lzo1_compress(coa_t coa, __u8 * src_first, unsigned src_len,
-	      __u8 * dst_first, unsigned *dst_len)
+lzo1_compress(coa_t coa, __u8 * src_first, size_t src_len,
+	      __u8 * dst_first, size_t *dst_len)
 {
 	int result;
 
@@ -302,8 +302,8 @@ lzo1_compress(coa_t coa, __u8 * src_firs
 }
 
 static void
-lzo1_decompress(coa_t coa, __u8 * src_first, unsigned src_len,
-		__u8 * dst_first, unsigned *dst_len)
+lzo1_decompress(coa_t coa, __u8 * src_first, size_t src_len,
+		__u8 * dst_first, size_t *dst_len)
 {
 	int result;
 
diff -puN fs/reiser4/plugin/file/cryptcompress.c~reiser4-fix-compile-warnings fs/reiser4/plugin/file/cryptcompress.c
--- a/fs/reiser4/plugin/file/cryptcompress.c~reiser4-fix-compile-warnings
+++ a/fs/reiser4/plugin/file/cryptcompress.c
@@ -1014,7 +1014,7 @@ int reiser4_deflate_cluster(struct clust
 	coplug = inode_compression_plugin(inode);
 	if (should_compress(tc, clust->index, inode)) {
 		/* try to compress, discard bad results */
-		__u32 dst_len;
+		size_t dst_len;
 		compression_mode_plugin * mplug =
 			inode_compression_mode_plugin(inode);
 		assert("edward-602", coplug != NULL);
@@ -1164,7 +1164,7 @@ int reiser4_inflate_cluster(struct clust
 		transformed = 1;
 	}
 	if (need_inflate(clust, inode, 0)) {
-		unsigned dst_len = inode_cluster_size(inode);
+		size_t dst_len = inode_cluster_size(inode);
 		if(transformed)
 			alternate_streams(tc);
 
diff -puN fs/reiser4/plugin/file/file_conversion.c~reiser4-fix-compile-warnings fs/reiser4/plugin/file/file_conversion.c
--- a/fs/reiser4/plugin/file/file_conversion.c~reiser4-fix-compile-warnings
+++ a/fs/reiser4/plugin/file/file_conversion.c
@@ -273,7 +273,7 @@ static int read_check_compressibility(st
 {
 	int i;
 	int result;
-	__u32 dst_len;
+	size_t dst_len;
 	hint_t tmp_hint;
 	hint_t * cur_hint = clust->hint;
 	assert("edward-1541", cont->state == DISPATCH_POINT);
diff -puN fs/reiser4/plugin/item/item.h~reiser4-fix-compile-warnings fs/reiser4/plugin/item/item.h
--- a/fs/reiser4/plugin/item/item.h~reiser4-fix-compile-warnings
+++ a/fs/reiser4/plugin/item/item.h
@@ -233,8 +233,8 @@ struct dir_entry_iops {
 
 /* operations specific to items regular (unix) file metadata are built of */
 struct file_iops{
-	int (*write) (struct file *, struct inode *,
-		      const char __user *, size_t, loff_t *pos);
+	ssize_t (*write) (struct file *, struct inode *,
+			  const char __user *, size_t, loff_t *pos);
 	int (*read) (struct file *, flow_t *, hint_t *);
 	int (*readpage) (void *, struct page *);
 	int (*get_block) (const coord_t *, sector_t, sector_t *);
diff -puN fs/reiser4/plugin/plugin.h~reiser4-fix-compile-warnings fs/reiser4/plugin/plugin.h
--- a/fs/reiser4/plugin/plugin.h~reiser4-fix-compile-warnings
+++ a/fs/reiser4/plugin/plugin.h
@@ -560,10 +560,10 @@ typedef struct compression_plugin {
 	int (*min_size_deflate) (void);
 	 __u32(*checksum) (char *data, __u32 length);
 	/* main transform procedures */
-	void (*compress) (coa_t coa, __u8 *src_first, unsigned src_len,
-			  __u8 *dst_first, unsigned *dst_len);
-	void (*decompress) (coa_t coa, __u8 *src_first, unsigned src_len,
-			    __u8 *dst_first, unsigned *dst_len);
+	void (*compress) (coa_t coa, __u8 *src_first, size_t src_len,
+			  __u8 *dst_first, size_t *dst_len);
+	void (*decompress) (coa_t coa, __u8 *src_first, size_t src_len,
+			    __u8 *dst_first, size_t *dst_len);
 } compression_plugin;
 
 typedef struct compression_mode_plugin {
_

Patches currently in -mm which might be from edward.shishkin@gmail.com are

vfs-take-2add-set_page_dirty_notag.patch
reiser4-vfs-add-super_operationssync_inodes-2.patch
reiser4.patch
reiser4-adjust-to-the-new-aops.patch
reiser4-adjust-to-the-new-aops-fixup.patch
reiser4-remove-simple_prepare_write-usage.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
reiser4-handling-error-returned-by-d_obtain_alias-fixup.patch
reiser4-update-names-of-quota-methods.patch
reiser4-use-set_page_dirty_notag.patch
fs-reiser4-add-parenths-around-x-y.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
reiser4-rename-psched-to-dispatch.patch
reiser4-drop-journal-info.patch
reiser4-fix-compile-warnings.patch
reiser4-reduce-frame-size-of-reiser4_init_super_data.patch
reiser4-reduce-frame-size-of-reiser4_init_super_data-fixup.patch
reiser4-disable.patch


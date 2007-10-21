From: akpm@linux-foundation.org
Subject: - reiser4-cryptcompress-misc-fixups-2.patch removed from -mm tree
Date: Sun, 21 Oct 2007 16:47:20 -0700
Message-ID: <200710212347.l9LNlKOc000655@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50183 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751235AbXJUXr5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 21 Oct 2007 19:47:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: edward@namesys.com, vs@namesys.com, mm-commits@vger.kernel.org


The patch titled
     reiser4: cryptcompress misc fixups-2
has been removed from the -mm tree.  Its filename was
     reiser4-cryptcompress-misc-fixups-2.patch

This patch was dropped because it was folded into reiser4.patch

------------------------------------------------------
Subject: reiser4: cryptcompress misc fixups-2
From: Edward Shishkin <edward@namesys.com>

Check a file plugin id before manipulating with plugin-specific counter.

Signed-off-by: Edward Shishkin <edward@namesys.com>
Cc: "Vladimir V. Saveliev" <vs@namesys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/plugin/file/cryptcompress.h |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)

diff -puN fs/reiser4/plugin/file/cryptcompress.h~reiser4-cryptcompress-misc-fixups-2 fs/reiser4/plugin/file/cryptcompress.h
--- a/fs/reiser4/plugin/file/cryptcompress.h~reiser4-cryptcompress-misc-fixups-2
+++ a/fs/reiser4/plugin/file/cryptcompress.h
@@ -38,11 +38,23 @@ static inline int cluster_shift_ok(int s
 
 #if REISER4_DEBUG
 #define INODE_PGCOUNT(inode)						\
-	(atomic_read(&cryptcompress_inode_data(inode)->pgcount))
+({								        \
+	assert("edward-1530", inode_file_plugin(inode) ==		\
+	       file_plugin_by_id(CRYPTCOMPRESS_FILE_PLUGIN_ID));	\
+	atomic_read(&cryptcompress_inode_data(inode)->pgcount);		\
+ })
 #define INODE_PGCOUNT_INC(inode)					\
-	(atomic_inc(&cryptcompress_inode_data(inode)->pgcount))
+do {								        \
+	assert("edward-1531", inode_file_plugin(inode) ==		\
+	       file_plugin_by_id(CRYPTCOMPRESS_FILE_PLUGIN_ID));	\
+	atomic_inc(&cryptcompress_inode_data(inode)->pgcount);		\
+} while (0)
 #define INODE_PGCOUNT_DEC(inode)					\
-	(atomic_dec(&cryptcompress_inode_data(inode)->pgcount))
+do {								        \
+	if (inode_file_plugin(inode) ==					\
+	    file_plugin_by_id(CRYPTCOMPRESS_FILE_PLUGIN_ID))		\
+		atomic_dec(&cryptcompress_inode_data(inode)->pgcount);	\
+} while (0)
 #else
 #define INODE_PGCOUNT(inode) (0)
 #define INODE_PGCOUNT_INC(inode)
_

Patches currently in -mm which might be from edward@namesys.com are

origin.patch
reiser4.patch
reiser4-cryptcompress-misc-fixups-2.patch
reiser4-cryptcompress-misc-fixups-make-3-functions-static.patch
reiser4-change-error-code-base.patch
reiser4-use-lzo-library-functions.patch
fs-reiser4-plugin-file-cryptcompressc-kmalloc-memset-conversion-to-kzalloc.patch
reiser4-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-init_superc-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-plugin-inode_ops_renamec-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-ktxnmgrdc-kmalloc-memset-conversion-to-kzalloc.patch
git-nfsd-broke-reiser4.patch

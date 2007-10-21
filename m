From: akpm@linux-foundation.org
Subject: - reiser4-fix-extent2tail.patch removed from -mm tree
Date: Sun, 21 Oct 2007 16:47:01 -0700
Message-ID: <200710212347.l9LNl1IE000625@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59140 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751104AbXJUXrj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 21 Oct 2007 19:47:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: edward@namesys.com, mm-commits@vger.kernel.org


The patch titled
     reiser4: fix extent2tail
has been removed from the -mm tree.  Its filename was
     reiser4-fix-extent2tail.patch

This patch was dropped because it was folded into reiser4.patch

------------------------------------------------------
Subject: reiser4: fix extent2tail
From: Edward Shishkin <edward@namesys.com>

Fixed bug in extent2tail conversion.

Bug description:
when converting partially converted file
(with flag REISER4_PART_MIXED installed)
reiser4_cut_tree() starts to cut old metatada
from wrong offset. Result is data corruption.

Signed-off-by: Edward Shishkin <edward@namesys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/plugin/file/file.c            |    7 -------
 fs/reiser4/plugin/file/tail_conversion.c |    2 +-
 2 files changed, 1 insertion(+), 8 deletions(-)

diff -puN fs/reiser4/plugin/file/file.c~reiser4-fix-extent2tail fs/reiser4/plugin/file/file.c
--- a/fs/reiser4/plugin/file/file.c~reiser4-fix-extent2tail
+++ a/fs/reiser4/plugin/file/file.c
@@ -194,13 +194,6 @@ static void set_file_state(struct unix_f
 	assert("vs-1164", level == LEAF_LEVEL || level == TWIG_LEVEL);
 
 	if (uf_info->container == UF_CONTAINER_UNKNOWN) {
-		/*
-		 * container is unknown, therefore conversion can not be in
-		 * progress
-		 */
-		assert("",
-		       !reiser4_inode_get_flag(unix_file_info_to_inode(uf_info),
-					       REISER4_PART_IN_CONV));
 		if (cbk_result == CBK_COORD_NOTFOUND)
 			uf_info->container = UF_CONTAINER_EMPTY;
 		else if (level == LEAF_LEVEL)
diff -puN fs/reiser4/plugin/file/tail_conversion.c~reiser4-fix-extent2tail fs/reiser4/plugin/file/tail_conversion.c
--- a/fs/reiser4/plugin/file/tail_conversion.c~reiser4-fix-extent2tail
+++ a/fs/reiser4/plugin/file/tail_conversion.c
@@ -620,7 +620,7 @@ int extent2tail(struct unix_file_info *u
 		}
 
 		/* cut part of file we have read */
-		start_byte = (__u64) (i << PAGE_CACHE_SHIFT);
+		start_byte = (__u64) ((i + start_page) << PAGE_CACHE_SHIFT);
 		set_key_offset(&from, start_byte);
 		set_key_offset(&to, start_byte + PAGE_CACHE_SIZE - 1);
 		/*
_

Patches currently in -mm which might be from edward@namesys.com are

origin.patch
reiser4.patch
reiser4-fix-extent2tail.patch
reiser4-fix-read_tail.patch
reiser4-fix-unix-file-readpages-filler.patch
reiser4-fix-readpage_unix_file.patch
reiser4-fix-for-new-aops-patches.patch
reiser4-do-not-allocate-struct-file-on-stack.patch
git-block-vs-reiser4.patch
reiser4-cryptcompress-misc-fixups.patch
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

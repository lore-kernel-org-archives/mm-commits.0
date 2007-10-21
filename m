From: akpm@linux-foundation.org
Subject: - reiser4-fix-read_tail.patch removed from -mm tree
Date: Sun, 21 Oct 2007 16:47:03 -0700
Message-ID: <200710212347.l9LNl3s8000634@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36693 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751164AbXJUXrk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 21 Oct 2007 19:47:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: edward@namesys.com, mm-commits@vger.kernel.org


The patch titled
     reiser4: fix read_tail
has been removed from the -mm tree.  Its filename was
     reiser4-fix-read_tail.patch

This patch was dropped because it was folded into reiser4.patch

------------------------------------------------------
Subject: reiser4: fix read_tail
From: Edward Shishkin <edward@namesys.com>

Update hint when reading tails

Signed-off-by: Edward Shishkin <edward@namesys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/plugin/item/tail.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/reiser4/plugin/item/tail.c~reiser4-fix-read_tail fs/reiser4/plugin/item/tail.c
--- a/fs/reiser4/plugin/item/tail.c~reiser4-fix-read_tail
+++ a/fs/reiser4/plugin/item/tail.c
@@ -758,7 +758,7 @@ int reiser4_read_tail(struct file *file 
 		coord->unit_pos--;
 		coord->between = AFTER_UNIT;
 	}
-
+	reiser4_set_hint(hint, &f->key, ZNODE_READ_LOCK);
 	return 0;
 }
 
_

Patches currently in -mm which might be from edward@namesys.com are

origin.patch
reiser4.patch
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

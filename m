From: akpm@osdl.org
Subject: + reiser4-fix-freeze-and-corruption.patch added to -mm tree
Date: Wed, 24 Jan 2007 22:00:15 -0800
Message-ID: <200701250600.l0P60FTD007507@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48726 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965366AbXAYGAT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 01:00:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vs@namesys.com, edward@namesys.com


The patch titled
     Reiser4: fix filesystem freeze and corruption
has been added to the -mm tree.  Its filename is
     reiser4-fix-freeze-and-corruption.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Reiser4: fix filesystem freeze and corruption
From: Vladimir Saveliev <vs@namesys.com>

remove_suid may open a transaction in reiser4 which is to be restarted
before entering into main write loop.

Signed-off-by: Vladimir Saveliev <vs@namesys.com>
Cc: Edward Shishkin <edward@namesys.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/reiser4/plugin/file/file.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/reiser4/plugin/file/file.c~reiser4-fix-freeze-and-corruption fs/reiser4/plugin/file/file.c
--- a/fs/reiser4/plugin/file/file.c~reiser4-fix-freeze-and-corruption
+++ a/fs/reiser4/plugin/file/file.c
@@ -2175,6 +2175,8 @@ ssize_t write_unix_file(struct file *fil
 		reiser4_exit_context(ctx);
 		return result;
 	}
+	/* remove_suid might create a transaction */
+	reiser4_txn_restart(ctx);
 
 	uf_info = unix_file_inode_data(inode);
 
_

Patches currently in -mm which might be from vs@namesys.com are

reiserfs-avoid-tail-packing-if-an-inode-was-ever-mmapped.patch
reiser4.patch
reiser4-hardirq-include-fix.patch
reiser4-fix-trivial-tyops-which-were-hard-to-hit.patch
reiser4-run-truncate_inode_pages-in-reiser4_delete_inode.patch
reiser4-bug-fixes.patch
reiser4-fix-gcc-ws-compains.patch
fs-reiser4-possible-cleanups.patch
reiser4-get_sb_dev-fix.patch
reiser4-vs-zoned-allocator.patch
reiser4-vs-streamline-generic_file_-interfaces-and-filemap.patch
reiser4-rename-generic_sounding_globalspatch.patch
reiser4-possible-cleanups-2.patch
reiser4-temp-fix.patch
fs-reiser4-more-possible-cleanups.patch
reiser4-use-null-for-pointers.patch
reiser4-test_clear_page_dirty.patch
reiser4-fix-freeze-and-corruption.patch
reiser4-vs-git-block.patch
reiser4-vs-git-block-2.patch

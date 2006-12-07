From: akpm@osdl.org
Subject: - reiserfs-do-not-add-save-links-for-o_direct-writes-fix.patch removed from -mm tree
Date: Wed, 06 Dec 2006 19:36:03 -0800
Message-ID: <200612070336.kB73a3Hh027527@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:43331 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968330AbWLGDle (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 6 Dec 2006 22:41:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vs@namesys.com, amitarora@in.ibm.com, jeffm@suse.com, mason@suse.com, suzuki@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     reiserfs-do-not-add-save-links-for-o_direct-writes fix
has been removed from the -mm tree.  Its filename was
     reiserfs-do-not-add-save-links-for-o_direct-writes-fix.patch

This patch was dropped because it was folded into reiserfs-do-not-add-save-links-for-o_direct-writes.patch

------------------------------------------------------
Subject: reiserfs-do-not-add-save-links-for-o_direct-writes fix
From: Vladimir Saveliev <vs@namesys.com>

To write far past the end of a file reiserfs appends a hole first.  While
the hole grows file size in ondisk inode has to be updated so that in case
of unclean shutdown it matches real file size.

Signed-off-by: Vladimir Saveliev <vs@namesys.com>
Cc: Amit Arora <amitarora@in.ibm.com>
Cc: Suzuki K P <suzuki@in.ibm.com>
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Chris Mason <mason@suse.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/reiserfs/file.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/reiserfs/file.c~reiserfs-do-not-add-save-links-for-o_direct-writes-fix fs/reiserfs/file.c
--- a/fs/reiserfs/file.c~reiserfs-do-not-add-save-links-for-o_direct-writes-fix
+++ a/fs/reiserfs/file.c
@@ -406,6 +406,8 @@ static int reiserfs_allocate_blocks_for_
 				   we restart it. This will also free the path. */
 				if (journal_transaction_should_end
 				    (th, th->t_blocks_allocated)) {
+					inode->i_size = cpu_key_k_offset(&key) +
+						(to_paste << inode->i_blkbits);
 					res =
 					    restart_transaction(th, inode,
 								&path);
_

Patches currently in -mm which might be from vs@namesys.com are

patch-to-fix-reiserfs-bad-path-release-panic-on-2619-rc1.patch
reiserfs-do-not-add-save-links-for-o_direct-writes.patch
reiserfs-do-not-add-save-links-for-o_direct-writes-fix.patch
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


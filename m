From: akpm@linux-foundation.org
Subject: [merged] ocfs2-fix-uninitialized-variable-access.patch removed
 from -mm tree
Date: Wed, 11 Feb 2015 12:20:59 -0800
Message-ID: <54dbb9ab.bc91BYwU7B1Xc9a6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40808 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013AbbBKUVA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Feb 2015 15:21:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: junxiao.bi@oracle.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix uninitialized variable access
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-uninitialized-variable-access.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: ocfs2: fix uninitialized variable access

Variable "why" is not yet initialized at line 615, fix it.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/file.c~ocfs2-fix-uninitialized-variable-access fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-fix-uninitialized-variable-access
+++ a/fs/ocfs2/file.c
@@ -569,7 +569,7 @@ static int __ocfs2_extend_allocation(str
 	handle_t *handle = NULL;
 	struct ocfs2_alloc_context *data_ac = NULL;
 	struct ocfs2_alloc_context *meta_ac = NULL;
-	enum ocfs2_alloc_restarted why;
+	enum ocfs2_alloc_restarted why = RESTART_NONE;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct ocfs2_extent_tree et;
 	int did_quota = 0;
_

Patches currently in -mm which might be from junxiao.bi@oracle.com are

origin.patch
linux-next.patch
ocfs2-prepare-some-interfaces-used-in-append-direct-io.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir-fix.patch
ocfs2-add-orphan-recovery-types-in-ocfs2_recover_orphans.patch
ocfs2-implement-ocfs2_direct_io_write.patch
ocfs2-implement-ocfs2_direct_io_write-fix.patch
ocfs2-allocate-blocks-in-ocfs2_direct_io_get_blocks.patch
ocfs2-do-not-fallback-to-buffer-i-o-write-if-appending.patch
ocfs2-complete-the-rest-request-through-buffer-io.patch
ocfs2-wait-for-orphan-recovery-first-once-append-o_direct-write-crash.patch
ocfs2-set-append-dio-as-a-ro-compat-feature.patch


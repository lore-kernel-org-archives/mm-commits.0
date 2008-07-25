From: akpm@linux-foundation.org
Subject: - ext3-kill-2-useless-magic-numbers.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:56:50 -0700
Message-ID: <200807252256.m6PMuogW003120@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58588 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755306AbYGYW5Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 18:57:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, adilger@sun.com, mm-commits@vger.kernel.org


The patch titled
     ext3: kill 2 useless magic numbers
has been removed from the -mm tree.  Its filename was
     ext3-kill-2-useless-magic-numbers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext3: kill 2 useless magic numbers
From: Li Zefan <lizf@cn.fujitsu.com>

dx_root_limit() will never return 20, and I can't figure out what 20
stands for.  This function has never changed since htree directory
indexing was merged.

Similar for dx_node_limit() and the magic 22.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Andreas Dilger <adilger@sun.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/namei.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/ext3/namei.c~ext3-kill-2-useless-magic-numbers fs/ext3/namei.c
--- a/fs/ext3/namei.c~ext3-kill-2-useless-magic-numbers
+++ a/fs/ext3/namei.c
@@ -240,13 +240,13 @@ static inline unsigned dx_root_limit (st
 {
 	unsigned entry_space = dir->i_sb->s_blocksize - EXT3_DIR_REC_LEN(1) -
 		EXT3_DIR_REC_LEN(2) - infosize;
-	return 0? 20: entry_space / sizeof(struct dx_entry);
+	return entry_space / sizeof(struct dx_entry);
 }
 
 static inline unsigned dx_node_limit (struct inode *dir)
 {
 	unsigned entry_space = dir->i_sb->s_blocksize - EXT3_DIR_REC_LEN(0);
-	return 0? 22: entry_space / sizeof(struct dx_entry);
+	return entry_space / sizeof(struct dx_entry);
 }
 
 /*
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
linux-next.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
introduce-__get_user_pages.patch
introduce-__get_user_pages-fix.patch
split-lru-munlock-rework.patch
revert-to-unevictable-lru-infrastructure-kconfig-fixpatch.patch


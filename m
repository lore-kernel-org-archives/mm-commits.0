From: akpm@linux-foundation.org
Subject: [merged] fs-befs-move-useless-assignment.patch removed from -mm
 tree
Date: Mon, 01 Aug 2016 17:25:22 -0700
Message-ID: <579fe872.IoJIAAkFWd7lPo3x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47756 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258AbcHBAZX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Aug 2016 20:25:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: salah.triki@acm.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/befs/linuxvfs.c: move useless assignment
has been removed from the -mm tree.  Its filename was
     fs-befs-move-useless-assignment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Salah Triki <salah.triki@acm.org>
Subject: fs/befs/linuxvfs.c: move useless assignment

Control is transfered to unacquire_none when sb->s_fs_info is equal to
NULL, so the assignment to NULL is useless and it is moved above
unacquire_none.

Link: http://lkml.kernel.org/r/ed41da113fc693c7daa4e8813ca04cc766ddfc05.1464226521.git.salah.triki@acm.org
Signed-off-by: Salah Triki <salah.triki@acm.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/befs/linuxvfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/befs/linuxvfs.c~fs-befs-move-useless-assignment fs/befs/linuxvfs.c
--- a/fs/befs/linuxvfs.c~fs-befs-move-useless-assignment
+++ a/fs/befs/linuxvfs.c
@@ -870,9 +870,9 @@ befs_fill_super(struct super_block *sb,
       unacquire_priv_sbp:
 	kfree(befs_sb->mount_opts.iocharset);
 	kfree(sb->s_fs_info);
+	sb->s_fs_info = NULL;
 
       unacquire_none:
-	sb->s_fs_info = NULL;
 	return ret;
 }
 
_

Patches currently in -mm which might be from salah.triki@acm.org are



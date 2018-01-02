From: akpm@linux-foundation.org
Subject: [merged] lustre-dont-set-f_version-in-ll_readdir.patch
 removed from -mm tree
Date: Tue, 02 Jan 2018 11:54:20 -0800
Message-ID: <20180102195420.lXeM6EU3q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59442 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751014AbeABTyX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 2 Jan 2018 14:54:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreas.dilger@intel.com, anton@tuxera.com, jlayton@redhat.com, jsimmons@infradead.org, mikulas@artax.karlin.mff.cuni.cz, mm-commits@vger.kernel.org, oleg.drokin@intel.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: lustre: don't set f_version in ll_readdir
has been removed from the -mm tree.  Its filename was
     lustre-dont-set-f_version-in-ll_readdir.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jeff Layton <jlayton@redhat.com>
Subject: lustre: don't set f_version in ll_readdir

f_version is only ever used by filesystem-specific code.  Generic VFS code
never uses it.

Nothing in lustre ever looks at it, so just remove this.

Link: http://lkml.kernel.org/r/20171207113206.31544-2-jlayton@kernel.org
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Anton Altaparmakov <anton@tuxera.com>
Cc: James Simmons <jsimmons@infradead.org>
Cc: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Cc: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/lustre/lustre/llite/dir.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN drivers/staging/lustre/lustre/llite/dir.c~lustre-dont-set-f_version-in-ll_readdir drivers/staging/lustre/lustre/llite/dir.c
--- a/drivers/staging/lustre/lustre/llite/dir.c~lustre-dont-set-f_version-in-ll_readdir
+++ a/drivers/staging/lustre/lustre/llite/dir.c
@@ -369,8 +369,6 @@ static int ll_readdir(struct file *filp,
 	}
 	ctx->pos = pos;
 	ll_finish_md_op_data(op_data);
-	filp->f_version = inode->i_version;

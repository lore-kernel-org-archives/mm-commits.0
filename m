From: akpm@linux-foundation.org
Subject: [merged] ocfs2-fix-panic-on-kfreexattr-name.patch removed from
 -mm tree
Date: Fri, 04 Apr 2014 12:30:28 -0700
Message-ID: <533f0854.53zgvXrYPTZoU8Rk%akpm__30136.0180521899$1396639844$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42779 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194AbaDDTa3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:30:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tariq.x.saeed@oracle.com, stable@vger.kernel.org, srinivas.eeda@oracle.com, mfasheh@suse.com, jlbec@evilplan.org, penguin-kernel@I-love.SAKURA.ne.jp

Subject: [merged] ocfs2-fix-panic-on-kfreexattr-name.patch removed from -mm tree
To: penguin-kernel@I-love.SAKURA.ne.jp,jlbec@evilplan.org,mfasheh@suse.com,srinivas.eeda@oracle.com,stable@vger.kernel.org,tariq.x.saeed@oracle.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:30:28 -0700


The patch titled
     Subject: ocfs2: fix panic on kfree(xattr->name)
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-panic-on-kfreexattr-name.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: ocfs2: fix panic on kfree(xattr->name)

Commit 9548906b 'xattr: Constify ->name member of "struct xattr".' missed that
ocfs2 is calling kfree(xattr->name). As a result, kernel panic occurs upon
calling kfree(xattr->name) because xattr->name refers static constant names.
This patch removes kfree(xattr->name) from ocfs2_mknod() and ocfs2_symlink().

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reported-by: Tariq Saeed <tariq.x.saeed@oracle.com>
Tested-by: Tariq Saeed <tariq.x.saeed@oracle.com>
Reviewed-by: Srinivas Eeda <srinivas.eeda@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: <stable@vger.kernel.org>	[3.12+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/ocfs2/namei.c~ocfs2-fix-panic-on-kfreexattr-name fs/ocfs2/namei.c
--- a/fs/ocfs2/namei.c~ocfs2-fix-panic-on-kfreexattr-name
+++ a/fs/ocfs2/namei.c
@@ -450,7 +450,6 @@ leave:
 
 	brelse(new_fe_bh);
 	brelse(parent_fe_bh);
-	kfree(si.name);
 	kfree(si.value);
 
 	ocfs2_free_dir_lookup_result(&lookup);
@@ -1856,7 +1855,6 @@ bail:
 
 	brelse(new_fe_bh);
 	brelse(parent_fe_bh);
-	kfree(si.name);
 	kfree(si.value);
 	ocfs2_free_dir_lookup_result(&lookup);
 	if (inode_ac)
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are

origin.patch
lib-vsprintf-add-%pt-format-specifier.patch
linux-next.patch


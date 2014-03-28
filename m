From: akpm@linux-foundation.org
Subject: + ocfs2-fix-panic-on-kfreexattr-name.patch added to -mm tree
Date: Fri, 28 Mar 2014 14:58:01 -0700
Message-ID: <5335f069.rzUNTnu7W+GHwP7s%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53901 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbaC1V6E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Mar 2014 17:58:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tariq.x.saeed@oracle.com, stable@vger.kernel.org, srinivas.eeda@oracle.com, mfasheh@suse.com, jlbec@evilplan.org, penguin-kernel@I-love.SAKURA.ne.jp

Subject: + ocfs2-fix-panic-on-kfreexattr-name.patch added to -mm tree
To: penguin-kernel@I-love.SAKURA.ne.jp,jlbec@evilplan.org,mfasheh@suse.com,srinivas.eeda@oracle.com,stable@vger.kernel.org,tariq.x.saeed@oracle.com
From: akpm@linux-foundation.org
Date: Fri, 28 Mar 2014 14:58:01 -0700


The patch titled
     Subject: ocfs2: fix panic on kfree(xattr->name)
has been added to the -mm tree.  Its filename is
     ocfs2-fix-panic-on-kfreexattr-name.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-panic-on-kfreexattr-name.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-panic-on-kfreexattr-name.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1949,7 +1948,6 @@ bail:
 
 	brelse(new_fe_bh);
 	brelse(parent_fe_bh);
-	kfree(si.name);
 	kfree(si.value);
 	ocfs2_free_dir_lookup_result(&lookup);
 	if (inode_ac)
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are

kthread-ensure-locality-of-task_struct-allocations.patch
ocfs2-fix-panic-on-kfreexattr-name.patch
lib-vsprintf-add-%pt-format-specifier.patch
linux-next.patch


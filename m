From: akpm@linux-foundation.org
Subject: + ocfs2-do-not-put-bh-when-buffer_uptodate-failed.patch added to
 -mm tree
Date: Wed, 26 Mar 2014 15:37:33 -0700
Message-ID: <533356ad.1i91PHcTPL+CzymR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58595 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755910AbaCZWhe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Mar 2014 18:37:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, srinivas.eeda@oracle.com, mfasheh@suse.com, joseph.qi@huawei.com, jlbec@evilplan.org, alex.chen@huawei.com

Subject: + ocfs2-do-not-put-bh-when-buffer_uptodate-failed.patch added to -mm tree
To: alex.chen@huawei.com,jlbec@evilplan.org,joseph.qi@huawei.com,mfasheh@suse.com,srinivas.eeda@oracle.com,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 26 Mar 2014 15:37:33 -0700


The patch titled
     Subject: ocfs2: do not put bh when buffer_uptodate failed
has been added to the -mm tree.  Its filename is
     ocfs2-do-not-put-bh-when-buffer_uptodate-failed.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-do-not-put-bh-when-buffer_uptodate-failed.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-do-not-put-bh-when-buffer_uptodate-failed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: alex chen <alex.chen@huawei.com>
Subject: ocfs2: do not put bh when buffer_uptodate failed

Do not put bh when buffer_uptodate failed in ocfs2_write_block and
ocfs2_write_super_or_backup, because it will put bh in b_end_io. 
Otherwise it will hit a warning "VFS: brelse: Trying to free free buffer".

Signed-off-by: Alex Chen <alex.chen@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: Srinivas Eeda <srinivas.eeda@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/buffer_head_io.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/ocfs2/buffer_head_io.c~ocfs2-do-not-put-bh-when-buffer_uptodate-failed fs/ocfs2/buffer_head_io.c
--- a/fs/ocfs2/buffer_head_io.c~ocfs2-do-not-put-bh-when-buffer_uptodate-failed
+++ a/fs/ocfs2/buffer_head_io.c
@@ -90,7 +90,6 @@ int ocfs2_write_block(struct ocfs2_super
 		 * information for this bh as it's not marked locally
 		 * uptodate. */
 		ret = -EIO;
-		put_bh(bh);
 		mlog_errno(ret);
 	}
 
@@ -420,7 +419,6 @@ int ocfs2_write_super_or_backup(struct o
 
 	if (!buffer_uptodate(bh)) {
 		ret = -EIO;
-		put_bh(bh);
 		mlog_errno(ret);
 	}
 
_

Patches currently in -mm which might be from alex.chen@huawei.com are

ocfs2-do-not-put-bh-when-buffer_uptodate-failed.patch


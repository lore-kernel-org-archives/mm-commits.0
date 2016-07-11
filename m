From: akpm@linux-foundation.org
Subject: +
 ocfs2-retry-on-enospc-if-sufficient-space-in-truncate-log-v3.patch added to -mm tree
Date: Mon, 11 Jul 2016 14:26:41 -0700
Message-ID: <57840f11.9QKeigLgJ8NIbQLp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43289 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbcGKV0m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jul 2016 17:26:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zren@suse.com, ghe@suse.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2-retry-on-enospc-if-sufficient-space-in-truncate-log-v3
has been added to the -mm tree.  Its filename is
     ocfs2-retry-on-enospc-if-sufficient-space-in-truncate-log-v3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-retry-on-enospc-if-sufficient-space-in-truncate-log-v3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-retry-on-enospc-if-sufficient-space-in-truncate-log-v3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Eric Ren <zren@suse.com>
Subject: ocfs2-retry-on-enospc-if-sufficient-space-in-truncate-log-v3

v3:
1. Also need to lock allocator inode when "= 0" is returned from
ocfs2_schedule_truncate_log_flush(), which means no space really.
-- spotted by Joseph Qi

Link: http://lkml.kernel.org/r/1468031546-4797-1-git-send-email-zren@suse.com
Signed-off-by: Eric Ren <zren@suse.com>
Cc: Gang He <ghe@suse.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/suballoc.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/ocfs2/suballoc.c~ocfs2-retry-on-enospc-if-sufficient-space-in-truncate-log-v3 fs/ocfs2/suballoc.c
--- a/fs/ocfs2/suballoc.c~ocfs2-retry-on-enospc-if-sufficient-space-in-truncate-log-v3
+++ a/fs/ocfs2/suballoc.c
@@ -1204,6 +1204,9 @@ retry:
 
 			if (ret < 0)
 				mlog_errno(ret);
+
+			inode_lock((*ac)->ac_inode);
+			ocfs2_inode_lock((*ac)->ac_inode, NULL, 1);
 		}
 		if (status < 0) {
 			if (status != -ENOSPC)
_

Patches currently in -mm which might be from zren@suse.com are

ocfs2-fix-a-redundant-re-initialization.patch
ocfs2-retry-on-enospc-if-sufficient-space-in-truncate-log.patch
ocfs2-retry-on-enospc-if-sufficient-space-in-truncate-log-v3.patch


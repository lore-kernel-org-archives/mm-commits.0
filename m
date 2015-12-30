From: akpm@linux-foundation.org
Subject: + ocfs2-dlm-remove-redundant-code.patch added to -mm tree
Date: Wed, 30 Dec 2015 13:31:05 -0800
Message-ID: <56844d19.cTxko56VkfZTBe0L%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39203 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466AbbL3VbG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Dec 2015 16:31:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: junxiao.bi@oracle.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: dlm: remove redundant code
has been added to the -mm tree.  Its filename is
     ocfs2-dlm-remove-redundant-code.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-dlm-remove-redundant-code.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-dlm-remove-redundant-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: ocfs2: dlm: remove redundant code

Found this when do patch review, remove to make it clear and save
a little cpu time.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmrecovery.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-remove-redundant-code fs/ocfs2/dlm/dlmrecovery.c
--- a/fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-remove-redundant-code
+++ a/fs/ocfs2/dlm/dlmrecovery.c
@@ -2457,11 +2457,7 @@ static void __dlm_hb_node_down(struct dl
 	 * perhaps later we can genericize this for other waiters. */
 	wake_up(&dlm->migration_wq);
 
-	if (test_bit(idx, dlm->recovery_map))
-		mlog(0, "domain %s, node %u already added "
-		     "to recovery map!\n", dlm->name, idx);
-	else
-		set_bit(idx, dlm->recovery_map);
+	set_bit(idx, dlm->recovery_map);
 }
 
 void dlm_hb_node_down_cb(struct o2nm_node *node, int idx, void *data)
_

Patches currently in -mm which might be from junxiao.bi@oracle.com are

o2hb-increase-unsteady-iterations.patch
ocfs2-dlm-remove-redundant-code.patch


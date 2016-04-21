From: akpm@linux-foundation.org
Subject: +
 ocfs2-dlm-return-zero-if-deref_done-message-is-successfully-handled.patch
 added to -mm tree
Date: Thu, 21 Apr 2016 16:36:59 -0700
Message-ID: <5719641b.DgakMktbUwgt8+aZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34692 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbcDUXhA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Apr 2016 19:37:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xuejiufei@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/dlm: return zero if deref_done message is successfully handled
has been added to the -mm tree.  Its filename is
     ocfs2-dlm-return-zero-if-deref_done-message-is-successfully-handled.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-dlm-return-zero-if-deref_done-message-is-successfully-handled.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-dlm-return-zero-if-deref_done-message-is-successfully-handled.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: xuejiufei <xuejiufei@huawei.com>
Subject: ocfs2/dlm: return zero if deref_done message is successfully handled

dlm_deref_lockres_done_handler() should return zero if the message is
successfully handled.

Fixes: 60d663cb5273 ("ocfs2/dlm: add DEREF_DONE message").
Signed-off-by: xuejiufei <xuejiufei@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmmaster.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/ocfs2/dlm/dlmmaster.c~ocfs2-dlm-return-zero-if-deref_done-message-is-successfully-handled fs/ocfs2/dlm/dlmmaster.c
--- a/fs/ocfs2/dlm/dlmmaster.c~ocfs2-dlm-return-zero-if-deref_done-message-is-successfully-handled
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -2455,6 +2455,8 @@ int dlm_deref_lockres_done_handler(struc
 
 	spin_unlock(&dlm->spinlock);
 
+	ret = 0;
+
 done:
 	dlm_put(dlm);
 	return ret;
_

Patches currently in -mm which might be from xuejiufei@huawei.com are

ocfs2-dlm-return-zero-if-deref_done-message-is-successfully-handled.patch


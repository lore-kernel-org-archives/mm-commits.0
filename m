From: akpm@linux-foundation.org
Subject: +
 ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages-v2.patch
 added to -mm tree
Date: Fri, 05 Sep 2014 14:55:26 -0700
Message-ID: <540a314e.hiSDh2QNQaAZGEyC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42610 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbaIEVz1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Sep 2014 17:55:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jiangyiwen@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages-v2
has been added to the -mm tree.  Its filename is
     ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: jiangyiwen <jiangyiwen@huawei.com>
Subject: ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages-v2

Signed-off-by: jiangyiwen <jiangyiwen@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmthread.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/dlm/dlmthread.c~ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages-v2 fs/ocfs2/dlm/dlmthread.c
--- a/fs/ocfs2/dlm/dlmthread.c~ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages-v2
+++ a/fs/ocfs2/dlm/dlmthread.c
@@ -217,7 +217,7 @@ static void dlm_purge_lockres(struct dlm
 	else {
 		mlog(ML_ERROR, "Resource %.*s not on the Tracking list\n",
 				res->lockname.len, res->lockname.name);
-		dlm_print_one_lock_resource(res);
+		__dlm_print_one_lock_resource(res);
 	}
 	spin_unlock(&dlm->track_lock);
 
_

Patches currently in -mm which might be from jiangyiwen@huawei.com are

ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages.patch
ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages-v2.patch
ocfs2-fix-deadlock-between-o2hb-thread-and-o2net_wq.patch


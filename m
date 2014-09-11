From: akpm@linux-foundation.org
Subject: + ocfs2-free-vol_lable-in-ocfs2_delete_osb.patch added to -mm
 tree
Date: Thu, 11 Sep 2014 13:29:15 -0700
Message-ID: <5412061b.NZcmkHwkxq5+iQ7Y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43141 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754759AbaIKU3Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Sep 2014 16:29:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, xuejiufei@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: free vol_label in ocfs2_delete_osb()
has been added to the -mm tree.  Its filename is
     ocfs2-free-vol_lable-in-ocfs2_delete_osb.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-free-vol_lable-in-ocfs2_delete_osb.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-free-vol_lable-in-ocfs2_delete_osb.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: free vol_label in ocfs2_delete_osb()

osb->vol_label is malloced in ocfs2_initialize_super but not freed if
error occurs or during umount, thus causing a memory leak.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: joyce.xue <xuejiufei@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/super.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/ocfs2/super.c~ocfs2-free-vol_lable-in-ocfs2_delete_osb fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~ocfs2-free-vol_lable-in-ocfs2_delete_osb
+++ a/fs/ocfs2/super.c
@@ -2532,6 +2532,7 @@ static void ocfs2_delete_osb(struct ocfs
 	kfree(osb->journal);
 	kfree(osb->local_alloc_copy);
 	kfree(osb->uuid_str);
+	kfree(osb->vol_label);
 	ocfs2_put_dlm_debug(osb->osb_dlm_debug);
 	memset(osb, 0, sizeof(struct ocfs2_super));
 }
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

ocfs2-dlm-refactor-error-handling-in-dlm_alloc_ctxt.patch
ocfs2-fix-shift-left-operations-overflow.patch
ocfs2-free-vol_lable-in-ocfs2_delete_osb.patch
ocfs2-dlm-fix-race-between-dispatched_work-and-dlm_lockres_grab_inflight_worker.patch
ocfs2-fix-deadlock-between-o2hb-thread-and-o2net_wq.patch


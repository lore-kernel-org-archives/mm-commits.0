From: akpm@linux-foundation.org
Subject: +
 ocfs2-fix-possible-double-free-in-ocfs2_write_begin_nolock.patch added to
 -mm tree
Date: Wed, 30 Oct 2013 15:52:36 -0700
Message-ID: <52718db4.Gm1PxxiSTR9ilgG8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49694 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292Ab3J3Wwh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Oct 2013 18:52:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com, xuejiufei@huawei.com

Subject: + ocfs2-fix-possible-double-free-in-ocfs2_write_begin_nolock.patch added to -mm tree
To: xuejiufei@huawei.com,jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com
From: akpm@linux-foundation.org
Date: Wed, 30 Oct 2013 15:52:36 -0700


The patch titled
     Subject: ocfs2: fix possible double free in ocfs2_write_begin_nolock
has been added to the -mm tree.  Its filename is
     ocfs2-fix-possible-double-free-in-ocfs2_write_begin_nolock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-possible-double-free-in-ocfs2_write_begin_nolock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-possible-double-free-in-ocfs2_write_begin_nolock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xue jiufei <xuejiufei@huawei.com>
Subject: ocfs2: fix possible double free in ocfs2_write_begin_nolock

When ocfs2_write_cluster_by_desc() failed in ocfs2_write_begin_nolock()
because of ENOSPC, it goes to out_quota, freeing data_ac(meta_ac).  Then
it calls ocfs2_try_to_free_truncate_log() to free space.  If enough space
freed, it will try to write again.  Unfortunately, some error happenes
before ocfs2_lock_allocators(), it goes to out and free data_ac(meta_ac)
again.

Signed-off-by: joyce <xuejiufei@huawei.com>
Reviewed-by: Jie Liu <jeff.liu@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/aops.c~ocfs2-fix-possible-double-free-in-ocfs2_write_begin_nolock fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-fix-possible-double-free-in-ocfs2_write_begin_nolock
+++ a/fs/ocfs2/aops.c
@@ -1898,10 +1898,14 @@ out_commit:
 out:
 	ocfs2_free_write_ctxt(wc);
 
-	if (data_ac)
+	if (data_ac) {
 		ocfs2_free_alloc_context(data_ac);
-	if (meta_ac)
+		data_ac = NULL;
+	}
+	if (meta_ac) {
 		ocfs2_free_alloc_context(meta_ac);
+		meta_ac = NULL;
+	}
 
 	if (ret == -ENOSPC && try_free) {
 		/*
_

Patches currently in -mm which might be from xuejiufei@huawei.com are

ocfs2-skip-locks-in-the-blocked-list.patch
ocfs2-delay-migration-when-the-lockres-is-in-migration-state.patch
ocfs2-fix-possible-double-free-in-ocfs2_write_begin_nolock.patch


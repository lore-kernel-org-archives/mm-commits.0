From: akpm@linux-foundation.org
Subject: + ocfs2-remove-unused-code-in-dlm_new_lockres.patch added to -mm
 tree
Date: Fri, 05 Sep 2014 15:57:11 -0700
Message-ID: <540a3fc7.2OFlbbFFePfa8YEC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42891 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbaIEW5M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Sep 2014 18:57:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xuejiufei@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: remove unused code in dlm_new_lockres()
has been added to the -mm tree.  Its filename is
     ocfs2-remove-unused-code-in-dlm_new_lockres.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-remove-unused-code-in-dlm_new_lockres.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-remove-unused-code-in-dlm_new_lockres.patch

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
Subject: ocfs2: remove unused code in dlm_new_lockres()

Remove the branch that free res->lockname.name because the condition
is never satisfied when jump to label error.

Signed-off-by: joyce.xue <xuejiufei@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmmaster.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN fs/ocfs2/dlm/dlmmaster.c~ocfs2-remove-unused-code-in-dlm_new_lockres fs/ocfs2/dlm/dlmmaster.c
--- a/fs/ocfs2/dlm/dlmmaster.c~ocfs2-remove-unused-code-in-dlm_new_lockres
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -625,9 +625,6 @@ struct dlm_lock_resource *dlm_new_lockre
 	return res;
 
 error:
-	if (res && res->lockname.name)
-		kmem_cache_free(dlm_lockname_cache, (void *)res->lockname.name);

From: akpm@linux-foundation.org
Subject: [merged] ocfs2-remove-unused-code-in-dlm_new_lockres.patch
 removed from -mm tree
Date: Mon, 13 Oct 2014 11:17:39 -0700
Message-ID: <543c1743.c+8YJwBu/+XlhIjx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59967 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140AbaJMSRj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:17:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xuejiufei@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: remove unused code in dlm_new_lockres()
has been removed from the -mm tree.  Its filename was
     ocfs2-remove-unused-code-in-dlm_new_lockres.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

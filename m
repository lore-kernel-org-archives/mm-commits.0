From: akpm@linux-foundation.org
Subject: [merged] ocfs2-fix-sparse-non-static-symbol-warning.patch removed from -mm tree
Date: Wed, 22 Jan 2014 12:11:57 -0800
Message-ID: <52e0260d.66f1a+HiM+AYdbpk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54183 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764AbaAVUL5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:11:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, yongjun_wei@trendmicro.com.cn

Subject: [merged] ocfs2-fix-sparse-non-static-symbol-warning.patch removed from -mm tree
To: yongjun_wei@trendmicro.com.cn,jlbec@evilplan.org,mfasheh@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:11:57 -0800


The patch titled
     Subject: ocfs2: fix sparse non static symbol warning
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-sparse-non-static-symbol-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: ocfs2: fix sparse non static symbol warning

Fixes the following sparse warning:

fs/ocfs2/stack_user.c:930:32: warning:
 symbol 'ocfs2_ls_ops' was not declared. Should it be static?

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/stack_user.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/stack_user.c~ocfs2-fix-sparse-non-static-symbol-warning fs/ocfs2/stack_user.c
--- a/fs/ocfs2/stack_user.c~ocfs2-fix-sparse-non-static-symbol-warning
+++ a/fs/ocfs2/stack_user.c
@@ -979,7 +979,7 @@ static void user_recover_done(void *arg,
 	wake_up(&lc->oc_wait);
 }
 
-const struct dlm_lockspace_ops ocfs2_ls_ops = {
+static const struct dlm_lockspace_ops ocfs2_ls_ops = {
 	.recover_prep = user_recover_prep,
 	.recover_slot = user_recover_slot,
 	.recover_done = user_recover_done,
_

Patches currently in -mm which might be from yongjun_wei@trendmicro.com.cn are

origin.patch
linux-next.patch


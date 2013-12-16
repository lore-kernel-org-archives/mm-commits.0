From: akpm@linux-foundation.org
Subject: + ocfs2-fix-sparse-non-static-symbol-warning.patch added to -mm
 tree
Date: Mon, 16 Dec 2013 11:55:52 -0800
Message-ID: <52af5ac8.ueswwbk0iYA3KW5k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45348 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079Ab3LPTzx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Dec 2013 14:55:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, yongjun_wei@trendmicro.com.cn

Subject: + ocfs2-fix-sparse-non-static-symbol-warning.patch added to -mm tree
To: yongjun_wei@trendmicro.com.cn,jlbec@evilplan.org,mfasheh@suse.com
From: akpm@linux-foundation.org
Date: Mon, 16 Dec 2013 11:55:52 -0800


The patch titled
     Subject: ocfs2: fix sparse non static symbol warning
has been added to the -mm tree.  Its filename is
     ocfs2-fix-sparse-non-static-symbol-warning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-sparse-non-static-symbol-warning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-sparse-non-static-symbol-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -983,7 +983,7 @@ static void user_recover_done(void *arg,
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
ocfs2-fix-sparse-non-static-symbol-warning.patch
linux-next.patch


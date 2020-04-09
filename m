From: akpm@linux-foundation.org
Subject: [merged]
 mm-gup-mark-lock-taken-only-after-a-successful-retake.patch removed from
 -mm tree
Date: Wed, 08 Apr 2020 17:08:27 -0700
Message-ID: <20200409000827.xGqcfvMuJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726508AbgDIAI1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 8 Apr 2020 20:08:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, peterx@redhat.com


The patch titled
     Subject: mm/gup: mark lock taken only after a successful retake
has been removed from the -mm tree.  Its filename was
     mm-gup-mark-lock-taken-only-after-a-successful-retake.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/gup: mark lock taken only after a successful retake

It's definitely incorrect to mark the lock as taken even if
down_read_killable() failed.  It's overlooked when we switched from
down_read() to down_read_killable() because down_read() won't fail while
down_read_killable() could.

Link: http://lkml.kernel.org/r/20200407204754.GA66033@xz-x1
Fixes: 71335f37c5e8 ("mm/gup: allow to react to fatal signals")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: syzbot+a8c70b7f3579fc0587dc@syzkaller.appspotmail.com
Tested-by: syzbot+a8c70b7f3579fc0587dc@syzkaller.appspotmail.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/gup.c~mm-gup-mark-lock-taken-only-after-a-successful-retake
+++ a/mm/gup.c
@@ -1329,7 +1329,6 @@ retry:
 		if (fatal_signal_pending(current))
 			break;
 
-		*locked = 1;
 		ret = down_read_killable(&mm->mmap_sem);
 		if (ret) {
 			BUG_ON(ret > 0);
@@ -1338,6 +1337,7 @@ retry:
 			break;
 		}
 
+		*locked = 1;
 		ret = __get_user_pages(tsk, mm, start, 1, flags | FOLL_TRIED,
 				       pages, NULL, locked);
 		if (!*locked) {
_

Patches currently in -mm which might be from peterx@redhat.com are

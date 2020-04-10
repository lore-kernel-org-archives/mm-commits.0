From: akpm@linux-foundation.org
Subject: [folded-merged]
 seq_read-info-message-about-buggy-next-functions-fix.patch removed from -mm
 tree
Date: Fri, 10 Apr 2020 14:14:07 -0700
Message-ID: <20200410211407.F3B4s10p2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726594AbgDJVOJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 10 Apr 2020 17:14:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cai@lca.pw, dave@stgolabs.net, longman@redhat.com, manfred@colorfullife.com, mingo@redhat.com, mm-commits@vger.kernel.org, neilb@suse.com, oberpar@linux.ibm.com, rostedt@goodmis.org, viro@zeniv.linux.org.uk, vvs@virtuozzo.com


The patch titled
     Subject: seq_read-info-message-about-buggy-next-functions-fix
has been removed from the -mm tree.  Its filename was
     seq_read-info-message-about-buggy-next-functions-fix.patch

This patch was dropped because it was folded into seq_read-info-message-about-buggy-next-functions.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: seq_read-info-message-about-buggy-next-functions-fix

s/pr_info/pr_info_ratelimited/, per Qian Cai

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: NeilBrown <neilb@suse.com>
Cc: Peter Oberparleiter <oberpar@linux.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Vasily Averin <vvs@virtuozzo.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Qian Cai <cai@lca.pw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/seq_file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/seq_file.c~seq_read-info-message-about-buggy-next-functions-fix
+++ a/fs/seq_file.c
@@ -233,7 +233,7 @@ Fill:
 
 		p = m->op->next(m, p, &m->index);
 		if (pos == m->index) {
-			pr_info("buggy seq_file .next function %ps "
+			pr_info_ratelimited("buggy seq_file .next function %ps "
 				"did not updated position index\n",
 				m->op->next);
 			m->index++;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

seq_read-info-message-about-buggy-next-functions.patch

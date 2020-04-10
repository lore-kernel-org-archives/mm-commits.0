From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 34/35] kernel/gcov/fs.c: gcov_seq_next() should
 increase position index
Date: Fri, 10 Apr 2020 14:34:10 -0700
Message-ID: <20200410213410.4BUQtCHen%akpm@linux-foundation.org>
References: <20200410143047.bf34a933ce1affdc042c7c80@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726663AbgDJVeK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 10 Apr 2020 17:34:10 -0400
In-Reply-To: <20200410143047.bf34a933ce1affdc042c7c80@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dave@stgolabs.net, linux-mm@kvack.org, longman@redhat.com, manfred@colorfullife.com, mingo@redhat.com, mm-commits@vger.kernel.org, neilb@suse.com, oberpar@linux.ibm.com, rostedt@goodmis.org, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, vvs@virtuozzo.com

From: Vasily Averin <vvs@virtuozzo.com>
Subject: kernel/gcov/fs.c: gcov_seq_next() should increase position index

If seq_file .next function does not change position index, read after some
lseek can generate unexpected output.

https://bugzilla.kernel.org/show_bug.cgi?id=206283
Link: http://lkml.kernel.org/r/f65c6ee7-bd00-f910-2f8a-37cc67e4ff88@virtuozzo.com
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Acked-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: NeilBrown <neilb@suse.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Waiman Long <longman@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/gcov/fs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/gcov/fs.c~gcov_seq_next-should-increase-position-index
+++ a/kernel/gcov/fs.c
@@ -108,9 +108,9 @@ static void *gcov_seq_next(struct seq_fi
 {
 	struct gcov_iterator *iter = data;
 
+	(*pos)++;
 	if (gcov_iter_next(iter))
 		return NULL;
-	(*pos)++;
 
 	return iter;
 }
_

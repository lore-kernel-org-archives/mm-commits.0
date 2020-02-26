From: Andrew Morton <akpm@linux-foundation.org>
Subject: + gcov_seq_next-should-increase-position-index.patch
 added to -mm tree
Date: Tue, 25 Feb 2020 19:56:27 -0800
Message-ID: <20200226035627.oCFQSJck5%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725788AbgBZD42 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 25 Feb 2020 22:56:28 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, longman@redhat.com, manfred@colorfullife.com, mingo@redhat.com, mm-commits@vger.kernel.org, neilb@suse.com, oberpar@linux.ibm.com, rostedt@goodmis.org, viro@zeniv.linux.org.uk, vvs@virtuozzo.com


The patch titled
     Subject:  kernel/gcov/fs.c: gcov_seq_next() should increase position index
has been added to the -mm tree.  Its filename is
     gcov_seq_next-should-increase-position-index.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/gcov_seq_next-should-increase-position-index.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/gcov_seq_next-should-increase-position-index.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vasily Averin <vvs@virtuozzo.com>
Subject:  kernel/gcov/fs.c: gcov_seq_next() should increase position index

If seq_file .next fuction does not change position index, read after some
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

Patches currently in -mm which might be from vvs@virtuozzo.com are

seq_read-info-message-about-buggy-next-functions.patch
pstore_ftrace_seq_next-should-increase-position-index.patch
gcov_seq_next-should-increase-position-index.patch
sysvipc_find_ipc-should-increase-position-index.patch

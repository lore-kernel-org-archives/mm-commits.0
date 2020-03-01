From: akpm@linux-foundation.org
Subject: [merged]
 pstore_ftrace_seq_next-should-increase-position-index.patch removed from
 -mm tree
Date: Sat, 29 Feb 2020 17:52:04 -0800
Message-ID: <20200301015204.LE0jiExFF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726786AbgCABwF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 29 Feb 2020 20:52:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, longman@redhat.com, manfred@colorfullife.com, mingo@redhat.com, mm-commits@vger.kernel.org, neilb@suse.com, oberpar@linux.ibm.com, rostedt@goodmis.org, viro@zeniv.linux.org.uk, vvs@virtuozzo.com


The patch titled
     Subject: fs/pstore: pstore_ftrace_seq_next() should increase position index
has been removed from the -mm tree.  Its filename was
     pstore_ftrace_seq_next-should-increase-position-index.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vasily Averin <vvs@virtuozzo.com>
Subject: fs/pstore: pstore_ftrace_seq_next() should increase position index

If seq_file .next fucntion does not change position index, read after some
lseek can generate unexpected output.

https://bugzilla.kernel.org/show_bug.cgi?id=206283
Link: http://lkml.kernel.org/r/51376af5-e0f2-0ff2-d664-e932153b0665@virtuozzo.com
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Oberparleiter <oberpar@linux.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: NeilBrown <neilb@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pstore/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/pstore/inode.c~pstore_ftrace_seq_next-should-increase-position-index
+++ a/fs/pstore/inode.c
@@ -87,11 +87,11 @@ static void *pstore_ftrace_seq_next(stru
 	struct pstore_private *ps = s->private;
 	struct pstore_ftrace_seq_data *data = v;
 
+	(*pos)++;
 	data->off += REC_SIZE;
 	if (data->off + REC_SIZE > ps->total_size)
 		return NULL;
 
-	(*pos)++;
 	return data;
 }
 
_

Patches currently in -mm which might be from vvs@virtuozzo.com are

seq_read-info-message-about-buggy-next-functions.patch
gcov_seq_next-should-increase-position-index.patch
sysvipc_find_ipc-should-increase-position-index.patch

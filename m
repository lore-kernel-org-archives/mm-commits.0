From: akpm@linux-foundation.org
Subject: [merged]
 seq_read-info-message-about-buggy-next-functions.patch removed from -mm
 tree
Date: Sat, 11 Apr 2020 23:45:57 -0700
Message-ID: <20200412064557.P3fASZfnF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725873AbgDLGp7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 12 Apr 2020 02:45:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, longman@redhat.com, manfred@colorfullife.com, mingo@redhat.com, mm-commits@vger.kernel.org, neilb@suse.com, oberpar@linux.ibm.com, rostedt@goodmis.org, viro@zeniv.linux.org.uk, vvs@virtuozzo.com


The patch titled
     Subject: fs/seq_file.c: seq_read(): add info message about buggy .next functions
has been removed from the -mm tree.  Its filename was
     seq_read-info-message-about-buggy-next-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vasily Averin <vvs@virtuozzo.com>
Subject: fs/seq_file.c: seq_read(): add info message about buggy .next functions

Patch series "seq_file .next functions should increase position index".

In Aug 2018 NeilBrown noticed commit 1f4aace60b0e ("fs/seq_file.c:
simplify seq_file iteration code and interface")

"Some ->next functions do not increment *pos when they return NULL... 
Note that such ->next functions are buggy and should be fixed.  A simple
demonstration is dd if=/proc/swaps bs=1000 skip=1 Choose any block size
larger than the size of /proc/swaps.  This will always show the whole last
line of /proc/swaps"

Described problem is still actual.  If you make lseek into middle of last
output line following read will output end of last line and whole last
line once again.

$ dd if=/proc/swaps bs=1  # usual output
Filename				Type		Size	Used	Priority
/dev/dm-0                               partition	4194812	97536	-2
104+0 records in
104+0 records out
104 bytes copied

$ dd if=/proc/swaps bs=40 skip=1    # last line was generated twice
dd: /proc/swaps: cannot skip to specified offset
v/dm-0                               partition	4194812	97536	-2
/dev/dm-0                               partition	4194812	97536	-2 
3+1 records in
3+1 records out
131 bytes copied

There are lot of other affected files, I've found 30+ including
/proc/net/ip_tables_matches and /proc/sysvipc/*

I've sent patches into maillists of affected subsystems already, this
patch-set fixes the problem in files related to pstore, tracing, gcov,
sysvipc and other subsystems processed via linux-kernel@ mailing list
directly

https://bugzilla.kernel.org/show_bug.cgi?id=206283


This patch (of 4):

Add debug code to seq_read() to detect missed or out-of-tree incorrect
.next seq_file functions.

[akpm@linux-foundation.org: s/pr_info/pr_info_ratelimited/, per Qian Cai]
https://bugzilla.kernel.org/show_bug.cgi?id=206283
Link: http://lkml.kernel.org/r/244674e5-760c-86bd-d08a-047042881748@virtuozzo.com
Link: http://lkml.kernel.org/r/7c24087c-e280-e580-5b0c-0cdaeb14cd18@virtuozzo.com
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Cc: NeilBrown <neilb@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Peter Oberparleiter <oberpar@linux.ibm.com>
Cc: Waiman Long <longman@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/seq_file.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/seq_file.c~seq_read-info-message-about-buggy-next-functions
+++ a/fs/seq_file.c
@@ -232,9 +232,12 @@ Fill:
 		loff_t pos = m->index;
 
 		p = m->op->next(m, p, &m->index);
-		if (pos == m->index)
-			/* Buggy ->next function */
+		if (pos == m->index) {
+			pr_info_ratelimited("buggy seq_file .next function %ps "
+				"did not updated position index\n",
+				m->op->next);
 			m->index++;
+		}
 		if (!p || IS_ERR(p)) {
 			err = PTR_ERR(p);
 			break;
_

Patches currently in -mm which might be from vvs@virtuozzo.com are

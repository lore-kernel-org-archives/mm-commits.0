From: akpm@linux-foundation.org
Subject: [patch 76/84] coredump: make coredump_wait wait for mmap_sem for
 write killable
Date: Mon, 23 May 2016 16:25:57 -0700
Message-ID: <57439185.aZvRLqJW7V17vP8x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42422 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342AbcEWXZ6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 19:25:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, oleg@redhat.com, vbabka@suse.cz

From: Michal Hocko <mhocko@suse.com>
Subject: coredump: make coredump_wait wait for mmap_sem for write killable

coredump_wait waits for mmap_sem for write currently which can prevent
oom_reaper to reclaim the oom victims address space asynchronously because
that requires mmap_sem for read.  This might happen if the oom victim is
multi threaded and some thread(s) is holding mmap_sem for read (e.g.  page
fault) and it is stuck in the page allocator while other thread(s) reached
coredump_wait already.

This patch simply uses down_write_killable and bails out with EINTR if the
lock got interrupted by the fatal signal.  do_coredump will return right
away and do_group_exit will take care to zap the whole thread group.

Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coredump.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/coredump.c~coredump-make-coredump_wait-wait-for-mmap_sem-for-write-killable fs/coredump.c
--- a/fs/coredump.c~coredump-make-coredump_wait-wait-for-mmap_sem-for-write-killable
+++ a/fs/coredump.c
@@ -413,7 +413,9 @@ static int coredump_wait(int exit_code,
 	core_state->dumper.task = tsk;
 	core_state->dumper.next = NULL;
 
-	down_write(&mm->mmap_sem);
+	if (down_write_killable(&mm->mmap_sem))
+		return -EINTR;
+
 	if (!mm->core_state)
 		core_waiters = zap_threads(tsk, mm, core_state, exit_code);
 	up_write(&mm->mmap_sem);
_

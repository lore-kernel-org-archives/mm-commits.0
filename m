From: akpm@linux-foundation.org
Subject: [patch 79/84] prctl: make PR_SET_THP_DISABLE wait for mmap_sem
 killable
Date: Mon, 23 May 2016 16:26:05 -0700
Message-ID: <5743918d.nLGaloOjMzDQuuEw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42441 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454AbcEWX0G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 19:26:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, athorlton@sgi.com, vbabka@suse.cz

From: Michal Hocko <mhocko@suse.com>
Subject: prctl: make PR_SET_THP_DISABLE wait for mmap_sem killable

PR_SET_THP_DISABLE requires mmap_sem for write.  If the waiting task gets
killed by the oom killer it would block oom_reaper from asynchronous
address space reclaim and reduce the chances of timely OOM resolving. 
Wait for the lock in the killable mode and return with EINTR if the task
got killed while waiting.

Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Alex Thorlton <athorlton@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/sys.c~prctl-make-pr_set_thp_disable-wait-for-mmap_sem-killable kernel/sys.c
--- a/kernel/sys.c~prctl-make-pr_set_thp_disable-wait-for-mmap_sem-killable
+++ a/kernel/sys.c
@@ -2246,7 +2246,8 @@ SYSCALL_DEFINE5(prctl, int, option, unsi
 	case PR_SET_THP_DISABLE:
 		if (arg3 || arg4 || arg5)
 			return -EINVAL;
-		down_write(&me->mm->mmap_sem);
+		if (down_write_killable(&me->mm->mmap_sem))
+			return -EINTR;
 		if (arg2)
 			me->mm->def_flags |= VM_NOHUGEPAGE;
 		else
_

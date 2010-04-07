From: akpm@linux-foundation.org
Subject: + sched-fix-sched_getaffinity.patch added to -mm tree
Date: Wed, 07 Apr 2010 14:21:28 -0700
Message-ID: <201004072121.o37LLSto007994@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41735 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750810Ab0DGVWN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Apr 2010 17:22:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anton@samba.org, kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu


The patch titled
     sched: fix sched_getaffinity()
has been added to the -mm tree.  Its filename is
     sched-fix-sched_getaffinity.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sched: fix sched_getaffinity()
From: Anton Blanchard <anton@samba.org>

taskset on 2.6.34-rc3 fails on one of my ppc64 test boxes with the
following error:

sched_getaffinity(0, 16, 0x10029650030) = -1 EINVAL (Invalid argument)

This box has 128 threads and 16 bytes is enough to cover it.  Commit
cd3d8031eb4311e516329aee03c79a08333141f1 ("sched: sched_getaffinity():
Allow less than NR_CPUS length") is comparing this 16 bytes agains
nr_cpu_ids.

Fix it by comparing nr_cpu_ids to the number of bits in the cpumask we
pass in.

Signed-off-by: Anton Blanchard <anton@samba.org>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sched.c~sched-fix-sched_getaffinity kernel/sched.c
--- a/kernel/sched.c~sched-fix-sched_getaffinity
+++ a/kernel/sched.c
@@ -4909,7 +4909,7 @@ SYSCALL_DEFINE3(sched_getaffinity, pid_t
 	int ret;
 	cpumask_var_t mask;
 
-	if (len < nr_cpu_ids)
+	if ((len * BITS_PER_BYTE) < nr_cpu_ids)
 		return -EINVAL;
 	if (len & (sizeof(unsigned long)-1))
 		return -EINVAL;
_

Patches currently in -mm which might be from anton@samba.org are

origin.patch
linux-next.patch
sched-fix-sched_getaffinity.patch


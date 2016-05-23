From: akpm@linux-foundation.org
Subject: + memcg-fix-mem_cgroup_out_of_memory-return-value.patch added to
 -mm tree
Date: Mon, 23 May 2016 14:59:49 -0700
Message-ID: <57437d55.eU7guByeaKEkAfKY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41341 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbcEWV7u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 17:59:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penguin-kernel@I-love.SAKURA.ne.jp, hannes@cmpxchg.org, mhocko@suse.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: fix mem_cgroup_out_of_memory() return value.
has been added to the -mm tree.  Its filename is
     memcg-fix-mem_cgroup_out_of_memory-return-value.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-fix-mem_cgroup_out_of_memory-return-value.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-fix-mem_cgroup_out_of_memory-return-value.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: memcg: fix mem_cgroup_out_of_memory() return value.

mem_cgroup_out_of_memory() is returning "true" if it finds a TIF_MEMDIE
task after an eligible task was found, "false" if it found a TIF_MEMDIE
task before an eligible task is found.

This difference confuses memory_max_write() which checks the return value
of mem_cgroup_out_of_memory().  Since memory_max_write() wants to continue
looping, mem_cgroup_out_of_memory() should return "true" in this case.

This patch sets a dummy pointer in order to return "true".

Link: http://lkml.kernel.org/r/1463753327-5170-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/memcontrol.c~memcg-fix-mem_cgroup_out_of_memory-return-value mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-mem_cgroup_out_of_memory-return-value
+++ a/mm/memcontrol.c
@@ -1302,6 +1302,8 @@ static bool mem_cgroup_out_of_memory(str
 				mem_cgroup_iter_break(memcg, iter);
 				if (chosen)
 					put_task_struct(chosen);
+				/* Set a dummy value to return "true". */
+				chosen = (void *) 1;
 				goto unlock;
 			case OOM_SCAN_OK:
 				break;
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are

memcg-fix-mem_cgroup_out_of_memory-return-value.patch
signal-make-oom_flags-a-bool.patch


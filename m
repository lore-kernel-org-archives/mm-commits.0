From: akpm@linux-foundation.org
Subject: [patch 06/10] memcg: fix mem_cgroup_out_of_memory() return value.
Date: Thu, 26 May 2016 15:16:19 -0700
Message-ID: <574775b3.bSYmF+8pPMoh+HRL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49400 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187AbcEZWQU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 May 2016 18:16:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, penguin-kernel@I-love.SAKURA.ne.jp, hannes@cmpxchg.org, mhocko@suse.com, vdavydov@virtuozzo.com

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

From: akpm@linux-foundation.org
Subject: [patch 031/126] mm: zap ZONE_OOM_LOCKED
Date: Tue, 26 Jul 2016 15:22:30 -0700
Message-ID: <5797e2a6.rpfmrldwdKe2yCZG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56618 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757579AbcGZWWb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 18:22:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@suse.com, penguin-kernel@I-love.SAKURA.ne.jp

From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: mm: zap ZONE_OOM_LOCKED

Not used since oom_lock was instroduced.

Link: http://lkml.kernel.org/r/1464358093-22663-1-git-send-email-vdavydov@virtuozzo.com
Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    1 -
 mm/oom_kill.c          |    4 ++--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff -puN include/linux/mmzone.h~mm-zap-zone_oom_locked include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-zap-zone_oom_locked
+++ a/include/linux/mmzone.h
@@ -524,7 +524,6 @@ struct zone {
 
 enum zone_flags {
 	ZONE_RECLAIM_LOCKED,		/* prevents concurrent reclaim */
-	ZONE_OOM_LOCKED,		/* zone is in OOM killer zonelist */
 	ZONE_CONGESTED,			/* zone has many dirty pages backed by
 					 * a congested BDI
 					 */
diff -puN mm/oom_kill.c~mm-zap-zone_oom_locked mm/oom_kill.c
--- a/mm/oom_kill.c~mm-zap-zone_oom_locked
+++ a/mm/oom_kill.c
@@ -988,8 +988,8 @@ bool out_of_memory(struct oom_control *o
 
 /*
  * The pagefault handler calls here because it is out of memory, so kill a
- * memory-hogging task.  If any populated zone has ZONE_OOM_LOCKED set, a
- * parallel oom killing is already in progress so do nothing.
+ * memory-hogging task. If oom_lock is held by somebody else, a parallel oom
+ * killing is already in progress so do nothing.
  */
 void pagefault_out_of_memory(void)
 {
_

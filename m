From: akpm@linux-foundation.org
Subject: + mm-zap-zone_oom_locked.patch added to -mm tree
Date: Fri, 27 May 2016 13:40:33 -0700
Message-ID: <5748b0c1.4Mdh9tVX9atwF7rp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44673 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756507AbcE0Uke (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 16:40:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@suse.com, penguin-kernel@I-love.SAKURA.ne.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: zap ZONE_OOM_LOCKED
has been added to the -mm tree.  Its filename is
     mm-zap-zone_oom_locked.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zap-zone_oom_locked.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zap-zone_oom_locked.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -998,8 +998,8 @@ bool out_of_memory(struct oom_control *o
 
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

Patches currently in -mm which might be from vdavydov@virtuozzo.com are

mm-oom-do-not-reap-task-if-there-are-live-threads-in-threadgroup.patch
mm-zap-zone_oom_locked.patch


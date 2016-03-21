From: akpm@linux-foundation.org
Subject: [merged] mmoom-make-oom_killer_disable-killable.patch removed
 from -mm tree
Date: Mon, 21 Mar 2016 11:40:43 -0700
Message-ID: <56f0402b.iHaa9PLn/pshdRvS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53456 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932297AbcCUT4e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:56:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penguin-kernel@I-love.SAKURA.ne.jp, mhocko@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm,oom: make oom_killer_disable() killable
has been removed from the -mm tree.  Its filename was
     mmoom-make-oom_killer_disable-killable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: mm,oom: make oom_killer_disable() killable

While oom_killer_disable() is called by freeze_processes() after all user
threads except the current thread are frozen, it is possible that kernel
threads invoke the OOM killer and sends SIGKILL to the current thread due
to sharing the thawed victim's memory.  Therefore, checking for SIGKILL is
preferable than TIF_MEMDIE.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff -puN mm/oom_kill.c~mmoom-make-oom_killer_disable-killable mm/oom_kill.c
--- a/mm/oom_kill.c~mmoom-make-oom_killer_disable-killable
+++ a/mm/oom_kill.c
@@ -455,15 +455,11 @@ void exit_oom_victim(void)
 bool oom_killer_disable(void)
 {
 	/*
-	 * Make sure to not race with an ongoing OOM killer
-	 * and that the current is not the victim.
+	 * Make sure to not race with an ongoing OOM killer. Check that the
+	 * current is not killed (possibly due to sharing the victim's memory).
 	 */
-	mutex_lock(&oom_lock);
-	if (test_thread_flag(TIF_MEMDIE)) {
-		mutex_unlock(&oom_lock);
+	if (mutex_lock_killable(&oom_lock))
 		return false;
-	}

From: akpm@linux-foundation.org
Subject: + mmoom-make-oom_killer_disable-killable.patch added to -mm tree
Date: Mon, 25 Jan 2016 16:22:14 -0800
Message-ID: <56a6bc36.UujD0y6jn7ytsuFZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45690 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702AbcAZAWP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jan 2016 19:22:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm,oom: make oom_killer_disable() killable.
has been added to the -mm tree.  Its filename is
     mmoom-make-oom_killer_disable-killable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmoom-make-oom_killer_disable-killable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmoom-make-oom_killer_disable-killable.patch

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
Subject: mm,oom: make oom_killer_disable() killable.

While oom_killer_disable() is called by freeze_processes() after all user
threads except the current thread are frozen, it is possible that kernel
threads invoke the OOM killer and sends SIGKILL to the current thread due
to sharing the thawed victim's memory.  Therefore, checking for SIGKILL is
preferable than TIF_MEMDIE.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff -puN mm/oom_kill.c~mmoom-make-oom_killer_disable-killable mm/oom_kill.c
--- a/mm/oom_kill.c~mmoom-make-oom_killer_disable-killable
+++ a/mm/oom_kill.c
@@ -458,15 +458,11 @@ void exit_oom_victim(void)
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

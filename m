From: akpm@linux-foundation.org
Subject: [merged]
 kthread-fix-return-value-of-kthread_create-upon-sigkill.patch removed from
 -mm tree
Date: Thu, 05 Jun 2014 12:42:01 -0700
Message-ID: <5390c809.CmPdCP5scSO97q22%akpm__27497.9062997319$1401997341$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55505 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983AbaFETmC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:42:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, rientjes@google.com, penguin-kernel@I-love.SAKURA.ne.jp, oleg@redhat.com, penguin-kernel@i-love.sakura.ne.jp

Subject: [merged] kthread-fix-return-value-of-kthread_create-upon-sigkill.patch removed from -mm tree
To: penguin-kernel@i-love.sakura.ne.jp,oleg@redhat.com,penguin-kernel@I-love.SAKURA.ne.jp,rientjes@google.com,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:42:01 -0700


The patch titled
     Subject: kthread: fix return value of kthread_create() upon SIGKILL.
has been removed from the -mm tree.  Its filename was
     kthread-fix-return-value-of-kthread_create-upon-sigkill.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: kthread: fix return value of kthread_create() upon SIGKILL.

786235eeb ("kthread: make kthread_create() killable") meant for allowing
kthread_create() to abort as soon as killed by the OOM-killer.  But
returning -ENOMEM is wrong if killed by SIGKILL from userspace.  Change
kthread_create() to return -EINTR upon SIGKILL.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Oleg Nesterov <oleg@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: <stable@vger.kernel.org> [3.13+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/kthread.c~kthread-fix-return-value-of-kthread_create-upon-sigkill kernel/kthread.c
--- a/kernel/kthread.c~kthread-fix-return-value-of-kthread_create-upon-sigkill
+++ a/kernel/kthread.c
@@ -262,7 +262,7 @@ static void create_kthread(struct kthrea
  * kthread_stop() has been called).  The return value should be zero
  * or a negative error number; it will be passed to kthread_stop().
  *
- * Returns a task_struct or ERR_PTR(-ENOMEM).
+ * Returns a task_struct or ERR_PTR(-ENOMEM) or ERR_PTR(-EINTR).
  */
 struct task_struct *kthread_create_on_node(int (*threadfn)(void *data),
 					   void *data, int node,
@@ -298,7 +298,7 @@ struct task_struct *kthread_create_on_no
 		 * that thread.
 		 */
 		if (xchg(&create->done, NULL))
-			return ERR_PTR(-ENOMEM);
+			return ERR_PTR(-EINTR);
 		/*
 		 * kthreadd (or new kernel thread) will call complete()
 		 * shortly.
_

Patches currently in -mm which might be from penguin-kernel@i-love.sakura.ne.jp are

origin.patch
lib-vsprintf-add-%pt-format-specifier.patch
linux-next.patch


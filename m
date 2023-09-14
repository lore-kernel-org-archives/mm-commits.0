Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFB00EEAA5D
	for <mm-commits@archiver.kernel.org>; Thu, 14 Sep 2023 17:54:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240272AbjINRyk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 14 Sep 2023 13:54:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240156AbjINRyk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Sep 2023 13:54:40 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E98961FFC;
        Thu, 14 Sep 2023 10:54:35 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CD9EC433C7;
        Thu, 14 Sep 2023 17:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694714075;
        bh=qFhpympcQHHwMSoiqk14nfbiylaVNarOrRLkXMGr2dM=;
        h=Date:To:From:Subject:From;
        b=LzkNy0KLy8LS3TEFRVy8ZYIk1c+46bWpqu5g1JnT/H7TZx6/9SN5p1SEinsE8A62G
         AwoKhmse7fGc0aMuPPgJQWi0pM5MgObCpLoMDtGVeY8/0PjsGQauLZJJKnfO8lPWFf
         F/PQ4SCDf64Z2VLvagcdzGIKNcsEWyWy3rpWhkvo=
Date:   Thu, 14 Sep 2023 10:54:34 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        oleg@redhat.com, giulio.benetti@benettiengineering.com,
        gerg@uclinux.org, ben.wolsieffer@hefring.com,
        Ben.Wolsieffer@hefring.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-nommu-proc-pid-maps-release-mmap-read-lock.patch added to mm-hotfixes-unstable branch
Message-Id: <20230914175435.6CD9EC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc: nommu: /proc/<pid>/maps: release mmap read lock
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     proc-nommu-proc-pid-maps-release-mmap-read-lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-nommu-proc-pid-maps-release-mmap-read-lock.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Ben Wolsieffer <Ben.Wolsieffer@hefring.com>
Subject: proc: nommu: /proc/<pid>/maps: release mmap read lock
Date: Thu, 14 Sep 2023 12:30:20 -0400

On NOMMU, when running "cat /proc/1/maps" twice the second run hangs.

The no-MMU implementation of /proc/<pid>/map doesn't normally release the
mmap read lock, because it uses !IS_ERR_OR_NULL(_vml) to determine whether
to release the lock.  Since _vml is NULL when the end of the mappings is
reached, the lock is not released.

This code was incorrectly adapted from the MMU implementation, which at
the time released the lock in m_next() before returning the last entry.

The MMU implementation has diverged further from the no-MMU version since
then, so this patch brings their locking and error handling into sync,
fixing the bug and hopefully avoiding similar issues in the future.

Link: https://lkml.kernel.org/r/20230914163019.4050530-2-ben.wolsieffer@hefring.com
Fixes: 47fecca15c09 ("fs/proc/task_nommu.c: don't use priv->task->mm")
Signed-off-by: Ben Wolsieffer <ben.wolsieffer@hefring.com>
Cc: Giulio Benetti <giulio.benetti@benettiengineering.com>
Cc: Greg Ungerer <gerg@uclinux.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_nommu.c |   27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

--- a/fs/proc/task_nommu.c~proc-nommu-proc-pid-maps-release-mmap-read-lock
+++ a/fs/proc/task_nommu.c
@@ -192,11 +192,16 @@ static void *m_start(struct seq_file *m,
 		return ERR_PTR(-ESRCH);
 
 	mm = priv->mm;
-	if (!mm || !mmget_not_zero(mm))
+	if (!mm || !mmget_not_zero(mm)) {
+		put_task_struct(priv->task);
+		priv->task = NULL;
 		return NULL;
+	}
 
 	if (mmap_read_lock_killable(mm)) {
 		mmput(mm);
+		put_task_struct(priv->task);
+		priv->task = NULL;
 		return ERR_PTR(-EINTR);
 	}
 
@@ -205,23 +210,21 @@ static void *m_start(struct seq_file *m,
 	if (vma)
 		return vma;
 
-	mmap_read_unlock(mm);
-	mmput(mm);
 	return NULL;
 }
 
-static void m_stop(struct seq_file *m, void *_vml)
+static void m_stop(struct seq_file *m, void *v)
 {
 	struct proc_maps_private *priv = m->private;
+	struct mm_struct *mm = priv->mm;
 
-	if (!IS_ERR_OR_NULL(_vml)) {
-		mmap_read_unlock(priv->mm);
-		mmput(priv->mm);
-	}
-	if (priv->task) {
-		put_task_struct(priv->task);
-		priv->task = NULL;
-	}
+	if (!priv->task)
+		return;
+
+	mmap_read_unlock(mm);
+	mmput(mm);
+	put_task_struct(priv->task);
+	priv->task = NULL;
 }
 
 static void *m_next(struct seq_file *m, void *_p, loff_t *pos)
_

Patches currently in -mm which might be from Ben.Wolsieffer@hefring.com are

proc-nommu-proc-pid-maps-release-mmap-read-lock.patch


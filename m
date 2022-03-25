Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9BCCC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:36:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357406AbiCYBhb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357530AbiCYBf5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:35:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECCEB3C4B6
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:34:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD75760B08
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:34:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EACEC340ED;
        Fri, 25 Mar 2022 01:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648172058;
        bh=KZ+jH9oqivMxE0aNxDdkpAarlNnTwOtJQD+eSZEXoBs=;
        h=Date:To:From:Subject:From;
        b=JoByH/aGo8JlFqhS1WW+ElArwuEuCH2R4VAAElewGExt0vp3SapwpJGUMkAE7s39r
         RKWSSbtXZboG4gOWSw/2ugqJLW2UjvJNebXsFOcnKrOdtcEoCjkAvNvxUq9AJSKWZO
         yw1Z/sCzfbvHbkWnK3CT3LW/mASefgye73u0ydt0=
Date:   Thu, 24 Mar 2022 18:34:17 -0700
To:     mm-commits@vger.kernel.org, tarasmadan@google.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        bigeasy@linutronix.de, andreyknvl@gmail.com, nogikh@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] kcov-split-ioctl-handling-into-locked-and-unlocked-parts.patch removed from -mm tree
Message-Id: <20220325013418.2EACEC340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kcov: split ioctl handling into locked and unlocked parts
has been removed from the -mm tree.  Its filename was
     kcov-split-ioctl-handling-into-locked-and-unlocked-parts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Aleksandr Nogikh <nogikh@google.com>
Subject: kcov: split ioctl handling into locked and unlocked parts

Patch series "kcov: improve mmap processing", v3.

Subsequent mmaps of the same kcov descriptor currently do not update the
virtual memory of the task and yet return 0 (success).  This is
counter-intuitive and may lead to unexpected memory access errors.

Also, this unnecessarily limits the functionality of kcov to only the
simplest usage scenarios.  Kcov instances are effectively forever attached
to their first address spaces and it becomes impossible to e.g.  reuse the
same kcov handle in forked child processes without mmapping the memory
first.  This is exactly what we tried to do in syzkaller and inadvertently
came upon this behavior.

This patch series addresses the problem described above.


This patch (of 3):

Currently all ioctls are de facto processed under a spinlock in order to
serialise them.  This, however, prohibits the use of vmalloc and other
memory management functions in the implementations of those ioctls,
unnecessary complicating any further changes to the code.

Let all ioctls first be processed inside the kcov_ioctl() function which
should execute the ones that are not compatible with spinlock and then
pass control to kcov_ioctl_locked() for all other ones. 
KCOV_REMOTE_ENABLE is processed both in kcov_ioctl() and
kcov_ioctl_locked() as the steps are easily separable.

Although it is still compatible with a spinlock, move KCOV_INIT_TRACE
handling to kcov_ioctl(), so that the changes from the next commit are
easier to follow.

Link: https://lkml.kernel.org/r/20220117153634.150357-1-nogikh@google.com
Link: https://lkml.kernel.org/r/20220117153634.150357-2-nogikh@google.com
Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Taras Madan <tarasmadan@google.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kcov.c |   68 ++++++++++++++++++++++++++----------------------
 1 file changed, 37 insertions(+), 31 deletions(-)

--- a/kernel/kcov.c~kcov-split-ioctl-handling-into-locked-and-unlocked-parts
+++ a/kernel/kcov.c
@@ -564,31 +564,12 @@ static int kcov_ioctl_locked(struct kcov
 			     unsigned long arg)
 {
 	struct task_struct *t;
-	unsigned long size, unused;
+	unsigned long flags, unused;
 	int mode, i;
 	struct kcov_remote_arg *remote_arg;
 	struct kcov_remote *remote;
-	unsigned long flags;
 
 	switch (cmd) {
-	case KCOV_INIT_TRACE:
-		/*
-		 * Enable kcov in trace mode and setup buffer size.
-		 * Must happen before anything else.
-		 */
-		if (kcov->mode != KCOV_MODE_DISABLED)
-			return -EBUSY;
-		/*
-		 * Size must be at least 2 to hold current position and one PC.
-		 * Later we allocate size * sizeof(unsigned long) memory,
-		 * that must not overflow.
-		 */
-		size = arg;
-		if (size < 2 || size > INT_MAX / sizeof(unsigned long))
-			return -EINVAL;
-		kcov->size = size;
-		kcov->mode = KCOV_MODE_INIT;
-		return 0;
 	case KCOV_ENABLE:
 		/*
 		 * Enable coverage for the current task.
@@ -692,9 +673,32 @@ static long kcov_ioctl(struct file *file
 	struct kcov_remote_arg *remote_arg = NULL;
 	unsigned int remote_num_handles;
 	unsigned long remote_arg_size;
-	unsigned long flags;
+	unsigned long size, flags;
 
-	if (cmd == KCOV_REMOTE_ENABLE) {
+	kcov = filep->private_data;
+	switch (cmd) {
+	case KCOV_INIT_TRACE:
+		/*
+		 * Enable kcov in trace mode and setup buffer size.
+		 * Must happen before anything else.
+		 *
+		 * First check the size argument - it must be at least 2
+		 * to hold the current position and one PC. Later we allocate
+		 * size * sizeof(unsigned long) memory, that must not overflow.
+		 */
+		size = arg;
+		if (size < 2 || size > INT_MAX / sizeof(unsigned long))
+			return -EINVAL;
+		spin_lock_irqsave(&kcov->lock, flags);
+		if (kcov->mode != KCOV_MODE_DISABLED) {
+			spin_unlock_irqrestore(&kcov->lock, flags);
+			return -EBUSY;
+		}
+		kcov->size = size;
+		kcov->mode = KCOV_MODE_INIT;
+		spin_unlock_irqrestore(&kcov->lock, flags);
+		return 0;
+	case KCOV_REMOTE_ENABLE:
 		if (get_user(remote_num_handles, (unsigned __user *)(arg +
 				offsetof(struct kcov_remote_arg, num_handles))))
 			return -EFAULT;
@@ -710,16 +714,18 @@ static long kcov_ioctl(struct file *file
 			return -EINVAL;
 		}
 		arg = (unsigned long)remote_arg;
+		fallthrough;
+	default:
+		/*
+		 * All other commands can be normally executed under a spin lock, so we
+		 * obtain and release it here in order to simplify kcov_ioctl_locked().
+		 */
+		spin_lock_irqsave(&kcov->lock, flags);
+		res = kcov_ioctl_locked(kcov, cmd, arg);
+		spin_unlock_irqrestore(&kcov->lock, flags);
+		kfree(remote_arg);
+		return res;
 	}
-
-	kcov = filep->private_data;
-	spin_lock_irqsave(&kcov->lock, flags);
-	res = kcov_ioctl_locked(kcov, cmd, arg);
-	spin_unlock_irqrestore(&kcov->lock, flags);
-
-	kfree(remote_arg);
-
-	return res;
 }
 
 static const struct file_operations kcov_fops = {
_

Patches currently in -mm which might be from nogikh@google.com are



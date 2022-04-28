Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B583C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 28 Apr 2022 23:50:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234921AbiD1Xxa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Apr 2022 19:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353424AbiD1Xxa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Apr 2022 19:53:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50CA3DF14
        for <mm-commits@vger.kernel.org>; Thu, 28 Apr 2022 16:50:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2718FB831C2
        for <mm-commits@vger.kernel.org>; Thu, 28 Apr 2022 23:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2B45C385AD;
        Thu, 28 Apr 2022 23:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651189809;
        bh=GL8R0SLAnfAXkVP4nG/4CmH+3+w6tcGt30eprZErtho=;
        h=Date:To:From:Subject:From;
        b=c7QW/jGqmhEtB4T5g8lGsrc5v5gl7RFduIQHHvyoyOjiZXEhKTfMIHzJeyWyNW54i
         DuUeGYJVEs5Xhf70QS4AUj1GB577FLymyUBd4ztwWkE1qTmTlG9DsPe4TXXRS+yioW
         S/mPde3GA2eruJCkimc+ilNCUlRgY5C1MObZu0Oc=
Date:   Thu, 28 Apr 2022 16:50:09 -0700
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        manfred@colorfullife.com, dave@stgolabs.net,
        prakash.sangappa@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ipc-update-semtimedop-to-use-hrtimer.patch added to -mm tree
Message-Id: <20220428235009.D2B45C385AD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ipc: update semtimedop() to use hrtimer
has been added to the -mm tree.  Its filename is
     ipc-update-semtimedop-to-use-hrtimer.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ipc-update-semtimedop-to-use-hrtimer.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ipc-update-semtimedop-to-use-hrtimer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Prakash Sangappa <prakash.sangappa@oracle.com>
Subject: ipc: update semtimedop() to use hrtimer

semtimedop() should be converted to use hrtimer like it has been done for
most of the system calls with timeouts.  This system call already takes a
struct timespec as an argument and can therefore provide finer granularity
timed wait.

Link: https://lkml.kernel.org/r/1651187881-2858-1-git-send-email-prakash.sangappa@oracle.com
Signed-off-by: Prakash Sangappa <prakash.sangappa@oracle.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

--- a/ipc/sem.c~ipc-update-semtimedop-to-use-hrtimer
+++ a/ipc/sem.c
@@ -1993,7 +1993,9 @@ long __do_semtimedop(int semid, struct s
 	int max, locknum;
 	bool undos = false, alter = false, dupsop = false;
 	struct sem_queue queue;
-	unsigned long dup = 0, jiffies_left = 0;
+	unsigned long dup = 0;
+	ktime_t expires, *exp = NULL;
+	bool timed_out = false;
 
 	if (nsops < 1 || semid < 0)
 		return -EINVAL;
@@ -2001,12 +2003,11 @@ long __do_semtimedop(int semid, struct s
 		return -E2BIG;
 
 	if (timeout) {
-		if (timeout->tv_sec < 0 || timeout->tv_nsec < 0 ||
-			timeout->tv_nsec >= 1000000000L) {
-			error = -EINVAL;
-			goto out;
-		}
-		jiffies_left = timespec64_to_jiffies(timeout);
+		if (!timespec64_valid(timeout))
+			return -EINVAL;
+		expires = ktime_add_safe(ktime_get(),
+				timespec64_to_ktime(*timeout));
+		exp = &expires;
 	}
 
 
@@ -2164,10 +2165,8 @@ long __do_semtimedop(int semid, struct s
 		sem_unlock(sma, locknum);
 		rcu_read_unlock();
 
-		if (timeout)
-			jiffies_left = schedule_timeout(jiffies_left);
-		else
-			schedule();
+		timed_out = !schedule_hrtimeout_range(exp,
+				current->timer_slack_ns, HRTIMER_MODE_ABS);
 
 		/*
 		 * fastpath: the semop has completed, either successfully or
@@ -2208,7 +2207,7 @@ long __do_semtimedop(int semid, struct s
 		/*
 		 * If an interrupt occurred we have to clean up the queue.
 		 */
-		if (timeout && jiffies_left == 0)
+		if (timed_out)
 			error = -EAGAIN;
 	} while (error == -EINTR && !signal_pending(current)); /* spurious */
 
_

Patches currently in -mm which might be from prakash.sangappa@oracle.com are

ipc-update-semtimedop-to-use-hrtimer.patch


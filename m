Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E9F2C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 19 Apr 2022 03:29:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344132AbiDSDby (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 18 Apr 2022 23:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239486AbiDSDby (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 18 Apr 2022 23:31:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 078AE2899A
        for <mm-commits@vger.kernel.org>; Mon, 18 Apr 2022 20:29:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FBA860CA5
        for <mm-commits@vger.kernel.org>; Tue, 19 Apr 2022 03:29:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9E04C385A7;
        Tue, 19 Apr 2022 03:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650338951;
        bh=OH7EXyhAEZ0QO01RmhxgQV7XOFBrCNeiRO7lWHuozE8=;
        h=Date:To:From:Subject:From;
        b=xQUaURkdiXWHVcz69uUoAZ5cNUEhR3azorUtrMMrd0BuclKgMk+EC+lDC5SU16GMY
         03asRdJDgxrREiwHUipB0Q0JIA2ZypRPN2HoeZ6TBt1XkBpU7uELBcOxOnD4UWOgnq
         HjgniF0sIX8wfDwD5V/w6yxDrzTM2HDFvOaY0dgA=
Date:   Mon, 18 Apr 2022 20:29:11 -0700
To:     mm-commits@vger.kernel.org, manfred@colorfullife.com,
        dave@stgolabs.net, prakash.sangappa@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ipc-update-semtimedop-to-use-hrtimer.patch added to -mm tree
Message-Id: <20220419032911.C9E04C385A7@smtp.kernel.org>
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

Link: https://lkml.kernel.org/r/1650333099-27214-1-git-send-email-prakash.sangappa@oracle.com
Signed-off-by: Prakash Sangappa <prakash.sangappa@oracle.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/ipc/sem.c~ipc-update-semtimedop-to-use-hrtimer
+++ a/ipc/sem.c
@@ -1993,7 +1993,10 @@ long __do_semtimedop(int semid, struct s
 	int max, locknum;
 	bool undos = false, alter = false, dupsop = false;
 	struct sem_queue queue;
-	unsigned long dup = 0, jiffies_left = 0;
+	unsigned long dup = 0;
+	ktime_t expires;
+	int timed_out = 0;
+	struct timespec64 end_time;
 
 	if (nsops < 1 || semid < 0)
 		return -EINVAL;
@@ -2006,7 +2009,9 @@ long __do_semtimedop(int semid, struct s
 			error = -EINVAL;
 			goto out;
 		}
-		jiffies_left = timespec64_to_jiffies(timeout);
+		ktime_get_ts64(&end_time);
+		end_time = timespec64_add_safe(end_time, *timeout);
+		expires = timespec64_to_ktime(end_time);
 	}
 
 
@@ -2165,7 +2170,9 @@ long __do_semtimedop(int semid, struct s
 		rcu_read_unlock();
 
 		if (timeout)
-			jiffies_left = schedule_timeout(jiffies_left);
+			timed_out = !schedule_hrtimeout_range(&expires,
+						current->timer_slack_ns,
+						HRTIMER_MODE_ABS);
 		else
 			schedule();
 
@@ -2208,7 +2215,7 @@ long __do_semtimedop(int semid, struct s
 		/*
 		 * If an interrupt occurred we have to clean up the queue.
 		 */
-		if (timeout && jiffies_left == 0)
+		if (timeout && timed_out)
 			error = -EAGAIN;
 	} while (error == -EINTR && !signal_pending(current)); /* spurious */
 
_

Patches currently in -mm which might be from prakash.sangappa@oracle.com are

ipc-update-semtimedop-to-use-hrtimer.patch


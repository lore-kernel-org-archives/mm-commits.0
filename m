Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5473C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 28 Apr 2022 21:35:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235502AbiD1VjH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Apr 2022 17:39:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233137AbiD1VjG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Apr 2022 17:39:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91F439682B
        for <mm-commits@vger.kernel.org>; Thu, 28 Apr 2022 14:35:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3078E61F5C
        for <mm-commits@vger.kernel.org>; Thu, 28 Apr 2022 21:35:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8740AC385AD;
        Thu, 28 Apr 2022 21:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651181748;
        bh=qsDuxCesNy3ou+O2yLgG00BT3UMr/xFqORi7zzEvpVY=;
        h=Date:To:From:Subject:From;
        b=s4upBY+qfqxFB3QujfrB3iwquwHSR4HEaKHS+79c9skZkuhYbL3kHoh07hs9OhJRW
         r2Nc3SZsO8rMMjVi9c98ZLIdVTqEsgQfnNXtm/sRzyalB0fPwIBWrERdNZN4ZHT9Hb
         zwguxIPaZmKpIVfK/dGBfkPii2zH1KlcAs5oAbr8=
Date:   Thu, 28 Apr 2022 14:35:47 -0700
To:     mm-commits@vger.kernel.org, manfred@colorfullife.com,
        dave@stgolabs.net, prakash.sangappa@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] ipc-update-semtimedop-to-use-hrtimer.patch removed from -mm tree
Message-Id: <20220428213548.8740AC385AD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ipc: update semtimedop() to use hrtimer
has been removed from the -mm tree.  Its filename was
     ipc-update-semtimedop-to-use-hrtimer.patch

This patch was dropped because an updated version will be merged

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



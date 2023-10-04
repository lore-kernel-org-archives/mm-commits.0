Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04879E936E1
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:24:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245062AbjJDUYx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:24:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245085AbjJDUXn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:23:43 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88E5A1B3
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:23:39 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE0B8C433C9;
        Wed,  4 Oct 2023 20:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696451019;
        bh=SYh5wbVZJRRdi8/69B1GOapR/n9ANcI0xccpKgVRQZk=;
        h=Date:To:From:Subject:From;
        b=WvOZaz5GGTGXzZ4yHYcoLlqh3eMjQZTEB+aSCOwgXS3lole3jh4tkkPXO1vvuefvY
         oFNkeYdamjyejqIEJ6RtJKINs/5MR0UEvqQgsgxqLGIrzEzZzyoMuklvoR4O8jPtJT
         LpuEcxjJPx2Yj1pSyNAPiQczyhWFVlLZ71rGDqYM=
Date:   Wed, 04 Oct 2023 13:23:37 -0700
To:     mm-commits@vger.kernel.org, ebiederm@xmission.com, oleg@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] signal-complete_signal-use-__for_each_thread.patch removed from -mm tree
Message-Id: <20231004202338.EE0B8C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: signal: complete_signal: use __for_each_thread()
has been removed from the -mm tree.  Its filename was
     signal-complete_signal-use-__for_each_thread.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: signal: complete_signal: use __for_each_thread()
Date: Sat, 9 Sep 2023 18:45:37 +0200

do/while_each_thread should be avoided when possible.

Link: https://lkml.kernel.org/r/20230909164537.GA11633@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/kernel/signal.c~signal-complete_signal-use-__for_each_thread
+++ a/kernel/signal.c
@@ -1058,12 +1058,11 @@ static void complete_signal(int sig, str
 			signal->flags = SIGNAL_GROUP_EXIT;
 			signal->group_exit_code = sig;
 			signal->group_stop_count = 0;
-			t = p;
-			do {
+			__for_each_thread(signal, t) {
 				task_clear_jobctl_pending(t, JOBCTL_PENDING_MASK);
 				sigaddset(&t->pending.signal, SIGKILL);
 				signal_wake_up(t, 1);
-			} while_each_thread(p, t);
+			}
 			return;
 		}
 	}
_

Patches currently in -mm which might be from oleg@redhat.com are



Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 084D1E936E6
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:24:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245075AbjJDUYy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:24:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245101AbjJDUXq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:23:46 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA3B11B7
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:23:43 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07529C433C7;
        Wed,  4 Oct 2023 20:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696451023;
        bh=I1FZXQPU2cQyfGIPs/l37UuX17dp21ZCzG6rF4d1EtQ=;
        h=Date:To:From:Subject:From;
        b=GKzTsdMjhrziKhIVnA0EOKwLbNG4EFTRTTYzC8DohFfHNzscslgUeHFV3KXsxghAc
         dzL+TBb2XBZnzmRwWWPr2Ug/ep2vn6rmUEPShqCmmiMEILVtL/zTNINuJ6/oi0hRoc
         MnBnNRVksvQKjf52p/KXIBnYxg8VcjQLVZNx/HS0=
Date:   Wed, 04 Oct 2023 13:23:41 -0700
To:     mm-commits@vger.kernel.org, ebiederm@xmission.com, oleg@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] getrusage-use-__for_each_thread.patch removed from -mm tree
Message-Id: <20231004202343.07529C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: getrusage: use __for_each_thread()
has been removed from the -mm tree.  Its filename was
     getrusage-use-__for_each_thread.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: getrusage: use __for_each_thread()
Date: Sat, 9 Sep 2023 19:26:29 +0200

do/while_each_thread should be avoided when possible.

Plus this change allows to avoid lock_task_sighand(), we can use rcu
and/or sig->stats_lock instead.

Link: https://lkml.kernel.org/r/20230909172629.GA20454@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/kernel/sys.c~getrusage-use-__for_each_thread
+++ a/kernel/sys.c
@@ -1830,10 +1830,8 @@ void getrusage(struct task_struct *p, in
 		r->ru_oublock += sig->oublock;
 		if (maxrss < sig->maxrss)
 			maxrss = sig->maxrss;
-		t = p;
-		do {
+		__for_each_thread(sig, t)
 			accumulate_thread_rusage(t, r);
-		} while_each_thread(p, t);
 		break;
 
 	default:
_

Patches currently in -mm which might be from oleg@redhat.com are



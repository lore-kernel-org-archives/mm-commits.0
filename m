Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38D7CC43217
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:05:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24ECC611EE
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:05:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346067AbhIIVGz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:06:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:56332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348319AbhIIVGd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:06:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83091611C8;
        Thu,  9 Sep 2021 21:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221523;
        bh=UZ4frFS/6qh86GWzevCVPVX6n2jH7Y1p1hneei5ieg0=;
        h=Date:From:To:Subject:From;
        b=rYPGAPcBb/0FZdQ7VWiVQj1aEY3hgsKeJwO4Cl6RiOjTGCGE5IXNmyDkfuzXrRKez
         zx73X9pahpdhbxubTTBKa78ATy2kQJEGqXG7P7yeZXfxb6yaWZQc8lDoRhb8W0UjA1
         l+vfjr0k3VPLi3u/aD4w49vTlcdAmfKvARQmUOAk=
Date:   Thu, 09 Sep 2021 14:05:23 -0700
From:   akpm@linux-foundation.org
To:     itazur@amazon.com, kuniyu@amazon.co.jp, mm-commits@vger.kernel.org
Subject:  [merged]
 pid-cleanup-the-stale-comment-mentioning-pidmap_init.patch removed from -mm
 tree
Message-ID: <20210909210523.fsl2ajWyQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: pid: cleanup the stale comment mentioning pidmap_init().
has been removed from the -mm tree.  Its filename was
     pid-cleanup-the-stale-comment-mentioning-pidmap_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Takahiro Itazuri <itazur@amazon.com>
Subject: pid: cleanup the stale comment mentioning pidmap_init().

pidmap_init() has already been replaced with pid_idr_init() in the commit
95846ecf9dac ("pid: replace pid bitmap implementation with IDR API"). 
Cleanup the stale comment which still mentions it.

Link: https://lkml.kernel.org/r/20210714120713.19825-1-itazur@amazon.com
Signed-off-by: Takahiro Itazuri <itazur@amazon.com>
Cc: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/threads.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/threads.h~pid-cleanup-the-stale-comment-mentioning-pidmap_init
+++ a/include/linux/threads.h
@@ -38,7 +38,7 @@
  * Define a minimum number of pids per cpu.  Heuristically based
  * on original pid max of 32k for 32 cpus.  Also, increase the
  * minimum settable value for pid_max on the running system based
- * on similar defaults.  See kernel/pid.c:pidmap_init() for details.
+ * on similar defaults.  See kernel/pid.c:pid_idr_init() for details.
  */
 #define PIDS_PER_CPU_DEFAULT	1024
 #define PIDS_PER_CPU_MIN	8
_

Patches currently in -mm which might be from itazur@amazon.com are



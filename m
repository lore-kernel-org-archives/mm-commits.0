Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B58E7C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 01:44:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D05C61244
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 01:44:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbhIOBpx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 14 Sep 2021 21:45:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:37302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230322AbhIOBpx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 14 Sep 2021 21:45:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68FEE61211;
        Wed, 15 Sep 2021 01:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631670275;
        bh=7WBcSAQzBzEuw+M+soaopgYsI88NbYauV4NoFDEv98U=;
        h=Date:From:To:Subject:From;
        b=Zki1OpOsxd3m0a0avJy0vnUAiQVYQHRuBOq1gQg/U7kv5Ubvx7VM7UwviXwQY3WHE
         Sh+AOYXFQZnllMJB0mfIypLTsDJwKKJYxolbnAE99sj/KZG1TpFZcpoB5JAp33nOR2
         BRE5ttHY7A57weX7diLqBpuVlHAaqxswGui9C5C8=
Date:   Tue, 14 Sep 2021 18:44:35 -0700
From:   akpm@linux-foundation.org
To:     hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org,
        shakeelb@google.com, vvs@virtuozzo.com
Subject:  [merged]
 ipc-remove-memcg-accounting-for-sops-objects-in-do_semtimedop.patch removed
 from -mm tree
Message-ID: <20210915014435.16EgxtbVG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ipc: remove memcg accounting for sops objects in do_semtimedop()
has been removed from the -mm tree.  Its filename was
     ipc-remove-memcg-accounting-for-sops-objects-in-do_semtimedop.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vasily Averin <vvs@virtuozzo.com>
Subject: ipc: remove memcg accounting for sops objects in do_semtimedop()

Linus proposes to revert an accounting for sops objects in do_semtimedop()
because it's really just a temporary buffer for a single semtimedop()
system call.

This object can consume up to 2 pages, syscall is sleeping one, size and
duration can be controlled by user, and this allocation can be repeated by
many thread at the same time.

However Shakeel Butt pointed that there are much more popular objects with
the same life time and similar memory consumption, the accounting of which
was decided to be rejected for performance reasons.

In addition, any usual task consumes much more accounted memory, so 2
pages of this temporal buffer can be safely ignored.

Link: https://patchwork.kernel.org/project/linux-fsdevel/patch/20171005222144.123797-1-shakeelb@google.com/
Link: https://lkml.kernel.org/r/90e254df-0dfe-f080-011e-b7c53ee7fd20@virtuozzo.com
Fixes: 18319498fdd4 ("memcg: enable accounting of ipc resources")
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/ipc/sem.c~ipc-remove-memcg-accounting-for-sops-objects-in-do_semtimedop
+++ a/ipc/sem.c
@@ -2238,7 +2238,7 @@ static long do_semtimedop(int semid, str
 		return -EINVAL;
 
 	if (nsops > SEMOPM_FAST) {
-		sops = kvmalloc_array(nsops, sizeof(*sops), GFP_KERNEL_ACCOUNT);
+		sops = kvmalloc_array(nsops, sizeof(*sops), GFP_KERNEL);
 		if (sops == NULL)
 			return -ENOMEM;
 	}
_

Patches currently in -mm which might be from vvs@virtuozzo.com are



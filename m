Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46C7FC433EF
	for <mm-commits@archiver.kernel.org>; Sat, 11 Sep 2021 22:09:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13A68610C9
	for <mm-commits@archiver.kernel.org>; Sat, 11 Sep 2021 22:09:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbhIKWKT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 11 Sep 2021 18:10:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:50574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229800AbhIKWKS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 11 Sep 2021 18:10:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DAA4360F5D;
        Sat, 11 Sep 2021 22:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631398145;
        bh=d8H+wtoRDJwWri3fXk5z3mpU3ZEFt5AXVjy/BmDq/yc=;
        h=Date:From:To:Subject:From;
        b=G+ft/+6MZWbhcFjAgRqjjSR0ApbtsYXjA2Vqh7Tuigkx3BE5BZVU4koT8rqdgSlRa
         78z4nly3FEmSa0r/qvKVQ9AzKCX88XlzADp77CFEtxfi1F8kWSTzqdYKPcU+n+VLg9
         6qv4G3S+IjPARbCpoZPH2p6Y6UhE9Y0ceolTliTE=
Date:   Sat, 11 Sep 2021 15:09:04 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, shakeelb@google.com, mhocko@kernel.org,
        hannes@cmpxchg.org, vvs@virtuozzo.com
Subject:  +
 ipc-remove-memcg-accounting-for-sops-objects-in-do_semtimedop.patch added to
 -mm tree
Message-ID: <20210911220904.oZinO%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ipc: remove memcg accounting for sops objects in do_semtimedop()
has been added to the -mm tree.  Its filename is
     ipc-remove-memcg-accounting-for-sops-objects-in-do_semtimedop.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ipc-remove-memcg-accounting-for-sops-objects-in-do_semtimedop.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ipc-remove-memcg-accounting-for-sops-objects-in-do_semtimedop.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

 ipc/sem.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/ipc/sem.c~ipc-remove-memcg-accounting-for-sops-objects-in-do_semtimedop
+++ a/ipc/sem.c
@@ -2005,8 +2005,7 @@ static long do_semtimedop(int semid, str
 	if (nsops > ns->sc_semopm)
 		return -E2BIG;
 	if (nsops > SEMOPM_FAST) {
-		sops = kvmalloc_array(nsops, sizeof(*sops),
-				      GFP_KERNEL_ACCOUNT);
+		sops = kvmalloc_array(nsops, sizeof(*sops), GFP_KERNEL);
 		if (sops == NULL)
 			return -ENOMEM;
 	}
_

Patches currently in -mm which might be from vvs@virtuozzo.com are

ipc-remove-memcg-accounting-for-sops-objects-in-do_semtimedop.patch


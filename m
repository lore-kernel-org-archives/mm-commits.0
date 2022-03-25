Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA0C4C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:32:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357360AbiCYBdj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:33:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357363AbiCYBcW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:32:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC087BD8B1
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:30:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F66EB8261B
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:30:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09407C340EC;
        Fri, 25 Mar 2022 01:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171846;
        bh=ERH97jkg97kYMO3bDoZhxYTMAtrdLYlm4qR5mnbhruI=;
        h=Date:To:From:Subject:From;
        b=kR2fCFFpoUNPqZ2FFNEFG8HLHao+ioWy45dvUKNyEr2hLWbrTHO5j9e7fAnYtO9c1
         +KoaoomF6FPZH8tioFRGSyXZ3ITV24gR/W+Q4z7VZF8xZoZPaMdPKyAUJNrFeDGt1M
         PLGdnw/6OeW1xdkyNXPxx1DzrjyG3E+Xu+J2dI10=
Date:   Thu, 24 Mar 2022 18:30:45 -0700
To:     mm-commits@vger.kernel.org, vdavydov.dev@gmail.com,
        shakeelb@google.com, roman.gushchin@linux.dev, mhocko@kernel.org,
        jirislaby@kernel.org, hannes@cmpxchg.org,
        gregkh@linuxfoundation.org, vvs@virtuozzo.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] memcg-enable-accounting-for-tty-related-objects.patch removed from -mm tree
Message-Id: <20220325013046.09407C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: enable accounting for tty-related objects
has been removed from the -mm tree.  Its filename was
     memcg-enable-accounting-for-tty-related-objects.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vasily Averin <vvs@virtuozzo.com>
Subject: memcg: enable accounting for tty-related objects

At each login the user forces the kernel to create a new terminal and
allocate up to ~1Kb memory for the tty-related structures.

By default it's allowed to create up to 4096 ptys with 1024 reserve for
initial mount namespace only and the settings are controlled by host
admin.

Though this default is not enough for hosters with thousands of containers
per node.  Host admin can be forced to increase it up to NR_UNIX98_PTY_MAX
= 1<<20.

By default container is restricted by pty mount_opt.max = 1024, but admin
inside container can change it via remount.  As a result, one container
can consume almost all allowed ptys and allocate up to 1Gb of unaccounted
memory.

It is not enough per-se to trigger OOM on host, however anyway, it allows
to significantly exceed the assigned memcg limit and leads to troubles on
the over-committed node.

It makes sense to account for them to restrict the host's memory
consumption from inside the memcg-limited container.

Link: https://lkml.kernel.org/r/5d4bca06-7d4f-a905-e518-12981ebca1b3@virtuozzo.com
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jirislaby@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/tty/tty_io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/tty_io.c~memcg-enable-accounting-for-tty-related-objects
+++ a/drivers/tty/tty_io.c
@@ -3088,7 +3088,7 @@ struct tty_struct *alloc_tty_struct(stru
 {
 	struct tty_struct *tty;
 
-	tty = kzalloc(sizeof(*tty), GFP_KERNEL);
+	tty = kzalloc(sizeof(*tty), GFP_KERNEL_ACCOUNT);
 	if (!tty)
 		return NULL;
 
_

Patches currently in -mm which might be from vvs@virtuozzo.com are



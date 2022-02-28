Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 084E2C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 28 Feb 2022 19:52:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbiB1Twp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Feb 2022 14:52:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbiB1Twi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Feb 2022 14:52:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E11E2114740
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 11:51:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8EC9A61594
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 19:41:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5D56C340F1;
        Mon, 28 Feb 2022 19:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646077260;
        bh=F2uRtrmqz+VtuHs33N3GGW584xZl1XAgUDa6ngfSo5Y=;
        h=Date:To:From:Subject:From;
        b=xurv7dfJvz8kKhunDrs1Gum57/NNnbMAngiPNzZDQftgR1PPOJkjmevGrcUmzc3EL
         ss713ExHyzhVE2K+A8qTR6Xd528CwtmqWptONfpape4oS76+oFbmC8OvnyKjjNwCIp
         iSbTb3SPzUp0Tl0ySCS4rb95pFAddcdQo1nWYInk=
Date:   Mon, 28 Feb 2022 11:40:59 -0800
To:     mm-commits@vger.kernel.org, vdavydov.dev@gmail.com,
        shakeelb@google.com, roman.gushchin@linux.dev, mhocko@kernel.org,
        jirislaby@kernel.org, hannes@cmpxchg.org,
        gregkh@linuxfoundation.org, vvs@virtuozzo.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-enable-accounting-for-tty-related-objects.patch added to -mm tree
Message-Id: <20220228194059.E5D56C340F1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: enable accounting for tty-related objects
has been added to the -mm tree.  Its filename is
     memcg-enable-accounting-for-tty-related-objects.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/memcg-enable-accounting-for-tty-related-objects.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/memcg-enable-accounting-for-tty-related-objects.patch

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

memcg-enable-accounting-for-tty-related-objects.patch


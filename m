Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51952C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:41:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234569AbiCVVnN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:43:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236028AbiCVVnK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:43:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4B5D5EDD2
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:41:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 705376104C
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:41:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8D12C340EC;
        Tue, 22 Mar 2022 21:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985301;
        bh=NdXGFOaH/G3Ca+xSreW2a3NNoD/Ri6hzHW0e16G2ANk=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=xM7c0/hKuiYxABcDQtmhtKSsKP9CF1oJaNsw3haREOPpZBlOUr12yS9goyrqfOyBc
         iO26lcfOxTDm6/hYThVAvrudhs0Dd8PMmY8acex+4lEyiT85fSEZjRihmA8zPgbvle
         mW2Vcg3DzllDGuG0tKzNSEHoqq0gPx9avys7B5w0=
Date:   Tue, 22 Mar 2022 14:41:41 -0700
To:     vdavydov.dev@gmail.com, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@kernel.org, jirislaby@kernel.org,
        hannes@cmpxchg.org, gregkh@linuxfoundation.org, vvs@virtuozzo.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 062/227] memcg: enable accounting for tty-related objects
Message-Id: <20220322214141.C8D12C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

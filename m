Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D9FCC001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 22:23:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234786AbjHKWXL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 18:23:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237161AbjHKWXH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:23:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F81835A8
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:22:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A269767342
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:22:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 043EDC433C7;
        Fri, 11 Aug 2023 22:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691792577;
        bh=bqh9jM/s8qsf2yLAt8Qv9uqgIbBKY3YJE4FbGJOFpUc=;
        h=Date:To:From:Subject:From;
        b=UAvcG7AfSczLR/x0WAEPkc/ZebvnUTb5cNLewjcLAqzffurrVJD1/rAagTdu5y5bI
         fWzrlm51mMVM1Jc6d+dvJTGJx+U6nyw9LnJyvkiAo8b7lKqWDVJSxJw3lcQMsnGfW0
         s+kgyu26gX7m6CmOzkAr5Qkx0eUaGjp4Te6Dsnug=
Date:   Fri, 11 Aug 2023 15:22:56 -0700
To:     mm-commits@vger.kernel.org, tj@kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, muchun.song@linux.dev,
        hannes@cmpxchg.org, mhocko@suse.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] memcg-drop-kmemlimit_in_bytes-fix.patch removed from -mm tree
Message-Id: <20230811222257.043EDC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: memcg-drop-kmemlimit_in_bytes-fix
has been removed from the -mm tree.  Its filename was
     memcg-drop-kmemlimit_in_bytes-fix.patch

This patch was dropped because it was folded into memcg-drop-kmemlimit_in_bytes.patch

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: memcg-drop-kmemlimit_in_bytes-fix
Date: Fri, 7 Jul 2023 09:07:47 +0200

restore _KMEM switch case

Link: https://lkml.kernel.org/r/ZKe5wxdbvPi5Cwd7@dhcp22.suse.cz
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/memcontrol.c~memcg-drop-kmemlimit_in_bytes-fix
+++ a/mm/memcontrol.c
@@ -3708,6 +3708,9 @@ static u64 mem_cgroup_read_u64(struct cg
 	case _MEMSWAP:
 		counter = &memcg->memsw;
 		break;
+	case _KMEM:
+		counter = &memcg->kmem;
+		break;
 	case _TCP:
 		counter = &memcg->tcpmem;
 		break;
_

Patches currently in -mm which might be from mhocko@suse.com are

memcg-drop-kmemlimit_in_bytes.patch


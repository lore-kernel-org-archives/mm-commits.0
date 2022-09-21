Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E70EECAAD8
	for <mm-commits@archiver.kernel.org>; Wed, 21 Sep 2022 20:27:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbiIUU1K (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Sep 2022 16:27:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230164AbiIUU1K (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 21 Sep 2022 16:27:10 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41B83A4B1A
        for <mm-commits@vger.kernel.org>; Wed, 21 Sep 2022 13:27:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 923F6CE1F69
        for <mm-commits@vger.kernel.org>; Wed, 21 Sep 2022 20:27:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3685C433D6;
        Wed, 21 Sep 2022 20:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663792026;
        bh=+eG+r/FBVn44Mkro/IE/uWCNe3qvUinn3tix/UrXWic=;
        h=Date:To:From:Subject:From;
        b=aG7va6XPL4SFqGNEDEwaAMfrSzTif4aKEn7RZf/cinDqr7bIfPdJneZm6YOBd6nYp
         14/KtOxAe34cULCMPJGmLhpj9MJXp0PEGwDyEpxjk7sghF13wB0EgzrsW73Cp4dPrk
         iVpyvxqJsEXeEb2dKA4s+v7AnAInlwVtY+c07fm4=
Date:   Wed, 21 Sep 2022 13:27:04 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shakeelb@google.com, roman.gushchin@linux.dev, mhocko@suse.com,
        hannes@cmpxchg.org, kasong@tencent.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-use-memcg_kmem_enabled-in-count_objcg_event.patch added to mm-unstable branch
Message-Id: <20220921202705.B3685C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: use memcg_kmem_enabled in count_objcg_event
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcontrol-use-memcg_kmem_enabled-in-count_objcg_event.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-use-memcg_kmem_enabled-in-count_objcg_event.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm: memcontrol: use memcg_kmem_enabled in count_objcg_event
Date: Tue, 20 Sep 2022 02:06:33 +0800

Patch series "mm: memcontrol: cleanup and optimize for two accounting
params", v2.


This patch (of 2):

There are currently two helpers for checking if cgroup kmem
accounting is enabled:

- mem_cgroup_kmem_disabled
- memcg_kmem_enabled

mem_cgroup_kmem_disabled is a simple helper that returns true
if cgroup.memory=nokmem is specified, otherwise returns false.

memcg_kmem_enabled is a bit different, it returns true if
cgroup.memory=nokmem is not specified and there was at least one
non-root memory control enabled cgroup ever created. This help improve
performance when kmem accounting was not actually activated. And it's
optimized with static branch.

The usage of mem_cgroup_kmem_disabled is for sub-systems that need to
preallocate data for kmem accounting since they could be initialized
before kmem accounting is activated. But count_objcg_event doesn't
need that, so using memcg_kmem_enabled is better here.

Link: https://lkml.kernel.org/r/20220919180634.45958-1-ryncsn@gmail.com
Link: https://lkml.kernel.org/r/20220919180634.45958-2-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Muchun Song <songmuchun@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/memcontrol.h~mm-memcontrol-use-memcg_kmem_enabled-in-count_objcg_event
+++ a/include/linux/memcontrol.h
@@ -1778,7 +1778,7 @@ static inline void count_objcg_event(str
 {
 	struct mem_cgroup *memcg;
 
-	if (mem_cgroup_kmem_disabled())
+	if (!memcg_kmem_enabled())
 		return;
 
 	rcu_read_lock();
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-memcontrol-use-memcg_kmem_enabled-in-count_objcg_event.patch
mm-memcontrol-make-cgroup_memory_noswap-a-static-key.patch


Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19EABC64EC4
	for <mm-commits@archiver.kernel.org>; Mon,  6 Mar 2023 20:54:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbjCFUyB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Mar 2023 15:54:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbjCFUyA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Mar 2023 15:54:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D423B0CB
        for <mm-commits@vger.kernel.org>; Mon,  6 Mar 2023 12:53:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C81BEB81110
        for <mm-commits@vger.kernel.org>; Mon,  6 Mar 2023 20:53:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A5D6C433D2;
        Mon,  6 Mar 2023 20:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678136036;
        bh=cQdVwzF9l263IOfyzDGnlcL4che/cxBWTUkhMT4VzkM=;
        h=Date:To:From:Subject:From;
        b=uPMCzBfhsm5Mro//O/1P+jZG0XTG7iT/+X/s3qQIPQ+78tXp9xzezebgRQ4Kzm6c9
         dCXQKtWesMzAW9iZuHvuTG53jWD576PBDxM3At0YP40nRmHfLoH/MPgEPv52QYvaBz
         MDZEuXVD7pvXYBaxmKFNpytLrAdM53uHf0bQldak=
Date:   Mon, 06 Mar 2023 12:53:55 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tangyeechou@gmail.com, shakeelb@google.com,
        roman.gushchin@linux.dev, muchun.song@linux.dev, mhocko@suse.com,
        hannes@cmpxchg.org, findns94@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-prevent-memoryswappiness-load-store-tearing.patch added to mm-unstable branch
Message-Id: <20230306205356.6A5D6C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, memcg: Prevent memory.swappiness load/store tearing
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-prevent-memoryswappiness-load-store-tearing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-prevent-memoryswappiness-load-store-tearing.patch

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
From: Yue Zhao <findns94@gmail.com>
Subject: mm, memcg: Prevent memory.swappiness load/store tearing
Date: Mon, 6 Mar 2023 23:41:36 +0800

The knob for cgroup v1 memory controller: memory.swappiness
is not protected by any locking so it can be modified while it is used.
This is not an actual problem because races are unlikely.
But it is better to use READ_ONCE/WRITE_ONCE to prevent compiler from
doing anything funky.

The access of memcg->swappiness and vm_swappiness is lockless,
so both of them can be concurrently set at the same time
as we are trying to read them.

Link: https://lkml.kernel.org/r/20230306154138.3775-3-findns94@gmail.com
Signed-off-by: Yue Zhao <findns94@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Tang Yizhou <tangyeechou@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/swap.h~mm-memcg-prevent-memoryswappiness-load-store-tearing
+++ a/include/linux/swap.h
@@ -620,18 +620,18 @@ static inline int mem_cgroup_swappiness(
 {
 	/* Cgroup2 doesn't have per-cgroup swappiness */
 	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
-		return vm_swappiness;
+		return READ_ONCE(vm_swappiness);
 
 	/* root ? */
 	if (mem_cgroup_disabled() || mem_cgroup_is_root(memcg))
-		return vm_swappiness;
+		return READ_ONCE(vm_swappiness);
 
-	return memcg->swappiness;
+	return READ_ONCE(memcg->swappiness);
 }
 #else
 static inline int mem_cgroup_swappiness(struct mem_cgroup *mem)
 {
-	return vm_swappiness;
+	return READ_ONCE(vm_swappiness);
 }
 #endif
 
--- a/mm/memcontrol.c~mm-memcg-prevent-memoryswappiness-load-store-tearing
+++ a/mm/memcontrol.c
@@ -4179,9 +4179,9 @@ static int mem_cgroup_swappiness_write(s
 		return -EINVAL;
 
 	if (!mem_cgroup_is_root(memcg))
-		memcg->swappiness = val;
+		WRITE_ONCE(memcg->swappiness, val);
 	else
-		vm_swappiness = val;
+		WRITE_ONCE(vm_swappiness, val);
 
 	return 0;
 }
_

Patches currently in -mm which might be from findns94@gmail.com are

mm-memcg-prevent-memoryoomgroup-load-store-tearing.patch
mm-memcg-prevent-memoryswappiness-load-store-tearing.patch
mm-memcg-prevent-memoryoom_control-load-store-tearing.patch
mm-memcg-prevent-memorysoft_limit_in_bytes-load-store-tearing.patch


Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84799EE49A8
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:39:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbjHUUj3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:39:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231239AbjHUUjM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:39:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 933CA1B9
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:39:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 75BEF64AFB
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:39:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB6F1C433C7;
        Mon, 21 Aug 2023 20:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650347;
        bh=OJRKwyikINQPNJrS8/eoWCaRxzQMOT+nlm0/tEGGGLs=;
        h=Date:To:From:Subject:From;
        b=wus/JI7gg67x9O5gDikEn+oUJEmQhVd7Q3YCRhRxi3Snk5VyIkz3WvhEjJZI6wT5t
         44sVTkBn+rfDFOYqxmdhbJ83vZL40STThm4GpZtmZHI6JlQ8ISG7nru4Kj8uxDfETv
         OXQZEl7nOa0CYxIk2myDjqUvn1t0Hvs3YNhmSS+o=
Date:   Mon, 21 Aug 2023 13:39:07 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shakeelb@google.com, roman.gushchin@linux.dev, mhocko@suse.com,
        hannes@cmpxchg.org, linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-fix-obsolete-function-name-in-mem_cgroup_protection.patch removed from -mm tree
Message-Id: <20230821203907.CB6F1C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memcg: fix obsolete function name in mem_cgroup_protection()
has been removed from the -mm tree.  Its filename was
     mm-memcg-fix-obsolete-function-name-in-mem_cgroup_protection.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memcg: fix obsolete function name in mem_cgroup_protection()
Date: Thu, 27 Jul 2023 19:59:34 +0800

Commit 45c7f7e1ef17 ("mm, memcg: decouple e{low,min} state mutations from
protection checks") changed the function name but not the corresponding
comment.

Link: https://lkml.kernel.org/r/20230727115934.657787-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/memcontrol.h~mm-memcg-fix-obsolete-function-name-in-mem_cgroup_protection
+++ a/include/linux/memcontrol.h
@@ -582,7 +582,7 @@ static inline void mem_cgroup_protection
 	/*
 	 * There is no reclaim protection applied to a targeted reclaim.
 	 * We are special casing this specific case here because
-	 * mem_cgroup_protected calculation is not robust enough to keep
+	 * mem_cgroup_calculate_protection is not robust enough to keep
 	 * the protection invariant for calculated effective values for
 	 * parallel reclaimers with different reclaim target. This is
 	 * especially a problem for tail memcgs (as they have pages on LRU)
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memory-failure-add-pageoffline-check.patch
mm-memory-failure-fix-potential-page-refcnt-leak-in-memory_failure.patch


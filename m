Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 838F0C4332F
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:17:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbiJCVRL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:17:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiJCVPK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:15:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCA921EEF7
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:09:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81E0CB815F8
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:09:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A097C433D7;
        Mon,  3 Oct 2022 21:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831391;
        bh=+79L/btlu6hlphvLQ4ElTXHHL24lzEvOnZ+w4Vk32G0=;
        h=Date:To:From:Subject:From;
        b=x6bsID3fiqE4XeFPKoljHEkgcNfYS0qvgE7lUZgkRqerBs3Bj4ad+L0vyTNVwyfpz
         8JWRZ+BU1PYk46poiTVovXpCAwBQAe0xUVDBf1lZC1RYOjv+4hv5Fi/9QZXn8k5J9O
         WvFYgIuPfEvbmyu3nalhV1VzkWmdu8B3JczcsU4c=
Date:   Mon, 03 Oct 2022 14:09:50 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shakeelb@google.com, roman.gushchin@linux.dev, mhocko@suse.com,
        hannes@cmpxchg.org, kasong@tencent.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcontrol-use-memcg_kmem_enabled-in-count_objcg_event.patch removed from -mm tree
Message-Id: <20221003210951.3A097C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memcontrol: use memcg_kmem_enabled in count_objcg_event
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-use-memcg_kmem_enabled-in-count_objcg_event.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

 include/linux/memcontrol.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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



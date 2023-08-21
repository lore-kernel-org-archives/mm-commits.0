Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29E2FEE49A5
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:40:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbjHUUkB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:40:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbjHUUjo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:39:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB723189
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:39:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D05A64AF5
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:39:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00F46C433C8;
        Mon, 21 Aug 2023 20:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650369;
        bh=R0YRAe7Fg7kMBf2zNLjjEQXztDSg/bNkUQne6MqlpyA=;
        h=Date:To:From:Subject:From;
        b=qliCZOFt1Wux+rnUmWHC9JVXW/hX+mpVgqh697zrAu1iWGCvVX1kWN+yn/pp4B3RO
         to7VArIFdIBmY11G9vkKXjUc7c4OYAeTV/9HDSwg7C9ob+5RwgcrRqd7DAwuaHxR/h
         immoXHMUVkeI2RxZYPBLJVdrQ08EZ4UFhdqQCYMs=
Date:   Mon, 21 Aug 2023 13:39:28 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shakeelb@google.com, roman.gushchin@linux.dev, mhocko@suse.com,
        hannes@cmpxchg.org, linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-update-obsolete-comment-above-parent_mem_cgroup.patch removed from -mm tree
Message-Id: <20230821203929.00F46C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memcg: update obsolete comment above parent_mem_cgroup()
has been removed from the -mm tree.  Its filename was
     mm-memcg-update-obsolete-comment-above-parent_mem_cgroup.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memcg: update obsolete comment above parent_mem_cgroup()
Date: Tue, 1 Aug 2023 20:43:59 +0800

Since commit bef8620cd8e0 ("mm: memcg: deprecate the non-hierarchical
mode"), use_hierarchy is already deprecated.  And it's further removed via
commit 9d9d341df4d5 ("cgroup: remove obsoleted broken_hierarchy and
warned_broken_hierarchy").  Update corresponding comment.

Link: https://lkml.kernel.org/r/20230801124359.2266860-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-update-obsolete-comment-above-parent_mem_cgroup
+++ a/include/linux/memcontrol.h
@@ -860,8 +860,7 @@ static inline struct mem_cgroup *lruvec_
  * parent_mem_cgroup - find the accounting parent of a memcg
  * @memcg: memcg whose parent to find
  *
- * Returns the parent memcg, or NULL if this is the root or the memory
- * controller is in legacy no-hierarchy mode.
+ * Returns the parent memcg, or NULL if this is the root.
  */
 static inline struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *memcg)
 {
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memory-failure-add-pageoffline-check.patch
mm-memory-failure-fix-potential-page-refcnt-leak-in-memory_failure.patch


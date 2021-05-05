Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4275C433B4
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 00:56:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABCD861168
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 00:56:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbhEEA5O (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 20:57:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:41320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230328AbhEEA5O (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 20:57:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 76CA6613BA;
        Wed,  5 May 2021 00:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620176177;
        bh=+lbi85RpEeK80J5F9yM6/sZy3jVyyp7qqafalrrWZBs=;
        h=Date:From:To:Subject:From;
        b=dFcKZ7YvclvvJZYyGSM9yMmwtL/gIvwQh68gk0DGuJ7FXmvKhTmtY3FBaETCy7fuH
         JdOElq8/++83JHVe86trYTtIKI3Hm5sGZcScO+rrvc/0pI62I4/WJeEjtBMflMXM4Z
         Z6hwaRJ79NHlncgY6DRt78xswecw7MsVRZCUog7w=
Date:   Tue, 04 May 2021 17:56:15 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, david@fromorbit.com, guro@fb.com,
        hannes@cmpxchg.org, hughd@google.com, ktkhai@virtuozzo.com,
        mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com,
        shy828301@gmail.com, vbabka@suse.cz
Subject:  [folded-merged]
 mm-vmscan-add-shrinker_info_protected-helper-fix.patch removed from -mm
 tree
Message-ID: <20210505005615.Oo7rfEXnK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmscan-add-shrinker_info_protected-helper-fix
has been removed from the -mm tree.  Its filename was
     mm-vmscan-add-shrinker_info_protected-helper-fix.patch

This patch was dropped because it was folded into mm-vmscan-add-shrinker_info_protected-helper.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmscan-add-shrinker_info_protected-helper-fix

retain rcu_dereference_protected() in free_shrinker_info(), per Hugh

Cc: Dave Chinner <david@fromorbit.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-add-shrinker_info_protected-helper-fix
+++ a/mm/vmscan.c
@@ -239,7 +239,7 @@ void free_shrinker_info(struct mem_cgrou
 
 	for_each_node(nid) {
 		pn = memcg->nodeinfo[nid];
-		info = shrinker_info_protected(memcg, nid);
+		info = rcu_dereference_protected(pn->shrinker_info, true);
 		kvfree(info);
 		rcu_assign_pointer(pn->shrinker_info, NULL);
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscan-add-shrinker_info_protected-helper.patch
mm-drop-redundant-arch_enable__migration-fix.patch
mm-drop-redundant-arch_enable__migration-fix-fix.patch
mm.patch
kernel-resource-allow-region_intersects-users-to-hold-resource_lock-fix.patch
linux-next-rejects.patch
cifsd-is-broken.patch
kernel-forkc-export-kernel_thread-to-modules.patch


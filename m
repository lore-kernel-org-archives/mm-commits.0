Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A749BC433ED
	for <mm-commits@archiver.kernel.org>; Wed, 31 Mar 2021 22:32:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5110F61008
	for <mm-commits@archiver.kernel.org>; Wed, 31 Mar 2021 22:32:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbhCaWbc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 31 Mar 2021 18:31:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:55250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232367AbhCaWbP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 31 Mar 2021 18:31:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4F5B61007;
        Wed, 31 Mar 2021 22:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617229875;
        bh=63x9BZzfZek1hb/JB7Df5Lg+ifb5pl48ldbrS8E2Zvk=;
        h=Date:From:To:Subject:From;
        b=xYifa8boqeFs5vCtDREEfJadcrLdSPxrcLoJwGyv0O6yUP//kwmohruBHGOJWyFzq
         hVHyhWXj+EGN2aS8XSmszGAkOaCurSn7no09Zpa3wZctyOt0TaaAuCgoJJgpcbaxak
         QlCW8j418kOAdG3wa6KrWDjxRpjjisRy3ePM8QiE=
Date:   Wed, 31 Mar 2021 15:31:14 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, david@fromorbit.com, guro@fb.com,
        hannes@cmpxchg.org, hughd@google.com, ktkhai@virtuozzo.com,
        mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com,
        shy828301@gmail.com, vbabka@suse.cz
Subject:  + mm-vmscan-add-shrinker_info_protected-helper-fix.patch
 added to -mm tree
Message-ID: <20210331223114.ru7X7uJYo%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmscan-add-shrinker_info_protected-helper-fix
has been added to the -mm tree.  Its filename is
     mm-vmscan-add-shrinker_info_protected-helper-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-add-shrinker_info_protected-helper-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-add-shrinker_info_protected-helper-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

kasan-remove-redundant-config-option-fix.patch
mm-gup-check-page-posion-status-for-coredump-fix.patch
mm.patch
mm-memcontrol-switch-to-rstat-fix.patch
mm-vmscan-add-shrinker_info_protected-helper-fix.patch
mmmemory_hotplug-allocate-memmap-from-the-added-memory-range-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch


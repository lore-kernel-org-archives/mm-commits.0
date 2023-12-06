Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EF26C4167B
	for <mm-commits@archiver.kernel.org>; Wed,  6 Dec 2023 21:10:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379534AbjLFVKS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Dec 2023 16:10:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379738AbjLFVKS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Dec 2023 16:10:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC44CD6F
        for <mm-commits@vger.kernel.org>; Wed,  6 Dec 2023 13:10:23 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70F40C433C7;
        Wed,  6 Dec 2023 21:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701897023;
        bh=jtUlSAQKB1asE2jD0vZJdiPb2a8wyc7hpy8cklt2hUo=;
        h=Date:To:From:Subject:From;
        b=w+RzfUD0h3UcKsvBNfrqI1orrVVifivE09XKp4FRYfMPwYtsmqwQEZO6Xjl6J8HBP
         JMpfK5IvNZyKlY30lSXU4RzRKbJyCozjwLZh7Fs9PxhgNzQONiEC40EdXq1nVLK0X2
         qZIysPw6g+FJC2slTswuJuA72zRH8wXsEabdaWhI=
Date:   Wed, 06 Dec 2023 13:10:22 -0800
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        weixugc@google.com, tj@kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, muchun.song@linux.dev, mkoutny@suse.com,
        mhocko@kernel.org, longman@redhat.com, ivan@cloudflare.com,
        hannes@cmpxchg.org, gthelen@google.com, chrisl@kernel.org,
        cerasuolodomenico@gmail.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-restore-subtree-stats-flushing-fix.patch added to mm-unstable branch
Message-Id: <20231206211023.70F40C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcg-restore-subtree-stats-flushing-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-restore-subtree-stats-flushing-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-restore-subtree-stats-flushing-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memcg-restore-subtree-stats-flushing-fix
Date: Wed Dec  6 01:09:20 PM PST 2023

fix mm/zswap.c

Cc: Chris Li <chrisl@kernel.org>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Ivan Babrou <ivan@cloudflare.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutny <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Waiman Long <longman@redhat.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/zswap.c~mm-memcg-restore-subtree-stats-flushing-fix
+++ a/mm/zswap.c
@@ -641,7 +641,7 @@ static unsigned long zswap_shrinker_coun
 		return 0;
 
 #ifdef CONFIG_MEMCG_KMEM
-	mem_cgroup_flush_stats();
+	mem_cgroup_flush_stats(memcg);
 	nr_backing = memcg_page_state(memcg, MEMCG_ZSWAP_B) >> PAGE_SHIFT;
 	nr_stored = memcg_page_state(memcg, MEMCG_ZSWAPPED);
 #else
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maintainers-add-andrew-morton-for-lib.patch
mm-memoryc-zap_pte_range-print-bad-swap-entry.patch
mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
mm-add-folio_zero_tail-and-use-it-in-ext4-fix.patch
mm-add-folio_fill_tail-and-use-it-in-iomap-fix.patch
mm-memcg-restore-subtree-stats-flushing-fix.patch
kernel-reboot-explicitly-notify-if-halt-occurred-instead-of-power-off-fix.patch


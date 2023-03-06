Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9E13C6FD1A
	for <mm-commits@archiver.kernel.org>; Mon,  6 Mar 2023 20:54:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbjCFUyH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Mar 2023 15:54:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbjCFUyG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Mar 2023 15:54:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 799473B0CB
        for <mm-commits@vger.kernel.org>; Mon,  6 Mar 2023 12:54:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1538561176
        for <mm-commits@vger.kernel.org>; Mon,  6 Mar 2023 20:54:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DFFEC433EF;
        Mon,  6 Mar 2023 20:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678136040;
        bh=+mEOpNowlTviKm/87fcsffyekYq/THMx2WyfvcwcFOg=;
        h=Date:To:From:Subject:From;
        b=yUY+WDJcyGDyAMrCElossKQO74dsPkirGp+PpfHUil7bXDSAywwYkuSqOQTOjYwRV
         cfymajblirlarLtNPaygZgJX9f3SKV9kWtV4q/GIaJdQwdNLgEfOxSwAbX/W/FSB9q
         PRyx26nMRzbaekdvlI4+jMXc5Ma5ZgeA8ae08yNc=
Date:   Mon, 06 Mar 2023 12:53:59 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tangyeechou@gmail.com, shakeelb@google.com,
        roman.gushchin@linux.dev, muchun.song@linux.dev, mhocko@suse.com,
        hannes@cmpxchg.org, findns94@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-prevent-memorysoft_limit_in_bytes-load-store-tearing.patch added to mm-unstable branch
Message-Id: <20230306205400.6DFFEC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, memcg: Prevent memory.soft_limit_in_bytes load/store tearing
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-prevent-memorysoft_limit_in_bytes-load-store-tearing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-prevent-memorysoft_limit_in_bytes-load-store-tearing.patch

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
Subject: mm, memcg: Prevent memory.soft_limit_in_bytes load/store tearing
Date: Mon, 6 Mar 2023 23:41:38 +0800

The knob for cgroup v1 memory controller: memory.soft_limit_in_bytes
is not protected by any locking so it can be modified while it is used.
This is not an actual problem because races are unlikely.
But it is better to use READ_ONCE/WRITE_ONCE to prevent compiler from
doing anything funky.

The access of memcg->soft_limit is lockless,
so it can be concurrently set at the same time as we are
trying to read it.

Link: https://lkml.kernel.org/r/20230306154138.3775-5-findns94@gmail.com
Signed-off-by: Yue Zhao <findns94@gmail.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Tang Yizhou <tangyeechou@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/memcontrol.c~mm-memcg-prevent-memorysoft_limit_in_bytes-load-store-tearing
+++ a/mm/memcontrol.c
@@ -3728,7 +3728,7 @@ static u64 mem_cgroup_read_u64(struct cg
 	case RES_FAILCNT:
 		return counter->failcnt;
 	case RES_SOFT_LIMIT:
-		return (u64)memcg->soft_limit * PAGE_SIZE;
+		return (u64)READ_ONCE(memcg->soft_limit) * PAGE_SIZE;
 	default:
 		BUG();
 	}
@@ -3870,7 +3870,7 @@ static ssize_t mem_cgroup_write(struct k
 		if (IS_ENABLED(CONFIG_PREEMPT_RT)) {
 			ret = -EOPNOTSUPP;
 		} else {
-			memcg->soft_limit = nr_pages;
+			WRITE_ONCE(memcg->soft_limit, nr_pages);
 			ret = 0;
 		}
 		break;
_

Patches currently in -mm which might be from findns94@gmail.com are

mm-memcg-prevent-memoryoomgroup-load-store-tearing.patch
mm-memcg-prevent-memoryswappiness-load-store-tearing.patch
mm-memcg-prevent-memoryoom_control-load-store-tearing.patch
mm-memcg-prevent-memorysoft_limit_in_bytes-load-store-tearing.patch


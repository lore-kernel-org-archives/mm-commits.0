Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77EA1C4167B
	for <mm-commits@archiver.kernel.org>; Tue,  5 Dec 2023 19:48:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbjLETs1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Dec 2023 14:48:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjLETsZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Dec 2023 14:48:25 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9AA4C9
        for <mm-commits@vger.kernel.org>; Tue,  5 Dec 2023 11:48:31 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67970C433CA;
        Tue,  5 Dec 2023 19:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701805711;
        bh=FDJ0BVwTYCy9n5hrXWgy701AicNQqc1MZ9bhSXa6zzE=;
        h=Date:To:From:Subject:From;
        b=LTpOMxRp55UnfphhUqEULiGGUu6YXxyBYvhX3bfmnIeC0dc1Fb0F8Xl/vVcQDDFgp
         NQRwPmns9x9YcepA6Xb0dDtoKghDTc1PUnKPMvqPHH2+0tOSf8TYTP4uCmb6lEOeJI
         ccHzvxlWep7bRjvj0okX/JPbu5VhSGxBYfI+9nTc=
Date:   Tue, 05 Dec 2023 11:48:30 -0800
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        vitaly.wool@konsulko.com, sjenning@redhat.com, shuah@kernel.org,
        shakeelb@google.com, roman.gushchin@linux.dev,
        muchun.song@linux.dev, mhocko@kernel.org, hannes@cmpxchg.org,
        ddstreet@ieee.org, chrisl@kernel.org, cerasuolodomenico@gmail.com,
        bagasdotme@gmail.com, nphamcs@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-add-per-memcg-zswap-writeback-stat-fix.patch added to mm-unstable branch
Message-Id: <20231205194831.67970C433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg: add per-memcg zswap writeback stat (fix)
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-add-per-memcg-zswap-writeback-stat-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-add-per-memcg-zswap-writeback-stat-fix.patch

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
From: Nhat Pham <nphamcs@gmail.com>
Subject: mm: memcg: add per-memcg zswap writeback stat (fix)
Date: Tue, 5 Dec 2023 11:33:07 -0800

Rename ZSWP_WB to ZSWPWB to better match the existing counters naming
scheme.

Link: https://lkml.kernel.org/r/20231205193307.2432803-1-nphamcs@gmail.com
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vm_event_item.h |    2 +-
 mm/memcontrol.c               |    2 +-
 mm/vmstat.c                   |    2 +-
 mm/zswap.c                    |    4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)

--- a/include/linux/vm_event_item.h~mm-memcg-add-per-memcg-zswap-writeback-stat-fix
+++ a/include/linux/vm_event_item.h
@@ -142,7 +142,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 #ifdef CONFIG_ZSWAP
 		ZSWPIN,
 		ZSWPOUT,
-		ZSWP_WB,
+		ZSWPWB,
 #endif
 #ifdef CONFIG_X86
 		DIRECT_MAP_LEVEL2_SPLIT,
--- a/mm/memcontrol.c~mm-memcg-add-per-memcg-zswap-writeback-stat-fix
+++ a/mm/memcontrol.c
@@ -703,7 +703,7 @@ static const unsigned int memcg_vm_event
 #if defined(CONFIG_MEMCG_KMEM) && defined(CONFIG_ZSWAP)
 	ZSWPIN,
 	ZSWPOUT,
-	ZSWP_WB,
+	ZSWPWB,
 #endif
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	THP_FAULT_ALLOC,
--- a/mm/vmstat.c~mm-memcg-add-per-memcg-zswap-writeback-stat-fix
+++ a/mm/vmstat.c
@@ -1401,7 +1401,7 @@ const char * const vmstat_text[] = {
 #ifdef CONFIG_ZSWAP
 	"zswpin",
 	"zswpout",
-	"zswp_wb",
+	"zswpwb",
 #endif
 #ifdef CONFIG_X86
 	"direct_map_level2_splits",
--- a/mm/zswap.c~mm-memcg-add-per-memcg-zswap-writeback-stat-fix
+++ a/mm/zswap.c
@@ -761,9 +761,9 @@ static enum lru_status shrink_memcg_cb(s
 	zswap_written_back_pages++;
 
 	if (entry->objcg)
-		count_objcg_event(entry->objcg, ZSWP_WB);
+		count_objcg_event(entry->objcg, ZSWPWB);
 
-	count_vm_event(ZSWP_WB);
+	count_vm_event(ZSWPWB);
 	/*
 	 * Writeback started successfully, the page now belongs to the
 	 * swapcache. Drop the entry from zswap - unless invalidate already
_

Patches currently in -mm which might be from nphamcs@gmail.com are

list_lru-allows-explicit-memcg-and-numa-node-selection.patch
memcontrol-implement-mem_cgroup_tryget_online.patch
mm-memcg-add-per-memcg-zswap-writeback-stat-fix.patch
zswap-shrinks-zswap-pool-based-on-memory-pressure.patch


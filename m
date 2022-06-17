Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AF7AC43334
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 02:40:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379539AbiFQCkq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:40:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233045AbiFQCkq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 22:40:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D03464D18
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 19:40:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B21661D0D
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 02:40:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FAE9C34114;
        Fri, 17 Jun 2022 02:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655433644;
        bh=ygbBk+a0rQqorVpc+U739j0RWTDQvxHydtcjp7OBFrI=;
        h=Date:To:From:Subject:From;
        b=tDbLdbN9oNEVA/fCQMzf6tgjnzAVKXvmcwW+CFCtiBdyi0ZSc0K3RDl9/Cd5/Q/zM
         xIxnEeetlX0sfe9b7T+v3K64kFWB0x1FxaEpRaXlpZ+RxpBWFOyNMBQXP3t7piyj4a
         hk5/498Uo5jU1k4id3ssIZBbxbspbgALwc6hftX0=
Date:   Thu, 16 Jun 2022 19:40:43 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shakeelb@google.com, roman.gushchin@linux.dev, mhocko@suse.com,
        hannes@cmpxchg.org, zhengqi.arch@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memcontrol-add-pgscanpgsteal_kswapddirect-items-in-memorystat-of-cgroup-v2-v4.patch removed from -mm tree
Message-Id: <20220617024044.7FAE9C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-memcontrol-add-pgscanpgsteal_kswapddirect-items-in-memorystat-of-cgroup-v2-v4
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-add-pgscanpgsteal_kswapddirect-items-in-memorystat-of-cgroup-v2-v4.patch

This patch was dropped because it was folded into mm-memcontrol-add-pgscanpgsteal_kswapddirect-items-in-memorystat-of-cgroup-v2.patch

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm-memcontrol-add-pgscanpgsteal_kswapddirect-items-in-memorystat-of-cgroup-v2-v4
Date: Tue, 7 Jun 2022 14:48:03 +0800

fix the doc, thanks to Johannes

Link: https://lkml.kernel.org/r/20220607064803.79363-1-zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |   24 +++++++++++-----------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/Documentation/admin-guide/cgroup-v2.rst~mm-memcontrol-add-pgscanpgsteal_kswapddirect-items-in-memorystat-of-cgroup-v2-v4
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1433,33 +1433,33 @@ PAGE_SIZE multiple when read back.
 	  workingset_nodereclaim
 		Number of times a shadow node has been reclaimed
 
-	  pgfault (npn)
-		Total number of page faults incurred
-
-	  pgmajfault (npn)
-		Number of major page faults incurred
-
-	  pgrefill (npn)
-		Amount of scanned pages (in an active LRU list)
-
 	  pgscan (npn)
 		Amount of scanned pages (in an inactive LRU list)
 
+	  pgsteal (npn)
+		Amount of reclaimed pages
+
 	  pgscan_kswapd (npn)
 		Amount of scanned pages by kswapd (in an inactive LRU list)
 
 	  pgscan_direct (npn)
 		Amount of scanned pages directly  (in an inactive LRU list)
 
-	  pgsteal (npn)
-		Amount of reclaimed pages
-
 	  pgsteal_kswapd (npn)
 		Amount of reclaimed pages by kswapd
 
 	  pgsteal_direct (npn)
 		Amount of reclaimed pages directly
 
+	  pgfault (npn)
+		Total number of page faults incurred
+
+	  pgmajfault (npn)
+		Number of major page faults incurred
+
+	  pgrefill (npn)
+		Amount of scanned pages (in an active LRU list)
+
 	  pgactivate (npn)
 		Amount of pages moved to the active LRU list
 
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-memcontrol-add-pgscanpgsteal_kswapddirect-items-in-memorystat-of-cgroup-v2.patch


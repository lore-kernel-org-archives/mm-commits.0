Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03BAFC433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Jun 2022 01:10:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359214AbiFHBKG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Jun 2022 21:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1588449AbiFGXyk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jun 2022 19:54:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA603ED3F
        for <mm-commits@vger.kernel.org>; Tue,  7 Jun 2022 16:08:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 41CB26135B
        for <mm-commits@vger.kernel.org>; Tue,  7 Jun 2022 23:08:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CE04C3411C;
        Tue,  7 Jun 2022 23:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654643314;
        bh=XmnznVDY4TpKx5plp0P0yk3au5nmfXP9as+LHQHYWAE=;
        h=Date:To:From:Subject:From;
        b=aQkTARWy84iSpCo/wqc0iK7K3U2djcROKLxWIbV9npZHdzPocaLrNduIvnwo/Ye/W
         WQ87Pfm+MMMQZUAoLzyJQcLpv4IZVnGsQvxjhQB4lHwCBKkgELnNw+o/J6bgloUsRQ
         Ol0cMe3PpUrjistCDMI1CXNmSEN3A/MN0q1L3K50=
Date:   Tue, 07 Jun 2022 16:08:33 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shakeelb@google.com, roman.gushchin@linux.dev, mhocko@suse.com,
        hannes@cmpxchg.org, zhengqi.arch@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-add-pgscanpgsteal_kswapddirect-items-in-memorystat-of-cgroup-v2-v4.patch added to mm-unstable branch
Message-Id: <20220607230834.8CE04C3411C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcontrol-add-pgscanpgsteal_kswapddirect-items-in-memorystat-of-cgroup-v2-v4
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcontrol-add-pgscanpgsteal_kswapddirect-items-in-memorystat-of-cgroup-v2-v4.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-add-pgscanpgsteal_kswapddirect-items-in-memorystat-of-cgroup-v2-v4.patch

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
mm-memcontrol-add-pgscanpgsteal_kswapddirect-items-in-memorystat-of-cgroup-v2-v3.patch
mm-memcontrol-add-pgscanpgsteal_kswapddirect-items-in-memorystat-of-cgroup-v2-v4.patch


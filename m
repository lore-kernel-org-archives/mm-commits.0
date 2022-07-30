Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88B26C00144
	for <mm-commits@archiver.kernel.org>; Sat, 30 Jul 2022 00:55:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239572AbiG3Azr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 20:55:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231613AbiG3Azp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 20:55:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33BF5F5AF
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 17:55:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9A27B829FD
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 00:55:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84A04C433C1;
        Sat, 30 Jul 2022 00:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659142541;
        bh=+UkgObl0CaS+7kp6YCWd99bSo6mqBLmaIn+soVjViqI=;
        h=Date:To:From:Subject:From;
        b=mrSAagjzJLsSrf/RDvZsUPcfzKTybWQsqViXk5YN2KDgBPydJC+xRLqepvVPnsYmZ
         q1qw6rLmxegFpvEhvlzSh2dtS8rmrmXH8KuIZII6qAia8BjJo1c82DO7QYuKoAlzvl
         qxzHFbwF8gGNQPNb6GcK4E+OlvpyzZe2uNhvoL9w=
Date:   Fri, 29 Jul 2022 17:55:40 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        surenb@google.com, songmuchun@bytedance.com, shakeelb@google.com,
        roman.gushchin@linux.dev, peterx@redhat.com, neilb@suse.de,
        mhocko@suse.com, linmiaohe@huawei.com, hannes@cmpxchg.org,
        david@redhat.com, apopple@nvidia.com, yosryahmed@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-vmpressure-dont-count-proactive-reclaim-in-vmpressure-v5.patch removed from -mm tree
Message-Id: <20220730005541.84A04C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-vmpressure-dont-count-proactive-reclaim-in-vmpressure-v5
has been removed from the -mm tree.  Its filename was
     mm-vmpressure-dont-count-proactive-reclaim-in-vmpressure-v5.patch

This patch was dropped because it was folded into mm-vmpressure-dont-count-proactive-reclaim-in-vmpressure.patch

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: mm-vmpressure-dont-count-proactive-reclaim-in-vmpressure-v5
Date: Thu, 21 Jul 2022 17:30:15 +0000

update documentation

Link: https://lkml.kernel.org/r/20220721173015.2643248-1-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: NeilBrown <neilb@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/Documentation/admin-guide/cgroup-v2.rst~mm-vmpressure-dont-count-proactive-reclaim-in-vmpressure-v5
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1229,6 +1229,13 @@ PAGE_SIZE multiple when read back.
 	the target cgroup. If less bytes are reclaimed than the
 	specified amount, -EAGAIN is returned.
 
+	Please note that the proactive reclaim (triggered by this
+	interface) is not meant to indicate memory pressure on the
+	memory cgroup. Therefore socket memory balancing triggered by
+	the memory reclaim normally is not exercised in this case.
+	This means that the networking layer will not adapt based on
+	reclaim induced by memory.reclaim.
+
   memory.peak
 	A read-only single value file which exists on non-root
 	cgroups.
_

Patches currently in -mm which might be from yosryahmed@google.com are

mm-vmpressure-dont-count-proactive-reclaim-in-vmpressure.patch


Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50067C7EE25
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:32:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232505AbjFIXb7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232954AbjFIXbM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:31:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 096FD44AB
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:29:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE2B363EA3
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:29:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C3AC433EF;
        Fri,  9 Jun 2023 23:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353345;
        bh=FBRRW9v2T54W91br2TnhKX7i4OxCapn/fJYWARXuo6Q=;
        h=Date:To:From:Subject:From;
        b=d/UJ7jpgOz579NxXMfc2PdsOdKF4DQkUwbPgfcONL6zeuVYO4Q4lUnj55GW0QPobh
         ZXywypxAJjTmdmvPnbLqXe7Yz1dFqM7Y8H9hKTNj/bPogZhTgNJaceb6jJSYx9MyCB
         3b5tQKqPD4JEaK6Z7cakOyPK/2dxZukt1O1m6uEs=
Date:   Fri, 09 Jun 2023 16:29:04 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@kernel.org, hannes@cmpxchg.org,
        haifeng.xu@shopee.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-cgroup-fix-unexpected-failure-on-test_memcg_low.patch removed from -mm tree
Message-Id: <20230609232905.44C3AC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests: cgroup: fix unexpected failure on test_memcg_low
has been removed from the -mm tree.  Its filename was
     selftests-cgroup-fix-unexpected-failure-on-test_memcg_low.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Haifeng Xu <haifeng.xu@shopee.com>
Subject: selftests: cgroup: fix unexpected failure on test_memcg_low
Date: Mon, 22 May 2023 09:52:33 +0000

Since commit f079a020ba95 ("selftests: memcg: factor out common parts of
memory.{low,min} tests"), the value used in second alloc_anon has changed
from 148M to 170M.  Because memory.low allows reclaiming page cache in
child cgroups, so the memory.current is close to 30M instead of 50M. 
Therefore, adjust the expected value of parent cgroup.

Link: https://lkml.kernel.org/r/20230522095233.4246-2-haifeng.xu@shopee.com
Fixes: f079a020ba95 ("selftests: memcg: factor out common parts of memory.{low,min} tests")
Signed-off-by: Haifeng Xu <haifeng.xu@shopee.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_memcontrol.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/cgroup/test_memcontrol.c~selftests-cgroup-fix-unexpected-failure-on-test_memcg_low
+++ a/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -292,6 +292,7 @@ static int test_memcg_protection(const c
 	char *children[4] = {NULL};
 	const char *attribute = min ? "memory.min" : "memory.low";
 	long c[4];
+	long current;
 	int i, attempts;
 	int fd;
 
@@ -400,7 +401,8 @@ static int test_memcg_protection(const c
 		goto cleanup;
 	}
 
-	if (!values_close(cg_read_long(parent[1], "memory.current"), MB(50), 3))
+	current = min ? MB(50) : MB(30);
+	if (!values_close(cg_read_long(parent[1], "memory.current"), current, 3))
 		goto cleanup;
 
 	if (!reclaim_until(children[0], MB(10)))
_

Patches currently in -mm which might be from haifeng.xu@shopee.com are

mm-mm_initc-drop-nid-parameter-from-check_for_memory.patch
mm-memory_hotplug-remove-reset_node_managed_pages-in-hotadd_init_pgdat.patch
mm-mm_initc-remove-reset_node_present_pages.patch
fork-optimize-memcg_charge_kernel_stack-a-bit.patch


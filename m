Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC979C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 26 May 2022 21:03:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234335AbiEZVDw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 26 May 2022 17:03:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232749AbiEZVDv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 26 May 2022 17:03:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EA3867D2A
        for <mm-commits@vger.kernel.org>; Thu, 26 May 2022 14:03:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05300B82217
        for <mm-commits@vger.kernel.org>; Thu, 26 May 2022 21:03:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A08E6C385B8;
        Thu, 26 May 2022 21:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653599027;
        bh=YYJm707Cr4NhiqzJXnxOrrUIfxKR351FgG01/O2933g=;
        h=Date:To:From:Subject:From;
        b=NvROwZ17ORimFk7Mh5VoeGQxsE8ZphGQ8rOyQcVYrtDA7qrLMBZF9klzsZhfLpngP
         B/OlH4ublT1ptk9wMS1BzD3+1vnfBvF7fiCPBQKxj1FmlfJHeIP0Lj+2zoqsu7tF+G
         77WzZj8goBfvNcT/DsHGZ11x+h2dejegXNpu0pI4=
Date:   Thu, 26 May 2022 14:03:46 -0700
To:     mm-commits@vger.kernel.org, void@manifault.com, tj@kernel.org,
        songmuchun@bytedance.com, shuah@kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@kernel.org,
        lizefan.x@bytedance.com, hannes@cmpxchg.org,
        dan.carpenter@oracle.com, akpm@linux-foundation.org,
        christophe.jaillet@wanadoo.fr, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] cgroup-fix-an-error-handling-path-in-alloc_pagecache_max_30m.patch removed from -mm tree
Message-Id: <20220526210347.A08E6C385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: cgroup: fix an error handling path in alloc_pagecache_max_30M()
has been removed from the -mm tree.  Its filename was
     cgroup-fix-an-error-handling-path-in-alloc_pagecache_max_30m.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: cgroup: fix an error handling path in alloc_pagecache_max_30M()
Date: Sun, 22 May 2022 16:18:51 +0200

If the first goto is taken, 'fd' is not opened yet (and is un-initialized).
So a direct return is safer.

Link: https://lkml.kernel.org/r/628312312eb40e0e39463a2c06415fde5295c716.1653229120.git.christophe.jaillet@wanadoo.fr
Fixes: c1a31a2f7a9c ("cgroup: fix racy check in alloc_pagecache_max_30M() helper function")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: David Vernet <void@manifault.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/cgroup/test_memcontrol.c~cgroup-fix-an-error-handling-path-in-alloc_pagecache_max_30m
+++ a/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -574,7 +574,7 @@ static int alloc_pagecache_max_30M(const
 	high = cg_read_long(cgroup, "memory.high");
 	max = cg_read_long(cgroup, "memory.max");
 	if (high != MB(30) && max != MB(30))
-		goto cleanup;
+		return -1;
 
 	fd = get_temp_fd();
 	if (fd < 0)
_

Patches currently in -mm which might be from christophe.jaillet@wanadoo.fr are



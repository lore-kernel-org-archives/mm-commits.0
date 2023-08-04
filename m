Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF0B6C04FDF
	for <mm-commits@archiver.kernel.org>; Fri,  4 Aug 2023 20:04:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbjHDUEv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Aug 2023 16:04:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbjHDUEr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 4 Aug 2023 16:04:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CCC41706
        for <mm-commits@vger.kernel.org>; Fri,  4 Aug 2023 13:04:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B1686210F
        for <mm-commits@vger.kernel.org>; Fri,  4 Aug 2023 20:04:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83B70C433C7;
        Fri,  4 Aug 2023 20:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691179464;
        bh=MUSDU3g6kqYvEWo8C3jLGUchM340yeTHPJ/oaKNkbiI=;
        h=Date:To:From:Subject:From;
        b=vCbsj/ABLx7jg89hvAnQbGuSnb0p0fi+h7atDHpfp17TSJ+iZt3Z5PoS5WKCAI1fN
         eipq+flBexsVmCzUM288DO8FlxJ10tie2D8D6mszB7afCY679HJIElTaHkGxbLp4ym
         6snPzm0xU8AXlauZhhOVhZwvf2XqWMD9unuC91UI=
Date:   Fri, 04 Aug 2023 13:04:23 -0700
To:     mm-commits@vger.kernel.org, roman.gushchin@linux.dev,
        paulmck@kernel.org, mhocko@suse.com, hannes@cmpxchg.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-cgroup-fix-test_kmem_basic-false-positives.patch removed from -mm tree
Message-Id: <20230804200424.83B70C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests: cgroup: fix test_kmem_basic false positives
has been removed from the -mm tree.  Its filename was
     selftests-cgroup-fix-test_kmem_basic-false-positives.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: selftests: cgroup: fix test_kmem_basic false positives
Date: Tue, 1 Aug 2023 09:56:32 -0400

This test fails routinely in our prod testing environment, and I can
reproduce it locally as well.

The test allocates dcache inside a cgroup, then drops the memory limit
and checks that usage drops correspondingly. The reason it fails is
because dentries are freed with an RCU delay - a debugging sleep shows
that usage drops as expected shortly after.

Insert a 1s sleep after dropping the limit. This should be good
enough, assuming that machines running those tests are otherwise not
very busy.

Link: https://lkml.kernel.org/r/20230801135632.1768830-1-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Paul E. McKenney <paulmck@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_kmem.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/tools/testing/selftests/cgroup/test_kmem.c~selftests-cgroup-fix-test_kmem_basic-false-positives
+++ a/tools/testing/selftests/cgroup/test_kmem.c
@@ -70,6 +70,10 @@ static int test_kmem_basic(const char *r
 		goto cleanup;
 
 	cg_write(cg, "memory.high", "1M");
+
+	/* wait for RCU freeing */
+	sleep(1);
+
 	slab1 = cg_read_key_long(cg, "memory.stat", "slab ");
 	if (slab1 <= 0)
 		goto cleanup;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-kill-frontswap.patch
mm-kill-frontswap-fix.patch
mm-zswap-use-zswap_invalidate_entry-for-duplicates.patch
mm-zswap-tighten-up-entry-invalidation.patch
mm-zswap-kill-zswap_get_swap_cache_page.patch


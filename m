Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29432C0015E
	for <mm-commits@archiver.kernel.org>; Tue,  1 Aug 2023 18:38:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbjHASiN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Aug 2023 14:38:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjHASiM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Aug 2023 14:38:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA91DDB
        for <mm-commits@vger.kernel.org>; Tue,  1 Aug 2023 11:38:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6AC9261684
        for <mm-commits@vger.kernel.org>; Tue,  1 Aug 2023 18:38:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5849C433C7;
        Tue,  1 Aug 2023 18:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690915086;
        bh=IMMRjaAHi+uwfCpju20UXFIGMRgVFt403zerexFN3MQ=;
        h=Date:To:From:Subject:From;
        b=STOjBhEm1Y3jd93TIRXIYcst3a/zZwZVVMBVb0dQYhjrLiecMk3PdkPTdHAowHK8j
         yDTXMOUTgoPmnkpxR39JWgxT/zzCTCtP4MOF3rgt8L+o5e2355WTlT2Q/lzYsyoeqA
         ntMBJJxnYa9UeYEufk9UA1RooADJOtNh5THfsCN4=
Date:   Tue, 01 Aug 2023 11:38:06 -0700
To:     mm-commits@vger.kernel.org, roman.gushchin@linux.dev,
        paulmck@kernel.org, mhocko@suse.com, hannes@cmpxchg.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-cgroup-fix-test_kmem_basic-false-positives.patch added to mm-hotfixes-unstable branch
Message-Id: <20230801183806.B5849C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: cgroup: fix test_kmem_basic false positives
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-cgroup-fix-test_kmem_basic-false-positives.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-cgroup-fix-test_kmem_basic-false-positives.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

mm-compaction-fix-endless-looping-over-same-migrate-block.patch
selftests-cgroup-fix-test_kmem_basic-false-positives.patch
mm-kill-frontswap.patch
mm-kill-frontswap-fix.patch
mm-zswap-use-zswap_invalidate_entry-for-duplicates.patch
mm-zswap-tighten-up-entry-invalidation.patch
mm-zswap-kill-zswap_get_swap_cache_page.patch


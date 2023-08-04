Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8806BC001DB
	for <mm-commits@archiver.kernel.org>; Fri,  4 Aug 2023 19:42:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbjHDTmI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Aug 2023 15:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbjHDTmH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 4 Aug 2023 15:42:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48BF71BF
        for <mm-commits@vger.kernel.org>; Fri,  4 Aug 2023 12:42:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB41F620EE
        for <mm-commits@vger.kernel.org>; Fri,  4 Aug 2023 19:42:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37B61C433C7;
        Fri,  4 Aug 2023 19:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691178125;
        bh=SFMdX9Ny8vls5M/N/pk3QuQhe9bnso9iR0yu8VxT4TU=;
        h=Date:To:From:Subject:From;
        b=FoL8zwaPRIvKYX0GfLYVAggRoi1lMJcB46Tg403hvfzsn54/IqUkT1USSzp1cV7yz
         U5dCxAUdJBSuX1Ga0RIxMx0RsvAdSf0F98gW5rJP4lM5xdq0HQW+nirY/FJxAo8Cny
         ZomFhjm4HSayckEqgXI/knM01XkIEt4qegXsh/jE=
Date:   Fri, 04 Aug 2023 12:42:04 -0700
To:     mm-commits@vger.kernel.org, tj@kernel.org, shuah@kernel.org,
        shakeelb@google.com, roman.gushchin@linux.dev,
        muchun.song@linux.dev, mhocko@kernel.org, lizefan.x@bytedance.com,
        hannes@cmpxchg.org, lkarpins@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-cgroup-fix-test_kmem_basic-less-than-error.patch added to mm-hotfixes-unstable branch
Message-Id: <20230804194205.37B61C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: cgroup: fix test_kmem_basic less than error
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-cgroup-fix-test_kmem_basic-less-than-error.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-cgroup-fix-test_kmem_basic-less-than-error.patch

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
From: Lucas Karpinski <lkarpins@redhat.com>
Subject: selftests: cgroup: fix test_kmem_basic less than error
Date: Fri, 4 Aug 2023 15:35:29 -0400

test_kmem_basic creates 100,000 negative dentries, with each one mapping
to a slab object.  After memory.high is set, these are reclaimed through
the shrink_slab function call which reclaims all 100,000 entries.  The
test passes the majority of the time because when slab1 or current is
calculated, it is often above 0, however, 0 is also an acceptable value.

Link: https://lkml.kernel.org/r/7d6gcuyzdjcice6qbphrmpmv5skr5jtglg375unnjxqhstvhxc@qkn6dw6bao6v
Signed-off-by: Lucas Karpinski <lkarpins@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_kmem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/cgroup/test_kmem.c~selftests-cgroup-fix-test_kmem_basic-less-than-error
+++ a/tools/testing/selftests/cgroup/test_kmem.c
@@ -75,11 +75,11 @@ static int test_kmem_basic(const char *r
 	sleep(1);
 
 	slab1 = cg_read_key_long(cg, "memory.stat", "slab ");
-	if (slab1 <= 0)
+	if (slab1 < 0)
 		goto cleanup;
 
 	current = cg_read_long(cg, "memory.current");
-	if (current <= 0)
+	if (current < 0)
 		goto cleanup;
 
 	if (slab1 < slab0 / 2 && current < slab0 / 2)
_

Patches currently in -mm which might be from lkarpins@redhat.com are

selftests-cgroup-fix-test_kmem_basic-less-than-error.patch


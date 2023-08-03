Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 842F5C41513
	for <mm-commits@archiver.kernel.org>; Thu,  3 Aug 2023 18:30:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232473AbjHCSa2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Aug 2023 14:30:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232399AbjHCSa1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 3 Aug 2023 14:30:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00D552726
        for <mm-commits@vger.kernel.org>; Thu,  3 Aug 2023 11:30:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C50C61D71
        for <mm-commits@vger.kernel.org>; Thu,  3 Aug 2023 18:30:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E02CBC433C9;
        Thu,  3 Aug 2023 18:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691087426;
        bh=aOixec4/IxFE5KNEwblMW6MBNG+Yq7zpcLIsOWGeY80=;
        h=Date:To:From:Subject:From;
        b=bBk+wlwAUsPqPyD48phFTP9H+6jS4cdowNM0xZkMZWf2uMH/2CJGQVjUE79hSLZmk
         GYGYU2/4SpV3BgLG74Zu6xsbYSPTEcxAtRFDh/jZGR7BIUElktRWGa6PsUMns+IY8T
         y85YKh4TleuRHh0E4D5LY0ppxkgM/5dZBTPy7OZA=
Date:   Thu, 03 Aug 2023 11:30:25 -0700
To:     mm-commits@vger.kernel.org, tj@kernel.org, shuah@kernel.org,
        shakeelb@google.com, roman.gushchin@linux.dev,
        muchun.song@linux.dev, mhocko@kernel.org, lizefan.x@bytedance.com,
        hannes@cmpxchg.org, lkarpins@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-cgroup-fix-test_kmem_basic-slab1-check.patch added to mm-hotfixes-unstable branch
Message-Id: <20230803183025.E02CBC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: cgroup: fix test_kmem_basic slab1 check
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-cgroup-fix-test_kmem_basic-slab1-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-cgroup-fix-test_kmem_basic-slab1-check.patch

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
Subject: selftests: cgroup: fix test_kmem_basic slab1 check
Date: Thu, 3 Aug 2023 14:25:00 -0400

test_kmem_basic creates 100,000 negative dentries, with each one mapping
to a slab object.  After memory.high is set, these are reclaimed through
the shrink_slab function call which reclaims all 100,000 entries.  The
test passes the majority of the time because when slab1 is calculated, it
is often above 0, however, 0 is also an acceptable value.

Link: https://lkml.kernel.org/r/zff2gqiy4cggy4px2hbcyna6eipy56qc4itx5cx5agtxlzdxt7@dvfdarqkucac
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

 tools/testing/selftests/cgroup/test_kmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/cgroup/test_kmem.c~selftests-cgroup-fix-test_kmem_basic-slab1-check
+++ a/tools/testing/selftests/cgroup/test_kmem.c
@@ -75,7 +75,7 @@ static int test_kmem_basic(const char *r
 	sleep(1);
 
 	slab1 = cg_read_key_long(cg, "memory.stat", "slab ");
-	if (slab1 <= 0)
+	if (slab1 < 0)
 		goto cleanup;
 
 	current = cg_read_long(cg, "memory.current");
_

Patches currently in -mm which might be from lkarpins@redhat.com are

selftests-cgroup-fix-test_kmem_basic-slab1-check.patch


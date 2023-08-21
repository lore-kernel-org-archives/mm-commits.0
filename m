Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE6CCEE49A8
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:08:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbjHUUIL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbjHUUIJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:08:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D0B12A
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:08:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61ADA649E4
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:08:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA26EC433C7;
        Mon, 21 Aug 2023 20:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692648485;
        bh=+VHOgIP3G4MOeachDH5QU5sIRa+jjKHFUFxIPxidk7I=;
        h=Date:To:From:Subject:From;
        b=OIuXslHIiWBexEA4oWySILkCZP7R3DsCcGoyOOVrrJmMiY94GxEi6vhFukJ+grVOK
         WwBg8aSflrOQFsGo0E0nzxlvUQd1MGmIwrOobYeeoJV+3zS0ddoOaC0Fg9+lnlVtzV
         29E1ykbPi3x+OTsZYozQxrHEiicrWd9FHrRLwD8s=
Date:   Mon, 21 Aug 2023 13:08:05 -0700
To:     mm-commits@vger.kernel.org, tj@kernel.org, shuah@kernel.org,
        shakeelb@google.com, roman.gushchin@linux.dev,
        muchun.song@linux.dev, mhocko@kernel.org, lizefan.x@bytedance.com,
        hannes@cmpxchg.org, lkarpins@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-cgroup-fix-test_kmem_basic-less-than-error.patch removed from -mm tree
Message-Id: <20230821200805.BA26EC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests: cgroup: fix test_kmem_basic less than error
has been removed from the -mm tree.  Its filename was
     selftests-cgroup-fix-test_kmem_basic-less-than-error.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

selftests-cgroup-fix-test_kmem_memcg_deletion-kernel-mem-check.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A68FCC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 19 Apr 2022 05:03:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235757AbiDSFFy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Apr 2022 01:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236113AbiDSFFt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Apr 2022 01:05:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AC98140BC
        for <mm-commits@vger.kernel.org>; Mon, 18 Apr 2022 22:03:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2036B612EA
        for <mm-commits@vger.kernel.org>; Tue, 19 Apr 2022 05:03:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69737C385A7;
        Tue, 19 Apr 2022 05:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650344587;
        bh=DrTp1m2p/WVJ363yFI7/HzKhdErqV5X562d7fAbQIx0=;
        h=Date:To:From:Subject:From;
        b=t1CDlByyXHT61HzT7oo9tWu6vLklydShEGXLx1Tfrg9dRJbJX593tcD201Wxgo3gg
         HQ/UTcEvvCMplYKNir8ufAMYZ4k9yiH3umar175TwSMv+V754xpBh/zYTsCtxYXXy0
         M/eQoURtZ9mnOBDqdtvhjbfw/DXZ4ICpwo1mcS9w=
Date:   Mon, 18 Apr 2022 22:03:06 -0700
To:     mm-commits@vger.kernel.org, void@manifault.com, tj@kernel.org,
        shakeelb@google.com, mhocko@kernel.org, lizefan.x@bytedance.com,
        hannes@cmpxchg.org, chris@chrisdown.name, roman.gushchin@linux.dev,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-corresponding-kselftests-to-memcg-entry.patch added to -mm tree
Message-Id: <20220419050307.69737C385A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add corresponding kselftests to memcg entry
has been added to the -mm tree.  Its filename is
     maintainers-add-corresponding-kselftests-to-memcg-entry.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/maintainers-add-corresponding-kselftests-to-memcg-entry.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/maintainers-add-corresponding-kselftests-to-memcg-entry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: MAINTAINERS: add corresponding kselftests to memcg entry

List memory control and kernel memory control kselftests in the memory
resource controller entry.

Link: https://lkml.kernel.org/r/20220415000133.3955987-5-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Chris Down <chris@chrisdown.name>
Cc: David Vernet <void@manifault.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

--- a/MAINTAINERS~maintainers-add-corresponding-kselftests-to-memcg-entry
+++ a/MAINTAINERS
@@ -5027,6 +5027,8 @@ L:	linux-mm@kvack.org
 S:	Maintained
 F:	mm/memcontrol.c
 F:	mm/swap_cgroup.c
+F:	tools/testing/selftests/cgroup/test_kmem.c
+F:	tools/testing/selftests/cgroup/test_memcontrol.c
 
 CORETEMP HARDWARE MONITORING DRIVER
 M:	Fenghua Yu <fenghua.yu@intel.com>
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are

kselftests-memcg-update-the-oom-group-leaf-events-test.patch
kselftests-memcg-speed-up-the-memoryhigh-test.patch
maintainers-add-corresponding-kselftests-to-cgroup-entry.patch
maintainers-add-corresponding-kselftests-to-memcg-entry.patch
mm-do-not-call-add_nr_deferred-with-zero-deferred.patch


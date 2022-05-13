Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09CF7C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:09:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379900AbiEMTJj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:09:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383570AbiEMTJh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:09:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56D923BBEC
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:09:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 09854B83133
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:09:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4B3BC34100;
        Fri, 13 May 2022 19:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652468972;
        bh=/d5rY6pq87dOwpEVoOwFwixIshHQ2Fgm/KCQKS6iWdI=;
        h=Date:To:From:Subject:From;
        b=Ipsc80EAJJ0evZRoVKYzQ9NqnIoOtBk/3xpPffL2mqICk0+q/12QLsH0/J87ZOcN9
         wCWM2cvSrB32pZtevID/bNtPqfZXHO1AyWLxoC4QJO47d1z4Pig4lrrduo3ISsag9c
         45biJxgRyCFLnijpaFsBirrbSQp7QFBBmMAQDPwA=
Date:   Fri, 13 May 2022 12:09:31 -0700
To:     mm-commits@vger.kernel.org, void@manifault.com, tj@kernel.org,
        shakeelb@google.com, rpalethorpe@suse.de, roman.gushchin@linux.dev,
        mhocko@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-memcg-expect-no-low-events-in-unprotected-sibling.patch added to mm-unstable branch
Message-Id: <20220513190932.A4B3BC34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: memcg: expect no low events in unprotected sibling
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-memcg-expect-no-low-events-in-unprotected-sibling.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-memcg-expect-no-low-events-in-unprotected-sibling.patch

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
From: Michal Koutný <mkoutny@suse.com>
Subject: selftests: memcg: expect no low events in unprotected sibling
Date: Fri, 13 May 2022 19:18:09 +0200

This is effectively a revert of commit cdc69458a5f3 ("cgroup: account for
memory_recursiveprot in test_memcg_low()").  The case test_memcg_low will
fail with memory_recursiveprot until resolved in reclaim code.

However, this patch preserves the existing helpers and variables for later
uses.

Link: https://lkml.kernel.org/r/20220513171811.730-3-mkoutny@suse.com
Fixes: cdc69458a5f3 ("cgroup: account for memory_recursiveprot in test_memcg_low()")
Signed-off-by: Michal Koutný <mkoutny@suse.com>
Reviewed-by: David Vernet <void@manifault.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Richard Palethorpe <rpalethorpe@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/cgroup/test_memcontrol.c~selftests-memcg-expect-no-low-events-in-unprotected-sibling
+++ a/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -528,7 +528,7 @@ static int test_memcg_low(const char *ro
 	}
 
 	for (i = 0; i < ARRAY_SIZE(children); i++) {
-		int no_low_events_index = has_recursiveprot ? 2 : 1;
+		int no_low_events_index = 1;
 
 		oom = cg_read_key_long(children[i], "memory.events", "oom ");
 		low = cg_read_key_long(children[i], "memory.events", "low ");
_

Patches currently in -mm which might be from mkoutny@suse.com are

selftests-memcg-fix-compilation.patch
selftests-memcg-expect-no-low-events-in-unprotected-sibling.patch
selftests-memcg-adjust-expected-reclaim-values-of-protected-cgroups.patch
selftests-memcg-remove-protection-from-top-level-memcg.patch


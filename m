Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C07AEC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 27 May 2022 16:37:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349282AbiE0QhI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 27 May 2022 12:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354154AbiE0QfH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2022 12:35:07 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2144F52523
        for <mm-commits@vger.kernel.org>; Fri, 27 May 2022 09:35:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 848C1CE25E9
        for <mm-commits@vger.kernel.org>; Fri, 27 May 2022 16:35:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 149A0C385B8;
        Fri, 27 May 2022 16:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653669304;
        bh=6RvfrsxwlqY9nqMkcVjEV1dThemgugaONeUMNWUsgW0=;
        h=Date:To:From:Subject:From;
        b=UIrTKvMyLzmhXgywW/FUIOQ2LT4rd5rzpXeglNzKlc1x6+Qhfu7/DC5CUAeE+aRh9
         C0uxCshhnUZbdk3MtK0mwZH16dvG8po0Ecpp/tx6TqXZgYaHTA+teTBtYzqzrurUQ3
         aK2RuPcOdPfLyWXUamL3oeuf+M7f3ZLDWoYZCvQo=
Date:   Fri, 27 May 2022 09:35:03 -0700
To:     mm-commits@vger.kernel.org, void@manifault.com,
        shakeelb@google.com, rpalethorpe@suse.de, roman.gushchin@linux.dev,
        mhocko@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-memcg-expect-no-low-events-in-unprotected-sibling.patch removed from -mm tree
Message-Id: <20220527163504.149A0C385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests: memcg: expect no low events in unprotected sibling
has been removed from the -mm tree.  Its filename was
     selftests-memcg-expect-no-low-events-in-unprotected-sibling.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Michal Koutný <mkoutny@suse.com>
Subject: selftests: memcg: expect no low events in unprotected sibling
Date: Wed, 18 May 2022 18:18:56 +0200

This is effectively a revert of commit cdc69458a5f3 ("cgroup: account for
memory_recursiveprot in test_memcg_low()").  The case test_memcg_low will
fail with memory_recursiveprot until resolved in reclaim code.

However, this patch preserves the existing helpers and variables for later
uses.

Link: https://lkml.kernel.org/r/20220518161859.21565-3-mkoutny@suse.com
Signed-off-by: Michal Koutný <mkoutny@suse.com>
Reviewed-by: David Vernet <void@manifault.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Richard Palethorpe <rpalethorpe@suse.de>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
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



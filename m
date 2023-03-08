Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51AE0C64EC4
	for <mm-commits@archiver.kernel.org>; Wed,  8 Mar 2023 20:15:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbjCHUPJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Mar 2023 15:15:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230294AbjCHUOv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Mar 2023 15:14:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40D586286E
        for <mm-commits@vger.kernel.org>; Wed,  8 Mar 2023 12:14:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A156D6193C
        for <mm-commits@vger.kernel.org>; Wed,  8 Mar 2023 20:14:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05726C433EF;
        Wed,  8 Mar 2023 20:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678306470;
        bh=U1qrYUHbQmRFeWohDEaknmMoo2zyOKl1OWlvH6RgBMs=;
        h=Date:To:From:Subject:From;
        b=hk4kmuir6jgTzNxsqDLYq84H5jRH/+BovJkU00zuDkrhvqEedZehBlF9LfAluYahB
         kxVcDbUPMmlDAgtvDAJUw8doLzHqzD/gDbms0o0Hs5uxIS9OwHWjo1BXefDIEYaFYR
         MpupPrhVVc8OtWtFVqkEOQxqVxIYpnwTYJRUB9cA=
Date:   Wed, 08 Mar 2023 12:14:29 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tangyeechou@gmail.com, shakeelb@google.com,
        roman.gushchin@linux.dev, muchun.song@linux.dev, mhocko@suse.com,
        hannes@cmpxchg.org, findns94@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-prevent-memoryoom_control-load-store-tearing-v3.patch added to mm-unstable branch
Message-Id: <20230308201430.05726C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcg-prevent-memoryoom_control-load-store-tearing-v3
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-prevent-memoryoom_control-load-store-tearing-v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-prevent-memoryoom_control-load-store-tearing-v3.patch

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
From: Yue Zhao <findns94@gmail.com>
Subject: mm-memcg-prevent-memoryoom_control-load-store-tearing-v3
Date: Thu, 9 Mar 2023 00:25:54 +0800

Add [WRITE|READ]_ONCE for all occurrences of memcg->oom_kill_disable,
memcg->swappiness and memcg->soft_limit

Link: https://lkml.kernel.org/r/20230308162555.14195-4-findns94@gmail.com
Signed-off-by: Yue Zhao <findns94@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tang Yizhou <tangyeechou@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/memcontrol.c~mm-memcg-prevent-memoryoom_control-load-store-tearing-v3
+++ a/mm/memcontrol.c
@@ -1929,7 +1929,7 @@ static bool mem_cgroup_oom(struct mem_cg
 	 * Please note that mem_cgroup_out_of_memory might fail to find a
 	 * victim and then we have to bail out from the charge path.
 	 */
-	if (memcg->oom_kill_disable) {
+	if (READ_ONCE(memcg->oom_kill_disable)) {
 		if (current->in_user_fault) {
 			css_get(&memcg->css);
 			current->memcg_in_oom = memcg;
@@ -1999,7 +1999,7 @@ bool mem_cgroup_oom_synchronize(bool han
 	if (locked)
 		mem_cgroup_oom_notify(memcg);
 
-	if (locked && !memcg->oom_kill_disable) {
+	if (locked && !READ_ONCE(memcg->oom_kill_disable)) {
 		mem_cgroup_unmark_under_oom(memcg);
 		finish_wait(&memcg_oom_waitq, &owait.wait);
 		mem_cgroup_out_of_memory(memcg, current->memcg_oom_gfp_mask,
@@ -5354,7 +5354,7 @@ mem_cgroup_css_alloc(struct cgroup_subsy
 	page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
 	if (parent) {
 		WRITE_ONCE(memcg->swappiness, mem_cgroup_swappiness(parent));
-		memcg->oom_kill_disable = parent->oom_kill_disable;
+		WRITE_ONCE(memcg->oom_kill_disable, READ_ONCE(parent->oom_kill_disable));
 
 		page_counter_init(&memcg->memory, &parent->memory);
 		page_counter_init(&memcg->swap, &parent->swap);
_

Patches currently in -mm which might be from findns94@gmail.com are

mm-memcg-prevent-memoryoomgroup-load-store-tearing.patch
mm-memcg-prevent-memoryswappiness-load-store-tearing.patch
mm-memcg-prevent-memoryswappiness-load-store-tearing-v3.patch
mm-memcg-prevent-memoryoom_control-load-store-tearing.patch
mm-memcg-prevent-memoryoom_control-load-store-tearing-v3.patch
mm-memcg-prevent-memorysoft_limit_in_bytes-load-store-tearing.patch
mm-memcg-prevent-memorysoft_limit_in_bytes-load-store-tearing-v3.patch


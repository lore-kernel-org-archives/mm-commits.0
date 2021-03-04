Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5992C15505
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 01:09:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BB8D64EFD
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 01:09:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346275AbhCDA7M (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:59:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:48836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1450984AbhCDA0w (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Mar 2021 19:26:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AAA2D64E5F;
        Thu,  4 Mar 2021 00:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614817597;
        bh=tYAkjVsNaq2zTbcWyT1QuyjzU2L8lfSNk2khiszQaW0=;
        h=Date:From:To:Subject:From;
        b=iXAkpU0NhqyKE3dXv3zAET+/kfNhi6MXmVAtyL/hAlSknt6GZxFCqYaE5X+AN/JtT
         tDWk8UPy9eHXOl56s4oITB1q8cPjNzbhlO9WsmDTK8CKDFjFd9i6b8MTDctIbSiiWi
         2qE5IllhvQNJO2ObZgSsPXghFaFNbrqPIdS8Q0As=
Date:   Wed, 03 Mar 2021 16:26:36 -0800
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com
Subject:  + memcg-cleanup-root-memcg-checks.patch added to -mm tree
Message-ID: <20210304002636.aaTaCim1L%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: cleanup root memcg checks
has been added to the -mm tree.  Its filename is
     memcg-cleanup-root-memcg-checks.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/memcg-cleanup-root-memcg-checks.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/memcg-cleanup-root-memcg-checks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shakeel Butt <shakeelb@google.com>
Subject: memcg: cleanup root memcg checks

Replace the implicit checking of root memcg with explicit root memcg
checking i.e.  !css->parent with mem_cgroup_is_root().

Link: https://lkml.kernel.org/r/20210223205625.2792891-1-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~memcg-cleanup-root-memcg-checks
+++ a/mm/memcontrol.c
@@ -4140,7 +4140,7 @@ static int mem_cgroup_swappiness_write(s
 	if (val > 100)
 		return -EINVAL;
 
-	if (css->parent)
+	if (!mem_cgroup_is_root(memcg))
 		memcg->swappiness = val;
 	else
 		vm_swappiness = val;
@@ -4490,7 +4490,7 @@ static int mem_cgroup_oom_control_write(
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
 
 	/* cannot set to root cgroup and only 0 and 1 are allowed */
-	if (!css->parent || !((val == 0) || (val == 1)))
+	if (mem_cgroup_is_root(memcg) || !((val == 0) || (val == 1)))
 		return -EINVAL;
 
 	memcg->oom_kill_disable = val;
_

Patches currently in -mm which might be from shakeelb@google.com are

memcg-cleanup-root-memcg-checks.patch


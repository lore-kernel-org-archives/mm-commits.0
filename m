Return-Path: <SRS0=GXSN=CI=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF7E7C433E6
	for <mm-commits@archiver.kernel.org>; Sun, 30 Aug 2020 22:15:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DECF2054F
	for <mm-commits@archiver.kernel.org>; Sun, 30 Aug 2020 22:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598825727;
	bh=CYJVi1M87TwyRz9z5EByNWwTppUNudXaue+n4TJQeQo=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=pfxAdnT0m+zd3GeJHvOPZtdsiiX9bNwkN+pY5p+wx59/2ndzJ7fwRx/VlPLRNvkzO
	 /HEBxMg9g/xfXqwWDUTZBYnVoYwcFuPeK1qjuGlB/9IEWnko/hiYBlBFdhlUElnR30
	 Tsl+cUHciZeWchkS4eSDpA3moBKimS42ga1Gn0n0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgH3WP1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 30 Aug 2020 18:15:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:40388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726178AbgH3WP0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 30 Aug 2020 18:15:26 -0400
Received: from X1 (unknown [65.49.58.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA25820738;
        Sun, 30 Aug 2020 22:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598825726;
        bh=CYJVi1M87TwyRz9z5EByNWwTppUNudXaue+n4TJQeQo=;
        h=Date:From:To:Subject:From;
        b=sTTe0EssxpHkW80HKaiq16AacBD4u8qnrlYHL2jUdXwDppZPROJHb6BM+dUoa5H4I
         ft4L6udSMr4gXHwjJuGvfNW/0Y1LWG91Ffl0tAmtOgOgvElj3NmH30ZyGJqJhkx2I0
         fghnkj7fuIvsFUDUHTlze20pdeD32R2WMpIBa/Wo=
Date:   Sun, 30 Aug 2020 15:15:25 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, shakeelb@google.com, mhocko@kernel.org,
        hannes@cmpxchg.org, guro@fb.com
Subject:  +
 mm-kmem-remove-redundant-checks-from-get_obj_cgroup_from_current.patch added
 to -mm tree
Message-ID: <20200830221525.yLmI3%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kmem: remove redundant checks from get_obj_cgroup_from_current()
has been added to the -mm tree.  Its filename is
     mm-kmem-remove-redundant-checks-from-get_obj_cgroup_from_current.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kmem-remove-redundant-checks-from-get_obj_cgroup_from_current.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kmem-remove-redundant-checks-from-get_obj_cgroup_from_current.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm: kmem: remove redundant checks from get_obj_cgroup_from_current()

There are checks for current->mm and current->active_memcg in
get_obj_cgroup_from_current(), but these checks are redundant:
memcg_kmem_bypass() called just above performs same checks.

Link: http://lkml.kernel.org/r/20200827225843.1270629-3-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/memcontrol.c~mm-kmem-remove-redundant-checks-from-get_obj_cgroup_from_current
+++ a/mm/memcontrol.c
@@ -2919,9 +2919,6 @@ __always_inline struct obj_cgroup *get_o
 	if (memcg_kmem_bypass())
 		return NULL;
 
-	if (unlikely(!current->mm && !current->active_memcg))
-		return NULL;
-
 	rcu_read_lock();
 	if (unlikely(current->active_memcg))
 		memcg = rcu_dereference(current->active_memcg);
_

Patches currently in -mm which might be from guro@fb.com are

mm-rework-remote-memcg-charging-api-to-support-nesting.patch
mm-kmem-move-memcg_kmem_bypass-calls-to-get_mem-obj_cgroup_from_current.patch
mm-kmem-remove-redundant-checks-from-get_obj_cgroup_from_current.patch
mm-kmem-prepare-remote-memcg-charging-infra-for-interrupt-contexts.patch
mm-kmem-enable-kernel-memcg-accounting-from-interrupt-contexts.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch


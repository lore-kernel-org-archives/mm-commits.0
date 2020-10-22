Return-Path: <SRS0=kBw3=D5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CB96C388F9
	for <mm-commits@archiver.kernel.org>; Thu, 22 Oct 2020 23:09:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F823223BF
	for <mm-commits@archiver.kernel.org>; Thu, 22 Oct 2020 23:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603408157;
	bh=5kktZ7yru77qacwX1ixEJXUbrBm+lRGY/WaypcLECTs=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=nywyv/PN61ujNxlQayrbuihF6eyTEOLBfCzQPaH/IKpKXdDjWY++py3e9yPW9Jaby
	 hdqUyzP0bA2UmMYOTTQx21RMu069LIInxXiUmEkyZY37zzoZIk7ZtyJoNk0WSU8s/X
	 XtORy1dd9oQW9U/bjzA6lfdaLrQ5HSUIW/Hmk7fU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373117AbgJVXJQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 22 Oct 2020 19:09:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:49804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2444502AbgJVXJQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 22 Oct 2020 19:09:16 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A218A20756;
        Thu, 22 Oct 2020 23:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603408156;
        bh=5kktZ7yru77qacwX1ixEJXUbrBm+lRGY/WaypcLECTs=;
        h=Date:From:To:Subject:From;
        b=2iWgZZAKOHx9+YAv8YqHj54jzGcMfmzTnxtghI80f+xVafDp5QPmEBhWM+wIrwmlp
         SmejVL4mV3XjRzUaGeZxM6oX+z8hV0c7wfa8ZrSMVjtUOKqxx5NZn6KnU2FaUI2jOR
         jEyK88kmvxyMFRfRGLpvDyDWWtc0WiDdQRz17+2E=
Date:   Thu, 22 Oct 2020 16:09:15 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shakeelb@google.com
Subject:  [merged]
 mm-kmem-remove-redundant-checks-from-get_obj_cgroup_from_current.patch
 removed from -mm tree
Message-ID: <20201022230915.7IOWsAyAZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kmem: remove redundant checks from get_obj_cgroup_from_current()
has been removed from the -mm tree.  Its filename was
     mm-kmem-remove-redundant-checks-from-get_obj_cgroup_from_current.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -2939,9 +2939,6 @@ __always_inline struct obj_cgroup *get_o
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

mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EF67C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:11:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B2D161C7A
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:11:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231891AbhGFTOP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:14:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:48614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231819AbhGFTOP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:14:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6CE5161C6C;
        Tue,  6 Jul 2021 19:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598696;
        bh=YacLAzQ+hSyQqDuEyZEpnKMZtDlNt/tgYxFjcOu2OZ8=;
        h=Date:From:To:Subject:From;
        b=SDFtIeHPruOgi/n77e8n8JOQ3LkxpQAOG7FPQeAMSBrCkyrjSMQMMD/7AWgfu69Vk
         oXhMtD0K1OVeI+xEBTtMdgf2xDDx+OXo2UuMpUJfAQDP1DIqoNSy4WL3B7M3/qhUp/
         1QlAB8L3maNTSkFAv9pMNDHdCaFRUO069vKUw7Yk=
Date:   Tue, 06 Jul 2021 12:11:36 -0700
From:   akpm@linux-foundation.org
To:     duanxiongchun@bytedance.com, guro@fb.com, hannes@cmpxchg.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com,
        songmuchun@bytedance.com, vdavydov.dev@gmail.com
Subject:  [merged]
 mm-memcontrol-fix-page-charging-in-page-replacement.patch removed from -mm
 tree
Message-ID: <20210706191136.PNFR5SgM6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: fix page charging in page replacement
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-fix-page-charging-in-page-replacement.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memcontrol: fix page charging in page replacement

Patch series "memcontrol code cleanup and simplification", v3.


This patch (of 8):

The pages aren't accounted at the root level, so do not charge the page to
the root memcg in page replacement.  Although we do not display the value
(mem_cgroup_usage) so there shouldn't be any actual problem, but there is
a WARN_ON_ONCE in the page_counter_cancel().  Who knows if it will
trigger?  So it is better to fix it.

Link: https://lkml.kernel.org/r/20210417043538.9793-1-songmuchun@bytedance.com
Link: https://lkml.kernel.org/r/20210417043538.9793-2-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Roman Gushchin <guro@fb.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-fix-page-charging-in-page-replacement
+++ a/mm/memcontrol.c
@@ -6984,9 +6984,11 @@ void mem_cgroup_migrate(struct page *old
 	/* Force-charge the new page. The old one will be freed soon */
 	nr_pages = thp_nr_pages(newpage);
 
-	page_counter_charge(&memcg->memory, nr_pages);
-	if (do_memsw_account())
-		page_counter_charge(&memcg->memsw, nr_pages);
+	if (!mem_cgroup_is_root(memcg)) {
+		page_counter_charge(&memcg->memory, nr_pages);
+		if (do_memsw_account())
+			page_counter_charge(&memcg->memsw, nr_pages);
+	}
 
 	css_get(&memcg->css);
 	commit_charge(newpage, memcg);
_

Patches currently in -mm which might be from songmuchun@bytedance.com are



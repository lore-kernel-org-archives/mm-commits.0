Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6E40C433E0
	for <mm-commits@archiver.kernel.org>; Fri, 19 Mar 2021 17:12:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8318A6191E
	for <mm-commits@archiver.kernel.org>; Fri, 19 Mar 2021 17:12:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbhCSRLt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 Mar 2021 13:11:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:36396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230239AbhCSRLd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 19 Mar 2021 13:11:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E00B6191E;
        Fri, 19 Mar 2021 17:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616173892;
        bh=BASrOlzfM+54+oPepxQg91WK1cqfEVjpxKSD9Rx7MWc=;
        h=Date:From:To:Subject:From;
        b=tGFLrfim960v7sRY0fgd6+hbmtkv5/WP4F6IE9YVHYeocLSuSXUzd64gaBadDjs6A
         UuPyl06igH+0brZVUbxFO/Mzgb+f0GlDsIzdiczmTPzoe7yRg1sO6OD4P8TUX5D2/i
         58KbQwoknqJYJciFUf6rNxgzmS8DZRyELr77waLw=
Date:   Fri, 19 Mar 2021 10:11:31 -0700
From:   akpm@linux-foundation.org
To:     duanxiongchun@bytedance.com, guro@fb.com, hannes@cmpxchg.org,
        mhocko@kernel.org, mm-commits@vger.kernel.org, shakeelb@google.com,
        songmuchun@bytedance.com, vdavydov.dev@gmail.com
Subject:  +
 mm-memcontrol-directly-access-page-memcg_data-in-mm-page_allocc.patch added
 to -mm tree
Message-ID: <20210319171131.3q6wTOQy3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: directly access page->memcg_data in mm/page_alloc.c
has been added to the -mm tree.  Its filename is
     mm-memcontrol-directly-access-page-memcg_data-in-mm-page_allocc.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-directly-access-page-memcg_data-in-mm-page_allocc.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-directly-access-page-memcg_data-in-mm-page_allocc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memcontrol: directly access page->memcg_data in mm/page_alloc.c

page_memcg() is not suitable for use by page_expected_state() and
page_bad_reason().  Because it can BUG_ON() for the slab pages when
CONFIG_DEBUG_VM is enabled.  As neither lru, nor kmem, nor slab page
should have anything left in there by the time the page is freed, what we
care about is whether the value of page->memcg_data is 0.  So just
directly access page->memcg_data here.

Link: https://lkml.kernel.org/r/20210319163821.20704-4-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-memcontrol-directly-access-page-memcg_data-in-mm-page_allocc
+++ a/mm/page_alloc.c
@@ -1103,7 +1103,7 @@ static inline bool page_expected_state(s
 	if (unlikely((unsigned long)page->mapping |
 			page_ref_count(page) |
 #ifdef CONFIG_MEMCG
-			(unsigned long)page_memcg(page) |
+			page->memcg_data |
 #endif
 			(page->flags & check_flags)))
 		return false;
@@ -1128,7 +1128,7 @@ static const char *page_bad_reason(struc
 			bad_reason = "PAGE_FLAGS_CHECK_AT_FREE flag(s) set";
 	}
 #ifdef CONFIG_MEMCG
-	if (unlikely(page_memcg(page)))
+	if (unlikely(page->memcg_data))
 		bad_reason = "page still charged to cgroup";
 #endif
 	return bad_reason;
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-memcontrol-fix-kernel-stack-account.patch
mm-memcontrol-slab-fix-obtain-a-reference-to-a-freeing-memcg.patch
mm-memcontrol-introduce-obj_cgroup_uncharge_pages.patch
mm-memcontrol-directly-access-page-memcg_data-in-mm-page_allocc.patch
mm-memcontrol-change-ug-dummy_page-only-if-memcg-changed.patch
mm-memcontrol-use-obj_cgroup-apis-to-charge-kmem-pages.patch
mm-memcontrol-inline-__memcg_kmem_uncharge-into-obj_cgroup_uncharge_pages.patch
mm-memcontrol-move-pagememcgkmem-to-the-scope-of-config_memcg_kmem.patch


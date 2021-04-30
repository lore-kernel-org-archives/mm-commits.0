Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3912CC433ED
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:24:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0892D61452
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:24:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbhD3FZa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:25:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:37772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229590AbhD3FZ3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:25:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EBED761434;
        Fri, 30 Apr 2021 05:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619760282;
        bh=PlGbqHa57STOfSb+7CxcKxqRQMJEif1MDT0GEZLdfhQ=;
        h=Date:From:To:Subject:From;
        b=VD1st2WRvpJ1Ixl+7KOl8Gv/7drvOY07C2LcQWpN9xO6WWJJRhJE1rNUZNxYsZ0le
         BNroT99E4Os2W2WG4dalztM/FQuWZhDE6KRbiWlQES78v4DVd4qW6pXLrwYGeKUxgL
         FlXijPvyMLj3QJaqeIqHc/qXpAXxVZjAJY8Gn+GY=
Date:   Thu, 29 Apr 2021 22:24:41 -0700
From:   akpm@linux-foundation.org
To:     borntraeger@de.ibm.com, duanxiongchun@bytedance.com, guro@fb.com,
        hannes@cmpxchg.org, linmiaohe@huawei.com, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        songmuchun@bytedance.com, vdavydov.dev@gmail.com
Subject:  [folded-merged]
 mm-memcontrol-use-obj_cgroup-apis-to-charge-kmem-pages-fix.patch removed
 from -mm tree
Message-ID: <20210430052441.UL3Tbb8-F%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: fix forget to obtain the ref to objcg in split_page_memcg
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-use-obj_cgroup-apis-to-charge-kmem-pages-fix.patch

This patch was dropped because it was folded into mm-memcontrol-use-obj_cgroup-apis-to-charge-kmem-pages.patch

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memcontrol: fix forget to obtain the ref to objcg in split_page_memcg

Christian Borntraeger reported a warning about "percpu ref
(obj_cgroup_release) <= 0 (-1) after switching to atomic".  Because we
forgot to obtain the reference to the objcg and wrongly obtain the
reference of memcg.

Link: https://lkml.kernel.org/r/20210401030141.37061-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
Acked-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    6 ++++++
 mm/memcontrol.c            |    6 +++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-use-obj_cgroup-apis-to-charge-kmem-pages-fix
+++ a/include/linux/memcontrol.h
@@ -798,6 +798,12 @@ static inline void obj_cgroup_get(struct
 	percpu_ref_get(&objcg->refcnt);
 }
 
+static inline void obj_cgroup_get_many(struct obj_cgroup *objcg,
+				       unsigned long nr)
+{
+	percpu_ref_get_many(&objcg->refcnt, nr);
+}
+
 static inline void obj_cgroup_put(struct obj_cgroup *objcg)
 {
 	percpu_ref_put(&objcg->refcnt);
--- a/mm/memcontrol.c~mm-memcontrol-use-obj_cgroup-apis-to-charge-kmem-pages-fix
+++ a/mm/memcontrol.c
@@ -3270,7 +3270,11 @@ void split_page_memcg(struct page *head,
 
 	for (i = 1; i < nr; i++)
 		head[i].memcg_data = head->memcg_data;
-	css_get_many(&memcg->css, nr - 1);
+
+	if (PageMemcgKmem(head))
+		obj_cgroup_get_many(__page_objcg(head), nr - 1);
+	else
+		css_get_many(&memcg->css, nr - 1);
 }
 
 #ifdef CONFIG_MEMCG_SWAP
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


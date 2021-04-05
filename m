Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16E95C433ED
	for <mm-commits@archiver.kernel.org>; Mon,  5 Apr 2021 20:05:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB276613BC
	for <mm-commits@archiver.kernel.org>; Mon,  5 Apr 2021 20:05:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233532AbhDEUF6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 5 Apr 2021 16:05:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:45024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232752AbhDEUF5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 5 Apr 2021 16:05:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E09F613BE;
        Mon,  5 Apr 2021 20:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617653150;
        bh=Vk3GkSVK2OuYa8aiKB1vO1QehgJJsIaxIsYzNEvAJCE=;
        h=Date:From:To:Subject:From;
        b=H98XtQYZTWwrIoQa3pVVlpZzOypR/z6JA3wQWtz5SIJgWhMFR/ydUF6R2noZCKEtU
         dWf9NyYjSIJfq9G4WYwAzeuj/CNeDYVpBR9CKLwayDlJ5yaIqsu7Tqd+hHw+BOhjtj
         7OS7NW7pa1MR9f3JZuVekfBjJCwje6C+fMf8ftSE=
Date:   Mon, 05 Apr 2021 13:05:49 -0700
From:   akpm@linux-foundation.org
To:     borntraeger@de.ibm.com, duanxiongchun@bytedance.com, guro@fb.com,
        hannes@cmpxchg.org, linmiaohe@huawei.com, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        songmuchun@bytedance.com, vdavydov.dev@gmail.com
Subject:  +
 =?US-ASCII?Q?mm-memcontrol-fix-forget-to-obtain-the-ref-to-objcg-in-sp?=
 =?US-ASCII?Q?lit=5Fpage=5Fmemcg.patch?= added to -mm tree
Message-ID: <20210405200549.SJ9WTWCcW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: fix forget to obtain the ref to objcg in split_page_memcg
has been added to the -mm tree.  Its filename is
     mm-memcontrol-fix-forget-to-obtain-the-ref-to-objcg-in-split_page_memcg.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-fix-forget-to-obtain-the-ref-to-objcg-in-split_page_memcg.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-fix-forget-to-obtain-the-ref-to-objcg-in-split_page_memcg.patch

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
Subject: mm: memcontrol: fix forget to obtain the ref to objcg in split_page_memcg

Christian Borntraeger reported a warning about "percpu ref
(obj_cgroup_release) <= 0 (-1) after switching to atomic".  Because we
forgot to obtain the reference to the objcg and wrongly obtain the
reference of memcg.

Link: https://lkml.kernel.org/r/20210401030141.37061-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
Acked-by: Roman Gushchin <guro@fb.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
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

--- a/include/linux/memcontrol.h~mm-memcontrol-fix-forget-to-obtain-the-ref-to-objcg-in-split_page_memcg
+++ a/include/linux/memcontrol.h
@@ -803,6 +803,12 @@ static inline void obj_cgroup_get(struct
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
--- a/mm/memcontrol.c~mm-memcontrol-fix-forget-to-obtain-the-ref-to-objcg-in-split_page_memcg
+++ a/mm/memcontrol.c
@@ -3257,7 +3257,11 @@ void split_page_memcg(struct page *head,
 
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
mm-memcontrol-fix-forget-to-obtain-the-ref-to-objcg-in-split_page_memcg.patch


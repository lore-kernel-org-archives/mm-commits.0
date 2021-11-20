Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2010EC433EF
	for <mm-commits@archiver.kernel.org>; Sat, 20 Nov 2021 00:43:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234793AbhKTAqo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 Nov 2021 19:46:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:50752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236503AbhKTAqn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 19 Nov 2021 19:46:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA0F961A86;
        Sat, 20 Nov 2021 00:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637369021;
        bh=O/JdrIesE0G8FKH3RyIHlFgd93mrEsm4ABmBxynphyc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Cl66eE4fBES2VmTsmX/0RQ0vri64kTgW1OiFbVN7ktfhwEvnXP+fOlpsPSb4G1bza
         ySzLTMN74T22TH94pP5xeMwMNiclr8HsWP81dpxiEyBpcodFFMtj4wYFtyWxTyY6bN
         jOkKw0As/ysYrwYGDjHfa/y0ov/7ERFbApIAotIc=
Date:   Fri, 19 Nov 2021 16:43:40 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, almasrymina@google.com,
        linmiaohe@huawei.com, linux-mm@kvack.org, mhocko@suse.com,
        mike.kravetz@oracle.com, minhquangbui99@gmail.com,
        mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        torvalds@linux-foundation.org
Subject:  [patch 09/15] hugetlb: fix hugetlb cgroup refcounting
 during mremap
Message-ID: <20211120004340.S1hmWsXgy%akpm@linux-foundation.org>
In-Reply-To: <20211119164248.50feee07c5d2cc6cc4addf97@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Bui Quang Minh <minhquangbui99@gmail.com>
Subject: hugetlb: fix hugetlb cgroup refcounting during mremap

When hugetlb_vm_op_open() is called during copy_vma(), we may take the
reference to resv_map->css.  Later, when clearing the reservation pointer
of old_vma after transferring it to new_vma, we forget to drop the
reference to resv_map->css.  This leads to a reference leak of css.

Fixes this by adding a check to drop reservation css reference in
clear_vma_resv_huge_pages()

Link: https://lkml.kernel.org/r/20211113154412.91134-1-minhquangbui99@gmail.com
Fixes: 550a7d60bd5e35 ("mm, hugepages: add mremap() support for hugepage backed vma")
Signed-off-by: Bui Quang Minh <minhquangbui99@gmail.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb_cgroup.h |   12 ++++++++++++
 mm/hugetlb.c                   |    4 +++-
 2 files changed, 15 insertions(+), 1 deletion(-)

--- a/include/linux/hugetlb_cgroup.h~hugetlb-fix-hugetlb-cgroup-refcounting-during-mremap
+++ a/include/linux/hugetlb_cgroup.h
@@ -128,6 +128,13 @@ static inline void resv_map_dup_hugetlb_
 		css_get(resv_map->css);
 }
 
+static inline void resv_map_put_hugetlb_cgroup_uncharge_info(
+						struct resv_map *resv_map)
+{
+	if (resv_map->css)
+		css_put(resv_map->css);
+}
+
 extern int hugetlb_cgroup_charge_cgroup(int idx, unsigned long nr_pages,
 					struct hugetlb_cgroup **ptr);
 extern int hugetlb_cgroup_charge_cgroup_rsvd(int idx, unsigned long nr_pages,
@@ -210,6 +217,11 @@ static inline void resv_map_dup_hugetlb_
 						struct resv_map *resv_map)
 {
 }
+
+static inline void resv_map_put_hugetlb_cgroup_uncharge_info(
+						struct resv_map *resv_map)
+{
+}
 
 static inline int hugetlb_cgroup_charge_cgroup(int idx, unsigned long nr_pages,
 					       struct hugetlb_cgroup **ptr)
--- a/mm/hugetlb.c~hugetlb-fix-hugetlb-cgroup-refcounting-during-mremap
+++ a/mm/hugetlb.c
@@ -1037,8 +1037,10 @@ void clear_vma_resv_huge_pages(struct vm
 	 */
 	struct resv_map *reservations = vma_resv_map(vma);
 
-	if (reservations && is_vma_resv_set(vma, HPAGE_RESV_OWNER))
+	if (reservations && is_vma_resv_set(vma, HPAGE_RESV_OWNER)) {
+		resv_map_put_hugetlb_cgroup_uncharge_info(reservations);
 		kref_put(&reservations->refs, resv_map_release);
+	}
 
 	reset_vma_resv_huge_pages(vma);
 }
_

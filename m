Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D889AC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 23 Nov 2021 22:46:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239035AbhKWWtJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 23 Nov 2021 17:49:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:51292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238741AbhKWWtD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 23 Nov 2021 17:49:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A967660FBF;
        Tue, 23 Nov 2021 22:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637707555;
        bh=KxVBkHPMWM1dh6wPjNzeB2LiHzw9zmOl5PTHbODpIqI=;
        h=Date:From:To:Subject:From;
        b=h/Q64WEfeOw3kzpwLSWzycGrHfhpUq730rUKclmwd+LHIJA6QjYmqhS3Whe1b3CbR
         xL4k1alGb8eNU/bBq9k0ClOq++EUA5K6xvefggZ/86LysiqzHY/p2uWJimd5T0uPK5
         IxMPlJUekejfAK6hoI2BaV+KYpp2FxEB5eAzPPpA=
Date:   Tue, 23 Nov 2021 14:45:54 -0800
From:   akpm@linux-foundation.org
To:     almasrymina@google.com, linmiaohe@huawei.com, mhocko@suse.com,
        mike.kravetz@oracle.com, minhquangbui99@gmail.com,
        mm-commits@vger.kernel.org, songmuchun@bytedance.com
Subject:  [merged]
 hugetlb-fix-hugetlb-cgroup-refcounting-during-mremap.patch removed from -mm
 tree
Message-ID: <20211123224554.F0bHCsp75%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: fix hugetlb cgroup refcounting during mremap
has been removed from the -mm tree.  Its filename was
     hugetlb-fix-hugetlb-cgroup-refcounting-during-mremap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from minhquangbui99@gmail.com are



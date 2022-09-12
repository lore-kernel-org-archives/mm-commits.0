Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67FA6ECAAD3
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:29:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbiILD3j (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbiILD2x (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:28:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 971C227B3D
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:28:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46D6AB80C76
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:28:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1EFFC433D6;
        Mon, 12 Sep 2022 03:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953322;
        bh=0fVu1TomnTTeUETyo12FSS0QQTc/MxYIYW4JS5ScrJo=;
        h=Date:To:From:Subject:From;
        b=gKLbTqqtL2glYpcCus1vZDQlr1kMCgbt0giJkvio+H7mYmZU+HCkr4qkPhwDKfsYT
         Qjq2blJv/tE0fVAG7TjfnZUpxjAWtkV4hobW/49/l+ZtHnYw8h5NTFsxnF8TlVcc/G
         vgT8HB1VovOT+8dx2vGkbJ23ky5cOcdHQmxsM7os=
Date:   Sun, 11 Sep 2022 20:28:41 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, mhocko@suse.com, dave.hansen@intel.com,
        bwidawsk@kernel.org, feng.tang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-add-dedicated-func-to-get-allowed-nodemask-for-current-process.patch removed from -mm tree
Message-Id: <20220912032841.E1EFFC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: add dedicated func to get 'allowed' nodemask for current process
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-add-dedicated-func-to-get-allowed-nodemask-for-current-process.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Feng Tang <feng.tang@intel.com>
Subject: mm/hugetlb: add dedicated func to get 'allowed' nodemask for current process
Date: Fri, 5 Aug 2022 08:59:03 +0800

Muchun Song found that after MPOL_PREFERRED_MANY policy was introduced in
commit b27abaccf8e8 ("mm/mempolicy: add MPOL_PREFERRED_MANY for multiple
preferred nodes"), the policy_nodemask_current()'s semantics for this new
policy has been changed, which returns 'preferred' nodes instead of
'allowed' nodes.

With the changed semantic of policy_nodemask_current, a task with
MPOL_PREFERRED_MANY policy could fail to get its reservation even though
it can fall back to other nodes (either defined by cpusets or all online
nodes) for that reservation failing mmap calles unnecessarily early.

The fix is to not consider MPOL_PREFERRED_MANY for reservations at all
because they, unlike MPOL_MBIND, do not pose any actual hard constrain.

Michal suggested the policy_nodemask_current() is only used by hugetlb,
and could be moved to hugetlb code with more explicit name to enforce the
'allowed' semantics for which only MPOL_BIND policy matters.

apply_policy_zone() is made extern to be called in hugetlb code and its
return value is changed to bool.

[1]. https://lore.kernel.org/lkml/20220801084207.39086-1-songmuchun@bytedance.com/t/

Link: https://lkml.kernel.org/r/20220805005903.95563-1-feng.tang@intel.com
Fixes: b27abaccf8e8 ("mm/mempolicy: add MPOL_PREFERRED_MANY for multiple preferred nodes")
Signed-off-by: Feng Tang <feng.tang@intel.com>
Reported-by: Muchun Song <songmuchun@bytedance.com>
Suggested-by: Michal Hocko <mhocko@suse.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Ben Widawsky <bwidawsk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |   13 +------------
 mm/hugetlb.c              |   24 ++++++++++++++++++++----
 mm/mempolicy.c            |    2 +-
 3 files changed, 22 insertions(+), 17 deletions(-)

--- a/include/linux/mempolicy.h~mm-hugetlb-add-dedicated-func-to-get-allowed-nodemask-for-current-process
+++ a/include/linux/mempolicy.h
@@ -151,13 +151,6 @@ extern bool mempolicy_in_oom_domain(stru
 				const nodemask_t *mask);
 extern nodemask_t *policy_nodemask(gfp_t gfp, struct mempolicy *policy);
 
-static inline nodemask_t *policy_nodemask_current(gfp_t gfp)
-{
-	struct mempolicy *mpol = get_task_policy(current);
-
-	return policy_nodemask(gfp, mpol);
-}
-
 extern unsigned int mempolicy_slab_node(void);
 
 extern enum zone_type policy_zone;
@@ -189,6 +182,7 @@ static inline bool mpol_is_preferred_man
 	return  (pol->mode == MPOL_PREFERRED_MANY);
 }
 
+extern bool apply_policy_zone(struct mempolicy *policy, enum zone_type zone);
 
 #else
 
@@ -294,11 +288,6 @@ static inline void mpol_put_task_policy(
 {
 }
 
-static inline nodemask_t *policy_nodemask_current(gfp_t gfp)
-{
-	return NULL;
-}
-
 static inline bool mpol_is_preferred_many(struct mempolicy *pol)
 {
 	return  false;
--- a/mm/hugetlb.c~mm-hugetlb-add-dedicated-func-to-get-allowed-nodemask-for-current-process
+++ a/mm/hugetlb.c
@@ -4330,18 +4330,34 @@ static int __init default_hugepagesz_set
 }
 __setup("default_hugepagesz=", default_hugepagesz_setup);
 
+static nodemask_t *policy_mbind_nodemask(gfp_t gfp)
+{
+#ifdef CONFIG_NUMA
+	struct mempolicy *mpol = get_task_policy(current);
+
+	/*
+	 * Only enforce MPOL_BIND policy which overlaps with cpuset policy
+	 * (from policy_nodemask) specifically for hugetlb case
+	 */
+	if (mpol->mode == MPOL_BIND &&
+		(apply_policy_zone(mpol, gfp_zone(gfp)) &&
+		 cpuset_nodemask_valid_mems_allowed(&mpol->nodes)))
+		return &mpol->nodes;
+#endif
+	return NULL;
+}
+
 static unsigned int allowed_mems_nr(struct hstate *h)
 {
 	int node;
 	unsigned int nr = 0;
-	nodemask_t *mpol_allowed;
+	nodemask_t *mbind_nodemask;
 	unsigned int *array = h->free_huge_pages_node;
 	gfp_t gfp_mask = htlb_alloc_mask(h);
 
-	mpol_allowed = policy_nodemask_current(gfp_mask);
-
+	mbind_nodemask = policy_mbind_nodemask(gfp_mask);
 	for_each_node_mask(node, cpuset_current_mems_allowed) {
-		if (!mpol_allowed || node_isset(node, *mpol_allowed))
+		if (!mbind_nodemask || node_isset(node, *mbind_nodemask))
 			nr += array[node];
 	}
 
--- a/mm/mempolicy.c~mm-hugetlb-add-dedicated-func-to-get-allowed-nodemask-for-current-process
+++ a/mm/mempolicy.c
@@ -1805,7 +1805,7 @@ bool vma_policy_mof(struct vm_area_struc
 	return pol->flags & MPOL_F_MOF;
 }
 
-static int apply_policy_zone(struct mempolicy *policy, enum zone_type zone)
+bool apply_policy_zone(struct mempolicy *policy, enum zone_type zone)
 {
 	enum zone_type dynamic_policy_zone = policy_zone;
 
_

Patches currently in -mm which might be from feng.tang@intel.com are



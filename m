Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72275C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:01:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FC6D2087C
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266079;
	bh=baZfyppwDvDeTHUEpMyArtdHPdH84qhGacYpfPbpGe0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=nUHnfzj8IfvjTY+NDuYgG2GnxMJ+foXZnymGgV3mez95pzg+gMNytjGV5BzV6Sr78
	 1n95dqxwEq//7Mf5atbdNqnBSt8yruWroUIwfkf2sQM4bQAroz66OnJaVlARBc9Cfz
	 mrHoJ/5vev2Pa3bJDmQd18olT7anatxbh4Z1BA1U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726547AbgHLVBT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:01:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:45402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726030AbgHLVBS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:01:18 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 924B02078B;
        Wed, 12 Aug 2020 21:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266077;
        bh=baZfyppwDvDeTHUEpMyArtdHPdH84qhGacYpfPbpGe0=;
        h=Date:From:To:Subject:From;
        b=EHr6Oqvf7IIdH1XyEbQ/iX2d6BPxZ9+2UE+oeTDyl8W+DeSOtM64JcNqlvDooV/G2
         J9Z/rnWsrn2ex0UftAAzlL/pZSgI+LGa4Mkbro1Pagk1IBvt+DVHne2gpNSM7zBjmb
         ICtnjOzU+hYQY3N2ILD9v7n3WtWLJyGKl97s1MJ8=
Date:   Wed, 12 Aug 2020 14:01:17 -0700
From:   akpm@linux-foundation.org
To:     bhe@redhat.com, guojianchao@bytedance.com, mgorman@suse.de,
        mhocko@kernel.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, rientjes@google.com,
        songmuchun@bytedance.com, walken@google.com
Subject:  [merged]
 mm-hugetlb-add-mempolicy-check-in-the-reservation-routine.patch removed
 from -mm tree
Message-ID: <20200812210117.WSVWbHOFq%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: add mempolicy check in the reservation routine
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-add-mempolicy-check-in-the-reservation-routine.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/hugetlb: add mempolicy check in the reservation routine

In the reservation routine, we only check whether the cpuset meets the
memory allocation requirements.  But we ignore the mempolicy of MPOL_BIND
case.  If someone mmap hugetlb succeeds, but the subsequent memory
allocation may fail due to mempolicy restrictions and receives the SIGBUS
signal.  This can be reproduced by the follow steps.

 1) Compile the test case.
    cd tools/testing/selftests/vm/
    gcc map_hugetlb.c -o map_hugetlb

 2) Pre-allocate huge pages. Suppose there are 2 numa nodes in the
    system. Each node will pre-allocate one huge page.
    echo 2 > /proc/sys/vm/nr_hugepages

 3) Run test case(mmap 4MB). We receive the SIGBUS signal.
    numactl --membind=3D0 ./map_hugetlb 4

With this patch applied, the mmap will fail in the step 3) and throw
"mmap: Cannot allocate memory".

[akpm@linux-foundation.org: include sched.h for `current']
Link: http://lkml.kernel.org/r/20200728034938.14993-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reported-by: Jianchao Guo <guojianchao@bytedance.com>
Suggested-by: Michal Hocko <mhocko@kernel.org>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michel Lespinasse <walken@google.com>
Cc: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |   16 +++++++++++++++-
 mm/hugetlb.c              |   24 +++++++++++++++++++-----
 mm/mempolicy.c            |    2 +-
 3 files changed, 35 insertions(+), 7 deletions(-)

--- a/include/linux/mempolicy.h~mm-hugetlb-add-mempolicy-check-in-the-reservation-routine
+++ a/include/linux/mempolicy.h
@@ -6,7 +6,7 @@
 #ifndef _LINUX_MEMPOLICY_H
 #define _LINUX_MEMPOLICY_H 1
 
-
+#include <linux/sched.h>
 #include <linux/mmzone.h>
 #include <linux/dax.h>
 #include <linux/slab.h>
@@ -152,6 +152,15 @@ extern int huge_node(struct vm_area_stru
 extern bool init_nodemask_of_mempolicy(nodemask_t *mask);
 extern bool mempolicy_nodemask_intersects(struct task_struct *tsk,
 				const nodemask_t *mask);
+extern nodemask_t *policy_nodemask(gfp_t gfp, struct mempolicy *policy);
+
+static inline nodemask_t *policy_nodemask_current(gfp_t gfp)
+{
+	struct mempolicy *mpol = get_task_policy(current);
+
+	return policy_nodemask(gfp, mpol);
+}
+
 extern unsigned int mempolicy_slab_node(void);
 
 extern enum zone_type policy_zone;
@@ -281,5 +290,10 @@ static inline int mpol_misplaced(struct
 static inline void mpol_put_task_policy(struct task_struct *task)
 {
 }
+
+static inline nodemask_t *policy_nodemask_current(gfp_t gfp)
+{
+	return NULL;
+}
 #endif /* CONFIG_NUMA */
 #endif
--- a/mm/hugetlb.c~mm-hugetlb-add-mempolicy-check-in-the-reservation-routine
+++ a/mm/hugetlb.c
@@ -3458,13 +3458,21 @@ static int __init default_hugepagesz_set
 }
 __setup("default_hugepagesz=", default_hugepagesz_setup);
 
-static unsigned int cpuset_mems_nr(unsigned int *array)
+static unsigned int allowed_mems_nr(struct hstate *h)
 {
 	int node;
 	unsigned int nr = 0;
-
-	for_each_node_mask(node, cpuset_current_mems_allowed)
-		nr += array[node];
+	nodemask_t *mpol_allowed;
+	unsigned int *array = h->free_huge_pages_node;
+	gfp_t gfp_mask = htlb_alloc_mask(h);
+
+	mpol_allowed = policy_nodemask_current(gfp_mask);
+
+	for_each_node_mask(node, cpuset_current_mems_allowed) {
+		if (!mpol_allowed ||
+		    (mpol_allowed && node_isset(node, *mpol_allowed)))
+			nr += array[node];
+	}
 
 	return nr;
 }
@@ -3643,12 +3651,18 @@ static int hugetlb_acct_memory(struct hs
 	 * we fall back to check against current free page availability as
 	 * a best attempt and hopefully to minimize the impact of changing
 	 * semantics that cpuset has.
+	 *
+	 * Apart from cpuset, we also have memory policy mechanism that
+	 * also determines from which node the kernel will allocate memory
+	 * in a NUMA system. So similar to cpuset, we also should consider
+	 * the memory policy of the current task. Similar to the description
+	 * above.
 	 */
 	if (delta > 0) {
 		if (gather_surplus_pages(h, delta) < 0)
 			goto out;
 
-		if (delta > cpuset_mems_nr(h->free_huge_pages_node)) {
+		if (delta > allowed_mems_nr(h)) {
 			return_unused_surplus_pages(h, delta);
 			goto out;
 		}
--- a/mm/mempolicy.c~mm-hugetlb-add-mempolicy-check-in-the-reservation-routine
+++ a/mm/mempolicy.c
@@ -1890,7 +1890,7 @@ static int apply_policy_zone(struct memp
  * Return a nodemask representing a mempolicy for filtering nodes for
  * page allocation
  */
-static nodemask_t *policy_nodemask(gfp_t gfp, struct mempolicy *policy)
+nodemask_t *policy_nodemask(gfp_t gfp, struct mempolicy *policy)
 {
 	/* Lower zones don't get a nodemask applied for MPOL_BIND */
 	if (unlikely(policy->mode == MPOL_BIND) &&
_

Patches currently in -mm which might be from songmuchun@bytedance.com are



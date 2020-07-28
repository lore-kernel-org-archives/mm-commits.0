Return-Path: <SRS0=nZXm=BH=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EA20C433E3
	for <mm-commits@archiver.kernel.org>; Tue, 28 Jul 2020 00:18:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08FC120786
	for <mm-commits@archiver.kernel.org>; Tue, 28 Jul 2020 00:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595895502;
	bh=es5cwUu9YF3q2lresfgqfKsQVdQe12+fWNAr5ASuZdc=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=b38UDGU4MiD71UHr7A1/eFgPmvn4UMgLbxBrfPHOUKe2FMhqciiirzUVJvyv9vyoW
	 5CRVQztiKE+DOANPUIuSZzIK/v/737iu15r8riBsyhTRfmFp8xZKSr9H5d4sEOoz1u
	 VmJJdB2qHkXqZK5io3/4TETpuBeu5xbNVqVpLdCY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbgG1ASV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Jul 2020 20:18:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:49432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726278AbgG1ASV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 27 Jul 2020 20:18:21 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 415F820809;
        Tue, 28 Jul 2020 00:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595895499;
        bh=es5cwUu9YF3q2lresfgqfKsQVdQe12+fWNAr5ASuZdc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=vuLLbubAmsfmLZx2EggJiiQOVXs75J1/newkDNbm1sGpQ00QCxKoFJG9yIxYa3bTr
         EcrX1446c7yb5axCi7mwd0aB7ZDciRrpb9yb3ukltcuxiFrWnOry7179QzlmlDF7hJ
         KHYtwv/R2b8ZEBQJhFjGyr6oQ9jFbbDAgWsywPpk=
Date:   Mon, 27 Jul 2020 17:18:18 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     guojianchao@bytedance.com, mgorman@suse.de, mhocko@kernel.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        rientjes@google.com, songmuchun@bytedance.com, walken@google.com
Subject:  [failures]
 mm-hugetlb-add-mempolicy-check-in-the-reservation-routine.patch removed
 from -mm tree
Message-ID: <20200728001818.BWUYi-b2f%akpm@linux-foundation.org>
In-Reply-To: <20200723211432.b31831a0df3bc2cbdae31b40@linux-foundation.org>
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

This patch was dropped because it had testing failures

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
    numactl --membind=0 ./map_hugetlb 4

With this patch applied, the mmap will fail in the step 3) and throw
"mmap: Cannot allocate memory".

Link: http://lkml.kernel.org/r/20200725080749.70470-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reported-by: Jianchao Guo <guojianchao@bytedance.com>
Suggested-by: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michel Lespinasse <walken@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |    1 +
 mm/hugetlb.c              |   25 ++++++++++++++++++++-----
 mm/mempolicy.c            |    2 +-
 3 files changed, 22 insertions(+), 6 deletions(-)

--- a/include/linux/mempolicy.h~mm-hugetlb-add-mempolicy-check-in-the-reservation-routine
+++ a/include/linux/mempolicy.h
@@ -152,6 +152,7 @@ extern int huge_node(struct vm_area_stru
 extern bool init_nodemask_of_mempolicy(nodemask_t *mask);
 extern bool mempolicy_nodemask_intersects(struct task_struct *tsk,
 				const nodemask_t *mask);
+extern nodemask_t *policy_nodemask(gfp_t gfp, struct mempolicy *policy);
 extern unsigned int mempolicy_slab_node(void);
 
 extern enum zone_type policy_zone;
--- a/mm/hugetlb.c~mm-hugetlb-add-mempolicy-check-in-the-reservation-routine
+++ a/mm/hugetlb.c
@@ -3458,13 +3458,22 @@ static int __init default_hugepagesz_set
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
+	struct mempolicy *mpol = get_task_policy(current);
+	nodemask_t *mpol_allowed;
+	unsigned int *array = h->free_huge_pages_node;
+	gfp_t gfp_mask = htlb_alloc_mask(h);
+
+	mpol_allowed = policy_nodemask(gfp_mask, mpol);
+
+	for_each_node_mask(node, cpuset_current_mems_allowed) {
+		if (!mpol_allowed ||
+		    (mpol_allowed && node_isset(node, *mpol_allowed)))
+			nr += array[node];
+	}
 
 	return nr;
 }
@@ -3643,12 +3652,18 @@ static int hugetlb_acct_memory(struct hs
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

mm-page_alloc-skip-setting-nodemask-when-we-are-in-interrupt.patch


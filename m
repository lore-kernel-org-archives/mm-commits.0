Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F313FC678D4
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:16:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbjASBQR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:16:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbjASBOp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:14:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7509E6B980
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:14:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25560B81D7E
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:14:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7221C433F1;
        Thu, 19 Jan 2023 01:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090856;
        bh=altwLyhTcj8CGTO71aqsI772HTIabv9y2nIrma7iEX8=;
        h=Date:To:From:Subject:From;
        b=lvUqhEzY9f9TI28rN68Qhv1I9I9pYRhmxsj8t1I06TzR3k3P+DVFg5rfThnrOlR8e
         gVoVN5uh3Q5CgEMoFkZI54NEKWpMcqUxwo/TFJ7h2XQjn0pEwyYncPo5cPjB4k9POD
         zkp+7xgiZZFdDA7aBAZnTddSR5QdQebo7aqNkfAk=
Date:   Wed, 18 Jan 2023 17:14:16 -0800
To:     mm-commits@vger.kernel.org, ying.huang@intel.com, vbabka@suse.cz,
        rdunlap@infradead.org, mike.kravetz@oracle.com, mhocko@kernel.org,
        mgorman@techsingularity.net, mathieu.desnoyers@efficios.com,
        feng.tang@intel.com, dave.hansen@linux.intel.com,
        dan.j.williams@intel.com, aneesh.kumar@linux.ibm.com,
        ak@linux.intel.com, aarcange@redhat.com, mhocko@suse.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mempolicy-do-not-duplicate-policy-if-it-is-not-applicable-for-set_mempolicy_home_node.patch removed from -mm tree
Message-Id: <20230119011416.C7221C433F1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mempolicy: do not duplicate policy if it is not applicable for set_mempolicy_home_node
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-do-not-duplicate-policy-if-it-is-not-applicable-for-set_mempolicy_home_node.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm/mempolicy: do not duplicate policy if it is not applicable for set_mempolicy_home_node
Date: Fri, 16 Dec 2022 14:45:37 -0500

set_mempolicy_home_node tries to duplicate a memory policy before checking
it whether it is applicable for the operation.  There is no real reason
for doing that and it might actually be a pointless memory allocation and
deallocation exercise for MPOL_INTERLEAVE.

Not a big problem but we can do better. Simply check the policy before
acting on it.

Link: https://lkml.kernel.org/r/20221216194537.238047-2-mathieu.desnoyers@efficios.com
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-do-not-duplicate-policy-if-it-is-not-applicable-for-set_mempolicy_home_node
+++ a/mm/mempolicy.c
@@ -1489,7 +1489,7 @@ SYSCALL_DEFINE4(set_mempolicy_home_node,
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
-	struct mempolicy *new;
+	struct mempolicy *new, *old;
 	unsigned long vmstart;
 	unsigned long vmend;
 	unsigned long end;
@@ -1521,31 +1521,27 @@ SYSCALL_DEFINE4(set_mempolicy_home_node,
 		return 0;
 	mmap_write_lock(mm);
 	for_each_vma_range(vmi, vma, end) {
-		vmstart = max(start, vma->vm_start);
-		vmend   = min(end, vma->vm_end);
-		new = mpol_dup(vma_policy(vma));
-		if (IS_ERR(new)) {
-			err = PTR_ERR(new);
-			break;
-		}
-		/*
-		 * Only update home node if there is an existing vma policy
-		 */
-		if (!new)
-			continue;
-
 		/*
 		 * If any vma in the range got policy other than MPOL_BIND
 		 * or MPOL_PREFERRED_MANY we return error. We don't reset
 		 * the home node for vmas we already updated before.
 		 */
-		if (new->mode != MPOL_BIND && new->mode != MPOL_PREFERRED_MANY) {
-			mpol_put(new);
+		old = vma_policy(vma);
+		if (!old)
+			continue;
+		if (old->mode != MPOL_BIND && old->mode != MPOL_PREFERRED_MANY) {
 			err = -EOPNOTSUPP;
 			break;
 		}
+		new = mpol_dup(old);
+		if (IS_ERR(new)) {
+			err = PTR_ERR(new);
+			break;
+		}
 
 		new->home_node = home_node;
+		vmstart = max(start, vma->vm_start);
+		vmend   = min(end, vma->vm_end);
 		err = mbind_range(mm, vmstart, vmend, new);
 		mpol_put(new);
 		if (err)
_

Patches currently in -mm which might be from mhocko@suse.com are

revert-mm-add-nodes=-arg-to-memoryreclaim.patch


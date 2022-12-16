Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C56F0C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 16 Dec 2022 19:50:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231829AbiLPTui (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Dec 2022 14:50:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231797AbiLPTuf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Dec 2022 14:50:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C88C750B6
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 11:50:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96A0C62204
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 19:50:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE161C433D2;
        Fri, 16 Dec 2022 19:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671220231;
        bh=FBAXn32V+4TVrJLr9bSIDjHJHz/AOwrDuwkb62QGTRw=;
        h=Date:To:From:Subject:From;
        b=Fjdpbs54s0q5zmf2/DldcN5kkaHSVc8tcFEINmVbLCVrRLocalRhSyFmLMUffENZk
         QhGKWqj65eeQyGWvoXBeXSAOn/ikpuXkMGbvwhtSjT1VNmcQpgRIkJZo56xuMpxr5y
         /4BI0iYxUJPriWc9ziMg/r82k9k5lsLwXZZ7kdEU=
Date:   Fri, 16 Dec 2022 11:50:30 -0800
To:     mm-commits@vger.kernel.org, ying.huang@intel.com, vbabka@suse.cz,
        rdunlap@infradead.org, mike.kravetz@oracle.com, mhocko@kernel.org,
        mgorman@techsingularity.net, mathieu.desnoyers@efficios.com,
        feng.tang@intel.com, dave.hansen@linux.intel.com,
        dan.j.williams@intel.com, aneesh.kumar@linux.ibm.com,
        ak@linux.intel.com, aarcange@redhat.com, mhocko@suse.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-do-not-duplicate-policy-if-it-is-not-applicable-for-set_mempolicy_home_node.patch added to mm-unstable branch
Message-Id: <20221216195030.EE161C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy: do not duplicate policy if it is not applicable for set_mempolicy_home_node
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mempolicy-do-not-duplicate-policy-if-it-is-not-applicable-for-set_mempolicy_home_node.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mempolicy-do-not-duplicate-policy-if-it-is-not-applicable-for-set_mempolicy_home_node.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-mempolicy-do-not-duplicate-policy-if-it-is-not-applicable-for-set_mempolicy_home_node.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAE9FC43334
	for <mm-commits@archiver.kernel.org>; Wed, 22 Jun 2022 01:02:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347111AbiFVBCd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Jun 2022 21:02:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353377AbiFVBCb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jun 2022 21:02:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA3BA31DE2
        for <mm-commits@vger.kernel.org>; Tue, 21 Jun 2022 18:02:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56034617E8
        for <mm-commits@vger.kernel.org>; Wed, 22 Jun 2022 01:02:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19FA7C3411C;
        Wed, 22 Jun 2022 01:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655859748;
        bh=k5gZdtcDP+Dy/j60xrgbhUvrdidaZaIy2RkgMHPzSQE=;
        h=Date:To:From:Subject:From;
        b=Zjk9ZFy4/ibLflF1DJ8FshsrbpzLhlsbMVPcPElP7huhx5s/WWZ97XkAcG0frXYK+
         n1uBlUmThyG+MER/4wiTbkSU7pXN4aGB2Fk8nVFTBttdHyUdApjHrr4pmLCUPg1bJz
         /4wA/RAfKnzwmqHs7LggYFsd9Rd2MfS7S0aULCvw=
Date:   Tue, 21 Jun 2022 18:02:19 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        songmuchun@bytedance.com, peterx@redhat.com,
        paul.walmsley@sifive.com, naoya.horiguchi@linux.dev,
        mhocko@suse.com, lkp@intel.com, jthoughton@google.com,
        eike-kernel@sf-tec.de, david@redhat.com, catalin.marinas@arm.com,
        borntraeger@linux.ibm.com, baolin.wang@linux.alibaba.com,
        anshuman.khandual@arm.com, aneesh.kumar@linux.vnet.ibm.com,
        almasrymina@google.com, mike.kravetz@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-lazy-page-table-copies-in-fork.patch added to mm-unstable branch
Message-Id: <20220622010227.19FA7C3411C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: lazy page table copies in fork()
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-lazy-page-table-copies-in-fork.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-lazy-page-table-copies-in-fork.patch

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
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: lazy page table copies in fork()
Date: Tue, 21 Jun 2022 16:56:20 -0700

Lazy page table copying at fork time was introduced with commit
d992895ba2b2 ("[PATCH] Lazy page table copies in fork()").  At the time,
hugetlb was very new and did not support page faulting.  As a result, it
was excluded.  When full page fault support was added for hugetlb, the
exclusion was not removed.

Simply remove the check that prevents lazy copying of hugetlb page tables
at fork.  Of course, like other mappings this only applies to shared
mappings.

Lazy page table copying at fork will be less advantageous for hugetlb
mappings because:
- There are fewer page table entries with hugetlb
- hugetlb pmds can be shared instead of copied

In any case, completely eliminating the copy at fork time should speed
things up.

Link: https://lkml.kernel.org/r/20220621235620.291305-5-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: James Houghton <jthoughton@google.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~hugetlb-lazy-page-table-copies-in-fork
+++ a/mm/memory.c
@@ -1262,7 +1262,7 @@ vma_needs_copy(struct vm_area_struct *ds
 	if (userfaultfd_wp(dst_vma))
 		return true;
 
-	if (src_vma->vm_flags & (VM_HUGETLB | VM_PFNMAP | VM_MIXEDMAP))
+	if (src_vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP))
 		return true;
 
 	if (src_vma->anon_vma)
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-skip-to-end-of-pt-page-mapping-when-pte-not-present.patch
hugetlb-do-not-update-address-in-huge_pmd_unshare.patch
hugetlb-lazy-page-table-copies-in-fork.patch


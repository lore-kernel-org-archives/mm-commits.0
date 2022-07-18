Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B3E8C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:18:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233159AbiGRASQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:18:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiGRARR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:17:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5976613CEF
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:17:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9B4A60F24
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:17:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D72DC3411E;
        Mon, 18 Jul 2022 00:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103432;
        bh=UbUL4MIKMcLQqc9lKYzsA6aRZtmFSPEnPlS1hIzTPWE=;
        h=Date:To:From:Subject:From;
        b=P1QOZUkHUQ1sEHJnycQR8mAaBwq/MosZxdBfhbomkQ/GE14UiXDePZbhvkiifmunA
         7i7YaJcEQF8WXhD3VHCFMlYH3HTp8Xo2TQeVXyqk+mHiGHP3cQoe4qdct5R4P7LvLq
         FfDiConzBQCOzyzd0NzuUiN0ohujkeUSXkgfQtvQ=
Date:   Sun, 17 Jul 2022 17:17:11 -0700
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
Subject: [merged mm-stable] hugetlb-lazy-page-table-copies-in-fork.patch removed from -mm tree
Message-Id: <20220718001712.4D72DC3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlb: lazy page table copies in fork()
has been removed from the -mm tree.  Its filename was
     hugetlb-lazy-page-table-copies-in-fork.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -1253,7 +1253,7 @@ vma_needs_copy(struct vm_area_struct *ds
 	if (userfaultfd_wp(dst_vma))
 		return true;
 
-	if (src_vma->vm_flags & (VM_HUGETLB | VM_PFNMAP | VM_MIXEDMAP))
+	if (src_vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP))
 		return true;
 
 	if (src_vma->anon_vma)
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are



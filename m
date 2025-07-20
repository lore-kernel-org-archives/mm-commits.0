Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 196EE1BDCF
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 00:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752972442; cv=none; b=hlx1q040MMhPPsHlYn/tLqKEK798wB156bRgVsOHNlgwpCPtabljBB/CdRfYiQkKtkYfzsxEnHa5fuorD9TaD477cNXAYrPSdXicVkvvw3wN35QOzXU8lZyfRtsppLnrimKjz2BVZiAnWphOBjJ4mrKkgnzy1vKNxa0AR0dsEAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752972442; c=relaxed/simple;
	bh=O59GKD6rYAXnbdlfLRWOTM8BAh+Q95TLUNMxJK7HRiY=;
	h=Date:To:From:Subject:Message-Id; b=slY0mKJO5VcSvIqLHGr3WSlMhkNUwFm6BnSb6i7+6w+Zgm4/Gg2PacvKl77aVBFXyPWum6WbvR45JIEAkCsd7gEUXvLGpZ9Y1js0vCZwabB6b1XEFL4cyVjTHAElCwM9U6cTTyRfdlK4DIP1jQ+NVLfeTP0iVz407b8AENkQ8BU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cLTKt3pH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cLTKt3pH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 758D0C4CEE3;
	Sun, 20 Jul 2025 00:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752972441;
	bh=O59GKD6rYAXnbdlfLRWOTM8BAh+Q95TLUNMxJK7HRiY=;
	h=Date:To:From:Subject:From;
	b=cLTKt3pHtpIVxHe6D/nM257Y0cClWKsAgmz42NHhJCUyO1r3Sk0yg4HfEudEAtRXV
	 Pis57ypTH21yQ7fKc/7PpKAepCGZoAjDqrKx/Gyct4h9p6tDYIb0dMgi2FBnNslNzz
	 lH7LIdLhPTi4mhzz5GxCpqww4Vq5RnVrCPk/XM7k=
Date: Sat, 19 Jul 2025 17:47:20 -0700
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,npache@redhat.com,matthew.brost@intel.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,k.shutemov@gmail.com,hughd@google.com,dev.jain@arm.com,david@redhat.com,dan.carpenter@linaro.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,balbirs@nvidia.com,antonio@mandelbit.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-remove-after_split-label-in-__split_unmapped_folio.patch added to mm-new branch
Message-Id: <20250720004721.758D0C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: remove after_split label in __split_unmapped_folio()
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-remove-after_split-label-in-__split_unmapped_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-remove-after_split-label-in-__split_unmapped_folio.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Zi Yan <ziy@nvidia.com>
Subject: mm/huge_memory: remove after_split label in __split_unmapped_folio()
Date: Thu, 17 Jul 2025 22:29:56 -0400

Checking stop_split instead to avoid the goto statement.

Link: https://lkml.kernel.org/r/20250718023000.4044406-3-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Antonio Quartulli <antonio@mandelbit.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <k.shutemov@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Mathew Brost <matthew.brost@intel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-remove-after_split-label-in-__split_unmapped_folio
+++ a/mm/huge_memory.c
@@ -3463,18 +3463,18 @@ static int __split_unmapped_folio(struct
 				if (xas_error(xas)) {
 					ret = xas_error(xas);
 					stop_split = true;
-					goto after_split;
 				}
 			}
 		}
 
-		folio_split_memcg_refs(folio, old_order, split_order);
-		split_page_owner(&folio->page, old_order, split_order);
-		pgalloc_tag_split(folio, old_order, split_order);
+		if (!stop_split) {
+			folio_split_memcg_refs(folio, old_order, split_order);
+			split_page_owner(&folio->page, old_order, split_order);
+			pgalloc_tag_split(folio, old_order, split_order);
 
-		__split_folio_to_order(folio, old_order, split_order);
+			__split_folio_to_order(folio, old_order, split_order);
+		}
 
-after_split:
 		/*
 		 * Iterate through after-split folios and update folio stats.
 		 * But in buddy allocator like split, the folio
_

Patches currently in -mm which might be from ziy@nvidia.com are

selftests-mm-fix-split_huge_page_test-for-folio_split-tests.patch
mm-huge_memory-move-unrelated-code-out-of-__split_unmapped_folio.patch
mm-huge_memory-remove-after_split-label-in-__split_unmapped_folio.patch
mm-huge_memory-deduplicate-code-in-__folio_split.patch
mm-huge_memory-convert-vm_bug-to-vm_warn-in-__folio_split.patch
mm-huge_memory-get-frozen-folio-refcount-with-folio_expected_ref_count.patch
mm-huge_memory-refactor-after-split-page-cache-code.patch


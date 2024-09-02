Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6FE1CA62;
	Mon,  2 Sep 2024 00:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725238773; cv=none; b=WgDYSNE8RrBr1H/mO3D3JceJAXBVqwSKgygekV20f3zr2OfIB7sdb8ptBNUtUBb7PwgVv2Ufq1fPP3aWFJcz33KylTs0vUEu45lm1BdVr7ZvsyXcKvHnbA9lJFrw6/v+8x9iHSjCpE+JE2R0rTiyvMII0U4iV2+CPTGvhDXn0Cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725238773; c=relaxed/simple;
	bh=yCLIDAeI0wom7CdzdWuuhgCaWzII2Clr/UYh1cEj2ZE=;
	h=Date:To:From:Subject:Message-Id; b=oSVQippI/Hgto+xQOqrG64V8sjkD6V97br3Cd7H51X92qwZ+yLnhgtluYPxRT7N8czlglXtcZP9FBZpi2GZt/Hh/gL6zpyO+dYg2eHAZJVO+3p5C5LVmZBToscEfhp8v1oa2Sc3Eim+4x6FyZ5NJfi5LSXO40od9K6vre3LMEz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z6zS8ky0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z6zS8ky0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54652C4CEC3;
	Mon,  2 Sep 2024 00:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725238773;
	bh=yCLIDAeI0wom7CdzdWuuhgCaWzII2Clr/UYh1cEj2ZE=;
	h=Date:To:From:Subject:From;
	b=z6zS8ky06VwL8euk1lhtWoq1lK/q+Cnc4D6/G6syMZmqBwe6cd86O4FREHyHPUZ12
	 z4IyoTPziEmNfzqZN0QNC4HKtwfqORCbMbCusXerULWzO16rvz4+JmARvEn0trF+AR
	 IT8DHiIbpgVtm7blNInYj9YwQKqb9C/3MU8yhy50=
Date: Sun, 01 Sep 2024 17:59:32 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,xemul@virtuozzo.com,stable@vger.kernel.org,hughd@google.com,david@redhat.com,aarcange@redhat.com,jannh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] userfaultfd-dont-bug_on-if-khugepaged-yanks-our-page-table.patch removed from -mm tree
Message-Id: <20240902005933.54652C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: userfaultfd: don't BUG_ON() if khugepaged yanks our page table
has been removed from the -mm tree.  Its filename was
     userfaultfd-dont-bug_on-if-khugepaged-yanks-our-page-table.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jann Horn <jannh@google.com>
Subject: userfaultfd: don't BUG_ON() if khugepaged yanks our page table
Date: Tue, 13 Aug 2024 22:25:22 +0200

Since khugepaged was changed to allow retracting page tables in file
mappings without holding the mmap lock, these BUG_ON()s are wrong - get
rid of them.

We could also remove the preceding "if (unlikely(...))" block, but then we
could reach pte_offset_map_lock() with transhuge pages not just for file
mappings but also for anonymous mappings - which would probably be fine
but I think is not necessarily expected.

Link: https://lkml.kernel.org/r/20240813-uffd-thp-flip-fix-v2-2-5efa61078a41@google.com
Fixes: 1d65b771bc08 ("mm/khugepaged: retract_page_tables() without mmap or vma lock")
Signed-off-by: Jann Horn <jannh@google.com>
Reviewed-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Pavel Emelyanov <xemul@virtuozzo.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/userfaultfd.c~userfaultfd-dont-bug_on-if-khugepaged-yanks-our-page-table
+++ a/mm/userfaultfd.c
@@ -807,9 +807,10 @@ retry:
 			err = -EFAULT;
 			break;
 		}
-
-		BUG_ON(pmd_none(*dst_pmd));
-		BUG_ON(pmd_trans_huge(*dst_pmd));
+		/*
+		 * For shmem mappings, khugepaged is allowed to remove page
+		 * tables under us; pte_offset_map_lock() will deal with that.
+		 */
 
 		err = mfill_atomic_pte(dst_pmd, dst_vma, dst_addr,
 				       src_addr, flags, &folio);
_

Patches currently in -mm which might be from jannh@google.com are

mm-fix-harmless-type-confusion-in-lock_vma_under_rcu.patch


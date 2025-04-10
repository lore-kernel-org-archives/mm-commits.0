Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D807628E0F;
	Thu, 10 Apr 2025 01:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744247687; cv=none; b=nLCKAJg4h+UoTzOIzKd1h0+WhG8m3Um03+5BzgEeeRVavFQjZaci4qddqqHRUUKsKe//3RdvqJw9zGc0lGzwzgxKXjgneTZO02OjaRTKtan7c0H0fPsv2ADKiZd4ZhJsa9oZ/8F7wvddP7DRMj8vonC+Y13VKvbljU+2akr0Z8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744247687; c=relaxed/simple;
	bh=DkvV/5X2DCk8F1pk8fGBWXxLlBnfwTonnk2IELQ9B9w=;
	h=Date:To:From:Subject:Message-Id; b=OncpEJ2c4/QdwJG/zrU45oewj0hjjjRsezXjj4J9jH197w8KyBx7/Q+SQ9sCbaMoUwiPEuXYGhIDknVx9EHb6u8GpfHJ39QfrMZO/PdgAbnsigyiFKg2GlvBExPqvSvt7LtacGMgFJFXAFc1sBYeKZNE3uA3DRIiVzQMV6Tty+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HyLJ1WhE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HyLJ1WhE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43F29C4CEE2;
	Thu, 10 Apr 2025 01:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744247686;
	bh=DkvV/5X2DCk8F1pk8fGBWXxLlBnfwTonnk2IELQ9B9w=;
	h=Date:To:From:Subject:From;
	b=HyLJ1WhE2DT0+hmzkjprMc/3m9938PKoK+4ie7Ma2LAI0i9oeOgQRh3J1hTCeh2sQ
	 KlVMA89BdUJDMbWVt8OyZFL+GbqyjkjBrumSOh57zVfjC54yQT7SUh+BL9TkdjgTfV
	 txNAWYIhi/6hsLB/PbjZ2kYj8dWQz77BoWudWaqI=
Date: Wed, 09 Apr 2025 18:14:45 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,stable@vger.kernel.org,dja@axtens.net,david@redhat.com,kirill.shutemov@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-apply_to_existing_page_range.patch added to mm-hotfixes-unstable branch
Message-Id: <20250410011446.43F29C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix apply_to_existing_page_range()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-fix-apply_to_existing_page_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-apply_to_existing_page_range.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: fix apply_to_existing_page_range()
Date: Wed, 9 Apr 2025 12:40:43 +0300

In the case of apply_to_existing_page_range(), apply_to_pte_range() is
reached with 'create' set to false.  When !create, the loop over the PTE
page table is broken.

apply_to_pte_range() will only move to the next PTE entry if 'create' is
true or if the current entry is not pte_none().

This means that the user of apply_to_existing_page_range() will not have
'fn' called for any entries after the first pte_none() in the PTE page
table.

Fix the loop logic in apply_to_pte_range().

There are no known runtime issues from this, but the fix is trivial enough
for stable@ even without a known buggy user. 

Link: https://lkml.kernel.org/r/20250409094043.1629234-1-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Fixes: be1db4753ee6 ("mm/memory.c: add apply_to_existing_page_range() helper")
Cc: Daniel Axtens <dja@axtens.net>
Cc: David Hildenbrand <david@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memory.c~mm-fix-apply_to_existing_page_range
+++ a/mm/memory.c
@@ -2943,11 +2943,11 @@ static int apply_to_pte_range(struct mm_
 	if (fn) {
 		do {
 			if (create || !pte_none(ptep_get(pte))) {
-				err = fn(pte++, addr, data);
+				err = fn(pte, addr, data);
 				if (err)
 					break;
 			}
-		} while (addr += PAGE_SIZE, addr != end);
+		} while (pte++, addr += PAGE_SIZE, addr != end);
 	}
 
 	arch_leave_lazy_mmu_mode();
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-page_alloc-fix-deadlock-on-cpu_hotplug_lock-in-__accept_page.patch
mm-fix-apply_to_existing_page_range.patch


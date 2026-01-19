Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34F2500960
	for <mm-commits@vger.kernel.org>; Mon, 19 Jan 2026 20:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768854656; cv=none; b=pjTw5JY7/SXSkURlmkCSOXBVdYDXN0bnL9HnoopsH2aJX6EOdVCyyFxnTmrpOJVVi5U4sgCLZueKK25D+b8eYwjc4xv5WelsoKy4ptFJ6L/UHrwevz4e1nwvRDVVQKBEoNXdt6oULgVDpSPp4F5zao4kg+waZOsZD8G53+EkE8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768854656; c=relaxed/simple;
	bh=gBw8e7AEvZLqqhI2/tBuFdM/Kv6qRlHjx2CRJSBNqas=;
	h=Date:To:From:Subject:Message-Id; b=m01pOnCptoONcy9sFNzMWt4D0hi0E9BXZV73XWxdavyQSGKO+iMCOkIZgCdKoUf0rQnlGUBfgjeTTVpCT1V4b0CCKEH9ux/KRnZrV1JdN/UK59YxX8K5uXisB/a1vQSpbq6i2F05+C5q3/rnmehu54Z5rteqVCjSOBazsVhEsSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lzHffP2A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lzHffP2A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9784C2BC86;
	Mon, 19 Jan 2026 20:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768854655;
	bh=gBw8e7AEvZLqqhI2/tBuFdM/Kv6qRlHjx2CRJSBNqas=;
	h=Date:To:From:Subject:From;
	b=lzHffP2AHFp1JYLxzXg9MMZs/WO8oRwsa6fBm0fZ4oYAjgrsP3MQ3oRcWwPSSo1By
	 syg2Ml7/jkD5V+fSroVoH4441szZIHYIKjyntLpaPy2UNiGHCo0EyaItBB75L2DOLc
	 opZom5d3RDIA+/rcrsSrm2kuVPPm5TRDJ9ue759M=
Date: Mon, 19 Jan 2026 12:30:55 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,sj@kernel.org,rppt@kernel.org,mhocko@suse.com,liam.howlett@oracle.com,david@kernel.org,clm@meta.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-remove-unnecessary-and-incorrect-mmap-lock-assert.patch removed from -mm tree
Message-Id: <20260119203055.C9784C2BC86@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove unnecessary and incorrect mmap lock assert
has been removed from the -mm tree.  Its filename was
     mm-remove-unnecessary-and-incorrect-mmap-lock-assert.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: remove unnecessary and incorrect mmap lock assert
Date: Wed, 14 Jan 2026 11:56:19 +0000

This check was introduced by commit 42fc541404f2 ("mmap locking API: add
mmap_assert_locked() and mmap_assert_write_locked()") which replaced a
VM_BUG_ON_VMA() over rwsem_is_locked from commit a00cc7d9dd93 ("mm, x86:
add support for PUD-sized transparent hugepages"), i.e.  the commit that
introduced PUD THPs.

These seem to be careful asserts introduced to ensure that locks are held
in general, however for a zap we require that VMAs are kept stable, and
this is a requirement that has held perfectly well for a long time.

These were long before VMA locks and thus there appears to be no reason to
think this is assert is there for anything other than 'stabilised VMA'.

Asserting that the VMA under examination is stable only in the case of a
THP PUD is strange and unnecessary.  If we wish to be careful and assert
such things, we should do so at the zap level.

However in any case the current situation is already simply incorrect - a
VMA lock suffices here.

Remove the assert for now as it is unnecessarily, incorrect and unhelpful,
subsequent work can introduce an assert in general for zapping if
required.

Link: https://lkml.kernel.org/r/20260114115619.1087466-1-lorenzo.stoakes@oracle.com
Fixes: 2ab7f1bbafc9 ("mm/madvise: allow guard page install/remove under VMA lock")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: Chris Mason <clm@meta.com>
Closes: https://lore.kernel.org/all/20260113220856.2358195-1-clm@meta.com/
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/memory.c~mm-remove-unnecessary-and-incorrect-mmap-lock-assert
+++ a/mm/memory.c
@@ -1963,10 +1963,9 @@ static inline unsigned long zap_pud_rang
 	do {
 		next = pud_addr_end(addr, end);
 		if (pud_trans_huge(*pud)) {
-			if (next - addr != HPAGE_PUD_SIZE) {
-				mmap_assert_locked(tlb->mm);
+			if (next - addr != HPAGE_PUD_SIZE)
 				split_huge_pud(vma, pud, addr);
-			} else if (zap_huge_pud(tlb, vma, pud, addr))
+			else if (zap_huge_pud(tlb, vma, pud, addr))
 				goto next;
 			/* fall through */
 		}
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-rmap-improve-anon_vma_clone-unlink_anon_vmas-comments-add-asserts.patch
mm-rmap-eliminate-partial-anon_vma-tear-down-in-anon_vma_fork.patch
mm-rmap-skip-unfaulted-vmas-on-anon_vma-clone-unlink.patch
mm-rmap-remove-unnecessary-root-lock-dance-in-anon_vma-clone-unmap.patch
mm-rmap-remove-anon_vma_merge-function.patch
mm-rmap-make-anon_vma-functions-internal.patch
mm-mmap_lock-add-vma_is_attached-helper.patch
mm-rmap-allocate-anon_vma_chain-objects-unlocked-when-possible.patch
mm-rmap-separate-out-fork-only-logic-on-anon_vma_clone.patch
locking-add-rwsem_is_write_locked-update-non-lockdep-asserts.patch
mm-vma-add-vma_is__locked-helpers.patch
mm-add-use-vma_is_stabilised-vma_assert_stabilised-helpers.patch
selftests-mm-remove-virtual_address_range-test.patch


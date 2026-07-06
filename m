Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD2B3A0B24
	for <mm-commits@vger.kernel.org>; Mon,  6 Jul 2026 23:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783379757; cv=none; b=hddr2+sIjf3AJilmRM9rtxWIeSMLvD3eyLuL1+LnYcsJ8fSDTG+mNW3SIM2SZK1c9hu3hyHPvhIO11YBsx9Pn8DQhtsIF9nERDQl4sujfne8KgsxRqxxfqoDaxEicGk59ujQ6b2s/RgPWhttElIpQqk8hf18Al3/ALE15AeN3eA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783379757; c=relaxed/simple;
	bh=VC7rnbUAZXKVxka3dXRIGz0Jx5hr7lbUybaA3Q0x1tM=;
	h=Date:To:From:Subject:Message-Id; b=LguVAb0ZJ27E5PCBIY/AeUVJDMU8d7wJk8l/z+UDmvOGiiPRnQ9rnduu9qLS8P+5yvT9Q65QCb0QOkpkpCDHzF22nugaws0qTz81+r+chs+6H9z2OrEgoixCgGHO3C1Nj67dHjdj9ZMHGVJuPWiYanM7J0urpPYV6clpGliPSL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zWtEXc0P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zWtEXc0P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A36A41F00A3A;
	Mon,  6 Jul 2026 23:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783379755;
	bh=y0XKILBOVvWxTKxYhZnfDHIXONc+SuaGzi9Xc4HfMU4=;
	h=Date:To:From:Subject;
	b=zWtEXc0P2XmdVj76hKB7gNrjCPrHiGH6Kur7mRmQGFho+eqHBxdsVOFFTEEqY2TdL
	 OzIgLSuc8mVTUbBttUdljT9psjKs9kpjL/QtPO32COqGSL/b05f0bU/jRTM0hWP6KQ
	 x+c/VQY9YAZLx59i0yP0LrtLmhB873ZyEEH8GOX4=
Date: Mon, 06 Jul 2026 16:15:55 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,rppt@kernel.org,nphamcs@gmail.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kasong@tencent.com,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-drop-stale-folio_ref_count==1-check-in-do_swap_page-reuse-logic-fix.patch added to mm-new branch
Message-Id: <20260706231555.A36A41F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-drop-stale-folio_ref_count==1-check-in-do_swap_page-reuse-logic-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-drop-stale-folio_ref_count==1-check-in-do_swap_page-reuse-logic-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-drop-stale-folio_ref_count==1-check-in-do_swap_page-reuse-logic-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-drop-stale-folio_ref_count==1-check-in-do_swap_page-reuse-logic-fix
Date: Mon Jul  6 04:13:37 PM PDT 2026

update comment, per David

Link: https://lore.kernel.org/3a185a5d-2f2c-4e9d-9cd9-8bdb236dfc5c@kernel.org
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memory.c~mm-drop-stale-folio_ref_count==1-check-in-do_swap_page-reuse-logic-fix
+++ a/mm/memory.c
@@ -5039,8 +5039,8 @@ check_folio:
 		pte = pte_mkuffd_wp(pte);
 
 	/*
-	 * Similar logic as in do_wp_page(); however, optimize for pages that are
-	 * certainly not because the swap entry indicates exclusivity.
+	 * Similar logic as in do_wp_page(); however, optimize for pages that
+	 * are certainly exclusive.
 	 */
 	if (exclusive) {
 		if ((vma->vm_flags & VM_WRITE) && !userfaultfd_pte_wp(vma, pte) &&
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-mincore-use-walk_page_range_vma-in-do_mincore-fix.patch
csky-implement-flush_cache_vmap-in-c.patch
mm-page_owner-add-print_mode-filter-fix.patch
mm-annotate-data-race-in-cpu_needs_drain-fix.patch
mm-zsmalloc-encode-class-index-in-obj-value-for-lockless-class-lookup-fix.patch
mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix.patch
mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix-fix.patch
mm-fix-assert_exclusive_bits-by-passing-memdesc_flags_t-by-pointer-fix.patch
mm-rmap-use-huge_ptep_get-in-try_to_migrate_one-checkpatch-fixes.patch
mm-mprotect-use-huge_ptep_get-for-hugetlb-fix.patch
mm-drop-stale-folio_ref_count==1-check-in-do_swap_page-reuse-logic-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch


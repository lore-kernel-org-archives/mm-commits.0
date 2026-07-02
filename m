Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A8A63B9
	for <mm-commits@vger.kernel.org>; Thu,  2 Jul 2026 00:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782951119; cv=none; b=X9VcBwWJSoA7eBztnUB9fwBFXlIwpgBtb11OV0mXBVTyRSK73HEG3hoBALTy5RVVGddvm3fzmCiJo0vbOgrLI9f+NgnAHBhkDi+IxT1gP9xyIjg1Jqv/oXTRPr3lF/5ZOEz5aLJkp1wv2bToZDssLTTo64MXvOGmhpXOCtBygQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782951119; c=relaxed/simple;
	bh=Uhn11uZ2bMCedl1UGk3TiYqtwFeSprezqXYPpqHNfl0=;
	h=Date:To:From:Subject:Message-Id; b=SCWwBfi6IqWovs31wbB/8Tdv92tEZKpm80Ikc4QZnWRVQXRZuu1w3R8fnV5juZrxadx5dqLoW+hrFDbcc9gRuASX1q0mC00A38/UQPm+vPzayYp2fGogAUdnThRV8EW0lnZxevBQ0hJuUTOCp3fvQIg6I5++AUMPyMaIdFWSvck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GHsNYhXN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GHsNYhXN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 985711F000E9;
	Thu,  2 Jul 2026 00:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782951114;
	bh=gMQeYuXbZxf2p5ceuQa385cCy03E5FRfDMjUALYactk=;
	h=Date:To:From:Subject;
	b=GHsNYhXNRolN6vmqkZQSj+B0k+HAgdvkrK2aJhzzQxH68w90CqA0Op0R5xyR6PuYp
	 g6AKzypofgCpC7jFdbbXaUHBlGc0ctTAyQoQ8DUNyF9cMsYandf02WHqIfNC2YS+cV
	 5PKFcBNDYwHcJgvcb8pvc3l6HA1HrbWw89gf8X3c=
Date: Wed, 01 Jul 2026 17:11:54 -0700
To: mm-commits@vger.kernel.org,ye.liu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_owner-use-memcg_data-snapshot-instead-of-pagememcgkmem-to-avoid-toctou-vm_bug_on.patch added to mm-unstable branch
Message-Id: <20260702001154.985711F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_owner: use memcg_data snapshot instead of PageMemcgKmem() to avoid TOCTOU VM_BUG_ON
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_owner-use-memcg_data-snapshot-instead-of-pagememcgkmem-to-avoid-toctou-vm_bug_on.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_owner-use-memcg_data-snapshot-instead-of-pagememcgkmem-to-avoid-toctou-vm_bug_on.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Ye Liu <ye.liu@linux.dev>
Subject: mm/page_owner: use memcg_data snapshot instead of PageMemcgKmem() to avoid TOCTOU VM_BUG_ON
Date: Wed, 1 Jul 2026 14:10:52 +0800

print_page_owner_memcg() takes a snapshot of page->memcg_data via
READ_ONCE at the top of the function and guards against tail pages and
NULL memcg_data.  However, at the end it calls PageMemcgKmem(page) which
internally calls folio_memcg_kmem() — and that function re-reads
folio->memcg_data and page->compound_head locklessly, wrapping both in
VM_BUG_ON assertions:

    VM_BUG_ON_PGFLAGS(PageTail(&folio->page), &folio->page);
    VM_BUG_ON_FOLIO(folio->memcg_data & MEMCG_DATA_OBJEXTS, folio);

If the page is concurrently freed and reallocated as a THP tail page or a
slab page between the initial guards and this final call, the VM_BUG_ON
assertions can fire on debug builds (CONFIG_DEBUG_VM=y), causing a kernel
panic.

Fix by reusing the memcg_data snapshot already taken at function entry
instead of calling PageMemcgKmem(), which is semantically equivalent:
PageMemcgKmem()->folio_memcg_kmem()->folio->memcg_data & MEMCG_DATA_KMEM. 
This avoids both the TOCTOU window and the assertions entirely.

Link: https://lore.kernel.org/20260701061101.344679-10-ye.liu@linux.dev
Signed-off-by: Ye Liu <ye.liu@linux.dev>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_owner.c~mm-page_owner-use-memcg_data-snapshot-instead-of-pagememcgkmem-to-avoid-toctou-vm_bug_on
+++ a/mm/page_owner.c
@@ -561,7 +561,7 @@ static inline int print_page_owner_memcg
 	cgroup_name(memcg->css.cgroup, name, sizeof(name));
 	ret += scnprintf(kbuf + ret, count - ret,
 			"Charged %sto %smemcg %s\n",
-			PageMemcgKmem(page) ? "(via objcg) " : "",
+			(memcg_data & MEMCG_DATA_KMEM) ? "(via objcg) " : "",
 			online ? "" : "offline ",
 			name);
 out_unlock:
_

Patches currently in -mm which might be from ye.liu@linux.dev are

mm-page_owner-extract-skip_buddy_pages-helper-to-unify-buddy-page-skipping.patch
mm-page_owner-add-mr_never-to-enum-migrate_reason-and-use-it-for-last_migrate_reason.patch
mm-use-enum-migrate_reason-instead-of-int-for-migration-reason-parameters.patch
mm-page_owner-hoist-config_memcg-to-function-level-for-print_page_owner_memcg.patch
mm-page_owner-add-missing-newline-to-count_threshold-format-string.patch
mm-page_owner-move-free_ts_nsec-output-to-free-section-in-__dump_page_owner.patch
mm-page_owner-drop-redundant-page_owner-prefix-from-static-symbols.patch
mm-page_owner-clamp-skip_buddy_pages-pfn-advance-at-max_order_nr_pages-boundary.patch
mm-page_owner-use-memcg_data-snapshot-instead-of-pagememcgkmem-to-avoid-toctou-vm_bug_on.patch


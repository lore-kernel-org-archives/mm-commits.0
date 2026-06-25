Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0981C3A8FE9
	for <mm-commits@vger.kernel.org>; Thu, 25 Jun 2026 02:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782353082; cv=none; b=hCkVToEZbX2WQQxgtKpUyMIhuAu2Y89UTjpmXO32PYcDTGUeFLNd0oxqJ6D+C7Xb0x+gdY8vLTHkCi3XpmxXqZqvMqJAQgrAZQjjQxIL0Ao6Vx6cAZS/cc87r3JoTh6zHqupGquoQaVotqT74WgScVYPT+56vUEFnck+CBdEJak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782353082; c=relaxed/simple;
	bh=GfeP+JSTtDquI6WPDD9wJLnzcUGA9lFgUGNCSPH2EVk=;
	h=Date:To:From:Subject:Message-Id; b=g3L3UTtsgm0iBANIqMFH26xYvdKEOvDTHZO+kedPgXV0z5tNo0OS22g4KYYqCNvGiZn6rVM50/JJDbOWBaqbgkfvd67oAiKqsn222v/mPNu02+7fSFRHgqOm9oy+OW30KORyZeJSCQGssyJB3c/yidh8OXqn8XpjsMz7dCNLBhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N1gGiOjE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N1gGiOjE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8887D1F000E9;
	Thu, 25 Jun 2026 02:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782353080;
	bh=VBhiRA4eF3AF6b/fBaIsPCicP25zGOVnbxmLZcAA3iw=;
	h=Date:To:From:Subject;
	b=N1gGiOjE+8IslWI+uNXHXfHCx0K+etIkwfYX+7Hzqghm2i/D1sKBbB/HBL6rMLPF/
	 wAFPUc7a6+OslqQODEDMwr4AFMLrlVpJSqF9rG4ApEi8/q0P80Bj7qyJ3AdNRpcZ6M
	 bfEYbnM5wgrKExQCBYiKRIVlX/Gq1SosKbl2z2UU=
Date: Wed, 24 Jun 2026 19:04:40 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,ye.liu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_owner-use-memcg_data-snapshot-instead-of-pagememcgkmem-to-avoid-toctou-vm_bug_on.patch added to mm-new branch
Message-Id: <20260625020440.8887D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_owner: use memcg_data snapshot instead of PageMemcgKmem() to avoid TOCTOU VM_BUG_ON
has been added to the -mm mm-new branch.  Its filename is
     mm-page_owner-use-memcg_data-snapshot-instead-of-pagememcgkmem-to-avoid-toctou-vm_bug_on.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_owner-use-memcg_data-snapshot-instead-of-pagememcgkmem-to-avoid-toctou-vm_bug_on.patch

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
From: Ye Liu <ye.liu@linux.dev>
Subject: mm/page_owner: use memcg_data snapshot instead of PageMemcgKmem() to avoid TOCTOU VM_BUG_ON
Date: Thu, 25 Jun 2026 09:47:05 +0800

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

Link: https://lore.kernel.org/20260625014708.87386-3-ye.liu@linux.dev
Signed-off-by: Ye Liu <ye.liu@linux.dev>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_owner.c~mm-page_owner-use-memcg_data-snapshot-instead-of-pagememcgkmem-to-avoid-toctou-vm_bug_on
+++ a/mm/page_owner.c
@@ -568,7 +568,7 @@ static inline int print_page_owner_memcg
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
mm-page_owner-use-migrate_reason_none-instead-of-1-for-last_migrate_reason.patch
mm-page_owner-hoist-config_memcg-to-function-level-for-print_page_owner_memcg.patch
mm-page_owner-add-missing-newline-to-count_threshold-format-string.patch
mm-page_owner-move-free_ts_nsec-output-to-free-section-in-__dump_page_owner.patch
mm-page_owner-drop-redundant-page_owner-prefix-from-static-symbols.patch
mm-page_owner-clamp-skip_buddy_pages-pfn-advance-at-max_order_nr_pages-boundary.patch
mm-page_owner-use-memcg_data-snapshot-instead-of-pagememcgkmem-to-avoid-toctou-vm_bug_on.patch


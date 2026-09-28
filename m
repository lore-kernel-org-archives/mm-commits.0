Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9781425333F
	for <mm-commits@vger.kernel.org>; Mon, 28 Sep 2026 22:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790636015; cv=none; b=MM5fyZfne/4k+29PoYjNVux0r8Yhb4649xJXDJH+zM6xSzHIRSJrRfjVjr77r0D4FNzxRmVYczVgQpSnRhaJHMYfy7pM0PwXQgmAdks/gEHybxrMzMe4F3vlYu23n4/6h7V0md3ei4YR7EJqsONCa2YrBZGjskEiLocvkABb4/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790636015; c=relaxed/simple;
	bh=7oEEFyird/dKwj8iskqBBvWuAm7nckDl2iBc9QCeRco=;
	h=Date:To:From:Subject:Message-Id; b=YYlqW1EYPB1KbPT5HQ4+AUViL5ddDptjecURgCr9+vaJI6szbtvntbzOOUMJ/LSH2RQqOOo2zt/bOpWRdhyTm13hCx+XPT5AVl9mwxR8+NiqfHJvawpvy4rK/NsvL3ALuCOy6oLMF/6p6fH6QU+L1x/wN7EXIyu71tDn4fxvDZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J/QKFCkV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J/QKFCkV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 479F61F000FF;
	Mon, 28 Sep 2026 22:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790636014;
	bh=jd1dchYrH1kXKGZr6m9thAwt97cbqEV0vg4npxej8+8=;
	h=Date:To:From:Subject;
	b=J/QKFCkVCeyOGcepwLVpupuF/iURCNuDfaj8zBJDSHG2M4w9JUFH4d06wLvtOdL3u
	 IDqHUB6d+4uaQ9FPnnc90KiKCq7a0Wf02b8Pdrq6H7hRYQkKvF5rEUQ/yNCAsoddxv
	 T4s0N2O5cmDl+sOyCxRU7qPrSOvu/8SuwKCkO+40=
Date: Mon, 28 Sep 2026 15:53:33 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,pjw@kernel.org,palmer@dabbelt.com,aou@eecs.berkeley.edu,alex@ghiti.fr,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-fix-vmalloc_dump_obj-address-alignment-for-last-page-lookups.patch added to mm-new branch
Message-Id: <20260928225334.479F61F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: fix vmalloc_dump_obj address alignment for last-page lookups
has been added to the -mm mm-new branch.  Its filename is
     mm-vmalloc-fix-vmalloc_dump_obj-address-alignment-for-last-page-lookups.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-fix-vmalloc_dump_obj-address-alignment-for-last-page-lookups.patch

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
From: Ye Liu <liuye@kylinos.cn>
Subject: mm/vmalloc: fix vmalloc_dump_obj address alignment for last-page lookups
Date: Mon, 28 Sep 2026 16:15:54 +0800

Patch series "mm/vmalloc: fix vmalloc_dump_obj VA lookup", v4.

vmalloc_dump_obj() has two bugs that cause it to miss vmalloc
allocations.

  1. PAGE_ALIGN() rounds up, pushing last-page addresses to va_end
     and outside the VA lookup range.

  2. The function searches only one vmap node, but allocations
     larger than 64 KiB may span multiple vmap zones whose VA
     is stored in a different node's rb-tree.

Patch 1 fixes the alignment, patch 2 fixes the cross-zone search.


This patch (of 2):

vmalloc_dump_obj() uses PAGE_ALIGN() to normalize the input address before
looking it up in the per-node busy tree.  PAGE_ALIGN() rounds up, which
can push an address in the last page of a vmalloc allocation to va_end --
outside the [va_start, va_end) range that __find_vmap_area() searches. 
This causes the lookup to miss the VA and return false, degrading
diagnostic output in OOM dumps and KASAN reports to the less informative
"vmalloc memory" fallback.

The upward alignment can also change the addr_to_node() mapping when the
page boundary crosses a vmap zone boundary, causing the search to hit the
wrong node entirely.

Use PAGE_ALIGN_DOWN() instead, which rounds down to the page containing
the address.  This keeps the address within the VA range and preserves the
correct node mapping.

Link: https://lore.kernel.org/20260928-vmalloc_dump_obj-v4-0-6f288a431edc@linux.dev
Link: https://lore.kernel.org/20260928-vmalloc_dump_obj-v4-1-6f288a431edc@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-fix-vmalloc_dump_obj-address-alignment-for-last-page-lookups
+++ a/mm/vmalloc.c
@@ -5281,7 +5281,7 @@ bool vmalloc_dump_obj(void *object)
 	unsigned long addr;
 	unsigned long nr_pages;
 
-	addr = PAGE_ALIGN((unsigned long) object);
+	addr = PAGE_ALIGN_DOWN((unsigned long) object);
 	vn = addr_to_node(addr);
 
 	if (!spin_trylock(&vn->busy.lock))
_

Patches currently in -mm which might be from liuye@kylinos.cn are

tools-mm-page_owner_sort-fix-sort-option-being-silently-ignored.patch
tools-mm-page_owner_sort-add-module-name-sort-cull-filter-support.patch
tools-mm-page_owner_sort-show-available-sort-keys-in-usage-text.patch
mm-oom_kill-remove-unreachable-__gfp_thisnode-check-in-constrained_alloc.patch
mm-oom_kill-proc-replace-magic-number-1000-with-oom_score_adj_max.patch
mm-page_table_check-add-explicit-pmd_none-check-in-pte_clear_range.patch
mm-vmalloc-group-xa_init-with-vbq-field-initializations.patch
mm-vmalloc-extract-vmap_insert_free_area-helper.patch
mm-vmalloc-extract-show_busy_info-from-vmalloc_info_show.patch
mm-vmalloc-fix-vmalloc_dump_obj-address-alignment-for-last-page-lookups.patch
mm-vmalloc-fix-vmalloc_dump_obj-cross-zone-va-lookup.patch


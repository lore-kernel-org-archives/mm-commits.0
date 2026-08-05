Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E56476CFE;
	Wed,  5 Aug 2026 16:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785948692; cv=none; b=hOO7VP2OWxf9uT9ek6qE57GidyaW2IhbWi9bUff/AAg5U/YGUVBcpx2FysjFq6/9jtJ64+Esm/VhdBlQbw37lfcs4+XsQ0Rmi7KVXhZ+V85eA9a4bvbK3l1VUWQfYwyh+AknNcu+4FuNdHxHn2kmhdnb3+kj1WUS8OWAfV6K+7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785948692; c=relaxed/simple;
	bh=xKqZGubRQdTcMewYYfzR77AGpzvapFrKlWPaY6SOhOI=;
	h=Date:To:From:Subject:Message-Id; b=hnrnTWtzFYCwGdyzehjl68CPv1dFBNTS0ImhfO5LGQRglXKxupHBhO+WHe+dkoqbAE/D3cd9MEwWX/DzqgD0KgehVDHweL6eHHj2OZMNsEVW2aOCGsP4QeWyA7w5KUhB3DWYEXTAbjoYCDgkMOUIQ6F26gvVlnqadND5XLt6yMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mbo/6nTv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mbo/6nTv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FE171F000E9;
	Wed,  5 Aug 2026 16:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785948691;
	bh=Xjog00WsPXGeoa/LySEvnwqupfJIqXQNHlOHBAgbvfc=;
	h=Date:To:From:Subject;
	b=mbo/6nTvfRehqbEyk8R7Cae2NuBuHfeJlUKKTDEgd6D8OwS63icfwvKdOY3wuznP2
	 kdIbLpA3DCB3pmOOClgYlM+0EpgWea2o7cc3IBrVTy1t44LAUTixnYiqKP+bYPQCJz
	 /oecfJQVpVkThBSukfI1DsanQCK1D5G4LY9sRoGg=
Date: Wed, 05 Aug 2026 09:51:30 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,stable@vger.kernel.org,hao.ge@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alloc_tag-fix-undetected-compressed-tag-overflow-when-profiling-is-disabled.patch added to mm-new branch
Message-Id: <20260805165131.3FE171F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: alloc_tag: fix undetected compressed tag overflow when profiling is disabled
has been added to the -mm mm-new branch.  Its filename is
     alloc_tag-fix-undetected-compressed-tag-overflow-when-profiling-is-disabled.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alloc_tag-fix-undetected-compressed-tag-overflow-when-profiling-is-disabled.patch

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
From: Hao Ge <hao.ge@linux.dev>
Subject: alloc_tag: fix undetected compressed tag overflow when profiling is disabled
Date: Wed, 5 Aug 2026 17:06:33 +0800

In reserve_module_tags(), the tag overflow check is gated on
mem_alloc_profiling_enabled():

    if (mem_alloc_profiling_enabled() && !tags_addressable())

If profiling is toggled off at runtime and a module is loaded whose tags
exceed the compressed-mode limit, shutdown_mem_profiling() is skipped. 
vm_module_tags_populate() still maps memory for the tags and the module
loads successfully, but the total tag count now exceeds what
NR_UNUSED_PAGEFLAG_BITS can address.

Once profiling is re-enabled, ref_to_idx() computes each tag's index as
its position in the alloc_tag array.  update_page_tag_ref() masks it to
alloc_tag_ref_mask before storing in page->flags.  Indices beyond the mask
are truncated and idx_to_ref() resolves them to wrong tags.

This silently corrupts /proc/allocinfo: allocated pages get attributed to
the wrong call sites, so the statistics it reports are wrong.

mem_alloc_profiling_enabled() and mem_profiling_compressed are
independent.  Once compressed mode is established at boot, it stays active
regardless of runtime toggles of mem_profiling.

Remove the mem_alloc_profiling_enabled() guard.  Also return an error
after shutdown_mem_profiling() to skip vm_module_tags_populate(), as the
mapped pages would never be reused - shutdown_mem_profiling() sets
mem_profiling_support to false, so no future module load enters the
codetag path.

Link: https://lore.kernel.org/20260805090633.141001-1-hao.ge@linux.dev
Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compression")
Signed-off-by: Hao Ge <hao.ge@linux.dev>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/alloc_tag.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/alloc_tag.c~alloc_tag-fix-undetected-compressed-tag-overflow-when-profiling-is-disabled
+++ a/mm/alloc_tag.c
@@ -904,10 +904,11 @@ unlock:
 		int grow_res;
 
 		module_tags.size = offset + size;
-		if (mem_alloc_profiling_enabled() && !tags_addressable()) {
+		if (!tags_addressable()) {
 			shutdown_mem_profiling(true);
-			pr_warn("With module %s there are too many tags to fit in %d page flag bits. Memory allocation profiling is disabled!\n",
-				mod->name, NR_UNUSED_PAGEFLAG_BITS);
+			pr_warn_once("With module %s there are too many tags to fit in %d page flag bits. Memory allocation profiling is disabled!\n",
+				     mod->name, NR_UNUSED_PAGEFLAG_BITS);
+			return ERR_PTR(-ENOMEM);
 		}
 
 		grow_res = vm_module_tags_populate();
_

Patches currently in -mm which might be from hao.ge@linux.dev are

alloc_tag-fix-undetected-compressed-tag-overflow-when-profiling-is-disabled.patch


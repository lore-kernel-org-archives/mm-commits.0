Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A2A33BBD7;
	Tue,  4 Aug 2026 23:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785886995; cv=none; b=H8G9vFn79ipqrrhFvdPrKKAalO92V14kaI7JUkqgXyGZIPl3Dz8C1oX9Wtm9RijXogAy5KqynVALA1SagXp8KEQHZ1DXLvTPiId5vvzjUXk+xMw3laj9S/kll3Yz2f0ZlnNDx0V4DK+myiU3NAsq1MEsc2neZaT/CMiKiXKRBt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785886995; c=relaxed/simple;
	bh=gcNRfZmVOUQE71chp7va5RueXNzy75wNDXktTz7Fw9o=;
	h=Date:To:From:Subject:Message-Id; b=Hrpm41FYW6E60z0rA0oBX6MY3E+7RWPZVhO0Ti84+ENDwGhK6DaGFH73V5QytoH5jVljDnLcotCBLfKZz8nBWW0wTBrmVN1ThgsZJvIu81ie3ETXyoFjftWnxLcVJeP06wWSLzL6RGGUYiIHUL53jNdFlJe0QhMr/ud9IQJjjIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FxQ5+DAj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FxQ5+DAj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2FBB1F000E9;
	Tue,  4 Aug 2026 23:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785886993;
	bh=P2leOc/jWqWp+zKq1Wpzb9w4lyv2AHhiWPAfCDwNdT4=;
	h=Date:To:From:Subject;
	b=FxQ5+DAjCsyXoK+rlVAq+r2K15fBOZhEhc5JqpzG3kSylMB4yitO+WNFp2KvIukW2
	 R5T4ye1RrOgP/7P/mGoDTDtfRIei5NUhXBT35cctcd6g74rN01r67h2n02+E/rq22d
	 8SanErZXmwG3KG7HbUUl6nuDB7V6BJKgWQ1EOV3Y=
Date: Tue, 04 Aug 2026 16:43:13 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,abhishekbapat@google.com,hao.ge@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alloc_tag-fix-undetected-compressed-tag-overflow-when-profiling-is-disabled.patch added to mm-new branch
Message-Id: <20260804234313.C2FBB1F000E9@smtp.kernel.org>
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
Date: Tue, 4 Aug 2026 14:44:08 +0800

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

mem_alloc_profiling_enabled() and mem_profiling_compressed are
independent.  Once compressed mode is established at boot, it stays active
regardless of runtime toggles of mem_profiling.

We therefore remove the mem_alloc_profiling_enabled() guard.

Link: https://lore.kernel.org/20260804064408.105033-1-hao.ge@linux.dev
Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compression")
Signed-off-by: Hao Ge <hao.ge@linux.dev>
Cc: Hao Ge <hao.ge@linux.dev>
Cc: Abhishek Bapat <abhishekbapat@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/alloc_tag.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/alloc_tag.c~alloc_tag-fix-undetected-compressed-tag-overflow-when-profiling-is-disabled
+++ a/mm/alloc_tag.c
@@ -904,7 +904,7 @@ unlock:
 		int grow_res;
 
 		module_tags.size = offset + size;
-		if (mem_alloc_profiling_enabled() && !tags_addressable()) {
+		if (!tags_addressable()) {
 			shutdown_mem_profiling(true);
 			pr_warn("With module %s there are too many tags to fit in %d page flag bits. Memory allocation profiling is disabled!\n",
 				mod->name, NR_UNUSED_PAGEFLAG_BITS);
_

Patches currently in -mm which might be from hao.ge@linux.dev are

alloc_tag-fix-undetected-compressed-tag-overflow-when-profiling-is-disabled.patch


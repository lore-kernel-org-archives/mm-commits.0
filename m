Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9993C456B
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 16:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785948633; cv=none; b=uFnqVFQdrVqf3go3fyFTW/tUcWQwlH99Bp74Kb47UypDBdCa/WLP3YwjZiGqNqADJ6DY7PzXEvs+kYDU9mP5AB2FWiZH0+NnAFh0xU0p/VmtGoVqOkiWkbgut/yTOw5wCIhMR9OkSf6JrqY4qwsedj2CyaQlOhmfUzPipEz/DcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785948633; c=relaxed/simple;
	bh=4ZNzfVj65CgKvbErQ8q9XyB9h3JW3Gsoydh8MvxCRKk=;
	h=Date:To:From:Subject:Message-Id; b=NsKdJ6qa2yqiq4S1wcfzRHXIEbHN1rUlkvWXHPxyQwBT/nvn1crSFss0CzJik4ujxb898p0lA/jZr1MENZ0Qim7s5rH2tQ7nrRTlqlxdvH6LXtJWJGzLeIj+5RU6S4Zkbc56KwHpCWKFWQd4NQh2rqkxmVVnwsw+5Lr29PnRLi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GpgxnB0T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GpgxnB0T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62AC61F000E9;
	Wed,  5 Aug 2026 16:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785948632;
	bh=Q2xK+QRlo9pvS4dj/6sEF4HqQ9j1MeVl8DcROqstRCU=;
	h=Date:To:From:Subject;
	b=GpgxnB0TKwjInRhALqoaD79ZodrpYhTvGEPLQQj6S64Aq3XXikHJnwfOhE01XFe1b
	 ksnaI0XhiT6vyNHMsM4lmlg9mE3q3mXHzjqkdJLCTqiEo5FBA0fooCfG24aPTXvA8T
	 CaFI1QWbVPIrdPnRm94QXUhK6N7KELgUbOc/cGFg=
Date: Wed, 05 Aug 2026 09:50:31 -0700
To: mm-commits@vger.kernel.org,hao.ge@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] alloc_tag-fix-undetected-compressed-tag-overflow-when-profiling-is-disabled.patch removed from -mm tree
Message-Id: <20260805165032.62AC61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: alloc_tag: fix undetected compressed tag overflow when profiling is disabled
has been removed from the -mm tree.  Its filename was
     alloc_tag-fix-undetected-compressed-tag-overflow-when-profiling-is-disabled.patch

This patch was dropped because an updated version will be issued

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



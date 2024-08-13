Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D92F282E5;
	Tue, 13 Aug 2024 18:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723574405; cv=none; b=j406Jk3HoryPZ+cjGbAUQ/Frim0FG4CmoVwk2hD4x9TVMZbEFyrsSA7vabKJgWt0MyoLgSSm3OPBYWxhw8ifjfG/GYROa6Rm5Ml67DBjfDa6dhMGNEdJj5XSH/EWER2ZIgebJdQII5qYrDnFNpPX00XojRLLOllBHXucG9zJ8E0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723574405; c=relaxed/simple;
	bh=XLjTxUm+HNyPlSMAn/vrQca+RTGNf/xSV+RySCqVtvc=;
	h=Date:To:From:Subject:Message-Id; b=g/CdIImVYhnIF7oV2MMc+fN/vfyGKk7cI3tJnii7DC9jPFZeYa4yLS3bLrtlpmaFjymPsPBK7Nlzfbpirz7C+4a0Ql9HM/G+Uj5+lAlXWn+co6j93R8DfrrcR4OWjIgvgYv2XgbFNhG96OPVh10eHH9bgKgZsCRMHSLNU2y3Fxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mcAX3i8t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mcAX3i8t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D5E7C32782;
	Tue, 13 Aug 2024 18:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723574404;
	bh=XLjTxUm+HNyPlSMAn/vrQca+RTGNf/xSV+RySCqVtvc=;
	h=Date:To:From:Subject:From;
	b=mcAX3i8tNh6rglDMHzEaNnT1oouyPsSzVYVKf8iMAZl2O14Z4PMfSAjAUaAUyE5n3
	 ChOU2N/y+i3ALq0mzPy1crMzj8nMt8A2rAWwYBE4mUlRMssTIJGGDS4T9vxj167xMi
	 sQNBrP6cGGlcHGEHtxzxC2oTq3XRZQuuqsUyjoRg=
Date: Tue, 13 Aug 2024 11:40:04 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,stable@vger.kernel.org,souravpanda@google.com,pasha.tatashin@soleen.com,kent.overstreet@linux.dev,keescook@chromium.org,david@redhat.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alloc_tag-mark-pages-reserved-during-cma-activation-as-not-tagged.patch added to mm-hotfixes-unstable branch
Message-Id: <20240813184004.9D5E7C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: alloc_tag: mark pages reserved during CMA activation as not tagged
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     alloc_tag-mark-pages-reserved-during-cma-activation-as-not-tagged.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alloc_tag-mark-pages-reserved-during-cma-activation-as-not-tagged.patch

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
From: Suren Baghdasaryan <surenb@google.com>
Subject: alloc_tag: mark pages reserved during CMA activation as not tagged
Date: Tue, 13 Aug 2024 08:07:57 -0700

During CMA activation, pages in CMA area are prepared and then freed
without being allocated.  This triggers warnings when memory allocation
debug config (CONFIG_MEM_ALLOC_PROFILING_DEBUG) is enabled.  Fix this by
marking these pages not tagged before freeing them.

Link: https://lkml.kernel.org/r/20240813150758.855881-2-surenb@google.com
Fixes: d224eb0287fb ("codetag: debug: mark codetags for reserved pages as empty")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>	[6.10]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/mm_init.c~alloc_tag-mark-pages-reserved-during-cma-activation-as-not-tagged
+++ a/mm/mm_init.c
@@ -2244,6 +2244,8 @@ void __init init_cma_reserved_pageblock(
 
 	set_pageblock_migratetype(page, MIGRATE_CMA);
 	set_page_refcounted(page);
+	/* pages were reserved and not allocated */
+	clear_page_tag_ref(page);
 	__free_pages(page, pageblock_order);
 
 	adjust_managed_page_count(page, pageblock_nr_pages);
_

Patches currently in -mm which might be from surenb@google.com are

alloc_tag-introduce-clear_page_tag_ref-helper-function.patch
alloc_tag-mark-pages-reserved-during-cma-activation-as-not-tagged.patch


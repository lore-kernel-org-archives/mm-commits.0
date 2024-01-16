Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9095730A
	for <mm-commits@vger.kernel.org>; Tue, 16 Jan 2024 20:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705435756; cv=none; b=eR9cUfRkMVf0hoyE8+lCQh/nocLTZFLg6DXGV49V70FzoCjtMlf71gK/97dk+4ihb1o/ImONngxlDwQbXspwb1zKc3WqMaJ06Dq84LiuTLHM8+DbqgM0V7Arwi7N13idrtJBSObxygIN3XQh3B/prxNECcpfHlh5sblyTpPGIcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705435756; c=relaxed/simple;
	bh=BrOTVHOlB5LAMKOCtLF8KshyxfPfQzwuGkolbnR7Hx4=;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id; b=c47rhK+0W9hx0JohVGXsCTd1oRKzCf6taoqoWYQ6TvhlwIXeJmar8InG1Ik0Sy5XFxsiTnrI+KPGfkUDu1lzTJTO/FIwQu+os3A4GvadGTkGR2d90+e8bKOsU5SEvSGlSBB30mmnuF4p0/9jhl+FYAJD9q72YYTXn/rS8a7lSY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Hb+NxyQ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Hb+NxyQ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FF61C433C7;
	Tue, 16 Jan 2024 20:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705435755;
	bh=BrOTVHOlB5LAMKOCtLF8KshyxfPfQzwuGkolbnR7Hx4=;
	h=Date:To:From:Subject:From;
	b=Hb+NxyQ/RZSNmO8iCDP6K42MVvESYYMzdAvd5dcUJjJPg4w09MlCQZRRAO5QQlHiV
	 VAwn1/yku1FOT8QcRrbjAyyUN7Tyj0kChPRqNTw+lRpQR4POnclFm/c318zQXDxklm
	 cL+58ZU2B6RGh4IzWtTeXc+XonLHSjnzzrz/EvcA=
Date: Tue, 16 Jan 2024 12:09:13 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,peterz@infradead.org,oleg@redhat.com,namhyung@kernel.org,mingo@redhat.com,mark.rutland@arm.com,jolsa@kernel.org,irogers@google.com,adrian.hunter@intel.com,acme@kernel.org,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + uprobes-use-pagesize-aligned-virtual-address-when-replacing-pages.patch added to mm-hotfixes-unstable branch
Message-Id: <20240116200915.7FF61C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: uprobes: use pagesize-aligned virtual address when replacing pages
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     uprobes-use-pagesize-aligned-virtual-address-when-replacing-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/uprobes-use-pagesize-aligned-virtual-address-when-replacing-pages.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: uprobes: use pagesize-aligned virtual address when replacing pages
Date: Mon, 15 Jan 2024 11:07:31 +0100

uprobes passes an unaligned page mapping address to
folio_add_new_anon_rmap(), which ends up triggering a VM_BUG_ON() we
recently extended in commit 372cbd4d5a066 ("mm: non-pmd-mappable, large
folios for folio_add_new_anon_rmap()").

Arguably, this is uprobes code doing something wrong; however, for the
time being it would have likely worked in rmap code because
__folio_set_anon() would set folio->index to the same value.

Looking at __replace_page(), we'd also pass slightly wrong values to
mmu_notifier_range_init(), page_vma_mapped_walk(), flush_cache_page(),
ptep_clear_flush() and set_pte_at_notify().  I suspect most of them are
fine, but let's just mark the introducing commit as the one needed fixing.
I don't think CC stable is warranted.

We'll add more sanity checks in rmap code separately, to make sure that we
always get properly aligned addresses.

Link: https://lkml.kernel.org/r/20240115100731.91007-1-david@redhat.com
Fixes: c517ee744b96 ("uprobes: __replace_page() should not use page_address_in_vma()")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: Jiri Olsa <jolsa@kernel.org>
Closes: https://lkml.kernel.org/r/ZaMR2EWN-HvlCfUl@krava
Tested-by: Jiri Olsa <jolsa@kernel.org>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Alexander Shishkin
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/events/uprobes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/events/uprobes.c~uprobes-use-pagesize-aligned-virtual-address-when-replacing-pages
+++ a/kernel/events/uprobes.c
@@ -537,7 +537,7 @@ retry:
 		}
 	}
 
-	ret = __replace_page(vma, vaddr, old_page, new_page);
+	ret = __replace_page(vma, vaddr & PAGE_MASK, old_page, new_page);
 	if (new_page)
 		put_page(new_page);
 put_old:
_

Patches currently in -mm which might be from david@redhat.com are

uprobes-use-pagesize-aligned-virtual-address-when-replacing-pages.patch


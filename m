Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC8801C6B4
	for <mm-commits@vger.kernel.org>; Thu, 17 Apr 2025 20:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744921073; cv=none; b=c/KWctgiZvrfyZkNsWs5Lo/GMbD9LfuwTp4koYFmSquxwl1fwSz6bO2PNfuQmlR/XvBwxWwaFZubEx0rHdJVNeI2JN2M0WueA3GjB6GCmLweO4gdwV2jgL0tKZ1zemIUf2/tN5pG9fR5GlA2xG0IGD2TbFJuzjWR45nHexuaCpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744921073; c=relaxed/simple;
	bh=WF/8TiUeNLQLWD9/VC+fj/sQAlD2MACBzwX73q2h/yg=;
	h=Date:To:From:Subject:Message-Id; b=Ckco1/Kd2g45609Xp8SzhWZSq3EbWXffPfHdhAxsOgss6wgH3fkWHBrBMkcOIBL+404oZlN4skcMYjV8QOI5XC9JlBtbQExXDN1t8e8QvzSo98DlVTyhIJavXijdLKKIhKuZZpLXBC7284BTf5mwOyDxth/dTa2nJ1ki2fA9Jfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VBjPNmm8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VBjPNmm8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51F73C4CEE4;
	Thu, 17 Apr 2025 20:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744921073;
	bh=WF/8TiUeNLQLWD9/VC+fj/sQAlD2MACBzwX73q2h/yg=;
	h=Date:To:From:Subject:From;
	b=VBjPNmm8QWDMQ23OjFMm2VzFImJhfoNfRBTnM4md8MtSifNonUVMTXI5djY65h/Oq
	 rw3fktmykzHm1S9EjmMzHCv+lTUGdAFsFMC7SMKpx8bLzHa2VYuKW+TMcTfB70Gma4
	 gV07P83buMBy4PN2Wpv6ow3eAs3L2fGzoecidI6Y=
Date: Thu, 17 Apr 2025 13:17:52 -0700
To: mm-commits@vger.kernel.org,yang@os.amperecomputing.com,willy@infradead.org,rostedt@goodmis.org,npache@redhat.com,mhiramat@kernel.org,mcgrof@kernel.org,david@redhat.com,dave@stgolabs.net,a.manzanares@samsung.com,fan.ni@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + khugepaged-refactor-trace_mm_collapse_huge_page_isolate-to-take-folio-instead-of-page.patch added to mm-new branch
Message-Id: <20250417201753.51F73C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: khugepaged: refactor trace_mm_collapse_huge_page_isolate() to take folio instead of page
has been added to the -mm mm-new branch.  Its filename is
     khugepaged-refactor-trace_mm_collapse_huge_page_isolate-to-take-folio-instead-of-page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/khugepaged-refactor-trace_mm_collapse_huge_page_isolate-to-take-folio-instead-of-page.patch

This patch will later appear in the mm-new branch at
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
From: Fan Ni <fan.ni@samsung.com>
Subject: khugepaged: refactor trace_mm_collapse_huge_page_isolate() to take folio instead of page
Date: Thu, 17 Apr 2025 10:17:11 -0700

trace_mm_collapse_huge_page_isolate() is only used in
__collapse_huge_page_isolate(), which passes in the head page of a folio,
so refactor it to take folio directly.

Link: https://lkml.kernel.org/r/20250417171758.142745-1-nifan.cxl@gmail.com
Signed-off-by: Fan Ni <fan.ni@samsung.com>
Cc: Adam Manzanares <a.manzanares@samsung.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: Mariano Pache <npache@redhat.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Yang Shi <yang@os.amperecomputing.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/huge_memory.h |    6 +++---
 mm/khugepaged.c                    |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/include/trace/events/huge_memory.h~khugepaged-refactor-trace_mm_collapse_huge_page_isolate-to-take-folio-instead-of-page
+++ a/include/trace/events/huge_memory.h
@@ -116,10 +116,10 @@ TRACE_EVENT(mm_collapse_huge_page,
 
 TRACE_EVENT(mm_collapse_huge_page_isolate,
 
-	TP_PROTO(struct page *page, int none_or_zero,
+	TP_PROTO(struct folio *folio, int none_or_zero,
 		 int referenced, bool  writable, int status),
 
-	TP_ARGS(page, none_or_zero, referenced, writable, status),
+	TP_ARGS(folio, none_or_zero, referenced, writable, status),
 
 	TP_STRUCT__entry(
 		__field(unsigned long, pfn)
@@ -130,7 +130,7 @@ TRACE_EVENT(mm_collapse_huge_page_isolat
 	),
 
 	TP_fast_assign(
-		__entry->pfn = page ? page_to_pfn(page) : -1;
+		__entry->pfn = folio ? folio_pfn(folio) : -1;
 		__entry->none_or_zero = none_or_zero;
 		__entry->referenced = referenced;
 		__entry->writable = writable;
--- a/mm/khugepaged.c~khugepaged-refactor-trace_mm_collapse_huge_page_isolate-to-take-folio-instead-of-page
+++ a/mm/khugepaged.c
@@ -696,13 +696,13 @@ next:
 		result = SCAN_LACK_REFERENCED_PAGE;
 	} else {
 		result = SCAN_SUCCEED;
-		trace_mm_collapse_huge_page_isolate(&folio->page, none_or_zero,
+		trace_mm_collapse_huge_page_isolate(folio, none_or_zero,
 						    referenced, writable, result);
 		return result;
 	}
 out:
 	release_pte_pages(pte, _pte, compound_pagelist);
-	trace_mm_collapse_huge_page_isolate(&folio->page, none_or_zero,
+	trace_mm_collapse_huge_page_isolate(folio, none_or_zero,
 					    referenced, writable, result);
 	return result;
 }
_

Patches currently in -mm which might be from fan.ni@samsung.com are

mm-convert-free_page_and_swap_cache-to-free_folio_and_swap_cache.patch
khugepaged-refactor-trace_mm_collapse_huge_page_isolate-to-take-folio-instead-of-page.patch


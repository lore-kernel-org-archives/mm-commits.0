Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F659A2D
	for <mm-commits@vger.kernel.org>; Tue, 25 Feb 2025 03:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740452463; cv=none; b=C1G6hGP3v+XYecN17KItSD65VGsD59JtSxmDwBCXnzyIsF1GMlyN4aLAmLPWHE4dTTLrxp5csjwckKgk1S32PSClDA8YJMM09fkgbRmL0zYIS4bKLzmD75XRA1lMtUx/qLGexQnJcKy+IG6hQC09iHWvvF3ArRPFRYK5wSBBgtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740452463; c=relaxed/simple;
	bh=ibkUJ7ayuqG06EmPofniZJ7joIa7BkSkHmW99BFN8HQ=;
	h=Date:To:From:Subject:Message-Id; b=RPOxRbHtltLRDTeKcst0DpPKBRaw6sEhfqGm/+fQpLSG8mkuiEe4GVh5/WPnT5uPSvG53PDluE1LigZstE4YJlvWeYMoq2BtFhfMj+w2UdERmocorA2x01aRf4Y37+RgBaNl0CYc5GwF9JpXrh4luTlWtNgEXX4QNVk+6JFDtn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FZR/mzl7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FZR/mzl7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54C25C4CED6;
	Tue, 25 Feb 2025 03:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740452462;
	bh=ibkUJ7ayuqG06EmPofniZJ7joIa7BkSkHmW99BFN8HQ=;
	h=Date:To:From:Subject:From;
	b=FZR/mzl77UpicrdI4sXNvV4Ijn3fxGmT+Bfme1jE3wR+CHgpvrq9tn3C9/WiWe8tk
	 VDbX2C0+7yDLr5nXz3OKdvwDdW6Zh2T67RD+2cEBjqIuSXKXhLxRA6cvXHUnkM4UV1
	 8A1iJ/Evc9q9Z0NG0bwJLczEVkyTb8ZSSTbzmifo=
Date: Mon, 24 Feb 2025 19:01:01 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,pasha.tatashin@soleen.com,muchun.song@linux.dev,hannes@cmpxchg.org,david@redhat.com,luizcap@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_ext-make-lookup_page_ext-public.patch added to mm-unstable branch
Message-Id: <20250225030102.54C25C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: page_ext: make lookup_page_ext() public
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_ext-make-lookup_page_ext-public.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_ext-make-lookup_page_ext-public.patch

This patch will later appear in the mm-unstable branch at
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
From: Luiz Capitulino <luizcap@redhat.com>
Subject: mm: page_ext: make lookup_page_ext() public
Date: Mon, 24 Feb 2025 16:59:05 -0500

Patch series "mm: page_ext: Introduce new iteration API", v2.

Introduction
============

  [ Thanks to David Hildenbrand for identifying the root cause of this
    issue and proving guidance on how to fix it. The new API idea, bugs
    and misconceptions are all mine though ]

Currently, trying to reserve 1G pages with page_owner=on and sparsemem
causes a crash.  The reproducer is very simple:

 1. Build the kernel with CONFIG_SPARSEMEM=y and the table extensions
 2. Pass 'default_hugepagesz=1 page_owner=on' in the kernel command-line
 3. Reserve one 1G page at run-time, this should crash (see patch 1 for
    backtrace) 

 [ A crash with page_table_check is also possible, but harder to trigger ]

Apparently, starting with commit cf54f310d0d3 ("mm/hugetlb: use __GFP_COMP
for gigantic folios") we now pass the full allocation order to page
extension clients and the page extension implementation assumes that all
PFNs of an allocation range will be stored in the same memory section
(which is not true for 1G pages).

To fix this, this series introduces a new iteration API for page extension
objects.  The API checks if the next page extension object can be
retrieved from the current section or if it needs to look up for it in
another section.

Please find all details in patch 2.


This patch (of 4):

The next commit will use lookup_page_ext().

Link: https://lkml.kernel.org/r/cover.1740434344.git.luizcap@redhat.com
Link: https://lkml.kernel.org/r/fb46436ec9ef892b6f40b9e48d40237b9855ac16.1740434344.git.luizcap@redhat.com
Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_ext.h |    1 +
 mm/page_ext.c            |    4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/include/linux/page_ext.h~mm-page_ext-make-lookup_page_ext-public
+++ a/include/linux/page_ext.h
@@ -79,6 +79,7 @@ static inline void page_ext_init(void)
 
 extern struct page_ext *page_ext_get(const struct page *page);
 extern void page_ext_put(struct page_ext *page_ext);
+extern struct page_ext *lookup_page_ext(const struct page *page);
 
 static inline void *page_ext_data(struct page_ext *page_ext,
 				  struct page_ext_operations *ops)
--- a/mm/page_ext.c~mm-page_ext-make-lookup_page_ext-public
+++ a/mm/page_ext.c
@@ -165,7 +165,7 @@ void __meminit pgdat_page_ext_init(struc
 	pgdat->node_page_ext = NULL;
 }
 
-static struct page_ext *lookup_page_ext(const struct page *page)
+struct page_ext *lookup_page_ext(const struct page *page)
 {
 	unsigned long pfn = page_to_pfn(page);
 	unsigned long index;
@@ -245,7 +245,7 @@ static bool page_ext_invalid(struct page
 	return !page_ext || (((unsigned long)page_ext & PAGE_EXT_INVALID) == PAGE_EXT_INVALID);
 }
 
-static struct page_ext *lookup_page_ext(const struct page *page)
+struct page_ext *lookup_page_ext(const struct page *page)
 {
 	unsigned long pfn = page_to_pfn(page);
 	struct mem_section *section = __pfn_to_section(pfn);
_

Patches currently in -mm which might be from luizcap@redhat.com are

mm-page_ext-make-lookup_page_ext-public.patch
mm-page_ext-add-an-iteration-api-for-page-extensions.patch
mm-page_table_check-use-new-iteration-api.patch
mm-page_owner-use-new-iteration-api.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9833F1EBFF0
	for <mm-commits@vger.kernel.org>; Wed,  2 Apr 2025 21:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743630653; cv=none; b=I5yUNtVtS5UXjQi0qbB2xUW14rauSt7X+T86Xv020gVaCDMyzh+BpRdX+5MjZo+h/i1B8xg5xoCxF11kIlpkePyG7bDk4yRaqgcX7aTkdsFlmFK89cw2WHgb5jbVxvmNE2RICcBknaBgT7tHSOWczUjUKwYQVI0YOy5ZNWXemw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743630653; c=relaxed/simple;
	bh=7T5FsmKDS6wWMvA8Cu6K70GDufGr3qk+xts+qJ0QDgE=;
	h=Date:To:From:Subject:Message-Id; b=bfYQ19nArwTkI5e0sXJ+olGpHc8G6MwYFO2yQGtkTFN+BGY3gQFetmZAmH3rXBRsf0usz3pUla6Yi/sw1sPJjoTPi8YZlW8D7CapuOH/8u3onlDJp5GckAbdgcnLu15scUTHIZ8ndERr2x0vDcyX9qEMOjRyN9giK/p/PyuE648=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RMoz/4fP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RMoz/4fP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F38BDC4CEDD;
	Wed,  2 Apr 2025 21:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743630653;
	bh=7T5FsmKDS6wWMvA8Cu6K70GDufGr3qk+xts+qJ0QDgE=;
	h=Date:To:From:Subject:From;
	b=RMoz/4fPAAqPSgYyemST2auN0lfK+jNENU+cZ16/aedDxX/oQI9TNRoSOVlswfo8d
	 UM3xXzRfWu17kDIs53YcTQbi0265ySdqfb7uZRslvPf72nT/SpXe4h96Faj9Crq1G7
	 5gvstAp9gHjzH8atXE0gLzVbh1FJN/IUlZr2Yiug=
Date: Wed, 02 Apr 2025 14:50:52 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-offset_in_thp.patch added to mm-new branch
Message-Id: <20250402215052.F38BDC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove offset_in_thp()
has been added to the -mm mm-new branch.  Its filename is
     mm-remove-offset_in_thp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-offset_in_thp.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove offset_in_thp()
Date: Wed, 2 Apr 2025 22:06:04 +0100

All callers have been converted to call offset_in_folio().

Link: https://lkml.kernel.org/r/20250402210612.2444135-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 -
 1 file changed, 1 deletion(-)

--- a/include/linux/mm.h~mm-remove-offset_in_thp
+++ a/include/linux/mm.h
@@ -2389,7 +2389,6 @@ static inline void clear_page_pfmemalloc
 extern void pagefault_out_of_memory(void);
 
 #define offset_in_page(p)	((unsigned long)(p) & ~PAGE_MASK)
-#define offset_in_thp(page, p)	((unsigned long)(p) & (thp_size(page) - 1))
 #define offset_in_folio(folio, p) ((unsigned long)(p) & (folio_size(folio) - 1))
 
 /*
_

Patches currently in -mm which might be from willy@infradead.org are

filemap-remove-readahead_page.patch
mm-remove-offset_in_thp.patch
iov_iter-convert-iter_xarray_populate_pages-to-use-folios.patch
iov_iter-convert-iov_iter_extract_xarray_pages-to-use-folios.patch
filemap-remove-find_subpage.patch
filemap-convert-__readahead_batch-to-use-a-folio.patch
filemap-remove-readahead_page_batch.patch
mm-delete-thp_nr_pages.patch


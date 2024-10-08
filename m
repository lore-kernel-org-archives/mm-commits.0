Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07340EC4
	for <mm-commits@vger.kernel.org>; Tue,  8 Oct 2024 01:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728352576; cv=none; b=MPH/EcT79+XCH4NrPBWQ6AexSajQDszHPVW4PZzH51V2zAdWC2BGW/LQtT4L8k211ybrgKZi/Z/EvsXh2z9mKwCnE0wJlczmWNWHwnNsuAjWkt8gjAXLRJ1nWtiXDmPISAJQ/CN7ZB6K59KYEpWSUbWelAz/jyUMZwtDNl1KTVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728352576; c=relaxed/simple;
	bh=01qBuw2sboWJpmr7EfMvPFGYl+Q2yXh29jZEMbz3C/4=;
	h=Date:To:From:Subject:Message-Id; b=YkxHdAZu8lO6W7+lLJbquKKRJVOeX/2YdjHe6BMxVOsuwUHaX+NTMDPFisrbbRuTsZR7UJOR8erE37zKCbpvSEq5NmHtzo3TdGa/qRfvRWtYqlpWAnBoPg50MCb85Mm/xUVOjBx2gT3DlP+jab6BqjnLwOPYcJTHO7/pWDdCT4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a/I0Vw2i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a/I0Vw2i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB003C4CEC6;
	Tue,  8 Oct 2024 01:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728352575;
	bh=01qBuw2sboWJpmr7EfMvPFGYl+Q2yXh29jZEMbz3C/4=;
	h=Date:To:From:Subject:From;
	b=a/I0Vw2ipssy3RWrbgwYu3JqJGqY8veqbKJN1aIN26fGcewj1IYkMgHQKGRJXx7yY
	 XA9EdVqrRhHObv8qLtvZebmh5crayKw8jyGvPU1xn3NPr5HhL4NnEArtsUJS5gPc1I
	 mY6q11jQho6VGIMy836duN1u5QllsOntrcWOC9K4=
Date: Mon, 07 Oct 2024 18:56:15 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-page-private-instead-of-page-index-in-percpu.patch added to mm-unstable branch
Message-Id: <20241008015615.CB003C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: use page->private instead of page->index in percpu
has been added to the -mm mm-unstable branch.  Its filename is
     mm-use-page-private-instead-of-page-index-in-percpu.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-page-private-instead-of-page-index-in-percpu.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: use page->private instead of page->index in percpu
Date: Sat, 5 Oct 2024 21:01:18 +0100

The percpu allocator only uses one field in struct page, just change it
from page->index to page->private.

Link: https://lkml.kernel.org/r/20241005200121.3231142-8-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/percpu.c~mm-use-page-private-instead-of-page-index-in-percpu
+++ a/mm/percpu.c
@@ -253,13 +253,13 @@ static int pcpu_chunk_slot(const struct
 /* set the pointer to a chunk in a page struct */
 static void pcpu_set_page_chunk(struct page *page, struct pcpu_chunk *pcpu)
 {
-	page->index = (unsigned long)pcpu;
+	page->private = (unsigned long)pcpu;
 }
 
 /* obtain pointer to a chunk from a page struct */
 static struct pcpu_chunk *pcpu_get_page_chunk(struct page *page)
 {
-	return (struct pcpu_chunk *)page->index;
+	return (struct pcpu_chunk *)page->private;
 }
 
 static int __maybe_unused pcpu_page_idx(unsigned int cpu, int page_idx)
_

Patches currently in -mm which might be from willy@infradead.org are

ksm-use-a-folio-in-try_to_merge_one_page.patch
ksm-convert-cmp_and_merge_page-to-use-a-folio.patch
ksm-convert-should_skip_rmap_item-to-take-a-folio.patch
mm-add-pageanonnotksm.patch
mm-add-pageanonnotksm-fix.patch
mm-remove-pageksm.patch
gup-convert-foll_touch-case-in-follow_page_pte-to-folio.patch
mm-convert-page_to_pgoff-to-page_pgoff.patch
mm-use-page_pgoff-in-more-places.patch
mm-renovate-page_address_in_vma.patch
mm-mass-constification-of-folio-page-pointers.patch
bootmem-stop-using-page-index.patch
mm-remove-references-to-page-index-in-huge_memoryc.patch
mm-use-page-private-instead-of-page-index-in-percpu.patch


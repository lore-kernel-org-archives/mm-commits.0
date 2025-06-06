Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8FA52AF10
	for <mm-commits@vger.kernel.org>; Fri,  6 Jun 2025 03:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749182146; cv=none; b=siGtO/sEndGQjuxJwMZSS3Twnyiei5o8GYpndhNdyPBXW1juIjQh9aUf28lfzBIKUpQz+VWmryBWN27x2y5NsWlYmmyPQmYfhnbcbB/Fofo2RUsO+cylgzsLpa/OY76UJp1vDPsu0UUCg1S/SPokgdfcfhKypJ4uCTaHUcGllbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749182146; c=relaxed/simple;
	bh=Fljo7HWWzOg+a1qSaNkP8ybQAEqAdvRZrmfbXFbGN1w=;
	h=Date:To:From:Subject:Message-Id; b=ahhn7d5K/7y4kSkwT9IsJYfkrPDcQz07C9yMbPovzP/CAF5Moxx6T+7gQBvWuv0oal/V00V/Xo06Ei3vUOzOZxJyU1R74AmW6oP37SUoR6EO/2wAQSdDzOLRj+K9FmKTCheeMog5TtM9/Eko7nbwG6/m03u9WVHsfR7XDDpEfEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KPC4Yjmb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KPC4Yjmb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 207B2C4CEED;
	Fri,  6 Jun 2025 03:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749182145;
	bh=Fljo7HWWzOg+a1qSaNkP8ybQAEqAdvRZrmfbXFbGN1w=;
	h=Date:To:From:Subject:From;
	b=KPC4YjmbAsrnIwaZJ9/+qBCRZPIhivho810A0oH3a0XCPiuBVd0XDVWBXk9+EmUfO
	 i89jWf4aUGM5jHS5kBnrYnQX4VaT9QA/BkQvjXLIzpBdTMLje7Zfr2pMIbopOOhF0h
	 pSaxafL4JZ6UxWrcUlxpTEAbva4fIOrGgeexkSDA=
Date: Thu, 05 Jun 2025 20:55:44 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,muchun.song@linux.dev,jhubbard@nvidia.com,jgg@ziepe.ca,dev.jain@arm.com,david@redhat.com,lizhe.67@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + gup-optimize-longterm-pin_user_pages-for-large-folio.patch added to mm-new branch
Message-Id: <20250606035545.207B2C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: gup: optimize longterm pin_user_pages() for large folio
has been added to the -mm mm-new branch.  Its filename is
     gup-optimize-longterm-pin_user_pages-for-large-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/gup-optimize-longterm-pin_user_pages-for-large-folio.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Li Zhe <lizhe.67@bytedance.com>
Subject: gup: optimize longterm pin_user_pages() for large folio
Date: Fri, 6 Jun 2025 10:37:42 +0800

In the current implementation of longterm pin_user_pages(), we invoke
collect_longterm_unpinnable_folios().  This function iterates through the
list to check whether each folio belongs to the "longterm_unpinnabled"
category.  The folios in this list essentially correspond to a contiguous
region of userspace addresses, with each folio representing a physical
address in increments of PAGESIZE.

If this userspace address range is mapped with large folio, we can
optimize the performance of function collect_longterm_unpinnable_folios()
by reducing the using of READ_ONCE() invoked in
pofs_get_folio()->page_folio()->_compound_head().

Also, we can simplify the logic of collect_longterm_unpinnable_folios(). 
Instead of comparing with prev_folio after calling pofs_get_folio(), we
can check whether the next page is within the same folio.

The performance test results, based on v6.15, obtained through the
gup_test tool from the kernel source tree are as follows.  We achieve an
improvement of over 66% for large folio with pagesize=2M.  For small
folio, we have only observed a very slight degradation in performance.

Without this patch:

    [root@localhost ~] ./gup_test -HL -m 8192 -n 512
    TAP version 13
    1..1
    # PIN_LONGTERM_BENCHMARK: Time: get:14391 put:10858 us#
    ok 1 ioctl status 0
    # Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
    [root@localhost ~]# ./gup_test -LT -m 8192 -n 512
    TAP version 13
    1..1
    # PIN_LONGTERM_BENCHMARK: Time: get:130538 put:31676 us#
    ok 1 ioctl status 0
    # Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0

With this patch:

    [root@localhost ~] ./gup_test -HL -m 8192 -n 512
    TAP version 13
    1..1
    # PIN_LONGTERM_BENCHMARK: Time: get:4867 put:10516 us#
    ok 1 ioctl status 0
    # Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
    [root@localhost ~]# ./gup_test -LT -m 8192 -n 512
    TAP version 13
    1..1
    # PIN_LONGTERM_BENCHMARK: Time: get:131798 put:31328 us#
    ok 1 ioctl status 0
    # Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0

Link: https://lkml.kernel.org/r/20250606023742.58344-1-lizhe.67@bytedance.com
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   37 +++++++++++++++++++++++++++++--------
 1 file changed, 29 insertions(+), 8 deletions(-)

--- a/mm/gup.c~gup-optimize-longterm-pin_user_pages-for-large-folio
+++ a/mm/gup.c
@@ -2296,6 +2296,31 @@ static void pofs_unpin(struct pages_or_f
 		unpin_user_pages(pofs->pages, pofs->nr_entries);
 }
 
+static struct folio *pofs_next_folio(struct folio *folio,
+		struct pages_or_folios *pofs, long *index_ptr)
+{
+	long i = *index_ptr + 1;
+
+	if (!pofs->has_folios && folio_test_large(folio)) {
+		const unsigned long start_pfn = folio_pfn(folio);
+		const unsigned long end_pfn = start_pfn + folio_nr_pages(folio);
+
+		for (; i < pofs->nr_entries; i++) {
+			unsigned long pfn = page_to_pfn(pofs->pages[i]);
+
+			/* Is this page part of this folio? */
+			if (pfn < start_pfn || pfn >= end_pfn)
+				break;
+		}
+	}
+
+	if (unlikely(i == pofs->nr_entries))
+		return NULL;
+	*index_ptr = i;
+
+	return pofs_get_folio(pofs, i);
+}
+
 /*
  * Returns the number of collected folios. Return value is always >= 0.
  */
@@ -2303,16 +2328,12 @@ static void collect_longterm_unpinnable_
 		struct list_head *movable_folio_list,
 		struct pages_or_folios *pofs)
 {
-	struct folio *prev_folio = NULL;
 	bool drain_allow = true;
-	unsigned long i;
+	struct folio *folio;
+	long i = 0;
 
-	for (i = 0; i < pofs->nr_entries; i++) {
-		struct folio *folio = pofs_get_folio(pofs, i);
-
-		if (folio == prev_folio)
-			continue;
-		prev_folio = folio;
+	for (folio = pofs_get_folio(pofs, i); folio;
+		 folio = pofs_next_folio(folio, pofs, &i)) {
 
 		if (folio_is_longterm_pinnable(folio))
 			continue;
_

Patches currently in -mm which might be from lizhe.67@bytedance.com are

gup-optimize-longterm-pin_user_pages-for-large-folio.patch


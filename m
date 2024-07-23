Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DACCE14658F
	for <mm-commits@vger.kernel.org>; Tue, 23 Jul 2024 21:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721771471; cv=none; b=BUvGGMrZDu9iT3o/N0DnDzm34x4LnfmDrUnjEoRn43XiiK9ldb2Q1q1FJ7gm4ArJpPwabXKUVmX2t0S75G0IgJldfBAQF97rensqmchkXYVBF4j8dPRlRAx5x9MqEOCyxMZoFV6Gz3anwKg2L5Q87bEQUwg++YKtOHvVozgjMl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721771471; c=relaxed/simple;
	bh=KuTBo/SP4ifvZWD4CpXKUdAvaZUjI3niEDW+37aGL5Y=;
	h=Date:To:From:Subject:Message-Id; b=sHH55g/1aovJQ2uI3+Oji6jxnYfJ/m095OmMG/q+8YIQxA2iOpz+wWh8B+JelR07qUTkhUATXlT40btN4qu2M8MrW+WNKWJua4wfnv0uIxQ+MI9Q8Pg3i1c/DSOF71nNSr5REg98wE7ICraq1fS8f63Kl4M2lGBT9uh08zALrNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j1lcT5Ce; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j1lcT5Ce"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C911C4AF0A;
	Tue, 23 Jul 2024 21:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721771471;
	bh=KuTBo/SP4ifvZWD4CpXKUdAvaZUjI3niEDW+37aGL5Y=;
	h=Date:To:From:Subject:From;
	b=j1lcT5CeQSijPDY94uwnBmLqLwkqLN6iRrkaV2jJ3LI22U/EySG8iUNamfgO48yAW
	 HK5i2VjOZrWMeu62v8UDTKmU7/mQgGh7aFRQvTkTGXWO5SrksqrRsOcb835SGOU97J
	 JWFz1nKeFE2mhydOdEHznxPtsxLdS3MTqm06EwTw=
Date: Tue, 23 Jul 2024 14:51:10 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-page-private-instead-of-page-index-in-percpu.patch added to mm-unstable branch
Message-Id: <20240723215111.7C911C4AF0A@smtp.kernel.org>
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
Date: Tue, 23 Jul 2024 16:35:01 +0100

The percpu allocator only uses one field in struct page, just change
it from page->index to page->private.

Link: https://lkml.kernel.org/r/20240723153503.1669586-7-willy@infradead.org
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

bootmem-stop-using-page-index.patch
mm-constify-page_address_in_vma.patch
mm-convert-page_to_pgoff-to-page_pgoff.patch
mm-mass-constification-of-folio-page-pointers.patch
mm-remove-references-to-page-index-in-huge_memoryc.patch
mm-use-page-private-instead-of-page-index-in-percpu.patch


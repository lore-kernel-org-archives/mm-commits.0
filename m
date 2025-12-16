Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3639026A1C4
	for <mm-commits@vger.kernel.org>; Tue, 16 Dec 2025 02:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765853373; cv=none; b=J9s68LcO9Fd+QGgM6uDOz0Z/h6xfczeSVMKj72vtA+uUIF06MQonzoWv7UDGH5q5W8ynntZoGYk88UuHc8XQgl2mNrJBYLBXdz5SzNVhx77CZqOkxbQctjQdPmm8V1vGpO4PoT4ajPLrbSAdxQTQQq0Nm/Ro551akbB5Wpr8E2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765853373; c=relaxed/simple;
	bh=pVsrOvY8+Sc1ksyjfjb8jevfvvWAD1JV+DC31cuvScE=;
	h=Date:To:From:Subject:Message-Id; b=TmtmWbNkrIXjGN+nCyeXiBVkMDsAWtrZpZ3+r+Pjh+tRIcG+2us/w3HpyUwXChmUlaZbnu9gCjziAIFKS4Utygpm9U1bS+6xclovWtlatdFGzSaixF43QS0Y61KFOicHiGsfnxnT1T6FgGepfHzh65EkfKFjuXIPx0zdQ3lWlsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NtlMQWFK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NtlMQWFK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85511C4CEF5;
	Tue, 16 Dec 2025 02:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765853371;
	bh=pVsrOvY8+Sc1ksyjfjb8jevfvvWAD1JV+DC31cuvScE=;
	h=Date:To:From:Subject:From;
	b=NtlMQWFKZEPXyqVtFMCuQoqvKzK8lCzma95pqIePd+La0XphnUDK1Ny82O3JOAqCO
	 zk88gBhZ1O/qRatMul4D0SXJYedOtS37qObUFXGjR5c7mmdalcW2V5oAn6gtyG1zQN
	 p3G/VEdTqv7QXRJKf9KLaZRN2mvYSB04WrSOddXs=
Date: Mon, 15 Dec 2025 18:49:31 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,tglx@linutronix.de,raghavendra.kt@amd.com,peterz@infradead.org,mjguzik@gmail.com,mingo@redhat.com,luto@kernel.org,konrad.wilk@oracle.com,ioworker0@gmail.com,hpa@zytor.com,david@redhat.com,bp@alien8.de,boris.ostrovsky@oracle.com,ankur.a.arora@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + highmem-do-range-clearing-in-clear_user_highpages.patch added to mm-new branch
Message-Id: <20251216024931.85511C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: highmem: do range clearing in clear_user_highpages()
has been added to the -mm mm-new branch.  Its filename is
     highmem-do-range-clearing-in-clear_user_highpages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/highmem-do-range-clearing-in-clear_user_highpages.patch

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
From: Ankur Arora <ankur.a.arora@oracle.com>
Subject: highmem: do range clearing in clear_user_highpages()
Date: Mon, 15 Dec 2025 12:49:18 -0800

Use the range clearing primitive clear_user_pages() when clearing
contiguous pages in clear_user_highpages().

We can safely do that when we have !CONFIG_HIGHMEM and when the
architecture does not have clear_user_highpage.

The first is necessary because not doing intermediate maps for pages lets
contiguous page ranges stay contiguous.  The second, because if the
architecture has clear_user_highpage(), it likely needs flushing magic
when clearing the page, magic that we aren't privy to.

Link: https://lkml.kernel.org/r/20251215204922.475324-5-ankur.a.arora@oracle.com
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Konrad Rzessutek Wilk <konrad.wilk@oracle.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Raghavendra K T <raghavendra.kt@amd.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/include/linux/highmem.h~highmem-do-range-clearing-in-clear_user_highpages
+++ a/include/linux/highmem.h
@@ -278,11 +278,28 @@ static inline void clear_user_highpage(s
 static inline void clear_user_highpages(struct page *page, unsigned long vaddr,
 					unsigned int npages)
 {
+
+#if defined(clear_user_highpage) || defined(CONFIG_HIGHMEM)
+	/*
+	 * An architecture defined clear_user_highpage() implies special
+	 * handling is needed.
+	 *
+	 * So we use that or, the generic variant if CONFIG_HIGHMEM is
+	 * enabled.
+	 */
 	do {
 		clear_user_highpage(page, vaddr);
 		vaddr += PAGE_SIZE;
 		page++;
 	} while (--npages);
+#else
+
+	/*
+	 * Prefer clear_user_pages() to allow for architectural optimizations
+	 * when operating on contiguous page ranges.
+	 */
+	clear_user_pages(page_address(page), vaddr, page, npages);
+#endif
 }
 
 #ifndef vma_alloc_zeroed_movable_folio
_

Patches currently in -mm which might be from ankur.a.arora@oracle.com are

highmem-introduce-clear_user_highpages.patch
mm-introduce-clear_pages-and-clear_user_pages.patch
highmem-do-range-clearing-in-clear_user_highpages.patch
x86-mm-simplify-clear_page_.patch
x86-clear_page-introduce-clear_pages.patch
mm-folio_zero_user-support-clearing-page-ranges.patch
mm-folio_zero_user-cache-neighbouring-pages.patch


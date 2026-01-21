Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7089205E3B
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 01:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768960281; cv=none; b=bTJN3aFyefSgH472H5JOSKsc9fX53qZnoXcCTMbNhOivufwscN7S/3u8AgvWAgS1oM+RjLEC7exPOebsFMmhz0JzuY7PkYNocRk/XlXcfPEHitx349685X6J0tjfK1dtGoFaSAXF4cyga1R9jGUnlJdJwi2Hz6+aEgBOmB5d3ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768960281; c=relaxed/simple;
	bh=mrD0Nx8MwZWhrVyKPAo9/Pmx7BJ0HDIJueMTtuXGDCw=;
	h=Date:To:From:Subject:Message-Id; b=n54FzF7dDBjLXn6hh1Ms8r4qrbtwwPehfzAcNbF0sDex8E73OmUKga9+/uMQU4r4MUiFyB6zfePx2CeOEUvH0xZZlLE51Vq55Dk/tmtpIVqtK5FFr5FcTREuE3Zvx82iac07ZseTazq0XANiGmGFpPVODsfYHGIJytjZr6Yp2LM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hw3HHL/F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hw3HHL/F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C44E7C16AAE;
	Wed, 21 Jan 2026 01:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768960279;
	bh=mrD0Nx8MwZWhrVyKPAo9/Pmx7BJ0HDIJueMTtuXGDCw=;
	h=Date:To:From:Subject:From;
	b=hw3HHL/Frvh6vBhFYruBgNg7vU/KOHWJg2tUooFB4r65MHqk/Ve2/dEzyE31pgADn
	 uBikfnwg0/SMMoYLF4qVaUbWgmgDmxtMpP199+kaFUhmp1PNSGgdqcpz6UP4KwAquB
	 J6Mnrntnwr4jlQQ6MC1osfmiIx16MMF5Sx0I3+4Y=
Date: Tue, 20 Jan 2026 17:51:19 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,tglx@linutronix.de,surenb@google.com,rppt@kernel.org,raghavendra.kt@amd.com,peterz@infradead.org,mjguzik@gmail.com,mingo@redhat.com,mhocko@suse.com,luto@kernel.org,lorenzo.stoakes@oracle.com,lizhe.67@bytedance.com,Liam.Howlett@oracle.com,konrad.wilk@oracle.com,ioworker0@gmail.com,hpa@zytor.com,david@kernel.org,bp@alien8.de,boris.ostrovsky@oracle.com,akpm@linux-foundation.org,ankur.a.arora@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-folio_zero_user-clear-page-ranges-fix.patch removed from -mm tree
Message-Id: <20260121015119.C44E7C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-folio_zero_user-clear-page-ranges-fix
has been removed from the -mm tree.  Its filename was
     mm-folio_zero_user-clear-page-ranges-fix.patch

This patch was dropped because it was folded into mm-folio_zero_user-clear-page-ranges.patch

------------------------------------------------------
From: Ankur Arora <ankur.a.arora@oracle.com>
Subject: mm-folio_zero_user-clear-page-ranges-fix
Date: Wed, 7 Jan 2026 22:04:06 -0800

Move the unit computation and make it a const. Also, clean up the
comment a little bit.

Use SZ_32M to define PROCESS_PAGES_NON_PREEMPT_BATCH instead
of hand coding the computation.

Link: https://lkml.kernel.org/r/20260108060406.1693853-1-ankur.a.arora@oracle.com
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Konrad Rzessutek Wilk <konrad.wilk@oracle.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Li Zhe <lizhe.67@bytedance.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Raghavendra K T <raghavendra.kt@amd.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 mm/memory.c        |   20 ++++++++++----------
 2 files changed, 11 insertions(+), 11 deletions(-)

--- a/include/linux/mm.h~mm-folio_zero_user-clear-page-ranges-fix
+++ a/include/linux/mm.h
@@ -4242,7 +4242,7 @@ static inline void clear_pages(void *add
  * (See comment above clear_pages() for why preemption latency is a concern
  * here.)
  */
-#define PROCESS_PAGES_NON_PREEMPT_BATCH		(32 << (20 - PAGE_SHIFT))
+#define PROCESS_PAGES_NON_PREEMPT_BATCH		(SZ_32M >> PAGE_SHIFT)
 #else /* !clear_pages */
 /*
  * The architecture does not provide a clear_pages() implementation. Assume
--- a/mm/memory.c~mm-folio_zero_user-clear-page-ranges-fix
+++ a/mm/memory.c
@@ -7243,19 +7243,19 @@ static inline int process_huge_page(
 static void clear_contig_highpages(struct page *page, unsigned long addr,
 				   unsigned int nr_pages)
 {
-	unsigned int i, unit, count;
-
-	might_sleep();
+	unsigned int i, count;
 	/*
-	 * When clearing we want to operate on the largest extent possible since
-	 * that allows for extent based architecture specific optimizations.
+	 * When clearing we want to operate on the largest extent possible to
+	 * allow for architecture specific extent based optimizations.
 	 *
-	 * However, since the clearing interfaces (clear_user_highpages(),
-	 * clear_user_pages(), clear_pages()), do not call cond_resched(), we
-	 * limit the batch size when running under non-preemptible scheduling
-	 * models.
+	 * However, since clear_user_highpages() (and primitives clear_user_pages(),
+	 * clear_pages()), do not call cond_resched(), limit the unit size when
+	 * running under non-preemptible scheduling models.
 	 */
-	unit = preempt_model_preemptible() ? nr_pages : PROCESS_PAGES_NON_PREEMPT_BATCH;
+	const unsigned int unit = preempt_model_preemptible() ?
+				   nr_pages : PROCESS_PAGES_NON_PREEMPT_BATCH;
+
+	might_sleep();
 
 	for (i = 0; i < nr_pages; i += count) {
 		cond_resched();
_

Patches currently in -mm which might be from ankur.a.arora@oracle.com are

mm-introduce-clear_pages-and-clear_user_pages.patch
highmem-introduce-clear_user_highpages.patch
x86-mm-simplify-clear_page_.patch
x86-clear_page-introduce-clear_pages.patch
mm-folio_zero_user-clear-pages-sequentially.patch
mm-folio_zero_user-clear-page-ranges.patch
mm-folio_zero_user-cache-neighbouring-pages.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF95E1A23A0
	for <mm-commits@vger.kernel.org>; Thu,  8 Jan 2026 20:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767903828; cv=none; b=b9TipUZs7DNZSVM69OkeQCF3lobT9QrLq183V0TqdmtkEcMQj+ixngFZKSF86hUvS3jygj5zymdwAVhxFb5q11BpjaOJ6vvZYRgkcEJabhLGNs6gNkFIivpFKLmFSnFaaFe/uTx0g8kyrdrVy/SEiGK9Qg5MdCTWeYPk0mOLRaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767903828; c=relaxed/simple;
	bh=3N6+jJcVhT0T6abWobXg1AsT7yxPkzjvfuaJ4/C7IGw=;
	h=Date:To:From:Subject:Message-Id; b=FifH+bhF5tnhTtMudoF0P2VLZOvPkRJ7uD+9ngEDw7/x2xWtWH3wkPHVJqXLg4Te4AbpV5jhQtIJ2+RS0b3W+ZEH1SNdkBelIP0RhaDuRF/A0VHZqNPEFrBE0qvEZ9DTgmfehgdujgtRcDy1GRvQ5K9b4uUcKzwpbHoZLbSg95w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lrtOV4m8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lrtOV4m8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2778EC116C6;
	Thu,  8 Jan 2026 20:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767903827;
	bh=3N6+jJcVhT0T6abWobXg1AsT7yxPkzjvfuaJ4/C7IGw=;
	h=Date:To:From:Subject:From;
	b=lrtOV4m84oVD7X9Q9ZEa9DxdW2ie/lZWY9YsR69PfN8V/d1uVpmS1MSaRonkl9qNf
	 fMqZ3E1J1hC5K2rW/W/2/SgrFImiMuCExz0CslEv/11zpSiMJpdiZLAl3A38cpQW2v
	 KHM2B6JUyo72YgjvdMWOyq1XBgkfA9dGvZGsonGQ=
Date: Thu, 08 Jan 2026 12:23:46 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,tglx@linutronix.de,surenb@google.com,rppt@kernel.org,raghavendra.kt@amd.com,peterz@infradead.org,mjguzik@gmail.com,mingo@redhat.com,mhocko@suse.com,luto@kernel.org,lorenzo.stoakes@oracle.com,lizhe.67@bytedance.com,Liam.Howlett@oracle.com,konrad.wilk@oracle.com,ioworker0@gmail.com,hpa@zytor.com,david@kernel.org,bp@alien8.de,boris.ostrovsky@oracle.com,ankur.a.arora@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-folio_zero_user-clear-page-ranges-fix.patch added to mm-unstable branch
Message-Id: <20260108202347.2778EC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-folio_zero_user-clear-page-ranges-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-folio_zero_user-clear-page-ranges-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-folio_zero_user-clear-page-ranges-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
@@ -4238,7 +4238,7 @@ static inline void clear_pages(void *add
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
@@ -7240,19 +7240,19 @@ static inline int process_huge_page(
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
mm-folio_zero_user-clear-page-ranges-fix.patch
mm-folio_zero_user-cache-neighbouring-pages.patch


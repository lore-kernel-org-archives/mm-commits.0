Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF8926C385
	for <mm-commits@vger.kernel.org>; Mon, 26 Jan 2026 19:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769454359; cv=none; b=k3WJhwql5nkSbAnIz/08v1zs9jN6DqSTwzONSw1NIgg9ldxf7iL4+nCa1IYcTjMAOMBbzstnmgMKYgEPTBHOCz7S/05GaFMykq6oxHzry31O6DNffuKtvBfwOSUkmr1gDm9mxLVm7kW2hMg77OfQ7oPBtFREhdfUOYRSIMJbW+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769454359; c=relaxed/simple;
	bh=w+xafbUrlf95EgJyBXj7iQobXXmtdTd8SWwAFFi2CLY=;
	h=Date:To:From:Subject:Message-Id; b=JX4t2ziEozix+r5d2xI7sYQ19dIV+05KKKIlzZlnnZRwTiAAPlXyjIejD+BXs2jKX+JblK5u1Q6PkrFBYXjbVJ2U7lt8QKhPkUPC68nT/qImkaR7SIagG5dKZy0AHuB2t8pQarprLlllPLLIEMNu43Ei/OYbhq6PoZGEtfJzh+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KDG4BjQF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KDG4BjQF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BDF0C116C6;
	Mon, 26 Jan 2026 19:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769454359;
	bh=w+xafbUrlf95EgJyBXj7iQobXXmtdTd8SWwAFFi2CLY=;
	h=Date:To:From:Subject:From;
	b=KDG4BjQFQGVP6vME65DFPOZeXFASM6CfaN32EylVCsCDi8xHMj76HuLv76dmitKn+
	 l+o3YUeL74V8ZquQnAl8OQZySfqxqmYc7PzIdESr+4T3BxS0IfuAlMKlZ3FHwuMggS
	 mWv93bRbeyUNCv67LNF7Qdwpl1YdwmJaDWEFkm1k=
Date: Mon, 26 Jan 2026 11:05:58 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,tglx@linutronix.de,raghavendra.kt@amd.com,peterz@infradead.org,mjguzik@gmail.com,mingo@redhat.com,luto@kernel.org,lkp@intel.com,lizhe.67@bytedance.com,konrad.wilk@oracle.com,ioworker0@gmail.com,hpa@zytor.com,david@kernel.org,bp@alien8.de,boris.ostrovsky@oracle.com,ankur.a.arora@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-folio_zero_user-open-code-range-computation-in-folio_zero_user.patch added to mm-new branch
Message-Id: <20260126190559.1BDF0C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: folio_zero_user: open code range computation in folio_zero_user()
has been added to the -mm mm-new branch.  Its filename is
     mm-folio_zero_user-open-code-range-computation-in-folio_zero_user.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-folio_zero_user-open-code-range-computation-in-folio_zero_user.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
Subject: mm: folio_zero_user: open code range computation in folio_zero_user()
Date: Mon, 26 Jan 2026 10:32:12 -0800

riscv64-gcc-linux-gnu (v8.5) reports a compile time assert in:

   r[2] = DEFINE_RANGE(clamp_t(s64, fault_idx - radius, pg.start, pg.end),
 		       clamp_t(s64, fault_idx + radius, pg.start, pg.end));

where it decides that pg.start > pg.end in:
  clamp_t(s64, fault_idx + radius, pg.start, pg.end));

where pg comes from:
  const struct range pg = DEFINE_RANGE(0, folio_nr_pages(folio) - 1);

That does not seem like it could be true. Even for pg.start == pg.end,
we would need folio_test_large() to evaluate to false at compile time:

  static inline unsigned long folio_nr_pages(const struct folio *folio)
  {
	if (!folio_test_large(folio))
		return 1;
	return folio_large_nr_pages(folio);
  }

Workaround by open coding the range computation.  Also, simplify the type
declarations for the relevant variables.

Link: https://lkml.kernel.org/r/20260126183212.2366596-1-ankur.a.arora@oracle.com
Fixes: 93552c9a3350 ("mm: folio_zero_user: cache neighbouring pages")
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202601240453.QCjgGdJa-lkp@intel.com/
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Ankur Arora <ankur.a.arora@oracle.com>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Konrad Rzessutek Wilk <konrad.wilk@oracle.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Li Zhe <lizhe.67@bytedance.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Raghavendra K T <raghavendra.kt@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

--- a/mm/memory.c~mm-folio_zero_user-open-code-range-computation-in-folio_zero_user
+++ a/mm/memory.c
@@ -7332,30 +7332,29 @@ static void clear_contig_highpages(struc
 void folio_zero_user(struct folio *folio, unsigned long addr_hint)
 {
 	const unsigned long base_addr = ALIGN_DOWN(addr_hint, folio_size(folio));
-	const long fault_idx = (addr_hint - base_addr) / PAGE_SIZE;
 	const struct range pg = DEFINE_RANGE(0, folio_nr_pages(folio) - 1);
-	const int radius = FOLIO_ZERO_LOCALITY_RADIUS;
+	const long fault_idx = (addr_hint - base_addr) / PAGE_SIZE;
+	const long radius = FOLIO_ZERO_LOCALITY_RADIUS;
 	struct range r[3];
 	int i;
 
 	/*
-	 * Faulting page and its immediate neighbourhood. Will be cleared at the
-	 * end to keep its cachelines hot.
+	 * Faulting page and its immediate neighbourhood. Cleared at the end to
+	 * keep its cachelines hot.
 	 */
-	r[2] = DEFINE_RANGE(clamp_t(s64, fault_idx - radius, pg.start, pg.end),
-			    clamp_t(s64, fault_idx + radius, pg.start, pg.end));
+	r[2] = DEFINE_RANGE(fault_idx - radius < (long)pg.start ? pg.start : fault_idx - radius,
+			    fault_idx + radius > (long)pg.end   ? pg.end   : fault_idx + radius);
+
 
-	/* Region to the left of the fault */
-	r[1] = DEFINE_RANGE(pg.start,
-			    clamp_t(s64, r[2].start - 1, pg.start - 1, r[2].start));
+	/* Region to the left of the fault. */
+	r[1] = DEFINE_RANGE(pg.start, r[2].start - 1);
 
 	/* Region to the right of the fault: always valid for the common fault_idx=0 case. */
-	r[0] = DEFINE_RANGE(clamp_t(s64, r[2].end + 1, r[2].end, pg.end + 1),
-			    pg.end);
+	r[0] = DEFINE_RANGE(r[2].end + 1, pg.end);
 
 	for (i = 0; i < ARRAY_SIZE(r); i++) {
 		const unsigned long addr = base_addr + r[i].start * PAGE_SIZE;
-		const unsigned int nr_pages = range_len(&r[i]);
+		const long nr_pages = (long)range_len(&r[i]);
 		struct page *page = folio_page(folio, r[i].start);
 
 		if (nr_pages > 0)
_

Patches currently in -mm which might be from ankur.a.arora@oracle.com are

mm-folio_zero_user-open-code-range-computation-in-folio_zero_user.patch


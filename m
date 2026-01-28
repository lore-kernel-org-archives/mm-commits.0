Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B2B5374173
	for <mm-commits@vger.kernel.org>; Wed, 28 Jan 2026 19:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769628889; cv=none; b=KE0T5jzCr40c/vEV7tE/1VkMpmxA5PwEtuCzY5x05UL9PYtzOlWl3RqxpMg29C90DVxBMCEjPjg+km4ggfMwRf94DlmxK5T6+wOLDyeEvntclaWw1ewhk40pU/jhCMb835x19U+A24g4woaqFizRm91y5bAVP+CNWLz4RGhudNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769628889; c=relaxed/simple;
	bh=OLz0CKZxqYSwMFODUwHwZT2NMd0w1uSe+muD5+1fX/M=;
	h=Date:To:From:Subject:Message-Id; b=Mnfa76xk5SSUJUfpjgn0RZDBaM1OZOdE/aellqbOqz2TkGK5hzvJojixtugy3O2HPgtkDCwxS7odb5aSiwmkIjBtBvHMw1WF+ipwMu3WLY1sskpS+IPVUQ57g8ecAkMQIiyM+bdYP0qOlm8+W1ALTvRCkhlh0OT4TJPTjuQYbIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yl+HLofI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yl+HLofI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E849C4CEF1;
	Wed, 28 Jan 2026 19:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769628888;
	bh=OLz0CKZxqYSwMFODUwHwZT2NMd0w1uSe+muD5+1fX/M=;
	h=Date:To:From:Subject:From;
	b=yl+HLofIAmfUlJeC4A11O699dQ2IjxXzKPHqp8zihVHIXDujAYbInCNaKqXavv68G
	 NpSiOKIqPUzVJZ6hzeG2AN25disDUA2iv9ssbP5nOkBFDKkWkF60Uc1Hrmm+KYHnfu
	 zfsvOg6A/5rM9uZcyOHd/F45eo+SEsyzyZ8K4IoM=
Date: Wed, 28 Jan 2026 11:34:48 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,tglx@linutronix.de,raghavendra.kt@amd.com,peterz@infradead.org,mjguzik@gmail.com,mingo@redhat.com,luto@kernel.org,lkp@intel.com,lizhe.67@bytedance.com,konrad.wilk@oracle.com,ioworker0@gmail.com,hpa@zytor.com,david@kernel.org,bp@alien8.de,boris.ostrovsky@oracle.com,ankur.a.arora@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-folio_zero_user-open-code-range-computation-in-folio_zero_user.patch removed from -mm tree
Message-Id: <20260128193448.9E849C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: folio_zero_user: open code range computation in folio_zero_user()
has been removed from the -mm tree.  Its filename was
     mm-folio_zero_user-open-code-range-computation-in-folio_zero_user.patch

This patch was dropped because an updated version will be issued

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



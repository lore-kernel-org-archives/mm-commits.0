Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63200372B4C
	for <mm-commits@vger.kernel.org>; Wed, 28 Jan 2026 19:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769628949; cv=none; b=Lbx+SVhTKrwju6ccDTsmA7FusR2jekAVbpkb9QjOHLbqfqRnBtCzHZ29p1penbOm+Kl5lVqVaxbHON37nP0eMcltGrpPWhm1ofJlkIw7wipt9AwknS8byt3whfXmGoCn5WBJGIQrGEn07HR3Kg8nqSfgkmvXNBujAq1Dq+rx3e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769628949; c=relaxed/simple;
	bh=q2PWmLNWjbjhZ5xPeDWOjjFdoqsC4JRZKpDKM+hyslI=;
	h=Date:To:From:Subject:Message-Id; b=raCyg3GVjMmqF7NlUEcEdr9xlaU9LDoMdjdZL1oTOzARxTUzikkWtfNrTlb9Paslj7KsRWj/IF746L2x/5wU7KE+a1xdVr8o+1Db2c9Gl+Pu4HXBMkl5x0Uhm3keUE3vyVA+DwybJ/YxxPqVBVMq9x68/Z67KkRlW32QP2LJL/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XPU47Tkl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XPU47Tkl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5EF9C4CEF1;
	Wed, 28 Jan 2026 19:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769628948;
	bh=q2PWmLNWjbjhZ5xPeDWOjjFdoqsC4JRZKpDKM+hyslI=;
	h=Date:To:From:Subject:From;
	b=XPU47Tkl2IiL9jAbZSwEo8mdnkYt2P/+14EUNypIOAOadMQXPVIgxZ+nzAsCwY3z6
	 y1CUNZ2qbRM7hWBwEBLihm2bSY6k1iFDwf4ZjnmNAsvLMQWd3IqsD1S2K/Xrs/TFsL
	 mXdB8BqaKekIandgxkgqUBjQ1pn0Od19YmrRROkU=
Date: Wed, 28 Jan 2026 11:35:48 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,tglx@linutronix.de,raghavendra.kt@amd.com,peterz@infradead.org,mjguzik@gmail.com,mingo@redhat.com,luto@kernel.org,lkp@intel.com,lizhe.67@bytedance.com,konrad.wilk@oracle.com,ioworker0@gmail.com,hpa@zytor.com,david@kernel.org,bp@alien8.de,boris.ostrovsky@oracle.com,ankur.a.arora@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-folio_zero_user-open-code-range-computation-in-folio_zero_user.patch added to mm-unstable branch
Message-Id: <20260128193548.D5EF9C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: folio_zero_user: open code range computation in folio_zero_user()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-folio_zero_user-open-code-range-computation-in-folio_zero_user.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-folio_zero_user-open-code-range-computation-in-folio_zero_user.patch

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
Subject: mm: folio_zero_user: open code range computation in folio_zero_user()
Date: Wed, 28 Jan 2026 10:59:43 -0800

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

Workaround by open coding the range computation. Also, simplify the type
declarations for the relevant variables.

Link: https://lkml.kernel.org/r/20260128185943.2397128-1-ankur.a.arora@oracle.com
Fixes: 93552c9a3350 ("mm: folio_zero_user: cache neighbouring pages")
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202601240453.QCjgGdJa-lkp@intel.com/
Cc: Andy Lutomirski <luto@kernel.org>
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

 mm/memory.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/mm/memory.c~mm-folio_zero_user-open-code-range-computation-in-folio_zero_user
+++ a/mm/memory.c
@@ -7334,7 +7334,7 @@ void folio_zero_user(struct folio *folio
 	const unsigned long base_addr = ALIGN_DOWN(addr_hint, folio_size(folio));
 	const long fault_idx = (addr_hint - base_addr) / PAGE_SIZE;
 	const struct range pg = DEFINE_RANGE(0, folio_nr_pages(folio) - 1);
-	const int radius = FOLIO_ZERO_LOCALITY_RADIUS;
+	const long radius = FOLIO_ZERO_LOCALITY_RADIUS;
 	struct range r[3];
 	int i;
 
@@ -7342,24 +7342,23 @@ void folio_zero_user(struct folio *folio
 	 * Faulting page and its immediate neighbourhood. Will be cleared at the
 	 * end to keep its cachelines hot.
 	 */
-	r[2] = DEFINE_RANGE(clamp_t(s64, fault_idx - radius, pg.start, pg.end),
-			    clamp_t(s64, fault_idx + radius, pg.start, pg.end));
+	r[2] = DEFINE_RANGE(fault_idx - radius < (long)pg.start ? pg.start : fault_idx - radius,
+			    fault_idx + radius > (long)pg.end   ? pg.end   : fault_idx + radius);
+
 
 	/* Region to the left of the fault */
-	r[1] = DEFINE_RANGE(pg.start,
-			    clamp_t(s64, r[2].start - 1, pg.start - 1, r[2].start));
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
-			clear_contig_highpages(page, addr, nr_pages);
+			clear_contig_highpages(page, addr, (unsigned int)nr_pages);
 	}
 }
 
_

Patches currently in -mm which might be from ankur.a.arora@oracle.com are

mm-folio_zero_user-open-code-range-computation-in-folio_zero_user.patch


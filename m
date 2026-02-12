Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFA8D1A76BB
	for <mm-commits@vger.kernel.org>; Thu, 12 Feb 2026 23:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770939814; cv=none; b=iK9V8KoVErc7KKl3UF8Y3h2UceKEit0vYAVY2sY5Ypx7GE4WSZvwawxLsjGUy/ryLB2xzQ4jHnE/ptlmIoFEAl4xb1zfH/avMbhdLjV+t0k2cNG38p6rG8n/wg1Hm/eA/wD3Yn9+F5geu+th6BKjuZAe/oHTAvBl2bNGdx28pbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770939814; c=relaxed/simple;
	bh=Dw8c+UYFX0S1HXJKKrNkjOVkVod8Ym5GoV/DpqHkSG0=;
	h=Date:To:From:Subject:Message-Id; b=XkUgqZlBLPjQ0k+eobsO4XaPQdaBlWO2v7UKzqre0i2/Pko0SZe49N1Uz4lolsKhj+FHQiiVZyH1yDXbLrFXAtqjjGZciScbnmZIibAEjrrzq07qjw7oNf+R7Bf0BbnM9t8ysGHU6hjEiHP+51C4svHtz2w493/LYtFZgwFgqhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l/mlZ3Qr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l/mlZ3Qr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B595C4CEF7;
	Thu, 12 Feb 2026 23:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770939814;
	bh=Dw8c+UYFX0S1HXJKKrNkjOVkVod8Ym5GoV/DpqHkSG0=;
	h=Date:To:From:Subject:From;
	b=l/mlZ3Qr8aJ69q+zshKLz7lArw1VTWdJZQh2c1P1tS4kipg+7FeSIdeQXC9KAgCeV
	 WKnbSlw50n3V0Qa7Qo+/rj/7i8ekuFZsBi/zWhzTaM8ghdgt3o/4QhW+YTQ4JytksW
	 TtqGo75KCqgwYuv/ALgpDw6JARQtfxF621MQcZGw=
Date: Thu, 12 Feb 2026 15:43:33 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,tglx@linutronix.de,raghavendra.kt@amd.com,peterz@infradead.org,mjguzik@gmail.com,mingo@redhat.com,luto@kernel.org,lkp@intel.com,lizhe.67@bytedance.com,konrad.wilk@oracle.com,ioworker0@gmail.com,hpa@zytor.com,david@kernel.org,bp@alien8.de,boris.ostrovsky@oracle.com,ankur.a.arora@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-folio_zero_user-open-code-range-computation-in-folio_zero_user.patch removed from -mm tree
Message-Id: <20260212234334.7B595C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: folio_zero_user: open code range computation in folio_zero_user()
has been removed from the -mm tree.  Its filename was
     mm-folio_zero_user-open-code-range-computation-in-folio_zero_user.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[ankur.a.arora@oracle.com: remove unneeded cast, per David]
  Link: https://lkml.kernel.org/r/20260206223801.2617497-1-ankur.a.arora@oracle.com
Link: https://lkml.kernel.org/r/20260206223801.2617497-1-ankur.a.arora@oracle.com
Link: https://lkml.kernel.org/r/20260128185943.2397128-1-ankur.a.arora@oracle.com
Fixes: 93552c9a3350 ("mm: folio_zero_user: cache neighbouring pages")
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202601240453.QCjgGdJa-lkp@intel.com/
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
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

 mm/memory.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/mm/memory.c~mm-folio_zero_user-open-code-range-computation-in-folio_zero_user
+++ a/mm/memory.c
@@ -7316,7 +7316,7 @@ void folio_zero_user(struct folio *folio
 	const unsigned long base_addr = ALIGN_DOWN(addr_hint, folio_size(folio));
 	const long fault_idx = (addr_hint - base_addr) / PAGE_SIZE;
 	const struct range pg = DEFINE_RANGE(0, folio_nr_pages(folio) - 1);
-	const int radius = FOLIO_ZERO_LOCALITY_RADIUS;
+	const long radius = FOLIO_ZERO_LOCALITY_RADIUS;
 	struct range r[3];
 	int i;
 
@@ -7324,20 +7324,19 @@ void folio_zero_user(struct folio *folio
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
_

Patches currently in -mm which might be from ankur.a.arora@oracle.com are



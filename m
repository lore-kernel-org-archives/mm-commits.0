Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4598C2D7387
	for <mm-commits@vger.kernel.org>; Tue, 16 Dec 2025 02:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765853382; cv=none; b=rd1raeMadIC2gCBVF0vEg52MymQzRAwTbBbsvwt+rIAzxp7H/f+FWjqfI6idlrXMrSjIGMVnoxqeCSrycD3M9FSoqhk+HeWAXUwG2V39zNqrhp6XL3V2Y1/5x8XZYYgA+HPHqa/LHd3GK1GOAtmiDLaaTc+6ijMkB+QWSR1qXU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765853382; c=relaxed/simple;
	bh=gHKskrY4pzzgk20NLUTvhjMpso9ORVxCUvSZ9Z0bHKs=;
	h=Date:To:From:Subject:Message-Id; b=UlTYV1YUvkEpSbGCClCgmLiQ4cRq0vQhCwssGR0H4xgiQt7BlKK5FGkF2ZiUIoh3IwNkQwoA/pHFhu2tXM8d6iBZS01suQj92w1RR/CIG9Qgt8bWrAEevOXljQlOTbbKthUSijeMrgRO+SZFsuEIIZhBR79FMJonJCuI/ydI4Mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sJAOgfwC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sJAOgfwC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD4D2C4CEF5;
	Tue, 16 Dec 2025 02:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765853381;
	bh=gHKskrY4pzzgk20NLUTvhjMpso9ORVxCUvSZ9Z0bHKs=;
	h=Date:To:From:Subject:From;
	b=sJAOgfwCPhfp7o1wO5ovXjDn4lqE6btMy29X4KJifJOjHtTsIcl7lEHrFOvmfJaiu
	 q+6KgRYWLTnBhwLi9P9TWPJ8yrao0rxuNLRJMi069e2gSeg15AXb83LjN6tz6lRWZS
	 TBT4lmxCJXQO4uouLGP7lSfVCVMRkJOBWRW1UjHY=
Date: Mon, 15 Dec 2025 18:49:41 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,tglx@linutronix.de,raghavendra.kt@amd.com,peterz@infradead.org,mjguzik@gmail.com,mingo@redhat.com,luto@kernel.org,konrad.wilk@oracle.com,ioworker0@gmail.com,hpa@zytor.com,david@redhat.com,bp@alien8.de,boris.ostrovsky@oracle.com,ankur.a.arora@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-folio_zero_user-cache-neighbouring-pages.patch added to mm-new branch
Message-Id: <20251216024941.CD4D2C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: folio_zero_user: cache neighbouring pages
has been added to the -mm mm-new branch.  Its filename is
     mm-folio_zero_user-cache-neighbouring-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-folio_zero_user-cache-neighbouring-pages.patch

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
Subject: mm: folio_zero_user: cache neighbouring pages
Date: Mon, 15 Dec 2025 12:49:22 -0800

folio_zero_user() does straight zeroing without caring about temporal
locality for caches.

This replaced commit c6ddfb6c5890 ("mm, clear_huge_page: move order
algorithm into a separate function") where we cleared a page at a time
converging to the faulting page from the left and the right.

To retain limited temporal locality, split the clearing in three parts:
the faulting page and its immediate neighbourhood, and, the remaining
regions on the left and the right.  The local neighbourhood will be
cleared last.  Do this only when zeroing small folios (<
MAX_ORDER_NR_PAGES) since there isn't much expectation of cache locality
for large folios.

Performance
===

AMD Genoa (EPYC 9J14, cpus=2 sockets * 96 cores * 2 threads,
  memory=2.2 TB, L1d= 16K/thread, L2=512K/thread, L3=2MB/thread)

anon-w-seq (vm-scalability):
                            stime                  utime

  page-at-a-time      1654.63 ( +- 3.84% )     811.00 ( +- 3.84% )
  contiguous clearing 1602.86 ( +- 3.00% )     970.75 ( +- 4.68% )
  neighbourhood-last  1630.32 ( +- 2.73% )     886.37 ( +- 5.19% )

Both stime and utime respond in expected ways.  stime drops for both
contiguous clearing (-3.14%) and neighbourhood-last (-1.46%) approaches. 
However, utime increases for both contiguous clearing (+19.7%) and
neighbourhood-last (+9.28%).

In part this is because anon-w-seq runs with 384 processes zeroing
anonymously mapped memory which they then access sequentially.  As such
this is likely an uncommon pattern where the memory bandwidth is saturated
while also being cache limited because we access the entire region.

Kernel make workload (make -j 12 bzImage):

                            stime                  utime

  page-at-a-time       138.16 ( +- 0.31% )    1015.11 ( +- 0.05% )
  contiguous clearing  133.42 ( +- 0.90% )    1013.49 ( +- 0.05% )
  neighbourhood-last   131.20 ( +- 0.76% )    1011.36 ( +- 0.07% )

For make the utime stays relatively flat with an up to 4.9% improvement in
the stime.

Link: https://lkml.kernel.org/r/20251215204922.475324-9-ankur.a.arora@oracle.com
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
Reviewed-by: Raghavendra K T <raghavendra.kt@amd.com>
Tested-by: Raghavendra K T <raghavendra.kt@amd.com>
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
Cc: Thomas Gleinxer <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   44 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 42 insertions(+), 2 deletions(-)

--- a/mm/memory.c~mm-folio_zero_user-cache-neighbouring-pages
+++ a/mm/memory.c
@@ -7268,13 +7268,53 @@ static void clear_contig_highpages(struc
  * @addr_hint: The address accessed by the user or the base address.
  *
  * Uses architectural support to clear page ranges.
+ *
+ * Clearing of small folios (< MAX_ORDER_NR_PAGES) is split in three parts:
+ * pages in the immediate locality of the faulting page, and its left, right
+ * regions; the local neighbourhood is cleared last in order to keep cache
+ * lines of the faulting region hot.
+ *
+ * For larger folios we assume that there is no expectation of cache locality
+ * and just do a straight zero.
  */
 void folio_zero_user(struct folio *folio, unsigned long addr_hint)
 {
 	unsigned long base_addr = ALIGN_DOWN(addr_hint, folio_size(folio));
+	const long fault_idx = (addr_hint - base_addr) / PAGE_SIZE;
+	const struct range pg = DEFINE_RANGE(0, folio_nr_pages(folio) - 1);
+	const int width = 2; /* number of pages cleared last on either side */
+	struct range r[3];
+	int i;
+
+	if (folio_nr_pages(folio) > MAX_ORDER_NR_PAGES) {
+		clear_contig_highpages(folio_page(folio, 0),
+				       base_addr, folio_nr_pages(folio));
+		return;
+	}
+
+	/*
+	 * Faulting page and its immediate neighbourhood. Cleared at the end to
+	 * ensure it sticks around in the cache.
+	 */
+	r[2] = DEFINE_RANGE(clamp_t(s64, fault_idx - width, pg.start, pg.end),
+			    clamp_t(s64, fault_idx + width, pg.start, pg.end));
+
+	/* Region to the left of the fault */
+	r[1] = DEFINE_RANGE(pg.start,
+			    clamp_t(s64, r[2].start-1, pg.start-1, r[2].start));
+
+	/* Region to the right of the fault: always valid for the common fault_idx=0 case. */
+	r[0] = DEFINE_RANGE(clamp_t(s64, r[2].end+1, r[2].end, pg.end+1),
+			    pg.end);
+
+	for (i = 0; i <= 2; i++) {
+		unsigned int npages = range_len(&r[i]);
+		struct page *page = folio_page(folio, r[i].start);
+		unsigned long addr = base_addr + folio_page_idx(folio, page) * PAGE_SIZE;
 
-	clear_contig_highpages(folio_page(folio, 0),
-				base_addr, folio_nr_pages(folio));
+		if (npages > 0)
+			clear_contig_highpages(page, addr, npages);
+	}
 }
 
 static int copy_user_gigantic_page(struct folio *dst, struct folio *src,
_

Patches currently in -mm which might be from ankur.a.arora@oracle.com are

highmem-introduce-clear_user_highpages.patch
mm-introduce-clear_pages-and-clear_user_pages.patch
highmem-do-range-clearing-in-clear_user_highpages.patch
x86-mm-simplify-clear_page_.patch
x86-clear_page-introduce-clear_pages.patch
mm-folio_zero_user-support-clearing-page-ranges.patch
mm-folio_zero_user-cache-neighbouring-pages.patch


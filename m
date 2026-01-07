Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EECD3339709
	for <mm-commits@vger.kernel.org>; Wed,  7 Jan 2026 18:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767809453; cv=none; b=K4a5SrscW09xOAIHlTBdM3yqbrPBCJWUTChVCW8DuHqRxE0Ceiqe+2e0GG96heUIKqM2dE5H+lPfaOWS4u6XWjQflsN88CouWmanrOpibnOWVlzjKz44E0ackEOwB2rMKPcOzLbm7m1+ufmfEJavlh3EeS7JErnaQ8MDOEUIupI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767809453; c=relaxed/simple;
	bh=dSNHoJrvPZjwahMWt3zA6gqXeA/4wYfMU0jHlae7qIg=;
	h=Date:To:From:Subject:Message-Id; b=vE9D5Ffa8pMdkmXjp1PHX0WHseK8yCALrZEmlhFeMzGYcbstw5akUDfx3NyXjrKVSLzqqR+L4lQS9RypCud9Ny90Gqo3HkfwvlzX0g0uBIguUAyckIZDBa+OoqacvCki3fkWNmG3a6CnFdTs2JYJXyDxpNqcp/0ibmSXbAPvkLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eIlu6AX+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eIlu6AX+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DBA8C4CEF1;
	Wed,  7 Jan 2026 18:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767809452;
	bh=dSNHoJrvPZjwahMWt3zA6gqXeA/4wYfMU0jHlae7qIg=;
	h=Date:To:From:Subject:From;
	b=eIlu6AX+jk2vNAhcKELwK8DR8Gz3IGW78cWMshGmUalhXPafctby4DCF+V6n9vbOx
	 O3qFR+BZ7oVj5Kd5EzXnub0O5+aZFHOYYbOZNSXurxpl5I9Tv3Ko/8TQrxSh9tjUwm
	 vRVTTSLKuI7070OCktXFlKS0vcp7jjmPkr3RlXt8=
Date: Wed, 07 Jan 2026 10:10:52 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,tglx@linutronix.de,surenb@google.com,rppt@kernel.org,raghavendra.kt@amd.com,peterz@infradead.org,mjguzik@gmail.com,mingo@redhat.com,mhocko@suse.com,luto@kernel.org,lorenzo.stoakes@oracle.com,lizhe.67@bytedance.com,Liam.Howlett@oracle.com,konrad.wilk@oracle.com,ioworker0@gmail.com,hpa@zytor.com,david@redhat.com,david@kernel.org,bp@alien8.de,boris.ostrovsky@oracle.com,ankur.a.arora@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-folio_zero_user-cache-neighbouring-pages.patch added to mm-unstable branch
Message-Id: <20260107181052.8DBA8C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: folio_zero_user: cache neighbouring pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-folio_zero_user-cache-neighbouring-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-folio_zero_user-cache-neighbouring-pages.patch

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
Subject: mm: folio_zero_user: cache neighbouring pages
Date: Tue, 6 Jan 2026 23:20:09 -0800

folio_zero_user() does straight zeroing without caring about temporal
locality for caches.

This replaced commit c6ddfb6c5890 ("mm, clear_huge_page: move order
algorithm into a separate function") where we cleared a page at a time
converging to the faulting page from the left and the right.

To retain limited temporal locality, split the clearing in three parts:
the faulting page and its immediate neighbourhood, and the regions on its
left and right.  We clear the local neighbourhood last to maximize chances
of it sticking around in the cache.

Performance
===

AMD Genoa (EPYC 9J14, cpus=2 sockets * 96 cores * 2 threads,
           memory=2.2 TB, L1d=16K/thread, L2=512K/thread, L3=2MB/thread)

vm-scalability/anon-w-seq-hugetlb: this workload runs with 384 processes
(one for each CPU) each zeroing anonymously mapped hugetlb memory which is
then accessed sequentially.  stime utime

  discontiguous-page      1739.93 ( +- 6.15% )  1016.61 ( +- 4.75% )
  contiguous-page         1853.70 ( +- 2.51% )  1187.13 ( +- 3.50% )
  batched-pages           1756.75 ( +- 2.98% )  1133.32 ( +- 4.89% )
  neighbourhood-last      1725.18 ( +- 4.59% )  1123.78 ( +- 7.38% )

Both stime and utime largely respond somewhat expectedly.  There is a fair
amount of run to run variation but the general trend is that the stime
drops and utime increases.  There are a few oddities, like contiguous-page
performing very differently from batched-pages.

As such this is likely an uncommon pattern where we saturate the memory
bandwidth (since all CPUs are running the test) and at the same time are
cache constrained because we access the entire region.

Kernel make (make -j 12 bzImage):

                              stime                  utime

  discontiguous-page      199.29 ( +- 0.63% )   1431.67 ( +- .04% )
  contiguous-page         193.76 ( +- 0.58% )   1433.60 ( +- .05% )
  batched-pages           193.92 ( +- 0.76% )   1431.04 ( +- .08% )
  neighbourhood-last      194.46 ( +- 0.68% )   1431.51 ( +- .06% )

For make the utime stays relatively flat with a fairly small (-2.4%)
improvement in the stime.

Link: https://lkml.kernel.org/r/20260107072009.1615991-9-ankur.a.arora@oracle.com
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
Reviewed-by: Raghavendra K T <raghavendra.kt@amd.com>
Tested-by: Raghavendra K T <raghavendra.kt@amd.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
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
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   41 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 38 insertions(+), 3 deletions(-)

--- a/mm/memory.c~mm-folio_zero_user-cache-neighbouring-pages
+++ a/mm/memory.c
@@ -7262,6 +7262,15 @@ static void clear_contig_highpages(struc
 	}
 }
 
+/*
+ * When zeroing a folio, we want to differentiate between pages in the
+ * vicinity of the faulting address where we have spatial and temporal
+ * locality, and those far away where we don't.
+ *
+ * Use a radius of 2 for determining the local neighbourhood.
+ */
+#define FOLIO_ZERO_LOCALITY_RADIUS	2
+
 /**
  * folio_zero_user - Zero a folio which will be mapped to userspace.
  * @folio: The folio to zero.
@@ -7269,10 +7278,36 @@ static void clear_contig_highpages(struc
  */
 void folio_zero_user(struct folio *folio, unsigned long addr_hint)
 {
-	unsigned long base_addr = ALIGN_DOWN(addr_hint, folio_size(folio));
+	const unsigned long base_addr = ALIGN_DOWN(addr_hint, folio_size(folio));
+	const long fault_idx = (addr_hint - base_addr) / PAGE_SIZE;
+	const struct range pg = DEFINE_RANGE(0, folio_nr_pages(folio) - 1);
+	const int radius = FOLIO_ZERO_LOCALITY_RADIUS;
+	struct range r[3];
+	int i;
+
+	/*
+	 * Faulting page and its immediate neighbourhood. Will be cleared at the
+	 * end to keep its cachelines hot.
+	 */
+	r[2] = DEFINE_RANGE(clamp_t(s64, fault_idx - radius, pg.start, pg.end),
+			    clamp_t(s64, fault_idx + radius, pg.start, pg.end));
+
+	/* Region to the left of the fault */
+	r[1] = DEFINE_RANGE(pg.start,
+			    clamp_t(s64, r[2].start - 1, pg.start - 1, r[2].start));
 
-	clear_contig_highpages(folio_page(folio, 0),
-				base_addr, folio_nr_pages(folio));
+	/* Region to the right of the fault: always valid for the common fault_idx=0 case. */
+	r[0] = DEFINE_RANGE(clamp_t(s64, r[2].end + 1, r[2].end, pg.end + 1),
+			    pg.end);
+
+	for (i = 0; i < ARRAY_SIZE(r); i++) {
+		const unsigned long addr = base_addr + r[i].start * PAGE_SIZE;
+		const unsigned int nr_pages = range_len(&r[i]);
+		struct page *page = folio_page(folio, r[i].start);
+
+		if (nr_pages > 0)
+			clear_contig_highpages(page, addr, nr_pages);
+	}
 }
 
 static int copy_user_gigantic_page(struct folio *dst, struct folio *src,
_

Patches currently in -mm which might be from ankur.a.arora@oracle.com are

mm-introduce-clear_pages-and-clear_user_pages.patch
highmem-introduce-clear_user_highpages.patch
x86-mm-simplify-clear_page_.patch
x86-clear_page-introduce-clear_pages.patch
mm-folio_zero_user-clear-pages-sequentially.patch
mm-folio_zero_user-clear-page-ranges.patch
mm-folio_zero_user-cache-neighbouring-pages.patch


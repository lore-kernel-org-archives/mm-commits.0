Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54412146D5A
	for <mm-commits@vger.kernel.org>; Mon, 21 Sep 2026 04:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789963777; cv=none; b=sfEMkaSmBmv544UWsawi5DGa+A3s1fv2eRJvXfD1+0xm11SvQSmmjZP1KUWOcRTlaxC7zAdIi5o1qqCT/euEcdwfNfp89gmmWgoKdqDvMezLelwjpIDgj5AUYpphZVEnLUG3OOGx0KjH1Utu94a+qv0WEKlAorstkL3fRioT6wM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789963777; c=relaxed/simple;
	bh=TcRyTtUQeDK+266FdCCdHO9gI7x09L6D0BJ69WRFy4Y=;
	h=Date:To:From:Subject:Message-Id; b=aS3hIpBFiU4F6lQawGA4FUjpJeTKItfr8Osx66R59zPO2eQyd7xFeSMsmKzPOIsebpI7u/08SUCQXBmJ0jsKJGPUuSg1QqhcP8duaVVDBnU4I6oI62ssPciqRbYnqk5J2/JT2OsxE6+6ug6QImIM+2soO3zjyBLfcZij+1ijRr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FmPfpNb7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FmPfpNb7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F1B91F000FF;
	Mon, 21 Sep 2026 04:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789963776;
	bh=wYyi7xnM2xxmxDqOKsz+amQq8nmJORq+yweQ6Cxr3zc=;
	h=Date:To:From:Subject;
	b=FmPfpNb7bdbqMEROWksMza/KgcNThTG6fou6O/+PSYbNx2SOLYO9o/mUlyRMTVJYo
	 p+xVH8Qg+3XhEu3Lrsqz9PqSEdRsrV+WK6g6DiXi6YaWiLKLlP9W9fIiCvM0PV26r0
	 QzX1wMOYzBbc88mnR3v6Dludu+zoTjMXQ3yBAwMI=
Date: Sun, 20 Sep 2026 21:09:35 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + perf-ring_buffer-stop-using-pg_private-as-aux-page-high-order-marker.patch added to mm-unstable branch
Message-Id: <20260921040936.1F1B91F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: perf/ring_buffer: stop using PG_private as AUX page high-order marker
has been added to the -mm mm-unstable branch.  Its filename is
     perf-ring_buffer-stop-using-pg_private-as-aux-page-high-order-marker.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/perf-ring_buffer-stop-using-pg_private-as-aux-page-high-order-marker.patch

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
From: Zi Yan <ziy@nvidia.com>
Subject: perf/ring_buffer: stop using PG_private as AUX page high-order marker
Date: Sun, 20 Sep 2026 22:27:58 -0400

A high-order AUX page sets PG_private on its first page and stores the
order in first_page->private.  Stop using PG_private and check
first_page->private for AUX page order only in the ring buffer and its
users.  This is fine because page->private is 0 for order-0 AUX pages,
matching the page order.

It prepares for a future commit that remove PG_private.

No functional change intended.

Assisted-by: LLM
Link: https://lore.kernel.org/20260920-remove-pg_private-v5-2-bb68b6a21869@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Usama Arif <usama.arif@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: James Clark <james.clark@linaro.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---

 arch/x86/events/intel/bts.c |    3 ---
 arch/x86/events/intel/pt.c  |    6 ++----
 kernel/events/ring_buffer.c |    7 +++----
 3 files changed, 5 insertions(+), 11 deletions(-)

--- a/arch/x86/events/intel/bts.c~perf-ring_buffer-stop-using-pg_private-as-aux-page-high-order-marker
+++ a/arch/x86/events/intel/bts.c
@@ -66,9 +66,6 @@ static struct pmu bts_pmu;
 
 static int buf_nr_pages(struct page *page)
 {
-	if (!PagePrivate(page))
-		return 1;
-
 	return 1 << page_private(page);
 }
 
--- a/arch/x86/events/intel/pt.c~perf-ring_buffer-stop-using-pg_private-as-aux-page-high-order-marker
+++ a/arch/x86/events/intel/pt.c
@@ -781,8 +781,7 @@ static int topa_insert_pages(struct pt_b
 	struct page *p;
 
 	p = virt_to_page(buf->data_pages[buf->nr_pages]);
-	if (PagePrivate(p))
-		order = page_private(p);
+	order = page_private(p);
 
 	if (topa_table_full(topa)) {
 		topa = topa_alloc(cpu, gfp);
@@ -1296,8 +1295,7 @@ static int pt_buffer_try_single(struct p
 	if (!intel_pt_validate_hw_cap(PT_CAP_single_range_output))
 		goto out;
 
-	if (PagePrivate(p))
-		order = page_private(p);
+	order = page_private(p);
 
 	if (1 << order != nr_pages)
 		goto out;
--- a/kernel/events/ring_buffer.c~perf-ring_buffer-stop-using-pg_private-as-aux-page-high-order-marker
+++ a/kernel/events/ring_buffer.c
@@ -630,11 +630,10 @@ static struct page *rb_alloc_aux_page(in
 		/*
 		 * Communicate the allocation size to the driver:
 		 * if we managed to secure a high-order allocation,
-		 * set its first page's private to this order;
-		 * !PagePrivate(page) means it's just a normal page.
+		 * set its first page's private to this order, otherwise page's
+		 * private remains zero.
 		 */
 		split_page(page, order);
-		SetPagePrivate(page);
 		set_page_private(page, order);
 	}
 
@@ -645,7 +644,7 @@ static void rb_free_aux_page(struct perf
 {
 	struct page *page = virt_to_page(rb->aux_pages[idx]);
 
-	ClearPagePrivate(page);
+	set_page_private(page, 0);
 	__free_page(page);
 }
 
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-zsmalloc-replace-pg_private-with-pointer-comparison.patch
perf-ring_buffer-stop-using-pg_private-as-aux-page-high-order-marker.patch
xen-grant-table-stop-setting-pg_private-on-pages-for-grant-mapping.patch
fscrypt-stop-setting-pg_private-on-bounce-page.patch
mm-hugetlb-use-direct-assignment-instead-of-folio_change_private.patch
f2fs-stop-using-pg_private.patch
f2fs-convert-the-private-flag-helpers-to-folio-only.patch
erofs-mm-pagemap-add-readahead_folio_last-to-avoid-folio-private.patch
erofs-use-folio_attach-detach_private-instead-of-direct-assignment.patch
mm-page-flags-check-page-folio-private-instead-of-pg_private.patch
treewide-remove-folio_set-clear_private-usage.patch
ceph-replace-pageprivate-with-page_private.patch
treewide-remove-pageprivate-and-pg_private-from-comments-and-docs.patch
mm-page-flags-remove-pg_private.patch
usb-gadgetfs-do-not-warn-about-excessively-large-memory-allocations.patch


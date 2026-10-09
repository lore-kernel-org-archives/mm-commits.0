Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19FD941E6CE
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525577; cv=none; b=qG77ZeFsI2PeDzGLTIxxZydNvznsa+htSMRyW5dvMq6uw3iO7i7MbJoFDn7mJz2j4E4MFH99AN6EQb/DbnLDw6pihEJALXZagdNj3uWL+A/nayUChVvhQIlklSnMAgx7SrYydTNN2izPxSXKyeo/faSkp5+sWqTH7BJQpVjdC+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525577; c=relaxed/simple;
	bh=DvUGeZM1sgb1wHGia+jLVj+BrrVF8ATbOurq3N57R+U=;
	h=Date:To:From:Subject:Message-Id; b=sGYweUvHLT4N7tMsBkI8nW4K7+WYTn28vtI4/f7CdevYhEDF22WMmyuUHRu7UUXYzqKji+QFdqTEqkkX1KLQyuo9NgcO3I+RcLwwmjAug+Vn/BKmGBnBHcyT9EyBEit7wtZ6uHcS/1xgENLWBEvEPc4bqdGFq1LgvdlkCbjotB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CRfBVDw8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CRfBVDw8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E771C1F00893;
	Fri,  9 Oct 2026 05:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525573;
	bh=KiYpjNz7xpdHl8P8gpPHtpcwI5+8f7IRaUATpQujDus=;
	h=Date:To:From:Subject;
	b=CRfBVDw8cXwUuLGIwKPiJ7oli/twEL8Vyb8dwvSp9VHqYlfHz3aOHBdsZPDVAgjb3
	 x/ZMsiASlcgM23i79awHeRWegzEylY/tOeHXVQmqCcvwKgRNQnSw6S+J1cDsNEvcmO
	 gDFLY1gIxOTMJ4qBtJjt9miMXBN1iYgzp8dvY5Mw=
Date: Thu, 08 Oct 2026 22:59:32 -0700
To: mm-commits@vger.kernel.org,usama.arif@linux.dev,tglx@kernel.org,peterz@infradead.org,namhyung@kernel.org,mingo@redhat.com,mark.rutland@arm.com,jolsa@kernel.org,james.clark@linaro.org,irogers@google.com,hpa@zytor.com,david@kernel.org,dave.hansen@linux.intel.com,bp@alien8.de,alexander.shishkin@linux.intel.com,adrian.hunter@intel.com,acme@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] perf-ring_buffer-stop-using-pg_private-as-aux-page-high-order-marker.patch removed from -mm tree
Message-Id: <20261009055932.E771C1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: perf/ring_buffer: stop using PG_private as AUX page high-order marker
has been removed from the -mm tree.  Its filename was
     perf-ring_buffer-stop-using-pg_private-as-aux-page-high-order-marker.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

Link: https://lore.kernel.org/20260920-remove-pg_private-v5-2-bb68b6a21869@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Usama Arif <usama.arif@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Assisted-by: LLM
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
@@ -635,11 +635,10 @@ static struct page *rb_alloc_aux_page(in
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
 
@@ -650,7 +649,7 @@ static void rb_free_aux_page(struct perf
 {
 	struct page *page = virt_to_page(rb->aux_pages[idx]);
 
-	ClearPagePrivate(page);
+	set_page_private(page, 0);
 	__free_page(page);
 }
 
_

Patches currently in -mm which might be from ziy@nvidia.com are



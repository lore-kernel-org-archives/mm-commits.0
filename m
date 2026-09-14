Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39EB735E1D9
	for <mm-commits@vger.kernel.org>; Mon, 14 Sep 2026 03:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789357915; cv=none; b=URYGwsAUUdWds1fsonFI0NTsUVoQpMU3S/sq7bwwaIBZiSKqsDCf4Ag1kzLdizPii+oGvCUOmXordQJ4DZikDC2S6DJQEvm7ns4ZYNpcghogDgtAbbHhDPq88Cy+9vY08pCifRgunVDvyrBfLgNLqOuwQrpCqzUo+mtgGytrLfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789357915; c=relaxed/simple;
	bh=cwgPriyTnq30wt0zxaTBp39yoVxvwNHn5rQiBLC2E8o=;
	h=Date:To:From:Subject:Message-Id; b=u5fyMiw5G7oqj2ek8K6QIM6J+gWjw4NitO/Nx1LGcRMQH2GIgpsZqMOf4whDSiWPjWDAqoeRYfalIsnUGt2zxUwHkz9ItrqrNgAaNaeN8RlEk9UA7lJo6IQoAQ6nuh3SJNxflvM+iY6CHhrxpcY9YuPSxnuGIaSe8qTxh0SCZb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uRyvB7tp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uRyvB7tp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B16101F000FF;
	Mon, 14 Sep 2026 03:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789357913;
	bh=KEmcDDUhJv9TaBfo0SLDikKpzDtZNlkplIYsjWOVcvM=;
	h=Date:To:From:Subject;
	b=uRyvB7tpdjvDc5FbHvu6+walOr1Of5jgXbcSQ9fcIycAOmOeuKNKggIGxmP1HSNgD
	 DzbkFQ/d2nHfDjT54RZMsghvkHAoNW2lEnjQQCpTZEv7YHx02iTVjLkXgRmdX5Uoc1
	 KKXUNztNsaJorvud5ibjPwwI868+gxEB+ofgWAzc=
Date: Sun, 13 Sep 2026 20:51:53 -0700
To: mm-commits@vger.kernel.org,usama.arif@linux.dev,tglx@kernel.org,peterz@infradead.org,namhyung@kernel.org,mingo@redhat.com,mark.rutland@arm.com,jolsa@kernel.org,james.clark@linaro.org,irogers@google.com,hpa@zytor.com,david@kernel.org,dave.hansen@linux.intel.com,bp@alien8.de,alexander.shishkin@linux.intel.com,adrian.hunter@intel.com,acme@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + perf-ring_buffer-stop-using-pg_private-as-aux-page-high-order-marker.patch added to mm-new branch
Message-Id: <20260914035153.B16101F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: perf/ring_buffer: stop using PG_private as AUX page high-order marker
has been added to the -mm mm-new branch.  Its filename is
     perf-ring_buffer-stop-using-pg_private-as-aux-page-high-order-marker.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/perf-ring_buffer-stop-using-pg_private-as-aux-page-high-order-marker.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
Date: Sun, 13 Sep 2026 22:24:00 -0400

A high-order AUX page sets PG_private on its first page and stores the
order in first_page->private.  Stop using PG_private and check
first_page->private for AUX page order only in the ring buffer and its
users.  This is fine because page->private is 0 for order-0 AUX pages,
matching the page order.

It prepares for a future commit that remove PG_private.

No functional change intended.

Assisted-by: LLM
Link: https://lore.kernel.org/20260913-remove-pg_private-v4-2-848550f7574e@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Usama Arif <usama.arif@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: James Clark <james.clark@linaro.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
To: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@redhat.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
To: Thomas Gleixner <tglx@kernel.org>
To: Borislav Petkov <bp@alien8.de>
To: Dave Hansen <dave.hansen@linux.intel.com>
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
md-md-bitmap-replace-pageprivate-with-page_private.patch
buffer-replace-page_buffer-with-page_private-and-delete-it.patch
treewide-remove-pageprivate-and-pg_private-from-comments-and-docs.patch
mm-page-flags-remove-pg_private.patch
usb-gadgetfs-do-not-warn-about-excessively-large-memory-allocations.patch


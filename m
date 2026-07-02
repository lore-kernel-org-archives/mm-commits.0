Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FD9132B124
	for <mm-commits@vger.kernel.org>; Thu,  2 Jul 2026 16:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783008238; cv=none; b=hbcoJzn1sXrHUols3S2Yv1O2NZkJfr0Z3yyjm1xDk3WfYLr3aCeJ/pDbxzdcAxg/ni28xREixJkwYVnW+1JLFHC26gouQBeFJePMKFmi6AyOskph1FDhXf1/DcGjnhCOYKfmA88RNWhzgkbku3S2EqJQptphEpc/YaBcz3got74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783008238; c=relaxed/simple;
	bh=NNUAesQWJsmzIG3Up18xlY+dS4t2LVqxOoXhw+d5LMQ=;
	h=Date:To:From:Subject:Message-Id; b=LDA6U0s2yTpBZh23KMD2tVg0vkkoPRHmQUsKWjGphNsrQV2wyvOVjDHUNhOORDYgb+e3k2xRGCJ7jo7f2QKfnilwm0BlBRnC+BPm/VAsuVN8uEkwoq3W8nllBL8kfIN0QthoSPekFmYe8+bCzKKBfXDfipyOCgH5gGX63fTQEok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UZqi28uR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UZqi28uR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DABCF1F00A3A;
	Thu,  2 Jul 2026 16:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783008237;
	bh=UN89C+EfZMT+T1j36+Vkn0Z1aJUKv73EUzFDEB8+Wiw=;
	h=Date:To:From:Subject;
	b=UZqi28uRPZZIQGFxFVGMiBttzgXX3jiBduxSAvJKgWX43FdbA6+1EmZW5NLxYLAWj
	 soI0TWNzgSMf+vyb8is6HlcR8c2qj1A+Vpl61qHYCDQIkhOhjtS/mZisF16FO/hrbm
	 V4KeCUkjrr1n/qHBiPJWIbzmnjJ8ZEqZwNt3ge74=
Date: Thu, 02 Jul 2026 09:03:56 -0700
To: mm-commits@vger.kernel.org,lizhe.67@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-use-memcpy_nt-in-zone-device-template-copies.patch removed from -mm tree
Message-Id: <20260702160356.DABCF1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: use memcpy_nt() in zone-device template copies
has been removed from the -mm tree.  Its filename was
     mm-use-memcpy_nt-in-zone-device-template-copies.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: mm: use memcpy_nt() in zone-device template copies
Date: Wed, 1 Jul 2026 17:05:53 +0800

The template fast path currently uses memcpy() for the actual struct page
copy.  Switch zone_device_page_init_from_template() to memcpy_nt() and add
memcpy_nt_drain() before memmap_init_compound(), before
prep_compound_head() updates overlapping tail metadata, and before
returning from memmap_init_zone_device().

ZONE_DEVICE memmap initialization is largely write-once: each struct page
is populated once, and most destination cachelines are not expected to be
reused immediately afterwards.  On x86, a regular cached memcpy() can
therefore incur write-allocate traffic by pulling destination cachelines
into the cache before writeback, and can populate the cache with data that
has little near-term reuse.  Using memcpy_nt() lets this path request
non-temporal stores for that copy pattern, which can reduce cache
pollution and avoid part of the associated write-allocate overhead, while
architectures without a specialized backend still fall back to memcpy().

When memcpy_nt() maps to non-temporal stores, order those stores before
memmap_init_compound(), before prep_compound_head() updates overlapping
compound metadata, and before returning from memmap_init_zone_device().

Keep sanitized builds on the slow path so KASAN/KMSAN retain their
instrumented stores.

Tested in a VM with a 100 GB fsdax namespace device configured with
map=dev and a 100 GB devdax namespace (align=2097152) on Intel Ice Lake
server.

Test procedure:
Rebind the nd_pmem and dax_pmem driver 30 times and collect the memmap
initialization time from the pr_debug() output of
memmap_init_zone_device().

Base(v7.2-rc1):
  First binding for nd_pmem driver: 1456 ms
  Average of subsequent rebinds: 244.28 ms

  First binding for dax_pmem driver: 1462 ms
  Average of subsequent rebinds: 273.31 ms

With this series:
  First binding for nd_pmem driver: 1272 ms
  Average of subsequent rebinds: 96.79 ms

  First binding for dax_pmem driver: 1354 ms
  Average of subsequent rebinds: 119.04 ms

This reduces the average rebind time by about 60.4% for nd_pmem and
56.4% for dax_pmem.

Link: https://lore.kernel.org/20260701090553.62691-9-lizhe.67@bytedance.com
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |   39 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 37 insertions(+), 2 deletions(-)

--- a/mm/mm_init.c~mm-use-memcpy_nt-in-zone-device-template-copies
+++ a/mm/mm_init.c
@@ -1059,10 +1059,20 @@ static void __ref zone_device_page_init_
 static inline bool zone_device_page_init_optimization_enabled(void)
 {
 	/*
+	 * Keep sanitized builds on the slow path so their stores stay
+	 * instrumented.
+	 */
+	if (IS_ENABLED(CONFIG_KASAN) || IS_ENABLED(CONFIG_KMSAN))
+		return false;
+
+	/*
 	 * The template fast path copies a preinitialized struct page image.
 	 * Skip it when the page_ref_set tracepoint is enabled.
 	 */
-	return !page_ref_tracepoint_active(page_ref_set);
+	if (page_ref_tracepoint_active(page_ref_set))
+		return false;
+
+	return true;
 }
 
 static inline void zone_device_template_page_init(struct page *template,
@@ -1107,7 +1117,7 @@ static void zone_device_page_init_from_t
 	 * to the destination page.
 	 */
 	zone_device_page_update_template(template, pfn);
-	memcpy(page, template, sizeof(*page));
+	memcpy_nt(page, template, sizeof(*page));
 }
 
 /*
@@ -1178,6 +1188,15 @@ static void __ref memmap_init_compound(s
 			zone_device_tail_page_init(page, pfn, zone_idx, nid,
 						   pgmap, head, order);
 	}
+
+	/*
+	 * When the template path is enabled, order the preceding tail-page copies
+	 * before prep_compound_head() updates the overlapping compound metadata
+	 * in the first tail-page descriptors. If memcpy_nt() fell back to
+	 * regular cached stores, memcpy_nt_drain() may be a no-op.
+	 */
+	if (use_template)
+		memcpy_nt_drain();
 	prep_compound_head(head, order);
 }
 
@@ -1247,10 +1266,26 @@ void __ref memmap_init_zone_device(struc
 		if (pfns_per_compound == 1)
 			continue;
 
+		/*
+		 * When the template path is enabled, order the preceding head-page copy
+		 * before memmap_init_compound(), which immediately updates compound-head
+		 * metadata. If memcpy_nt() fell back to regular cached stores,
+		 * memcpy_nt_drain() may be a no-op.
+		 */
+		if (use_template)
+			memcpy_nt_drain();
+
 		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
 				     compound_nr_pages(pfn, altmap, pgmap),
 				     use_template);
 	}
+	/*
+	 * Ensure any prior template copies are ordered before returning.
+	 * On architectures where memcpy_nt() used regular cached stores,
+	 * memcpy_nt_drain() may be a no-op.
+	 */
+	if (use_template)
+		memcpy_nt_drain();
 
 	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE, false);
 
_

Patches currently in -mm which might be from lizhe.67@bytedance.com are



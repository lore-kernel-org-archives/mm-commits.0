Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA2F30C168
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334299; cv=none; b=aOUOe+WcIq7xSlwTVvGWVvyVZFas/V4CIKBlOEsSGEIM823B8A1y4JSdxfwNL3xzjDSx1TPCkXt3ssA6jR0xGhnn7uUC0FLhzL52++aNw1K6jUC12y6NHVut9JvqI7gRPnQDw4ZUSZbbzU5olz6s/vbfUZMRnom+XKWrR6lgsW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334299; c=relaxed/simple;
	bh=AaP7Bq55d/qNwX3kBM+zlrWzCmEIGoiHguhxhS+Ax5s=;
	h=Date:To:From:Subject:Message-Id; b=l1SHRRUiLu4gATUKGEvG1tvCvZWgidCtJ36ZwzF0lVGIJvBwQMaMOt+adIFFnfP4wqJ3cZWuk4VXE9qfLL6W6izH411iqho5GD8pF/dbpYH4zX9NR6M+oTOhrOrSzvUxDbi5cO70x3kIcs+e1nuPJOZYrVRbbYCRuL49XyEVw6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VmCPBeDN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VmCPBeDN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6350B1F0089B;
	Wed,  7 Oct 2026 00:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334298;
	bh=+QTpxg+XHT5aHPaq9WSEWOZIC6xDmtIUXhqvedY9rnk=;
	h=Date:To:From:Subject;
	b=VmCPBeDNLnXiqEkQDV8b+78C0Ul5RTf6CzgVnW/QilUlo+htxvzQihDMbvIo53T/1
	 c0GfXYTQqFCnoRTtqOJkfbRJGU5tcERj9jcsxWTHVFbTaEEsDjyt0gdxcJPxJZPsuV
	 FDP54iXbmOTebc+S0Qpq4oHTd20zOCEEt1mNnGc0=
Date: Tue, 06 Oct 2026 17:51:38 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,muchun.song@linux.dev,mingo@redhat.com,kees@kernel.org,david@kernel.org,dave.hansen@linux.intel.com,bp@alien8.de,balbirs@nvidia.com,arnd@arndb.de,apopple@nvidia.com,lizhe.67@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-use-memcpy_nontemporal-in-zone-device-template-copies.patch removed from -mm tree
Message-Id: <20261007005138.6350B1F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: use memcpy_nontemporal() in zone-device template copies
has been removed from the -mm tree.  Its filename was
     mm-use-memcpy_nontemporal-in-zone-device-template-copies.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: mm: use memcpy_nontemporal() in zone-device template copies
Date: Mon, 31 Aug 2026 19:16:37 +0800

The template fast path currently uses memcpy() for the actual struct page
copy.  Switch zone_device_page_init_from_template() to
memcpy_nontemporal().

ZONE_DEVICE memmap initialization is largely write-once: each struct page
is populated once, and most destination cachelines are not expected to be
reused immediately afterwards.  On x86, a regular cached memcpy() can
therefore incur write-allocate traffic by pulling destination cachelines
into the cache before writeback, and can populate the cache with data that
has little near-term reuse.  Using memcpy_nontemporal() lets this path
request nontemporal stores for that copy pattern, which can reduce cache
pollution and avoid part of the associated write-allocate overhead, while
architectures without a specialized backend still fall back to memcpy().

Do not add a KASAN/KMSAN-specific fallback around this call site.  As
Muchun pointed out, special KASAN handling for memcpy_flushcache() or
memcpy_nontemporal(), if needed, belongs in the low-level helper rather
than in this ZONE_DEVICE caller.

No separate drain is added here.  memcpy_nontemporal() is used only as the
copy primitive while memmap_init_zone_device() is still initializing the
struct page array.  The ordinary stores that follow in this path, such as
compound-page setup, are part of the same CPU's initialization sequence;
they are not used as a publication store that tells another CPU or device
to consume data written by the non-temporal copy.

Therefore this call site does not need a helper-level drain for
correctness.  Callers that use memcpy_nontemporal() as part of a
producer-consumer or device-visible handoff must add the required ordering
themselves.

Tested in a VM with a 100 GB fsdax namespace device configured with
map=dev and a 100 GB devdax namespace (align=2097152) on Intel Ice Lake
server.

Test procedure:
Rebind the nd_pmem and dax_pmem driver 30 times and collect the memmap
initialization time from the pr_debug() output of
memmap_init_zone_device().

Base(v7.3-rc1):
  Average of rebinds for nd_pmem driver: 221.07 ms
  Average of rebinds for dax_pmem driver: 191.20 ms

With this patch and its prerequisites applied:
  Average of rebinds for nd_pmem driver: 150.40 ms
  Average of rebinds for dax_pmem driver: 161.83 ms

This reduces the average memmap initialization time measured during rebind
by about 32.0% for nd_pmem and 15.4% for dax_pmem.

Link: https://lore.kernel.org/20260831111638.76012-7-lizhe.67@bytedance.com
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
---

 mm/mm_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mm_init.c~mm-use-memcpy_nontemporal-in-zone-device-template-copies
+++ a/mm/mm_init.c
@@ -1037,7 +1037,7 @@ static void zone_device_page_init_from_t
 	if (!is_highmem_idx(ZONE_DEVICE))
 		set_page_address(template, __va(pfn << PAGE_SHIFT));
 #endif
-	memcpy(page, template, sizeof(*page));
+	memcpy_nontemporal(page, template, sizeof(*page));
 }
 
 /*
_

Patches currently in -mm which might be from lizhe.67@bytedance.com are

mm-hugetlb-fix-overbroad-mmu-notifiers-for-unshared-pmds.patch


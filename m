Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 106FE30C168
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334297; cv=none; b=WbITUB1gTNt7EKOmm1KgZfe3UIe2Fy4IBC5AMWIzNUmWFcOppL/zGLhVuyX+Fj3r8ZkXOqkwExRd5nomEDH/EU+FudZ2IIYTYbZieEklBk2/Eafw/o199nvClDY070SJ2D1dWwpvvWeJD7cCE6kj7ivyeF96dJ94zrqFHoncYkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334297; c=relaxed/simple;
	bh=HoIeQwdobHKIl90zZgpxiwKEcNnvf/hptruzCrvn64M=;
	h=Date:To:From:Subject:Message-Id; b=BL6ZilIUdYFLu1do2S25cQ9QyNJUYc6IiGHXMgdOTgFHu+XL7sB/HYCPkg27gsuBRaGqBRpdBK+56RzAWSXekF+lEADeg49p7qntZaBuESWmzxcSUawMzRE4un4XiAfSXT8QjVwvORa6BwLel6oUf00t1XIfqM0750Sk4m4Xikc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yP5Ad/PC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yP5Ad/PC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D86221F0089B;
	Wed,  7 Oct 2026 00:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334296;
	bh=o5fEz1CvAQH6uMwVRbwGQ2qSzVV9RdYWzweHkXP4OTg=;
	h=Date:To:From:Subject;
	b=yP5Ad/PCsHRsb+gBW76dFWls0AfZp13e31peeA3IGGkUSpe37fLtgcXX8HZW+YpgB
	 bUBRt4GOXP20d8skMmXoW+F6v/pqH3MUIlDQriCfKUqLorZiL/XwHsjMS/XL9U1Gol
	 udxrtgmjhPz04nFurml7S6osWIXsPWX12uoQOGuQ=
Date: Tue, 06 Oct 2026 17:51:35 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,muchun.song@linux.dev,mingo@redhat.com,kees@kernel.org,david@kernel.org,dave.hansen@linux.intel.com,bp@alien8.de,balbirs@nvidia.com,arnd@arndb.de,apopple@nvidia.com,lizhe.67@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-extend-the-template-fast-path-to-zone-device-compound-tails.patch removed from -mm tree
Message-Id: <20261007005135.D86221F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: extend the template fast path to zone-device compound tails
has been removed from the -mm tree.  Its filename was
     mm-extend-the-template-fast-path-to-zone-device-compound-tails.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: mm: extend the template fast path to zone-device compound tails
Date: Mon, 31 Aug 2026 19:16:35 +0800

The template fast path from the previous patch only accelerates head
pages.  Compound tails in memmap_init_compound() still go through the
normal initialization path one by one.

Build separate head and tail templates and reuse one prepared tail
template across the tail pages in a compound range.  Head pages preserve
the existing refcount policy, while compound tails always start with a
refcount of 0 after prep_compound_tail().

This extends the template-copy fast path to pfns_per_compound > 1. 
Tail-page PFN-dependent fields are refreshed in the reusable tail template
before each copy.

Do not keep a separate non-template fallback for compound tails either. 
These pages are still under memmap initialization, and the
initialization-time refcount updates are not part of the observable
lifetime of pages handed out later.

The impact is controlled for the same reason as for head pages.  The first
tail page still seeds the reusable tail template through the normal tail
initialization sequence, and the copied tail pages have the same final
initialized state except for the PFN-dependent fields refreshed before
each copy.

Tested in a VM with a 100 GB devdax namespace (align=2097152) on Intel Ice
Lake server.  This test exercises the dax_pmem rebind path and measures
memmap initialization latency.

Test procedure: Unbind and rebind the dax_pmem driver 30 times, collect
memmap initialization time from the pr_debug() output of
memmap_init_zone_device().

Base(v7.3-rc1):
  Average of rebinds for dax_pmem driver: 191.20 ms

With this patch and its prerequisites applied:
  Average of rebinds for dax_pmem driver: 176.87 ms

This reduces the average memmap initialization time measured during
rebind from 191.20 ms to 176.87 ms, or about 7.5%.

Link: https://lore.kernel.org/20260831111638.76012-5-lizhe.67@bytedance.com
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
---

 mm/mm_init.c |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

--- a/mm/mm_init.c~mm-extend-the-template-fast-path-to-zone-device-compound-tails
+++ a/mm/mm_init.c
@@ -1072,6 +1072,8 @@ static void __ref memmap_init_compound(s
 {
 	unsigned long pfn, end_pfn = head_pfn + nr_pages;
 	unsigned int order = pgmap->vmemmap_shift;
+	struct page template;
+	struct page *page;
 
 	/*
 	 * We have to initialize the pages, including setting up page links.
@@ -1080,13 +1082,23 @@ static void __ref memmap_init_compound(s
 	 * the pages in the same go.
 	 */
 	__SetPageHead(head);
-	for (pfn = head_pfn + 1; pfn < end_pfn; pfn++) {
-		struct page *page = pfn_to_page(pfn);
 
-		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
-		prep_compound_tail(page, head, order);
-		set_page_count(page, 0);
-	}
+	/*
+	 * All tails of the same compound page share the state established by
+	 * prep_compound_tail(). Reuse one tail template for the whole range and
+	 * refresh only the PFN-dependent fields in that template before each copy.
+	 */
+	pfn = head_pfn + 1;
+	page = pfn_to_page(pfn);
+	__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
+	prep_compound_tail(page, head, order);
+	set_page_count(page, 0);
+	memcpy(&template, page, sizeof(*page));
+
+	/* Initialize the remaining tail pages from template. */
+	for (pfn = head_pfn + 2; pfn < end_pfn; pfn++)
+		zone_device_page_init_from_template(pfn_to_page(pfn), pfn,
+						    &template);
 	prep_compound_head(head, order);
 }
 
_

Patches currently in -mm which might be from lizhe.67@bytedance.com are

mm-hugetlb-fix-overbroad-mmu-notifiers-for-unshared-pmds.patch


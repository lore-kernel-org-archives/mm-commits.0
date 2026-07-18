Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ABA92AD03
	for <mm-commits@vger.kernel.org>; Sat, 18 Jul 2026 01:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784337816; cv=none; b=hrzvllJcdO4ZVkQ9JU7Thb7To8LfNg0HtRlCmVhtMrICoxFiutv8qyP/y4/Seg8PfoIfGv8z0HJlfAbEQ7RyXHOeehDBk7vlGI1DI9/Ekb4e8qbtF/lO3NNZ1B95pDyXLmagptjfJBd1DxZkGz57qjvwpdoBdi2FNp2rfwgJPsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784337816; c=relaxed/simple;
	bh=3MLmAoK/oqmoQ79XiXHxINty2tsnuIlWNz0MW8iJDCo=;
	h=Date:To:From:Subject:Message-Id; b=k2mHdqDidbuPbxW3o489ujPS2+r1VM1S2VvI00b5leuX0vSk7XQRIiZnMrL2zE7NzcFjA4uOYjv11fAeO1jdkEdSnMDXnh0wtrpXfJ6GtEqV36ICZeW1d1ySv43YwfwssSa7eMNbJdCtGnMCaJMORVroikL7PYPxSH044edSRVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M7a33w+e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M7a33w+e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA4E61F000E9;
	Sat, 18 Jul 2026 01:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784337814;
	bh=njodvPB208Oy4asCxy+W3ixdoTqA1yK6XCpsXDsxlTk=;
	h=Date:To:From:Subject;
	b=M7a33w+e98K73YV8TyFdxpDwI/Qv0AQ14mmrgI1Vs6gVdXGZkqmFk4jjC8l95NFcj
	 vnq+lXv2bYONz3qPjbRsh0bnAqajlnS8gfa/DEhs4AEEpRE7GQLh/oVXiktVOT3xwn
	 gZnm9bZyb14yKiZpaTmVQXTZvn7YkAqOqaCrMjBE=
Date: Fri, 17 Jul 2026 18:23:34 -0700
To: mm-commits@vger.kernel.org,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-decrement-mthp_stat_nr_anon-in-free_zone_device_folio.patch removed from -mm tree
Message-Id: <20260718012334.AA4E61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: decrement MTHP_STAT_NR_ANON in free_zone_device_folio()
has been removed from the -mm tree.  Its filename was
     mm-decrement-mthp_stat_nr_anon-in-free_zone_device_folio.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Nico Pache <npache@redhat.com>
Subject: mm: decrement MTHP_STAT_NR_ANON in free_zone_device_folio()
Date: Thu, 2 Jul 2026 11:25:46 -0600

Patch series "mm: fix PMD level mTHP accounting bugs".

While running selftests I noticed the PMD level per-mTHP stats (nr_anon)
remained elevated after each run.  After further investigation I noticed
this accounting error occurs for both the migration.private_anon_htlb_test
and the HMM tests.

In the HMM case this is due to folio_add_new_anon_rmap() incrementing the
mTHP stats, but never containing a corresponding decrement in
free_zone_device_folio().  We solve this by making sure to decrement the
counter when freeing device memory.

In the migration case, we are incrementing this counter without first
checking whether this folio is a hugetlb folio, which relies on a separate
accounting system.  We solve this by adding the proper hugetlb check
before incrementing this counter.

With these changes in place, the two tests no longer cause elevated PMD
level accounting issues.


This patch (of 2):

When a zone device folio is mapped as anonymous, folio_add_new_anon_rmap()
increments MTHP_STAT_NR_ANON.  The corresponding decrement lives in
__free_pages_prepare() in page_alloc.c, but zone device folios are freed
via free_zone_device_folio() which never calls __free_pages_prepare(). 
This causes nr_anon to remain permanently elevated after zone device
folios are freed.

Add the missing mod_mthp_stat() decrement to free_zone_device_folio() so
that the counter is properly balanced.

Link: https://lore.kernel.org/20260702172548.37075-1-npache@redhat.com
Link: https://lore.kernel.org/20260702172548.37075-2-npache@redhat.com
Fixes: 5d65c8d758f2 ("mm: count the number of anonymous THPs per size")
Co-developed-by: David Hildenbrand <david@kernel.org>
Signed-off-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Nico Pache <npache@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memremap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/memremap.c~mm-decrement-mthp_stat_nr_anon-in-free_zone_device_folio
+++ a/mm/memremap.c
@@ -425,6 +425,7 @@ void free_zone_device_folio(struct folio
 	mem_cgroup_uncharge(folio);
 
 	if (folio_test_anon(folio)) {
+		mod_mthp_stat(folio_order(folio), MTHP_STAT_NR_ANON, -1);
 		for (i = 0; i < nr; i++)
 			__ClearPageAnonExclusive(folio_page(folio, i));
 	}
_

Patches currently in -mm which might be from npache@redhat.com are

mm-migrate-exclude-hugetlb-folios-from-mthp_stat_nr_anon-accounting.patch


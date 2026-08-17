Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 679783BFE2B;
	Mon, 17 Aug 2026 22:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787007027; cv=none; b=ZZKH9vJ4/OBXU3KM1pai8Ddjlu6ycSTSe14tXzT7BjoWpMxQKUXrvv1uqydRO4yiCUUQbWI4uOPDSIrDe+fWck8K8UOSXwwKx0f0zu1hCUHolnsmh//yLMhCvcTVc+uAE+QieNhWX1Tx3WChXRQJq7vDuWFBIalKjEQuabrzKao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787007027; c=relaxed/simple;
	bh=HxFN5ZaNjv9S62JrkmPjnMknUQoLVrTVbUA6HaULKFQ=;
	h=Date:To:From:Subject:Message-Id; b=h0/yB6upu5s1+U1Y16ThHTUXgYC+3EIaR1roIIQ4s52Op8yj2K10LhFTygw7YkIAdcLpJTjJ0KjG62el0+WVIDy1WxVIYfn1S00GC2n/lKh+LqzIBpvErAtnMJ42YZe6ss2CAkV4TTXPl6Tk8kLvDLuqE7S2K+T993BUJLD2v7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VRQLV75r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VRQLV75r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EDA91F000E9;
	Mon, 17 Aug 2026 22:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787007026;
	bh=LOeEglrf3tpYWHAEOgISvET4NR3kdPQu3ua8Q2RIiLA=;
	h=Date:To:From:Subject;
	b=VRQLV75rK1vLlY6PNHeubQ3NIeS2bCPsq9hk9wpmlmyC/AN0bO7PrhjOAFFQBdnBn
	 hKjVWJuoQ1Lp+RNtEfqu0AkrjyYWwxZEPNPQAkckzELgL+bpsgLIonzybAl8wOupQS
	 KvV6mngZxJ7SL1+uqahHMCGlOdwZHVbEhOYa/Vw8=
Date: Mon, 17 Aug 2026 15:50:25 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,stable@vger.kernel.org,rakie.kim@sk.com,matthew.brost@intel.com,joshua.hahnjy@gmail.com,gourry@gourry.net,david@kernel.org,byungchul@sk.com,balbirs@nvidia.com,apopple@nvidia.com,sh_def@163.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate_device-avoid-out-of-bounds-writes-for-compound-folios.patch added to mm-hotfixes-unstable branch
Message-Id: <20260817225026.2EDA91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/migrate_device: avoid out-of-bounds writes for compound folios
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-migrate_device-avoid-out-of-bounds-writes-for-compound-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate_device-avoid-out-of-bounds-writes-for-compound-folios.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Hui Su <sh_def@163.com>
Subject: mm/migrate_device: avoid out-of-bounds writes for compound folios
Date: Mon, 17 Aug 2026 20:08:00 +0800

migrate_device_range() and migrate_device_pfns() clear the entries
following a compound folio so that the PFN arrays retain their
page-granular representation.

If a compound folio extends beyond the end of the caller-provided range,
the loops clear all following folio entries without limiting them to the
number of slots remaining in the npages-sized array, causing an
out-of-bounds write.

Do not proceed with a compound folio if its page-granular representation
does not fit entirely in the remaining PFN array.  If this happens, drop
any reference and lock acquired for the folio, clear the remaining
entries, and stop collecting.

Observed with a KASAN x86 QEMU kernel using the HMM migrate_anon_huge_zero
selftest.  Closing /dev/hmm_dmirror0 after migrating an anonymous huge
page to device memory exercises:

  dmirror_fops_release()
    -> dmirror_device_evict_chunk()
      -> migrate_device_range()

Link: https://lore.kernel.org/20260817120758.669807-3-sh_def@163.com
Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
Signed-off-by: Hui Su <sh_def@163.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate_device.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/mm/migrate_device.c~mm-migrate_device-avoid-out-of-bounds-writes-for-compound-folios
+++ a/mm/migrate_device.c
@@ -1400,6 +1400,15 @@ int migrate_device_range(unsigned long *
 
 		src_pfns[i] = migrate_device_pfn_lock(pfn);
 		nr = folio_nr_pages(folio);
+		if (nr > npages - i) {
+			if (src_pfns[i] & MIGRATE_PFN_MIGRATE) {
+				folio_unlock(folio);
+				folio_put(folio);
+			}
+			memset(&src_pfns[i], 0,
+			       (npages - i) * sizeof(*src_pfns));
+			break;
+		}
 		if (nr > 1) {
 			src_pfns[i] |= MIGRATE_PFN_COMPOUND;
 			for (j = 1; j < nr; j++)
@@ -1434,6 +1443,15 @@ int migrate_device_pfns(unsigned long *s
 
 		src_pfns[i] = migrate_device_pfn_lock(src_pfns[i]);
 		nr = folio_nr_pages(folio);
+		if (nr > npages - i) {
+			if (src_pfns[i] & MIGRATE_PFN_MIGRATE) {
+				folio_unlock(folio);
+				folio_put(folio);
+			}
+			memset(&src_pfns[i], 0,
+			       (npages - i) * sizeof(*src_pfns));
+			break;
+		}
 		if (nr > 1) {
 			src_pfns[i] |= MIGRATE_PFN_COMPOUND;
 			for (j = 1; j < nr; j++)
_

Patches currently in -mm which might be from sh_def@163.com are

mm-migrate_device-avoid-out-of-bounds-writes-for-compound-folios.patch
kasan-fix-cache-shrink-race-with-cpu-hotplug.patch
kasan-fix-quarantine_size-accounting-during-cache-removal.patch
mm-migrate_device-fix-cache-flush-when-replacing-huge-zero-pmd.patch


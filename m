Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF23C377019;
	Thu, 27 Aug 2026 20:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787861305; cv=none; b=trannqkvzBNU3TT0RFUXea8oB5Q2MQL9QwX1avS68QXUTi7oWIWBT5VtHh9saYb4xxspRt1C1WrUMsIEF0U7Yi7OoLwpbCqu4cqXijvpB5MG7L10aN5vCu7YHkFkvUyKpe5JVNiMlyLVuC0n5q816ILHGotzek2ntMS3G2hklbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787861305; c=relaxed/simple;
	bh=iCLeU3rVNSENvnBl+WIRtKCjTDSCy6y/XdqRm6DtRSs=;
	h=Date:To:From:Subject:Message-Id; b=ra+UZ819oRMhOZiPB5cPBPvZ1hIFe+R6wwvCoI1QRR+P4ca4JnF/svgItVZo/X0o7w3N3Ar6N1deoaGOxWftTJJzG2TpKmsxh5wG4673MYsmjZEU5mzrODnmaFDwRtpAcISIEB7IIvqGwQZT0dOWqGsfapMFDHC074TvtRoAF34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bt3YyfpM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bt3YyfpM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEE441F00A3E;
	Thu, 27 Aug 2026 20:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787861302;
	bh=WxNfcrs4yeg9Y25ZC995lfIxXjLIowcw6hg/YjQtNs8=;
	h=Date:To:From:Subject;
	b=bt3YyfpMehZKPuZZtpVYLIdi7KYrZRqpiCduM/k3yUVGZ1nmEV2eljRGPS347HSC5
	 Zo5FE0cl2XMXDe01bieG7VrAs6T7v7WbdfsnAriQVs+wJqHIKDjcETkGFFDxllbbCc
	 80JLfuBzkO4XmksRZbv0wcpYTr9/sQXU22IkDHzs=
Date: Thu, 27 Aug 2026 13:08:21 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,stable@vger.kernel.org,rakie.kim@sk.com,matthew.brost@intel.com,joshua.hahnjy@gmail.com,gourry@gourry.net,david@kernel.org,byungchul@sk.com,balbirs@nvidia.com,apopple@nvidia.com,sh_def@163.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-migrate_device-avoid-out-of-bounds-writes-for-compound-folios.patch removed from -mm tree
Message-Id: <20260827200821.EEE441F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/migrate_device: avoid out-of-bounds writes for compound folios
has been removed from the -mm tree.  Its filename was
     mm-migrate_device-avoid-out-of-bounds-writes-for-compound-folios.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -1423,6 +1423,15 @@ int migrate_device_range(unsigned long *
 
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
@@ -1457,6 +1466,15 @@ int migrate_device_pfns(unsigned long *s
 
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



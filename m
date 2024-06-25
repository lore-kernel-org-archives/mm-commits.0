Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC76C13A416
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719289793; cv=none; b=UOQKBP/skyYh7VjoWQKPljcCvvTFY1w+m/MqRcAyQTO/ghdWhn/Url6QWlBH0ba6BUHpUPGpuo99t4V2GN32p5LisSdBj1GmIz1N9UaerxmTAwaclPT4Q4Tg7GMPNrf9jfht2YE1LZWh7DXpAD/BZNiF+UgqM0HePa9ab2QpFeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719289793; c=relaxed/simple;
	bh=uuYGHwAyckNeYwpsblVuPMo6ik8vxh7VDpL3KvB4j68=;
	h=Date:To:From:Subject:Message-Id; b=GKevY2A0vauk444cL02bhyUSRTEVRXgGDlgKFMt2GRwwPb47KWPJwHwR3Hz+abewkF3cztUi+01+htOxOyZbvpZDdRAhv4ACpCwsgRcacYScv74rdfeS9hiKvt4kF2DwCE8iPlkZAC+tmi2ZUNjxuqhz6z1rN5VDE9JxogYEei4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t+jfgkaK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t+jfgkaK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58B09C32782;
	Tue, 25 Jun 2024 04:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719289792;
	bh=uuYGHwAyckNeYwpsblVuPMo6ik8vxh7VDpL3KvB4j68=;
	h=Date:To:From:Subject:From;
	b=t+jfgkaKUdqLEGwTm2lzHYMvQcxewIXv7rWoRfOG1WYsT5z4GjZn39cgWezXQc5kj
	 UaFjJrStEQBfwXGwUdhKi7zbTQT2eQL7qj9dymoEJhvpceHro7LBYZSlpbV1z8znJy
	 yGpbuVUWlQt0gpx3NLNhxhuHo95OCihUx9KLDw3g=
Date: Mon, 24 Jun 2024 21:29:51 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-highmem-reimplement-totalhigh_pages-by-walking-zones-fix.patch removed from -mm tree
Message-Id: <20240625042952.58B09C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-highmem-reimplement-totalhigh_pages-by-walking-zones-fix
has been removed from the -mm tree.  Its filename was
     mm-highmem-reimplement-totalhigh_pages-by-walking-zones-fix.patch

This patch was dropped because it was folded into mm-highmem-reimplement-totalhigh_pages-by-walking-zones.patch

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm-highmem-reimplement-totalhigh_pages-by-walking-zones-fix
Date: Fri, 7 Jun 2024 23:04:53 +0200

fix build bot complaint

Link: https://lkml.kernel.org/r/b57e5bc4-eb72-40e3-add4-57dfa6e03df6@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/highmem.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/highmem.c~mm-highmem-reimplement-totalhigh_pages-by-walking-zones-fix
+++ a/mm/highmem.c
@@ -136,6 +136,7 @@ unsigned long __totalhigh_pages(void)
 
 	return pages;
 }
+EXPORT_SYMBOL(__totalhigh_pages);
 
 static int pkmap_count[LAST_PKMAP];
 static  __cacheline_aligned_in_smp DEFINE_SPINLOCK(kmap_lock);
_

Patches currently in -mm which might be from david@redhat.com are

mm-memory-move-page_count-check-into-validate_page_before_insert.patch
mm-memory-cleanly-support-zeropage-in-vm_insert_page-vm_map_pages-and-vmf_insert_mixed.patch
mm-rmap-sanity-check-that-zeropages-are-not-passed-to-rmap.patch
fs-proc-task_mmu-indicate-pm_file-for-pmd-mapped-file-thp.patch
fs-proc-task_mmu-dont-indicate-pm_mmap_exclusive-without-pm_present.patch
fs-proc-task_mmu-properly-detect-pm_mmap_exclusive-per-page-of-pmd-mapped-thps.patch
fs-proc-task_mmu-account-non-present-entries-as-maybe-shared-but-no-idea-how-often.patch
fs-proc-move-page_mapcount-to-fs-proc-internalh.patch
documentation-admin-guide-mm-pagemaprst-drop-using-pagemap-to-do-something-useful.patch
mm-highmem-reimplement-totalhigh_pages-by-walking-zones.patch
mm-highmem-make-nr_free_highpages-return-unsigned-long.patch
mm-pass-meminit_context-to-__free_pages_core.patch
mm-pass-meminit_context-to-__free_pages_core-fix.patch
mm-pass-meminit_context-to-__free_pages_core-fix-2.patch
mm-pass-meminit_context-to-__free_pages_core-fix-3.patch
mm-memory_hotplug-initialize-memmap-of-zone_device-with-pageoffline-instead-of-pagereserved.patch
mm-memory_hotplug-skip-adjust_managed_page_count-for-pageoffline-pages-when-offlining.patch
mm-read-page_type-using-read_once.patch
mm-migrate-make-migrate_misplaced_folio-return-0-on-success.patch
mm-migrate-move-numa-hinting-fault-folio-isolation-checks-under-ptl.patch


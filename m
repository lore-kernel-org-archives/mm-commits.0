Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 087A573477
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247767; cv=none; b=boaHCtZDNGbp12qkYKZxYPk9udueZ+75V+KrQRff1FKe91whYNKs6CUpGrLLCA9YtZ/0p7col9njGqPrJtq+r1pQ8oOYXZIT1jGvBl0xFSV5h5P4+Ejczbh6ZbkfhaROvaVM1wz9v/Vv3f9oHj+wbC6Pm5GlKLWyLrRXKw12Luc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247767; c=relaxed/simple;
	bh=rKNXG7GLEZ6S0v+KbEvedC78cCE/Che8XTbnVEQ9XOY=;
	h=Date:To:From:Subject:Message-Id; b=NhJsRBaGe2DVsoiJs8Lj6HMi+nsq7qVLjEgVaXW//ubTfiDLzI8efwIjfgPa7IV9l71Wu+sAfJ3+4wx4OvZQOPebPcuk7G3T7ESSIsgQPgUrov1AvGC3kCclQHfghLDjl8aDk2yCMFR1ua+DpeZd04i6huOomTtQ0yrTvtnfB/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QPqtGGpN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QPqtGGpN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D36E3C4CEC2;
	Mon,  2 Sep 2024 03:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247766;
	bh=rKNXG7GLEZ6S0v+KbEvedC78cCE/Che8XTbnVEQ9XOY=;
	h=Date:To:From:Subject:From;
	b=QPqtGGpNPmn2uYw3MPzaBfTDGMHdGAHlwDbIp2fmL515mgBxu6Iy4F2iAnzwEbV5s
	 jbb7OhjnVaNc4vP6NntfWKq+BoVghYyL/84V9wi3ZYS2757LAmQwWuVpn4ydHB+a5T
	 IVRMwurO+/dDG4au068RtdbXJjn/LvKfVYXDmbxk=
Date: Sun, 01 Sep 2024 20:29:26 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-minimize-folio-_nr_pages_mapped-updates-when-batching-pte-unmapping.patch removed from -mm tree
Message-Id: <20240902032926.D36E3C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: minimize folio->_nr_pages_mapped updates when batching PTE (un)mapping
has been removed from the -mm tree.  Its filename was
     mm-rmap-minimize-folio-_nr_pages_mapped-updates-when-batching-pte-unmapping.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/rmap: minimize folio->_nr_pages_mapped updates when batching PTE (un)mapping
Date: Wed, 7 Aug 2024 13:55:15 +0200

It is not immediately obvious, but we can move the folio->_nr_pages_mapped
update out of the loop and reduce the number of atomic ops without
affecting the stats.

The important point to realize is that only removing the last PMD mapping
will result in _nr_pages_mapped going below ENTIRELY_MAPPED, not the
individual atomic_inc_return_relaxed() calls.  Concurrent races with
removal of PMD mappings should be handled as expected, just like when we
would have such races right now on a single mapcount update.

In a simple munmap() microbenchmark [1] on 1 GiB of memory backed by the
same PTE-mapped folio size (only mapped by a single process such that they
will get completely unmapped), this change results in a speedup (positive
is good) per folio size on a x86-64 Intel machine of roughly (a bit of
noise expected):

* 16 KiB: +10%
* 32 KiB: +15%
* 64 KiB: +17%
* 128 KiB: +21%
* 256 KiB: +22%
* 512 KiB: +22%
* 1024 KiB: +23%
* 2048 KiB: +27%

[1] https://gitlab.com/davidhildenbrand/scratchspace/-/blob/main/pte-mapped-folio-benchmarks.c

Link: https://lkml.kernel.org/r/20240807115515.1640951-1-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

--- a/mm/rmap.c~mm-rmap-minimize-folio-_nr_pages_mapped-updates-when-batching-pte-unmapping
+++ a/mm/rmap.c
@@ -1158,7 +1158,7 @@ static __always_inline unsigned int __fo
 {
 	atomic_t *mapped = &folio->_nr_pages_mapped;
 	const int orig_nr_pages = nr_pages;
-	int first, nr = 0;
+	int first = 0, nr = 0;
 
 	__folio_rmap_sanity_checks(folio, page, nr_pages, level);
 
@@ -1170,13 +1170,13 @@ static __always_inline unsigned int __fo
 		}
 
 		do {
-			first = atomic_inc_and_test(&page->_mapcount);
-			if (first) {
-				first = atomic_inc_return_relaxed(mapped);
-				if (first < ENTIRELY_MAPPED)
-					nr++;
-			}
+			first += atomic_inc_and_test(&page->_mapcount);
 		} while (page++, --nr_pages > 0);
+
+		if (first &&
+		    atomic_add_return_relaxed(first, mapped) < ENTIRELY_MAPPED)
+			nr = first;
+
 		atomic_add(orig_nr_pages, &folio->_large_mapcount);
 		break;
 	case RMAP_LEVEL_PMD:
@@ -1527,7 +1527,7 @@ static __always_inline void __folio_remo
 		enum rmap_level level)
 {
 	atomic_t *mapped = &folio->_nr_pages_mapped;
-	int last, nr = 0, nr_pmdmapped = 0;
+	int last = 0, nr = 0, nr_pmdmapped = 0;
 	bool partially_mapped = false;
 
 	__folio_rmap_sanity_checks(folio, page, nr_pages, level);
@@ -1541,14 +1541,13 @@ static __always_inline void __folio_remo
 
 		atomic_sub(nr_pages, &folio->_large_mapcount);
 		do {
-			last = atomic_add_negative(-1, &page->_mapcount);
-			if (last) {
-				last = atomic_dec_return_relaxed(mapped);
-				if (last < ENTIRELY_MAPPED)
-					nr++;
-			}
+			last += atomic_add_negative(-1, &page->_mapcount);
 		} while (page++, --nr_pages > 0);
 
+		if (last &&
+		    atomic_sub_return_relaxed(last, mapped) < ENTIRELY_MAPPED)
+			nr = last;
+
 		partially_mapped = nr && atomic_read(mapped);
 		break;
 	case RMAP_LEVEL_PMD:
_

Patches currently in -mm which might be from david@redhat.com are

mm-rmap-use-folio-_mapcount-for-small-folios.patch
mm-always-inline-_compound_head-with-config_hugetlb_page_optimize_vmemmap=y.patch
selftests-mm-fix-charge_reserved_hugetlbsh-test.patch


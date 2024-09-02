Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE5A47A5C
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247740; cv=none; b=k8t50gkbj40noV/IkPsCg8DhS4g5I2iQEIby9/hUExiss+MH3Jv8s0QOSAuPkHox0ZurMp8gkJjYlrhO41+g2pt9TuMF5vYwnYpjY8rD7T+1RJmW6ZrohjtTgcMyuABE4fTkHbk4pKdm3kIp+BTy/JSyYAHYbvfDzRKaz3Y7yC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247740; c=relaxed/simple;
	bh=Okx5RbqJJyfp42nHUj/UjBQwKDOvF8hbGHyg24TIJGw=;
	h=Date:To:From:Subject:Message-Id; b=s3ruKh2MnkGPOi0vsJnuov0+TEHl9YpK/ff8eY7S/2TOBl0oG0xJIE2OiNsQVXgkFBATN3v8lSIFy3fiZ6wxAdOLYRiMzXaktWimABywkTEHd93Rv376W7Jm8VlcYxxZWR4heyD1ZxTIucjpVfxcVq/Ww0VGy8+oRBQRgcj97es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=D4dblGem; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D4dblGem"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DA16C4CEC2;
	Mon,  2 Sep 2024 03:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247740;
	bh=Okx5RbqJJyfp42nHUj/UjBQwKDOvF8hbGHyg24TIJGw=;
	h=Date:To:From:Subject:From;
	b=D4dblGem9LGmoKuvogCGe7miTwILClnaV8JUA9NkQKkLSxzKVyNrQHmK8DJdn5BbI
	 EB/nJB1sonEEAZ2zGbGcTO1H6jOTe7FPm02vDy2ZwBwkzfw+gt3ml5NmXjy9L63pD6
	 9V071tbSoiBJum28khaQW6voL3ZJ2U2K6Qmz0UPc=
Date: Sun, 01 Sep 2024 20:28:59 -0700
To: mm-commits@vger.kernel.org,kaiyang2@cs.cmu.edu,hannes@cmpxchg.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] include-linux-mmzoneh-clean-up-watermark-accessors.patch removed from -mm tree
Message-Id: <20240902032900.1DA16C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: include/linux/mmzone.h: clean up watermark accessors
has been removed from the -mm tree.  Its filename was
     include-linux-mmzoneh-clean-up-watermark-accessors.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: include/linux/mmzone.h: clean up watermark accessors
Date: Thu Aug  1 04:50:05 PM PDT 2024

- we have a helper wmark_pages().  Teach min_wmark_pages(),
  low_wmark_pages(), high_wmark_pages() and promo_wmark_pages() to use
  it instead of open-coding its implementation.

- there's no reason to implement all these things as macros.  Redo them
  in C.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kaiyang Zhao <kaiyang2@cs.cmu.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

--- a/include/linux/mmzone.h~include-linux-mmzoneh-clean-up-watermark-accessors
+++ a/include/linux/mmzone.h
@@ -666,12 +666,6 @@ enum zone_watermarks {
 #define NR_LOWORDER_PCP_LISTS (MIGRATE_PCPTYPES * (PAGE_ALLOC_COSTLY_ORDER + 1))
 #define NR_PCP_LISTS (NR_LOWORDER_PCP_LISTS + NR_PCP_THP)
 
-#define min_wmark_pages(z) (z->_watermark[WMARK_MIN] + z->watermark_boost)
-#define low_wmark_pages(z) (z->_watermark[WMARK_LOW] + z->watermark_boost)
-#define high_wmark_pages(z) (z->_watermark[WMARK_HIGH] + z->watermark_boost)
-#define promo_wmark_pages(z) (z->_watermark[WMARK_PROMO] + z->watermark_boost)
-#define wmark_pages(z, i) (z->_watermark[i] + z->watermark_boost)
-
 /*
  * Flags used in pcp->flags field.
  *
@@ -1017,6 +1011,32 @@ enum zone_flags {
 	ZONE_BELOW_HIGH,		/* zone is below high watermark. */
 };
 
+static inline unsigned long wmark_pages(const struct zone *z,
+					enum zone_watermarks w)
+{
+	return z->_watermark[w] + z->watermark_boost;
+}
+
+static inline unsigned long min_wmark_pages(const struct zone *z)
+{
+	return wmark_pages(z, WMARK_MIN);
+}
+
+static inline unsigned long low_wmark_pages(const struct zone *z)
+{
+	return wmark_pages(z, WMARK_LOW);
+}
+
+static inline unsigned long high_wmark_pages(const struct zone *z)
+{
+	return wmark_pages(z, WMARK_HIGH);
+}
+
+static inline unsigned long promo_wmark_pages(const struct zone *z)
+{
+	return wmark_pages(z, WMARK_PROMO);
+}
+
 static inline unsigned long zone_managed_pages(struct zone *zone)
 {
 	return (unsigned long)atomic_long_read(&zone->managed_pages);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-contig_alloc-support-__gfp_comp-fix.patch
selftests-mm-add-more-mseal-traversal-tests-fix.patch
selftests-mm-add-more-mseal-traversal-tests-fix-fix.patch
mm-remove-pageactive-fix.patch
selftests-test_zswap-add-test-for-hierarchical-zswapwriteback-fix.patch
mm-count-the-number-of-anonymous-thps-per-size-fix.patch
mm-memory-failure-add-unmap_poisoned_folio-fix.patch
mm-shmem-extend-shmem_unused_huge_shrink-to-all-sizes-fix.patch
mm-hugetlb-sort-out-global-lock-annotations-fix.patch
mm-hugetlb-sort-out-global-lock-annotations-fix-fix.patch
lib-maple_treec-remove-unused-functions.patch
fault-inject-improve-build-for-config_fault_injection=n-fix.patch
fault-inject-improve-build-for-config_fault_injection=n-fix-2.patch
fault-inject-improve-build-for-config_fault_injection=n-fix-3.patch


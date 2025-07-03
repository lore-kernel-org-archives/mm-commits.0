Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F8BD1885B8
	for <mm-commits@vger.kernel.org>; Thu,  3 Jul 2025 20:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751574598; cv=none; b=jaWjvIMYwh52wqJM6tqOKVtT7ck7gzLSXYuehTD0+SGqJPhggN0ugu8AmHvsmNpSoB7PDmZIZda0HwVRujsLxaMiO7LZlcfXwptnDJWlGyHzXbtXLOX683mCqir+tdhI8m6e8YyhR3GWcPraDWeyiL+y3A4oAGg1F0IFtRdkpz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751574598; c=relaxed/simple;
	bh=HEndZPr9NnigkSb14VBe0ClC+ddB64Hc6GhCLpM62IQ=;
	h=Date:To:From:Subject:Message-Id; b=VCUTyWu9S5mrQWry12On0cVM2iASP7Y2ziCXYtcusLSgeJNV/JO5DBRthgbITAzo+/L9p3i5x8DmpxgMXDjQegKlwi/FkNf0uRjc6dV+IA0HybDLr82d0UHSMQ3OsEB1SC1vfp7hSZRXZrGMY6Hcz4+K7FPwvsRocf8h2+XKxMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LCshpUnp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LCshpUnp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5183C4CEE3;
	Thu,  3 Jul 2025 20:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751574598;
	bh=HEndZPr9NnigkSb14VBe0ClC+ddB64Hc6GhCLpM62IQ=;
	h=Date:To:From:Subject:From;
	b=LCshpUnp0mpcCnWf5NrTpnuwbjBEo2PE/UzEBKGAyAVUMybf+ktUz46WHRKppW0YO
	 JKuAUN3WisnbAwio6Tu6sZtHDaP18YQoTwuKg/tm90LlMdPsraGsf8pEvlOy/VLwV3
	 TX1HqfYcF6hk7/718yLOkYsnopnHavYf/ADWgNsk=
Date: Thu, 03 Jul 2025 13:29:57 -0700
To: mm-commits@vger.kernel.org,ptyadav@amazon.de,osalvador@suse.de,david@redhat.com,alexghiti@rivosinc.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + cma-split-resrvation-of-fixed-area-into-a-helper-function.patch added to mm-new branch
Message-Id: <20250703202957.E5183C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: cma: split resrvation of fixed area into a helper function
has been added to the -mm mm-new branch.  Its filename is
     cma-split-resrvation-of-fixed-area-into-a-helper-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/cma-split-resrvation-of-fixed-area-into-a-helper-function.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: cma: split resrvation of fixed area into a helper function
Date: Thu, 3 Jul 2025 21:47:10 +0300

Move the check that verifies that reservation of fixed area does not cross
HIGHMEM boundary and the actual memblock_resrve() call into a helper
function.

This makes code more readable and decouples logic related to
CONFIG_HIGHMEM from the core functionality of
__cma_declare_contiguous_nid().

Link: https://lkml.kernel.org/r/20250703184711.3485940-3-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Oscar Salvador <osalvador@suse.de>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: Pratyush Yadav <ptyadav@amazon.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |   40 +++++++++++++++++++++++++++-------------
 1 file changed, 27 insertions(+), 13 deletions(-)

--- a/mm/cma.c~cma-split-resrvation-of-fixed-area-into-a-helper-function
+++ a/mm/cma.c
@@ -353,6 +353,30 @@ static void __init list_insert_sorted(
 	}
 }
 
+static int __init cma_fixed_reserve(phys_addr_t base, phys_addr_t size)
+{
+	if (IS_ENABLED(CONFIG_HIGHMEM)) {
+		phys_addr_t highmem_start = __pa(high_memory - 1) + 1;
+
+		/*
+		 * If allocating at a fixed base the request region must not
+		 * cross the low/high memory boundary.
+		 */
+		if (base < highmem_start && base + size > highmem_start) {
+			pr_err("Region at %pa defined on low/high memory boundary (%pa)\n",
+			       &base, &highmem_start);
+			return -EINVAL;
+		}
+	}
+
+	if (memblock_is_region_reserved(base, size) ||
+	    memblock_reserve(base, size) < 0) {
+		return -EBUSY;
+	}
+
+	return 0;
+}
+
 static int __init __cma_declare_contiguous_nid(phys_addr_t *basep,
 			phys_addr_t size, phys_addr_t limit,
 			phys_addr_t alignment, unsigned int order_per_bit,
@@ -408,15 +432,6 @@ static int __init __cma_declare_contiguo
 	if (!IS_ALIGNED(size >> PAGE_SHIFT, 1 << order_per_bit))
 		return -EINVAL;
 
-	/*
-	 * If allocating at a fixed base the request region must not cross the
-	 * low/high memory boundary.
-	 */
-	if (fixed && base < highmem_start && base + size > highmem_start) {
-		pr_err("Region at %pa defined on low/high memory boundary (%pa)\n",
-			&base, &highmem_start);
-		return -EINVAL;
-	}
 
 	/*
 	 * If the limit is unspecified or above the memblock end, its effective
@@ -434,10 +449,9 @@ static int __init __cma_declare_contiguo
 
 	/* Reserve memory */
 	if (fixed) {
-		if (memblock_is_region_reserved(base, size) ||
-		    memblock_reserve(base, size) < 0) {
-			return -EBUSY;
-		}
+		ret = cma_fixed_reserve(base, size);
+		if (ret)
+			return ret;
 	} else {
 		phys_addr_t addr = 0;
 
_

Patches currently in -mm which might be from rppt@kernel.org are

cma-move-__cma_declare_contiguous_nid-before-its-usage.patch
cma-split-resrvation-of-fixed-area-into-a-helper-function.patch
cma-move-memory-allocation-to-a-helper-function.patch


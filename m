Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794336371;
	b=HSAjqRlXI3lYC39bSAMzPow2yULNFgrhLUyhNTAzSXWruiYMfktLHq902HAeHqw7pC8k
	 lF9/fVUakEfTOnhY5pFxCIxGCZ7MzQnHmPX4lavLimLMyhq5mNmMT3YaJngR33wmwPYkS
	 JKrgYVYiZMZxF0LSslulqIiUBUYyy/anDOupSX66dMpJqadghvjn3J6fGy0DtB1vEwlVR
	 myJTW3Ab+v9c4PnV9KAryl+Pj5qJvZoGLNybTU1NSIULPh1UDvmjJUCW1VPxi5EiuH6Fj
	 PrUzaSDXeceeeiKUiYbUEhyoDA2sCjNyWUcKiJjVc7+cRZ465ncGgaYIadV5XuhxLKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794336371;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=2sIgpqexoevo3CDu8Vf4OuWOKB4TRDf/K02nuu284lU=;
	b=OAiplqKUyrOE6UzVKNIteyrKL8PqplCWfRvVKeyFjUrVvMHqBv/7gnb5KjdusLVskjOO
	 hoKluRCLmMwOHlQdF0N1nfFPxCPPtpNuH5RCGWpQLOuSbO4y+xlsMC5C4VYDtIaa/8Wbe
	 ilgeWrJ9CH9uB6vO1AAwW3yijAOrMEWc8VVWiD2eASycxCsoZJGEdSeotXINpf/P2o2KK
	 wnUSflYKeVRaIsOZuhbFX+p9QFPzNy6MGr+TiEYh+a62IoGDRvc4li+q5vh6M2BmKapoH
	 ckCVGbAtUtOOkylLx8omJVO/Yx7hhWXz/OvhQuTJNw7yOv0iAdUHueO7NxZisvQPHnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="Njt/YB+V";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A16A0606B580
	for <mm-commits@vger.kernel.org>; Tue, 10 Nov 2026 18:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Njt/YB+V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 255D91F0089F;
	Tue, 10 Nov 2026 18:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794336370;
	bh=2sIgpqexoevo3CDu8Vf4OuWOKB4TRDf/K02nuu284lU=;
	h=Date:To:From:Subject;
	b=Njt/YB+VxQIdj4PvfebqIUMkHITLXrjpkDccrxwDJTg+Hwt1r76FuXEb0fce9W/Lj
	 c0zBU0XVtTbyh9cMfRsGJ+KXSKxT6m9yg9OU2b4CwLYrUcNcsTDURQav5lkptKyDbx
	 /r/4/cac1Eawn+IjaL7edyHGc2mqZWU20iuBRbEI=
Date: Tue, 10 Nov 2026 10:46:09 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vernon2gm@gmail.com,
	usama.arif@linux.dev,ryan.roberts@arm.com,peterz@infradead.org,
	nico.pache@linux.dev,liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,
	dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,
	baohua@kernel.org,azpijr@gmail.com,ast@kernel.org,ljs@kernel.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-release-contended-mmap-read-lock-after-scanning-enough-vmas.patch added to mm-new branch
Message-Id: <20261110184610.255D91F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/khugepaged: release contended mmap read lock after scanning enough VMAs
has been added to the -mm mm-new branch.  Its filename is
     mm-khugepaged-release-contended-mmap-read-lock-after-scanning-enough-vmas.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-release-contended-mmap-read-lock-after-scanning-enough-vmas.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm/khugepaged: release contended mmap read lock after scanning enough VMAs
Date: Tue, 10 Nov 2026 17:19:13 +0000

khugepaged walks an mm's VMAs under the mmap read lock in
collapse_scan_mm_slot(), checking for ineligible VMAs first, and skipping
them if encountered.

It charges cc->progress 1 page against the /sys/.../pages_to_scan budget
when these are encountered, however only checking this budget once an
eligible PMD-spanning VMA is encountered.

It can therefore hold the mmap read lock for a long time if there are a
large number of ineligible VMAs present in an mm, over which time no mmap
write locks (and thus no VMA write locks) can be acquired.

Address this by checking whether the mmap lock is contended after 1-10
ms (depending on CONFIG_HZ), i.e. the granularity of jiffies. This is a
long time for a lock to be held, so is a reasonable compromise for
determining when best to do this.

Skipping an ineligible VMA costs ~100 ns on tested hardware (x86 server),
so a batch of 1024 bounds the lock hold to ~100 us without expensive
high-grained timer checks.

This scales for large numbers of VMAs, and tests with ~1M ineligible VMAs
reduced the maximum mmap read lock hold time from ~93ms to ~110us.

This was also observed to reduce mmap_lock stalls in concurrent threads of
a similar duration. Note that a reader re-acquiring the lock can currently
steal it from a writer that is queued but not yet running, so the full
benefit to writers depends on the linked rwsem change.

Local measurements indicated no change for ordinary use cases, so this is
all upside.

This work came out of investigations into mmap stalls when getting latency
numbers for an unrelated patch series.

Link: https://lore.kernel.org/20261110-khugepaged-latency-fix-v3-3-6eea743cf9a3@kernel.org
Link: https://lore.kernel.org/all/20261105-rwsem-dont-steal-from-queued-writer-v1-1-275e070f426f@kernel.org/
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Vernon Yang <vernon2gm@gmail.com>
---

 mm/khugepaged.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/mm/khugepaged.c~mm-khugepaged-release-contended-mmap-read-lock-after-scanning-enough-vmas
+++ a/mm/khugepaged.c
@@ -66,6 +66,13 @@ static DEFINE_READ_MOSTLY_HASHTABLE(mm_s
 
 static struct kmem_cache *mm_slot_cache __ro_after_init;
 
+/*
+ * The number of VMAs to walk before checking for, and relieving, mmap lock
+ * contention. This bounds the maximum mmap read lock to an estimated ~100 -
+ * 300us depending on hardware.
+ */
+#define KHUGEPAGED_MAX_VMA_SCAN_BATCH 1024
+
 /**
  * struct khugepaged_mm_slot - khugepaged information per mm that is being scanned
  * @slot: hash lookup from mm to mm_slot
@@ -2933,6 +2940,7 @@ static void collapse_scan_mm_slot(unsign
 	struct mm_struct *mm;
 	struct vm_area_struct *vma;
 	unsigned int progress_prev = cc->progress;
+	unsigned int nr_vmas_batch = 0;
 
 	lockdep_assert_held(&khugepaged_mm_lock);
 	*result = SCAN_FAIL;
@@ -2965,6 +2973,18 @@ static void collapse_scan_mm_slot(unsign
 	for_each_vma(vmi, vma) {
 		unsigned long hstart, hend;
 
+		/* Relieve mmap lock contention after walking a batch of VMAs. */
+		if (nr_vmas_batch++ >= KHUGEPAGED_MAX_VMA_SCAN_BATCH) {
+			nr_vmas_batch = 0;
+			if (mmap_lock_is_contended(mm)) {
+				mmap_read_unlock(mm);
+				cond_resched();
+				mmap_read_lock(mm);
+				vma_iter_set(&vmi, mm_slot->address);
+				continue;
+			}
+		}
+
 		cond_resched();
 		if (unlikely(collapse_test_exit_or_disable(mm))) {
 			cc->progress++;
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vma-predicate-vma_assert_stabilised-on-config_debug_vm.patch
revert-mm-khugepaged-remove-definition-of-struct-khugepaged_mm_slot.patch
mm-khugepaged-scan-mms-more-efficiently-under-mmap_lock-contention.patch
mm-khugepaged-release-contended-mmap-read-lock-after-scanning-enough-vmas.patch


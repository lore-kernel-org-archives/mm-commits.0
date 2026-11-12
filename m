Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794483993;
	b=BT7BkIPjXtHQlZ6y3iOiHVLOMF/u2MsqYG1VsIb+FEw94UAHf5a2eSWHkPpHBYzOr3kI
	 F8XzydOqAqYj12QkgYVfkaYtLcbZM7+njnQY8Z2QyeUzfUsD59nIbTLCjt6dLfgmDlbtg
	 s8ytlRSsChkuMuDPV7D12JjEaH9iMGCHS9HOvGmsni4O9XoEgLn9HSzymMyp6DQ83miws
	 9+MZq94ws4+tuuyon/Qen93SPiDhB84iw+05FXM74hvvdbdMon3Lv2bdxZlbgqPoBE2pW
	 bTSeg1TPt1Nqoscuy/7CNcLFFnEpXvDyctLmI9W9FX9ObGpMeKV8TA7i+g1/rzjaq3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794483993;
	h=Received:DKIM-Signature:Date:To:Cc:From:Subject:Message-Id;
	bh=ZFrhahr9MyfIHxEzefZDuXQaUFKXSQeWwqsZHAEKNzg=;
	b=GRbnFGxyaZmZlieJwLHkcqRaCXlH6yLQ+vAWhIgITyKq9FmhZ6onLUAooza7rntwFnCK
	 z1hd7IR6RU8hj1WygJ5NlMJGCmTaz+hRTKp00kNT2HQjrU4iIgL+KmrIGcYuLzHT/rmpd
	 U7sPcp3IMUyZKEcE8PxayOYfHQ8HEJmPD2Lz5kZuO05rA4fOxo7cWbyMV5CoVXTUuncbn
	 mPSO+WECwwrqVJ5HjS+iTkAgWAlubvGBXdxFQuT0f6vLFUAym1xrqhs7nPgllsK7WhKFh
	 oJziP9YDNtS1ALB/3KqhHW2TfTg4+pbqUAIXDH2XFSjTWEnssFW/zSx56pFqkn3510g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="bII0t/9d";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58173606A321
	for <mm-commits@vger.kernel.org>; Thu, 12 Nov 2026 11:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=bII0t/9d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A41A1F00A05;
	Thu, 12 Nov 2026 11:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794483993;
	bh=ZFrhahr9MyfIHxEzefZDuXQaUFKXSQeWwqsZHAEKNzg=;
	h=Date:To:Cc:From:Subject;
	b=bII0t/9dyauLxIYqPourQdfNZeIP3YgwTztPzit5kwToegWuteesqV1rMC8MqRXU5
	 8u+peXETLiJoej7B0nF2+ipILGcsTzds024//FHVoxkVKZqBX7OUs0jUt1XPGUPHGn
	 6EuOgTdUz7U/M2pAwF9g1KR5YAq40MThu7ja9Py4=
Date: Thu, 12 Nov 2026 03:46:32 -0800
To: mm-commits@vger.kernel.org, ljs@kernel.org, akpm@linux-foundation.org
Cc: David Hildenbrand <david@kernel.org>
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-khugepaged-release-contended-mmap-read-lock-after-scanning-enough-vmas.patch removed from -mm tree
Message-Id: <20261112114633.1A41A1F00A05@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/khugepaged: release contended mmap read lock after scanning enough VMAs
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-release-contended-mmap-read-lock-after-scanning-enough-vmas.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Address this by checking whether the mmap lock is contended after 1024
VMAs scanned.  This was measured to take around ~100 us on a fast
machine, and given VMA eligibility checking is a light operation, it is
likely this will remain at the same order of magnitude for slower
machines.

This therefore establishes a reasonable upper bound on how long a
contended mmap lock is held.

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
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
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

maintainers-remove-myself-from-mm-core-reviewership.patch
maintainers-remove-myself-from-mm-misc-reclaim-reviewership.patch
maintainers-remove-myself-from-mm-rust-reviewerships.patch
credits-add-entry-for-thp-maintenance.patch
mm-vma-predicate-vma_assert_stabilised-on-config_debug_vm.patch
mm-only-assert-mmap-locks-if-config_debug_vm-or-lockdep-is-set.patch
mm-only-assert-vma-locks-if-config_debug_vm-is-set.patch
mm-convert-warn_on_onces-to-vm_warn_on_once-in-vma-lock-code.patch


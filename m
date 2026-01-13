Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F74C3595D
	for <mm-commits@vger.kernel.org>; Tue, 13 Jan 2026 05:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768280967; cv=none; b=acSls6XdJ1TwEtf4bzS2t5O+XVSIWY4ksXm3OLUZ8TjB+3xCgcQ5ARY94Kwrv/AqcNF5+dfrdwszYQBuCxGfXKE5SZtdnrA4x2EAHjYJSMHaahrUo156BB/MTjUg2Ljx5E63JzlXX2cLKqz1QN1whmMG5VEb0eyFZdkmo0pJqhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768280967; c=relaxed/simple;
	bh=sBx1DTFjJNkQIzJi1fPsRnFu5FJQMHtDK1HxfVX8xkQ=;
	h=Date:To:From:Subject:Message-Id; b=tuOnYJQx/y4Ozx4vblpch9CKjVfARkB7ejOxxh2jIFfhwQMFcVXrwoDJbaDHVzhNtzaP1+YhUrASf4rQsiwj5IwDBcPQ7ZZY8Dv2MA9S9NzvOJuzHBPVx/F2vyXSbPwFZcIgqg7zXTQhBFJJC4liX1EQ7e+YToNfhlp7h2iDEbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NAld+fu8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NAld+fu8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B440C116C6;
	Tue, 13 Jan 2026 05:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768280967;
	bh=sBx1DTFjJNkQIzJi1fPsRnFu5FJQMHtDK1HxfVX8xkQ=;
	h=Date:To:From:Subject:From;
	b=NAld+fu8TrfpML5MVlMwX4pCsrmzifQgYXg/wK49A8MXmxynbpGEMHMoWsmhgwI4J
	 skI0W6MYIcQBxF5dBqsEKEqLFD5eNsQJ7tDCy2arOL54NeKtnenfsC9agRCys8zggn
	 GALa9/rInm1lkCWjou5+YaTwgjRbLa6nQt400WCQ=
Date: Mon, 12 Jan 2026 21:09:26 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,ricardo.neri-calderon@linux.intel.com,pratyush@kernel.org,graf@amazon.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kho-validate-preserved-memory-map-during-population.patch removed from -mm tree
Message-Id: <20260113050927.0B440C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho: validate preserved memory map during population
has been removed from the -mm tree.  Its filename was
     kho-validate-preserved-memory-map-during-population.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: kho: validate preserved memory map during population
Date: Tue, 23 Dec 2025 09:01:40 -0500

If the previous kernel enabled KHO but did not call kho_finalize() (e.g.,
CONFIG_LIVEUPDATE=n or userspace skipped the finalization step), the
'preserved-memory-map' property in the FDT remains empty/zero.

Previously, kho_populate() would succeed regardless of the memory map's
state, reserving the incoming scratch regions in memblock.  However,
kho_memory_init() would later fail to deserialize the empty map.  By that
time, the scratch regions were already registered, leading to partial
initialization and subsequent list corruption (freeing scratch area twice)
during kho_init().

Move the validation of the preserved memory map earlier into
kho_populate(). If the memory map is empty/NULL:
1. Abort kho_populate() immediately with -ENOENT.
2. Do not register or reserve the incoming scratch memory, allowing the new
   kernel to reclaim those pages as standard free memory.
3. Leave the global 'kho_in' state uninitialized.

Consequently, kho_memory_init() sees no active KHO context
(kho_in.mem_chunks_phys is 0) and falls back to kho_reserve_scratch(),
allocating fresh scratch memory as if it were a standard cold boot.

Link: https://lkml.kernel.org/r/20251223140140.2090337-1-pasha.tatashin@soleen.com
Fixes: de51999e687c ("kho: allow memory preservation state updates after finalization")
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reported-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Closes: https://lore.kernel.org/all/20251218215613.GA17304@ranerica-svr.sc.intel.com
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/kexec_handover.c |   37 +++++++++++++--------------
 1 file changed, 19 insertions(+), 18 deletions(-)

--- a/kernel/liveupdate/kexec_handover.c~kho-validate-preserved-memory-map-during-population
+++ a/kernel/liveupdate/kexec_handover.c
@@ -460,27 +460,23 @@ static void __init deserialize_bitmap(un
 	}
 }
 
-/* Return true if memory was deserizlied */
-static bool __init kho_mem_deserialize(const void *fdt)
+/* Returns physical address of the preserved memory map from FDT */
+static phys_addr_t __init kho_get_mem_map_phys(const void *fdt)
 {
-	struct khoser_mem_chunk *chunk;
 	const void *mem_ptr;
-	u64 mem;
 	int len;
 
 	mem_ptr = fdt_getprop(fdt, 0, PROP_PRESERVED_MEMORY_MAP, &len);
 	if (!mem_ptr || len != sizeof(u64)) {
 		pr_err("failed to get preserved memory bitmaps\n");
-		return false;
+		return 0;
 	}
 
-	mem = get_unaligned((const u64 *)mem_ptr);
-	chunk = mem ? phys_to_virt(mem) : NULL;
-
-	/* No preserved physical pages were passed, no deserialization */
-	if (!chunk)
-		return false;
+	return get_unaligned((const u64 *)mem_ptr);
+}
 
+static void __init kho_mem_deserialize(struct khoser_mem_chunk *chunk)
+{
 	while (chunk) {
 		unsigned int i;
 
@@ -489,8 +485,6 @@ static bool __init kho_mem_deserialize(c
 					   &chunk->bitmaps[i]);
 		chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
 	}
-
-	return true;
 }
 
 /*
@@ -1253,6 +1247,7 @@ bool kho_finalized(void)
 struct kho_in {
 	phys_addr_t fdt_phys;
 	phys_addr_t scratch_phys;
+	phys_addr_t mem_map_phys;
 	struct kho_debugfs dbg;
 };
 
@@ -1434,12 +1429,10 @@ static void __init kho_release_scratch(v
 
 void __init kho_memory_init(void)
 {
-	if (kho_in.scratch_phys) {
+	if (kho_in.mem_map_phys) {
 		kho_scratch = phys_to_virt(kho_in.scratch_phys);
 		kho_release_scratch();
-
-		if (!kho_mem_deserialize(kho_get_fdt()))
-			kho_in.fdt_phys = 0;
+		kho_mem_deserialize(phys_to_virt(kho_in.mem_map_phys));
 	} else {
 		kho_reserve_scratch();
 	}
@@ -1448,8 +1441,9 @@ void __init kho_memory_init(void)
 void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 			 phys_addr_t scratch_phys, u64 scratch_len)
 {
-	void *fdt = NULL;
 	struct kho_scratch *scratch = NULL;
+	phys_addr_t mem_map_phys;
+	void *fdt = NULL;
 	int err = 0;
 	unsigned int scratch_cnt = scratch_len / sizeof(*kho_scratch);
 
@@ -1475,6 +1469,12 @@ void __init kho_populate(phys_addr_t fdt
 		goto out;
 	}
 
+	mem_map_phys = kho_get_mem_map_phys(fdt);
+	if (!mem_map_phys) {
+		err = -ENOENT;
+		goto out;
+	}
+
 	scratch = early_memremap(scratch_phys, scratch_len);
 	if (!scratch) {
 		pr_warn("setup: failed to memremap scratch (phys=0x%llx, len=%lld)\n",
@@ -1515,6 +1515,7 @@ void __init kho_populate(phys_addr_t fdt
 
 	kho_in.fdt_phys = fdt_phys;
 	kho_in.scratch_phys = scratch_phys;
+	kho_in.mem_map_phys = mem_map_phys;
 	kho_scratch_cnt = scratch_cnt;
 	pr_info("found kexec handover data.\n");
 
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

list-add-primitives-for-private-list-manipulations.patch
list-add-kunit-test-for-private-list-primitives.patch
liveupdate-luo_file-use-private-list.patch
liveupdate-luo_flb-introduce-file-lifecycle-bound-global-state.patch
tests-liveupdate-add-in-kernel-liveupdate-test.patch
liveupdate-separate-memfd-support-into-liveupdate_memfd.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EE8A9460
	for <mm-commits@vger.kernel.org>; Sun, 16 Aug 2026 04:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786853570; cv=none; b=sizlkmBfvY95RuNAkX9oKPr5b226wlTTTR/az/nOvRbiTYvooKHkKWMCO61sThCo4OdqBAn9HkWiM1D+I7Gxs82vBse9EX6xRfsZt2UVNHFhVln4w6gQZFAPGeoFTBVHR6wa2pHqNRvFgLhlr/MMPKBlZbB7ZTEMDXDfouErf5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786853570; c=relaxed/simple;
	bh=sT5Rzqk2+tQo6eBMHeHr5o8ZUR6m2czkyF/YeP4B86s=;
	h=Date:To:From:Subject:Message-Id; b=N0rMMmbNN3Aso3ryUaE8RBDOWg5kpD3NSEDm5fOXKewoyK+KF5cx5ogukW0TM4uDVI2nvQvIYQvcKIOsLVspebVl2pJTBfSir0xGuIecY72c3KA3sqG5bMBSW+uULJAg/o1YTD1xNm6yFqwWGwgRhxFVZY7T/Zs8pNXgr4Wh5f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u4/9dnv2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u4/9dnv2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9A801F000E9;
	Sun, 16 Aug 2026 04:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786853569;
	bh=1NOQ7joh8UV2RL8i61czk28cIUnPUiVHBF+JL2vvbYo=;
	h=Date:To:From:Subject;
	b=u4/9dnv2Or/wD99z6wj29pSATrKs/f3Jbm+YUbrLjzJTnbMZVdKltDmdygAS6t1nz
	 daPPsMvFUqDUuhWYlV2266feym8PEYBO3nz7wPOFA0F8yRBmZcoe5EPrDdMSd1OF9z
	 LktgzVb3WdUdY3r3SlgwSLx1QcPDRoZMRzkXSj6Y=
Date: Sat, 15 Aug 2026 21:12:48 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,sarthak.sharma@arm.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-thuge-gen-fix-test_shmget-for-page_size-check.patch removed from -mm tree
Message-Id: <20260816041248.D9A801F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: thuge-gen: fix test_shmget() for PAGE_SIZE check
has been removed from the -mm tree.  Its filename was
     selftests-mm-thuge-gen-fix-test_shmget-for-page_size-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: selftests/mm: thuge-gen: fix test_shmget() for PAGE_SIZE check
Date: Wed, 12 Aug 2026 11:17:40 +0300

Commit 49a4e7186b08 ("selftests/mm: thuge-gen: add setup of HugeTLB
pages") changed thuge-gen test to use common functions for reading hugetlb
attributes from sysfs, but it missed that the original read_free()
function special cased PAGE_SIZE tests.

For PAGE_SIZE tests, failure to read sysfs was ignored and read_free()
returned 0.

This allowed test_shmget() to essentially skip the check of how many huge
pages was consumed when it ran with PAGE_SIZE.

Commit 3199b0c09efa ("selftests/mm: fix read_file() return value check")
fixed checks for read_file() return value and this exposed the issue in
test_shmget() that checks the number of free hugetlb pages even for
PAGE_SIZE test, tries to access

/sys/kernel/mm/hugepages/hugepages-<PAGE_SIZE>/free_hugepages

and obviously fails there.

Gate the checks for free huge pages on size != getpagesize() and
initialize before and after variables to values matching PAGE_SIZE test.

Link: https://lore.kernel.org/20260812-selftests-thuge-gen-fix-v2-1-9adaa693e73b@kernel.org
Fixes: 49a4e7186b08 ("selftests/mm: thuge-gen: add setup of HugeTLB pages")
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/thuge-gen.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/mm/thuge-gen.c~selftests-mm-thuge-gen-fix-test_shmget-for-page_size-check
+++ a/tools/testing/selftests/mm/thuge-gen.c
@@ -71,12 +71,16 @@ void test_mmap(unsigned long size, unsig
 
 void test_shmget(unsigned long size, unsigned flags)
 {
-	int id;
-	unsigned long before, after;
+	/* values for PAGE_SIZE test */
+	unsigned long before = NUM_PAGES;
+	unsigned long after = 0;
 	struct shm_info i;
 	char *map;
+	int id;
+
+	if (size != getpagesize())
+		before = hugetlb_free_pages(size);
 
-	before = hugetlb_free_pages(size);
 	id = shmget(IPC_PRIVATE, size * NUM_PAGES, IPC_CREAT|0600|flags);
 	if (id < 0) {
 		if (errno == EPERM) {
@@ -97,10 +101,11 @@ void test_shmget(unsigned long size, uns
 	shmctl(id, IPC_RMID, NULL);
 
 	memset(map, 0xff, size*NUM_PAGES);
-	after = hugetlb_free_pages(size);
+	if (size != getpagesize())
+		after = hugetlb_free_pages(size);
 
 	show(size);
-	ksft_test_result(size == getpagesize() || (before - after) == NUM_PAGES,
+	ksft_test_result((before - after) == NUM_PAGES,
 			 "%s: mmap %lu %x\n", __func__, size, flags);
 	if (shmdt(map))
 		ksft_exit_fail_msg("%s: shmdt: %s\n", __func__, strerror(errno));
_

Patches currently in -mm which might be from rppt@kernel.org are

drivers-base-mm-move-arch_numac-to-mm.patch
sh-remove-config_numa-and-realted-configuration-options.patch
sh-mm-remove-numac.patch
sh-mm-drop-allocate_pgdat.patch
sh-remove-setup_bootmem_node-and-plat_mem_setup.patch
sh-drop-dead-code-guarded-by-ifdef-config_numa.patch
sh-drop-include-asm-mmzoneh.patch
init-kconfig-drop-arch_want_numa_variable_locality.patch
sh-init-remove-call-the-memblock_set_node.patch
sh-remove-sparsemem-related-entries-from-kconfig.patch
sh-drop-include-asm-sparsememh.patch


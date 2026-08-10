Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED2FD2857CC
	for <mm-commits@vger.kernel.org>; Mon, 10 Aug 2026 22:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786401075; cv=none; b=na2boTTA6JWDXxB5iDICN+pLw+FvBGOAr2Fb5LGuF4ls+7/JxJOrJREc/i890O9zQaWiP+WUaRFmP46kT6GIQjP1Q5ZEFn6VnSbq5U67t5T04UdQEgNxsALp1cV71XRfc8PnVIYwPdV/BjP19TXLlSpMEkiWLedz7dXmRJzmrk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786401075; c=relaxed/simple;
	bh=D3kkICppU7VX+uz5+evarAyF1sWpeBp9XLMbbLQiPOQ=;
	h=Date:To:From:Subject:Message-Id; b=ux2TlpbUFFyBm+O4jEwJrBdXrFWa9EnX7euhLjwSqctsBncjTP6mRMpyYmaxgw1r3ixB1b8jdcyGeUZfh3eX1Il00r/w2s4TBO9MjpzgXz0BQPXs7WDJomE3KGs6MDU1/Ca/IPc4r6pKCFa2rIMECn3ZaVBWxaqBtfd1K4bbW5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xwF7MIzU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xwF7MIzU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CA551F000E9;
	Mon, 10 Aug 2026 22:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786401073;
	bh=foGbRcDUxlFyN8xFtnXOvi3HsBVGfGVYKSKV6rlwqzQ=;
	h=Date:To:From:Subject;
	b=xwF7MIzUMPHzI0GDT7Jiv+j9syywB6hqBMgt1NLlAjFg2ZLA5EPsPctBlK9Xa3+L+
	 49zLDRKD8Ts9JP7zGvwb6mF+CsgYqyWTv6QVxtGzR1xG4EtdkiUyQp6gG/a04/dHI5
	 UzWFFUng0au0Zj33kUbIx6xkVk5i5hbS63qt8Qd4=
Date: Mon, 10 Aug 2026 15:31:13 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-thuge-gen-fix-test_shmget-for-page_size-check.patch added to mm-unstable branch
Message-Id: <20260810223113.7CA551F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: thuge-gen: fix test_shmget() for PAGE_SIZE check
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-thuge-gen-fix-test_shmget-for-page_size-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-thuge-gen-fix-test_shmget-for-page_size-check.patch

This patch will later appear in the mm-unstable branch at
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
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: selftests/mm: thuge-gen: fix test_shmget() for PAGE_SIZE check
Date: Sun, 09 Aug 2026 11:03:35 +0300

Commit 49a4e7186b08 ("selftests/mm: thuge-gen: add setup of HugeTLB
pages") changed thuge-gen test to use common functions for reading hugetlb
attributes from sysfs, but it missed that the original read_free()
function special cased PAGE_SIZE tests.

For PAGE_SIZE tests, failure to read sysfs was ignored and read_free()
returned 0.

This allowed test_shmget() to essentially skip the check of how many huge
pages was consumed when it ran with PAGE_SIZE.

Commit 3199b0c09efa ("selftests/mm: fix read_file() return value check")
fixed the common read_file() to actually return error on failure and this
exposed the issue in test_shmget() that checks the number of free hugetlb
pages even for PAGE_SIZE test, tries to access

/sys/kernel/mm/hugepages/hugepages-<PAGE_SIZE>/free_hugepages

and obviously fails there.

Gate the checks for free huge pages on size != getpagesize() and
initialize before and after variables to values matching PAGE_SIZE test.

Link: https://lore.kernel.org/20260809-selftests-thuge-gen-fix-v1-1-1919f4b3d12f@kernel.org
Fixes: 49a4e7186b08 ("selftests/mm: thuge-gen: add setup of HugeTLB pages")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
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

selftests-mm-thuge-gen-fix-test_shmget-for-page_size-check.patch
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


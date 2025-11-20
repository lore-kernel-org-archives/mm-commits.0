Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D2C12E2F1F
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 21:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763675117; cv=none; b=rHmyFOxBmZ5WkAGuoOLz6fMKv2keP1CW76rcNU12IJoGoTOHQIY5uAKWeDezMP0dlXsJd0inzkBrtAns1OcP4OpgkYKu60WgsuuaOFWVkAL/GIm6OuXMtFOI8z8wety4sQ1KRVteZgco6QGWR2UyE3Srg1n5t+GthZTVc233dTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763675117; c=relaxed/simple;
	bh=iDK4tRoYRezOsPhQJXsyW1vP05tIRb/Po+RQBfi0ao8=;
	h=Date:To:From:Subject:Message-Id; b=aciShn7dwxRA7IZh2LajR3pZR/KfZuWKz5Xy73G3U7j8ShfBB3dDVKSNu80UUzcGXOGJUVtc4dg+f9c3ZiEOgkfRDROmx4fFCJ9TL6f2+J+9p55rnU+YgTwotQV/+t1NZlzr2SlD8U5XzDc1hdRMtp18xdFrZGrSfpYMLYMaAjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mPovaGxp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mPovaGxp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0EF4C4CEF1;
	Thu, 20 Nov 2025 21:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763675117;
	bh=iDK4tRoYRezOsPhQJXsyW1vP05tIRb/Po+RQBfi0ao8=;
	h=Date:To:From:Subject:From;
	b=mPovaGxpVEghoQqQBX/T2wcJroBp/RCjr2ilKKh/G16k6uaJmnMsYcT3KzukFGwh/
	 CxfveSIu/s/wcgnkxCI7Nmee81AifI/MM2+3S5YF6hjA5qhNKmKqKUuNo1iVrTrRxL
	 D6/wex1Ws0f0/xHsAj5dklvvLsr+PrhQqFPSuZZ0=
Date: Thu, 20 Nov 2025 13:45:16 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,peterx@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,david.hunter.linux@gmail.com,mehdi.benhadjkhelifa@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-uffd-remove-static-address-usage-in-shmem_allocate_area.patch removed from -mm tree
Message-Id: <20251120214516.E0EF4C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm/uffd: remove static address usage in shmem_allocate_area()
has been removed from the -mm tree.  Its filename was
     selftests-mm-uffd-remove-static-address-usage-in-shmem_allocate_area.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mehdi Ben Hadj Khelifa <mehdi.benhadjkhelifa@gmail.com>
Subject: selftests/mm/uffd: remove static address usage in shmem_allocate_area()
Date: Tue, 11 Nov 2025 21:54:27 +0100

The current shmem_allocate_area() implementation uses a hardcoded virtual
base address (BASE_PMD_ADDR) as a hint for mmap() when creating
shmem-backed test areas.  This approach is fragile and may fail on systems
with ASLR or different virtual memory layouts, where the chosen address is
unavailable.

Replace the static base address with a dynamically reserved address range
obtained via mmap(NULL, ..., PROT_NONE).  The memfd-backed areas and their
alias are then mapped into that reserved region using MAP_FIXED,
preserving the original layout and aliasing semantics while avoiding
collisions with unrelated mappings.

This change improves robustness and portability of the test suite without
altering its behavior or coverage.

[mehdi.benhadjkhelifa@gmail.com: make cleanup code more clear, per Mike]
  Link: https://lkml.kernel.org/r/20251113142050.108638-1-mehdi.benhadjkhelifa@gmail.com
Link: https://lkml.kernel.org/r/20251111205739.420009-1-mehdi.benhadjkhelifa@gmail.com
Signed-off-by: Mehdi Ben Hadj Khelifa <mehdi.benhadjkhelifa@gmail.com>
Suggested-by: Mike Rapoport <rppt@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Hunter <david.hunter.linux@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-common.c |   24 +++++++++++++--------
 1 file changed, 15 insertions(+), 9 deletions(-)

--- a/tools/testing/selftests/mm/uffd-common.c~selftests-mm-uffd-remove-static-address-usage-in-shmem_allocate_area
+++ a/tools/testing/selftests/mm/uffd-common.c
@@ -10,7 +10,6 @@
 uffd_test_ops_t *uffd_test_ops;
 uffd_test_case_ops_t *uffd_test_case_ops;
 
-#define BASE_PMD_ADDR ((void *)(1UL << 30))
 
 /* pthread_mutex_t starts at page offset 0 */
 pthread_mutex_t *area_mutex(char *area, unsigned long nr, uffd_global_test_opts_t *gopts)
@@ -142,30 +141,37 @@ static int shmem_allocate_area(uffd_glob
 	unsigned long offset = is_src ? 0 : bytes;
 	char *p = NULL, *p_alias = NULL;
 	int mem_fd = uffd_mem_fd_create(bytes * 2, false);
+	size_t region_size = bytes * 2 + hpage_size;
 
-	/* TODO: clean this up.  Use a static addr is ugly */
-	p = BASE_PMD_ADDR;
-	if (!is_src)
-		/* src map + alias + interleaved hpages */
-		p += 2 * (bytes + hpage_size);
+	void *reserve = mmap(NULL, region_size, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS,
+			-1, 0);
+	if (reserve == MAP_FAILED) {
+		close(mem_fd);
+		return -errno;
+	}
+
+	p = reserve;
 	p_alias = p;
 	p_alias += bytes;
 	p_alias += hpage_size;  /* Prevent src/dst VMA merge */
 
-	*alloc_area = mmap(p, bytes, PROT_READ | PROT_WRITE, MAP_SHARED,
+	*alloc_area = mmap(p, bytes, PROT_READ | PROT_WRITE, MAP_FIXED | MAP_SHARED,
 			   mem_fd, offset);
 	if (*alloc_area == MAP_FAILED) {
 		*alloc_area = NULL;
+		munmap(reserve, region_size);
+		close(mem_fd);
 		return -errno;
 	}
 	if (*alloc_area != p)
 		err("mmap of memfd failed at %p", p);
 
-	area_alias = mmap(p_alias, bytes, PROT_READ | PROT_WRITE, MAP_SHARED,
+	area_alias = mmap(p_alias, bytes, PROT_READ | PROT_WRITE, MAP_FIXED | MAP_SHARED,
 			  mem_fd, offset);
 	if (area_alias == MAP_FAILED) {
-		munmap(*alloc_area, bytes);
 		*alloc_area = NULL;
+		munmap(reserve, region_size);
+		close(mem_fd);
 		return -errno;
 	}
 	if (area_alias != p_alias)
_

Patches currently in -mm which might be from mehdi.benhadjkhelifa@gmail.com are



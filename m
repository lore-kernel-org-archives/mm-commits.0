Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE7035CBD5
	for <mm-commits@vger.kernel.org>; Tue, 11 Nov 2025 21:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762895420; cv=none; b=XH2/Ofvzs3W0EimQhBgb4N7+OSv0OaZBVs2NimUdS0oB9EWURw/zVo6Mtkr9GWNLZXrVLujrKLeHVZOwu0CKchSfS6tY2tJZ9n60C06Ibz8uiVK3q7hpJrIp0JbUvNgSjdpNe1RuItglCnU9pRnNrkajoocHGeBeoEfb8J8IbTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762895420; c=relaxed/simple;
	bh=WiwW1H5hMnkHHfxGEHT6BykdRQGgWtqKQCC6pHiJv44=;
	h=Date:To:From:Subject:Message-Id; b=EpgJ6C8VZvb+NNwt8cjNdvLERp+PVIsqSsjwDFooi7svl3gaMOFKHeUM7+PA5N8voQIgxlaXn4VpuDPddYX9q7P5+KJWjBIm5v+aWG2oYECf9HsiI8xndEXU/Dxh2p1R0fQSpnlWFn96+O9FfoEvIOHynCOawuX8mNldYlfe7xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IY8ox6tc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IY8ox6tc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55FF3C4CEF7;
	Tue, 11 Nov 2025 21:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762895420;
	bh=WiwW1H5hMnkHHfxGEHT6BykdRQGgWtqKQCC6pHiJv44=;
	h=Date:To:From:Subject:From;
	b=IY8ox6tcxnFo8ZKSQ25XFVC1eBTafpCV/tOzvJcsi4m1+xHR+LDD+TEZnlVmM7V3F
	 FRtGFiX7ztEbX1MKs3FI9PluxeyBHDDmu8y7XyuAdlZBLcEZxpi0QD6fXS2zn9T5o9
	 ZUb2xTYz4vytD43coEJGiu7GXI8j1dntTCGYG150=
Date: Tue, 11 Nov 2025 13:10:19 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,peterx@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,david.hunter.linux@gmail.com,mehdi.benhadjkhelifa@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-uffd-remove-static-address-usage-in-shmem_allocate_area.patch added to mm-new branch
Message-Id: <20251111211020.55FF3C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm/uffd: remove static address usage in shmem_allocate_area()
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-uffd-remove-static-address-usage-in-shmem_allocate_area.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-uffd-remove-static-address-usage-in-shmem_allocate_area.patch

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
From: Mehdi Ben Hadj Khelifa <mehdi.benhadjkhelifa@gmail.com>
Subject: selftests/mm/uffd: remove static address usage in shmem_allocate_area()
Date: Tue, 11 Nov 2025 21:54:27 +0100

The current shmem_allocate_area() implementation uses a hardcoded virtual
base address(BASE_PMD_ADDR) as a hint for mmap() when creating
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

Link: https://lkml.kernel.org/r/20251111205739.420009-1-mehdi.benhadjkhelifa@gmail.com
Signed-off-by: Mehdi Ben Hadj Khelifa <mehdi.benhadjkhelifa@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Hunter <david.hunter.linux@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-common.c |   25 +++++++++++++--------
 1 file changed, 16 insertions(+), 9 deletions(-)

--- a/tools/testing/selftests/mm/uffd-common.c~selftests-mm-uffd-remove-static-address-usage-in-shmem_allocate_area
+++ a/tools/testing/selftests/mm/uffd-common.c
@@ -6,11 +6,11 @@
  */
 
 #include "uffd-common.h"
+#include "asm-generic/mman-common.h"
 
 uffd_test_ops_t *uffd_test_ops;
 uffd_test_case_ops_t *uffd_test_case_ops;
 
-#define BASE_PMD_ADDR ((void *)(1UL << 30))
 
 /* pthread_mutex_t starts at page offset 0 */
 pthread_mutex_t *area_mutex(char *area, unsigned long nr, uffd_global_test_opts_t *gopts)
@@ -142,30 +142,37 @@ static int shmem_allocate_area(uffd_glob
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
+	p = (char *)reserve;
 	p_alias = p;
 	p_alias += bytes;
 	p_alias += hpage_size;  /* Prevent src/dst VMA merge */
 
-	*alloc_area = mmap(p, bytes, PROT_READ | PROT_WRITE, MAP_SHARED,
+	*alloc_area = mmap(p, bytes, PROT_READ | PROT_WRITE, MAP_FIXED | MAP_SHARED,
 			   mem_fd, offset);
 	if (*alloc_area == MAP_FAILED) {
+		munmap(reserve, region_size);
 		*alloc_area = NULL;
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
+		munmap(reserve, region_size);
 		*alloc_area = NULL;
+		close(mem_fd);
 		return -errno;
 	}
 	if (area_alias != p_alias)
_

Patches currently in -mm which might be from mehdi.benhadjkhelifa@gmail.com are

mm-vmalloc-use-kmalloc_array-instead-of-kmalloc.patch
selftests-mm-uffd-remove-static-address-usage-in-shmem_allocate_area.patch


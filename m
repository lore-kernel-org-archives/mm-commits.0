Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C7A0370AC5
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067192; cv=none; b=NTlSat7kQsFyoMsEjcNUt+p4+acMhBi03jUORnVM9hyt/28mLxK5Uueo7dodLPunfEejMzRgbkn5uXHfaoQ2c+gmAgyPp+jVb/+zIFamY5loI0NPcEnglRUkkFIiMWyYmSiIN1esYL9CoUnYH4s7PT8MIakPXNC6DVAUKTnZpWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067192; c=relaxed/simple;
	bh=sYvc/G0glTqAomq4xALn36W4DfLHCuNdOuG2LB1ndfQ=;
	h=Date:To:From:Subject:Message-Id; b=gGZR892H7uLS0uuOBtrzUv3ec/4MLL1StkeKGm2D79hDAs9NrG4RHdDTMir4AcBMr71U2zhXugBribBDhFjTpOpDyz7H+pO9b4/t7Q9VlpbXwaz5IrLBEiQzhf9cKOHdyZa//dNKKNmrbia4M74x1JjxqRDi8+zvjOph6ICbLsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BectTQvd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BectTQvd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70B831F000E9;
	Sun, 21 Jun 2026 18:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067191;
	bh=wrnHe/al5HpnIZoOTgS+BgPoBHYx1N/evAROwbCV+F4=;
	h=Date:To:From:Subject;
	b=BectTQvdn1rZjOpaVffOT9wmYF6+jaDnrN4liiZqmHUUj0oyicVWA6tzVq8dhL6zU
	 u0pCDu1eioU5sxBhwtpCrnj46V+PubLfBrzeICY8EVA4PSe3ddY+zDz1o+a8M/DrvF
	 K3nYpErhFETsaqZLTbZzRqkFAotI51+4mo9OxNpY=
Date: Sun, 21 Jun 2026 11:39:51 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,dev.jain@arm.com,david@kernel.org,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-fix-incorrect-mmap-error-handling-with-null-instead-of-map_failed.patch removed from -mm tree
Message-Id: <20260621183951.70B831F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: fix incorrect mmap() error handling with NULL instead of MAP_FAILED
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-incorrect-mmap-error-handling-with-null-instead-of-map_failed.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hongfu Li <lihongfu@kylinos.cn>
Subject: selftests/mm: fix incorrect mmap() error handling with NULL instead of MAP_FAILED
Date: Wed, 13 May 2026 10:52:23 +0800

mmap() returns MAP_FAILED, which is defined as (void *)-1, on error, not
NULL.  Several selftests incorrectly check the return value of mmap()
using !ptr or ptr == NULL, which would erroneously treat MAP_FAILED as a
valid pointer since MAP_FAILED is non-zero and non-NULL.  This can lead to
segfaults when mmap() actually fails under memory pressure.

Link: https://lore.kernel.org/20260513025223.592766-1-lihongfu@kylinos.cn
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/ksm_tests.c     |    2 +-
 tools/testing/selftests/mm/madv_populate.c |    2 +-
 tools/testing/selftests/mm/soft-dirty.c    |    4 ++--
 tools/testing/selftests/mm/vm_util.c       |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/mm/ksm_tests.c~selftests-mm-fix-incorrect-mmap-error-handling-with-null-instead-of-map_failed
+++ a/tools/testing/selftests/mm/ksm_tests.c
@@ -174,7 +174,7 @@ static void  *allocate_memory(void *ptr,
 {
 	void *map_ptr = mmap(ptr, map_size, PROT_WRITE, mapping, -1, 0);
 
-	if (!map_ptr) {
+	if (map_ptr == MAP_FAILED) {
 		ksft_perror("mmap");
 		return NULL;
 	}
--- a/tools/testing/selftests/mm/madv_populate.c~selftests-mm-fix-incorrect-mmap-error-handling-with-null-instead-of-map_failed
+++ a/tools/testing/selftests/mm/madv_populate.c
@@ -34,7 +34,7 @@ static void sense_support(void)
 
 	addr = mmap(0, pagesize, PROT_READ | PROT_WRITE,
 		    MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
-	if (!addr)
+	if (addr == MAP_FAILED)
 		ksft_exit_fail_msg("mmap failed\n");
 
 	ret = madvise(addr, pagesize, MADV_POPULATE_READ);
--- a/tools/testing/selftests/mm/soft-dirty.c~selftests-mm-fix-incorrect-mmap-error-handling-with-null-instead-of-map_failed
+++ a/tools/testing/selftests/mm/soft-dirty.c
@@ -143,7 +143,7 @@ static void test_mprotect(int pagemap_fd
 	if (anon) {
 		map = mmap(NULL, pagesize, PROT_READ|PROT_WRITE,
 			   MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
-		if (!map)
+		if (map == MAP_FAILED)
 			ksft_exit_fail_msg("anon mmap failed\n");
 	} else {
 		test_fd = open(fname, O_RDWR | O_CREAT, 0664);
@@ -155,7 +155,7 @@ static void test_mprotect(int pagemap_fd
 		ftruncate(test_fd, pagesize);
 		map = mmap(NULL, pagesize, PROT_READ|PROT_WRITE,
 			   MAP_SHARED, test_fd, 0);
-		if (!map)
+		if (map == MAP_FAILED)
 			ksft_exit_fail_msg("file mmap failed\n");
 	}
 
--- a/tools/testing/selftests/mm/vm_util.c~selftests-mm-fix-incorrect-mmap-error-handling-with-null-instead-of-map_failed
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -396,7 +396,7 @@ bool softdirty_supported(void)
 	/* New mappings are expected to be marked with VM_SOFTDIRTY (sd). */
 	addr = mmap(0, pagesize, PROT_READ | PROT_WRITE,
 		    MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
-	if (!addr)
+	if (addr == MAP_FAILED)
 		ksft_exit_fail_msg("mmap failed\n");
 
 	supported = check_vmflag(addr, "sd");
_

Patches currently in -mm which might be from lihongfu@kylinos.cn are



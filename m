Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B3E2D5425
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 21:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763674665; cv=none; b=h4z33E016KuOmPUWv19MqSxadmPPXVHwsYgw/QzkED8r3D48cXPZtI1V2wJcp2IwT6NWVpK201y455VlUCGxm/VV5YYof6aMJhVL1jCWtNZC0oXdaiOWypFAZApanVsE630l0RKqHTz8HWgSn64dY3q1di0RL4dl6akw8yOBC0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763674665; c=relaxed/simple;
	bh=l0mIhC66aUkZtddtoeFo9jy71TYittfncjxyrngdpRA=;
	h=Date:To:From:Subject:Message-Id; b=UVTjAJISRwcpfbgowI8+ZXqBB1tr4TqN0TfeXTJXwbz3PtQ335c4hs3ZIOlZKwrImvP1VUU2jniG1aZoWybfoI3AgkBXQMUYJH7Y90usSuFVmIChf9xkHMNiJtElIVQ3cJPQxA5j8B1SOxZEd2riA24FpWn7cu4P02UsbwNghb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cDgSZv8E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cDgSZv8E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23269C4CEF1;
	Thu, 20 Nov 2025 21:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763674665;
	bh=l0mIhC66aUkZtddtoeFo9jy71TYittfncjxyrngdpRA=;
	h=Date:To:From:Subject:From;
	b=cDgSZv8EbNE049xBr+7MnVi8/1Vv/FpHp8HXVDmH5x5y2p8UQl2N+3BLAqDQwQttp
	 LPcAibGZzJMlzEPqn0pUL8prxeoOF5ZwvZVnQv4gSAfYzc9+eucvt3rco3rQetC6c9
	 JA6jEBrdRSkm3dtreTt6eCRCEnbFrG70RXBQtmSs=
Date: Thu, 20 Nov 2025 13:37:44 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,peterx@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,david.hunter.linux@gmail.com,mehdi.benhadjkhelifa@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftests-mm-uffd-remove-static-address-usage-in-shmem_allocate_area-v2.patch removed from -mm tree
Message-Id: <20251120213745.23269C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm/uffd: remove static address usage in shmem_allocate_area()
has been removed from the -mm tree.  Its filename was
     selftests-mm-uffd-remove-static-address-usage-in-shmem_allocate_area-v2.patch

This patch was dropped because it was folded into selftests-mm-uffd-remove-static-address-usage-in-shmem_allocate_area.patch

------------------------------------------------------
From: Mehdi Ben Hadj Khelifa <mehdi.benhadjkhelifa@gmail.com>
Subject: selftests/mm/uffd: remove static address usage in shmem_allocate_area()
Date: Thu, 13 Nov 2025 15:20:33 +0100

make cleanup code more clear, per Mike

Link: https://lkml.kernel.org/r/20251113142050.108638-1-mehdi.benhadjkhelifa@gmail.com
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

 tools/testing/selftests/mm/uffd-common.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/mm/uffd-common.c~selftests-mm-uffd-remove-static-address-usage-in-shmem_allocate_area-v2
+++ a/tools/testing/selftests/mm/uffd-common.c
@@ -6,7 +6,6 @@
  */
 
 #include "uffd-common.h"
-#include "asm-generic/mman-common.h"
 
 uffd_test_ops_t *uffd_test_ops;
 uffd_test_case_ops_t *uffd_test_case_ops;
@@ -151,7 +150,7 @@ static int shmem_allocate_area(uffd_glob
 		return -errno;
 	}
 
-	p = (char *)reserve;
+	p = reserve;
 	p_alias = p;
 	p_alias += bytes;
 	p_alias += hpage_size;  /* Prevent src/dst VMA merge */
@@ -159,8 +158,8 @@ static int shmem_allocate_area(uffd_glob
 	*alloc_area = mmap(p, bytes, PROT_READ | PROT_WRITE, MAP_FIXED | MAP_SHARED,
 			   mem_fd, offset);
 	if (*alloc_area == MAP_FAILED) {
-		munmap(reserve, region_size);
 		*alloc_area = NULL;
+		munmap(reserve, region_size);
 		close(mem_fd);
 		return -errno;
 	}
@@ -170,8 +169,8 @@ static int shmem_allocate_area(uffd_glob
 	area_alias = mmap(p_alias, bytes, PROT_READ | PROT_WRITE, MAP_FIXED | MAP_SHARED,
 			  mem_fd, offset);
 	if (area_alias == MAP_FAILED) {
-		munmap(reserve, region_size);
 		*alloc_area = NULL;
+		munmap(reserve, region_size);
 		close(mem_fd);
 		return -errno;
 	}
_

Patches currently in -mm which might be from mehdi.benhadjkhelifa@gmail.com are

selftests-mm-uffd-remove-static-address-usage-in-shmem_allocate_area.patch


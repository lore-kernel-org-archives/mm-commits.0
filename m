Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3A223BD1B
	for <mm-commits@vger.kernel.org>; Thu, 13 Nov 2025 22:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763073454; cv=none; b=lSrdZr1ThHBwUHauKYdxD2QwfMOuPnbq2hDA88hGdkg8gExBmXigKuFiXwll7vh/HldmTWbXAVWl1hZTpNsAptWs0lemHlvRDmtK8hxMclVgyJ7I4BzUNX3YWfUI8EpHAa7MTOPaV1Tytb+7buzMnzw3Qe6PdIY/9UZ+ONHkUaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763073454; c=relaxed/simple;
	bh=7EpAs+u4HSpV6jl6mJIo2Rmm+RcAigC/VpllAmxOI1g=;
	h=Date:To:From:Subject:Message-Id; b=jxaxRYn8Uq0fshveuwERc+h99i4XEOvYg2u2mcW978GiW4AJxQr8RZi3as5z8lzP5Pv8QxCYbQ+4i+RhLIKPa0mNgBWTYREtNcoKEXcIyXxvonYmODfmazr8K0w2E1xe3rHf40iAsgfP1Kakfod0/ZDFTQU6WI6y6lSDZ5wVbMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lkOhU+XB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lkOhU+XB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12CF3C4CEFB;
	Thu, 13 Nov 2025 22:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763073453;
	bh=7EpAs+u4HSpV6jl6mJIo2Rmm+RcAigC/VpllAmxOI1g=;
	h=Date:To:From:Subject:From;
	b=lkOhU+XBIZ5PC1wqL9oE6GrrsnKfq5ILpik0H1N2OEfWTdvao1AgME7+OBuBqkeWm
	 di2ROcflyOXDYz4ymvePWfgXpakSdHiCSuwnUG2bjaWNiBhSTYQVIEzVzZz1jrbNfz
	 BB5qsRhh7TkfHu3HqG06YSQ6YMPyf5YnX4EE5wzU=
Date: Thu, 13 Nov 2025 14:37:32 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,peterx@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,david.hunter.linux@gmail.com,mehdi.benhadjkhelifa@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-uffd-remove-static-address-usage-in-shmem_allocate_area-v2.patch added to mm-unstable branch
Message-Id: <20251113223733.12CF3C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm/uffd: remove static address usage in shmem_allocate_area()
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-uffd-remove-static-address-usage-in-shmem_allocate_area-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-uffd-remove-static-address-usage-in-shmem_allocate_area-v2.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-vmalloc-use-kmalloc_array-instead-of-kmalloc.patch
selftests-mm-uffd-remove-static-address-usage-in-shmem_allocate_area.patch
selftests-mm-uffd-remove-static-address-usage-in-shmem_allocate_area-v2.patch


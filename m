Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907A913B7AE
	for <mm-commits@vger.kernel.org>; Wed, 29 Apr 2026 13:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777468146; cv=none; b=PnvRDDcl7MrgprW1XhQmox0XQXMww17W5P6b+kwoI8/GRT3FQmu0FsoSr88A8Bf6GbOHI9LSYh2gHinG+BpE4y99mZryNxHLnFdP+73gAFoMlwpObc8wkkEkgSVgZGYNVMiHf2AJ/8kI3dVb0fvRyk6yh0nk2/ugy9IaH8q4zIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777468146; c=relaxed/simple;
	bh=phelkqdJ5Az2Y7Ef3osewM3YJOQ4BIPntrN5BPnWc14=;
	h=Date:To:From:Subject:Message-Id; b=i+Cmv80jxmxFLNWrUebsCBny7e1Mm3gfYQ5KY06yCqx448CVOIlZ6zicMiVWdUBB37FXHD24P4QKiI06tFhwjU7JYv+PAUMULvX5RvvE+UtqYqUEPJwLdqaBGQGrFzVnCsPmh8G6MvqX0+ag6hW5X3BgbgkhuiyI2Pp45Wn6NRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sRpfMcwj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sRpfMcwj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13B52C19425;
	Wed, 29 Apr 2026 13:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777468146;
	bh=phelkqdJ5Az2Y7Ef3osewM3YJOQ4BIPntrN5BPnWc14=;
	h=Date:To:From:Subject:From;
	b=sRpfMcwjOaQLIw3cWLeeuU9DWkaLrDbIcDTDkHSW6QwhC2/Scae+b9WmZuVDtT/hE
	 T29eXKoxAB+MVEDVTznfKVioBkdwsurO1KoTQsFx9R3xNPf57d7/C6WTmbfmYwkWB2
	 NSuz8kk/QO6ifrSB9yyVoXSWeyycblYt/VT/CJqA=
Date: Wed, 29 Apr 2026 06:09:05 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,agarwal.vineet2006@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-khugepaged-initialize-file-contents-via-mmap.patch added to mm-new branch
Message-Id: <20260429130906.13B52C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: khugepaged: initialize file contents via mmap
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-khugepaged-initialize-file-contents-via-mmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-khugepaged-initialize-file-contents-via-mmap.patch

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
From: Vineet Agarwal <agarwal.vineet2006@gmail.com>
Subject: selftests/mm: khugepaged: initialize file contents via mmap
Date: Wed, 29 Apr 2026 17:28:16 +0530

file_setup_area() currently allocates anonymous memory, fills it, and
writes it into the backing file used for collapse testing.

Instead of copying data through write(), resize the file with ftruncate(),
map it directly with MAP_SHARED, and initialize the mapped area in place.

This simplifies the setup path and avoids the need for explicit partial
write handling.

Link: https://lore.kernel.org/20260429115816.98824-1-agarwal.vineet2006@gmail.com
Signed-off-by: Vineet Agarwal <agarwal.vineet2006@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Tested-by: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/khugepaged.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/khugepaged.c~selftests-mm-khugepaged-initialize-file-contents-via-mmap
+++ a/tools/testing/selftests/mm/khugepaged.c
@@ -373,7 +373,7 @@ static void *file_setup_area(int nr_hpag
 	unlink(finfo.path);  /* Cleanup from previous failed tests */
 	printf("Creating %s for collapse%s...", finfo.path,
 	       finfo.type == VMA_SHMEM ? " (tmpfs)" : "");
-	fd = open(finfo.path, O_DSYNC | O_CREAT | O_RDWR | O_TRUNC | O_EXCL,
+	fd = open(finfo.path, O_CREAT | O_RDWR | O_TRUNC | O_EXCL,
 		  777);
 	if (fd < 0) {
 		perror("open()");
@@ -381,9 +381,21 @@ static void *file_setup_area(int nr_hpag
 	}
 
 	size = nr_hpages * hpage_pmd_size;
-	p = alloc_mapping(nr_hpages);
+	if (ftruncate(fd, size)) {
+		perror("ftruncate()");
+		exit(EXIT_FAILURE);
+	}
+	p = mmap(BASE_ADDR, size, PROT_READ | PROT_WRITE,
+		MAP_SHARED, fd, 0);
+	if (p != BASE_ADDR) {
+		perror("mmap()");
+		exit(EXIT_FAILURE);
+	}
 	fill_memory(p, 0, size);
-	write(fd, p, size);
+	if (msync(p, size, MS_SYNC)) {
+		perror("msync()");
+		exit(EXIT_FAILURE);
+	}
 	close(fd);
 	munmap(p, size);
 	success("OK");
_

Patches currently in -mm which might be from agarwal.vineet2006@gmail.com are

selftests-mm-khugepaged-initialize-file-contents-via-mmap.patch


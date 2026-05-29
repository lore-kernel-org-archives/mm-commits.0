Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7973836F8EF
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027685; cv=none; b=H7uHAA0OpHFv6tDA+bXD5igFJ6pjQncPWYYpaZfOB/bsFhzaaQE+qWauhJF/vYzYnVaOPYCuTx08mPiozE7dSn/F2T/G4zeVtIX95emp4hden0GNwUS+sTDxIrwQgexyfs2NpQ/AzwDr06tWaPSRnGobo7sobRbxo8jZhzLMlMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027685; c=relaxed/simple;
	bh=gQF/tqMB/SPo3GrvzqSo5LS9ZWlFOj3+eG6CNce0Sao=;
	h=Date:To:From:Subject:Message-Id; b=fC7zpmDDbATrcDuN8Sp9cIVtr5xGZmcTNAgimQtwCZ0kKeLWuaQenauM+CMyGh9d5SK+cX0wu/VTNfngktnKyfJd+EOmRr3ZeHrdPm1TuUkvVHhQhYwhoklX9iFEkfUKim4ogZ5S3RXUo2xhgjAQQR6BP1i3o8hPOvAziwcSKDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Zz1jNz8G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Zz1jNz8G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 541F51F00893;
	Fri, 29 May 2026 04:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027684;
	bh=rKeAYGNiVuFbCh0+GDYh4jPanypY1Prfq8TmKxvUWa8=;
	h=Date:To:From:Subject;
	b=Zz1jNz8G9uE+Eq+/qR6YwFf00EZlKbEz9ETLLVJS4kZMFXPM1hzzxnjTLY+XNoOgK
	 sEwYYMfRmb+oZ5PoFKivHMXavEBDDvuX4uhZrT9Lsvc4PI4rCzGXxqgQhLkwqfa7t8
	 T1vKIY95EKrCS2HsVpXdX6U05ay/A8ceY3eg+C0w=
Date: Thu, 28 May 2026 21:08:03 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,agarwal.vineet2006@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-khugepaged-initialize-file-contents-via-mmap.patch removed from -mm tree
Message-Id: <20260529040804.541F51F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: khugepaged: initialize file contents via mmap
has been removed from the -mm tree.  Its filename was
     selftests-mm-khugepaged-initialize-file-contents-via-mmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
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

selftests-mm-check-file-initialization-writes-in-split_huge_page_test.patch
mm-damon-sysfs-schemes-fix-double-increment-of-nr_regions.patch
selftests-mm-ksm-functional-tests-fix-partial-write-handling.patch


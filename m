Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31358B672
	for <mm-commits@vger.kernel.org>; Tue, 28 Apr 2026 15:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777388638; cv=none; b=mGL1UmIXU3iNZ2tiGvmNgUm56I+jvo0p5Yvc3YC0ymex98ZwwMo4MuOOej4yhBwCHoF6qvDd14CNGiJOmU4LAX7uUqfzpljdGsvFXXQU+pI9xknW6HQAkYOiwsJDYFI3TVjJ2AwgbllZhhLWFiuHMG22DrgDsFAU2H87oVxbvrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777388638; c=relaxed/simple;
	bh=rmf4Qjc4Jqv9tAhGvFnptxPZt2Oq0XEZ+zQE/6iZOqo=;
	h=Date:To:From:Subject:Message-Id; b=gXiQOUqEQ9m9EUArX0BIM7oqo3wpYry3vrFoXlYSogoJ+RYbnR3uf7MYDh9Mg9udUgppBJBy1YY6U0zPJ6y+Ol5CE+FgCKj9qtovEjEhD7alN7zMGtBBZjY/TW58YiB8+Z8bah3azRVZzJH3fwRgdaPvd6+pT+R0gAvL1qdlo7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ggju8pOT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ggju8pOT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5FAAC2BCAF;
	Tue, 28 Apr 2026 15:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777388637;
	bh=rmf4Qjc4Jqv9tAhGvFnptxPZt2Oq0XEZ+zQE/6iZOqo=;
	h=Date:To:From:Subject:From;
	b=ggju8pOTw01lAVDVdkyphZRz2KvTHk1JHmJsISCElwiFuIaGrVtzyuJv20rjS2srZ
	 NQSbuBGxDoFZiaHdt0ko3bEO0FuKJ38n8hcgE1rv1rhYLTkzmgeH3agleSmqOMTgrz
	 sfFPn3Z7XAvVj6GGzqih1jrxsQjyIRbWIOebdNK0=
Date: Tue, 28 Apr 2026 08:03:57 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,agarwal.vineet2006@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-khugepaged-initialize-file-contents-via-mmap.patch added to mm-new branch
Message-Id: <20260428150357.A5FAAC2BCAF@smtp.kernel.org>
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
Date: Tue, 28 Apr 2026 19:01:38 +0530

file_setup_area() currently allocates anonymous memory, fills it, and
writes it into the backing file used for collapse testing.

Instead of copying data through write(), resize the file with ftruncate(),
map it directly with MAP_SHARED, and initialize the mapped area in place.

This simplifies the setup path and avoids the need for explicit partial
write handling.

Link: https://lore.kernel.org/20260428133138.88802-1-agarwal.vineet2006@gmail.com
Signed-off-by: Vineet Agarwal <agarwal.vineet2006@gmail.com>
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
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/khugepaged.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/khugepaged.c~selftests-mm-khugepaged-initialize-file-contents-via-mmap
+++ a/tools/testing/selftests/mm/khugepaged.c
@@ -381,9 +381,19 @@ static void *file_setup_area(int nr_hpag
 	}
 
 	size = nr_hpages * hpage_pmd_size;
-	p = alloc_mapping(nr_hpages);
+	if (ftruncate(fd, size)) {
+		perror("ftruncate()");
+		close(fd);
+		exit(EXIT_FAILURE);
+	}
+	p = mmap(BASE_ADDR, size, PROT_READ | PROT_WRITE,
+		MAP_SHARED, fd, 0);
+	if (p == MAP_FAILED || p != BASE_ADDR) {
+		perror("mmap()");
+		close(fd);
+		exit(EXIT_FAILURE);
+	}
 	fill_memory(p, 0, size);
-	write(fd, p, size);
 	close(fd);
 	munmap(p, size);
 	success("OK");
_

Patches currently in -mm which might be from agarwal.vineet2006@gmail.com are

selftests-mm-khugepaged-initialize-file-contents-via-mmap.patch


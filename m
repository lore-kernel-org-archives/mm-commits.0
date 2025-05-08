Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17869219A9D
	for <mm-commits@vger.kernel.org>; Thu,  8 May 2025 06:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746686454; cv=none; b=N6uAaGivq/KXoa1qut3SQATO7raGyps129bT+r9mvfK96yRxOEHkQEb+fnOSJsmJAgdpfruAddmI7rerQcMN9UVrfQ3Qu16gxpMq9G+MvyqjRDYkbamLy6eMVaxhP24eGRW3DEzkcgN+KEjc/50TYfUti/3UoP5fUdL1VXAIP9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746686454; c=relaxed/simple;
	bh=BqcWajtEf1mnciR37WybXDXRY07b9Y0l8L/w12suBws=;
	h=Date:To:From:Subject:Message-Id; b=ExnndSRh48wYcYmMWkRyfKa5jEHMAuNzu9BUehg36LhLx+xXFhX5j8qwnDRZgm2YMurh2n9UDpxFZ5M2ONMYWjw0PeHYZFe9aXNH2W312fHsMBLJdgXL4jeQkWcSkg3YbcwjUm/jQOmjRMZGpJk2GmiehlUNfpTzEXBaB7dBIJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nmR0DX7k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nmR0DX7k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF9F5C4CEEB;
	Thu,  8 May 2025 06:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746686454;
	bh=BqcWajtEf1mnciR37WybXDXRY07b9Y0l8L/w12suBws=;
	h=Date:To:From:Subject:From;
	b=nmR0DX7ktYs3mf30ScmtNtpfqRL7A7C005dK9rGuS3w6ryei5KFIkxDMODwG5kvWQ
	 VqZxYhyT8i67Pa3ZOHTgfymPgplYi8m8JtBCp/9C30a8Py/t5byuh7oRCA2eAsmEb6
	 Ecvcb1CMDeSdZrLGGjHHaINqEgKcIo8A9El4cNGY=
Date: Wed, 07 May 2025 23:40:53 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,ryan.roberts@arm.com,npache@redhat.com,liam.howlett@oracle.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-add-mm-thp-section.patch removed from -mm tree
Message-Id: <20250508064053.DF9F5C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add mm THP section
has been removed from the -mm tree.  Its filename was
     maintainers-add-mm-thp-section.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: MAINTAINERS: add mm THP section
Date: Thu, 24 Apr 2025 12:16:32 +0100

As part of the ongoing efforts to sub-divide memory management
maintainership and reviewership, establish a section for Transparent Huge
Page support and add appropriate maintainers and reviewers.

[lorenzo.stoakes@oracle.com: add Dev Jain as THP reviewer]
  Link: https://lkml.kernel.org/r/327e6f2f-0f0f-48af-9ca2-3f8cadf0d8bf@lucifer.local
Link: https://lkml.kernel.org/r/20250424111632.103637-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/MAINTAINERS~maintainers-add-mm-thp-section
+++ a/MAINTAINERS
@@ -15587,6 +15587,30 @@ S:	Maintained
 F:	include/linux/secretmem.h
 F:	mm/secretmem.c
 
+MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE)
+M:	Andrew Morton <akpm@linux-foundation.org>
+M:	David Hildenbrand <david@redhat.com>
+R:	Zi Yan <ziy@nvidia.com>
+R:	Baolin Wang <baolin.wang@linux.alibaba.com>
+R:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
+R:	Liam R. Howlett <Liam.Howlett@oracle.com>
+R:	Nico Pache <npache@redhat.com>
+R:	Ryan Roberts <ryan.roberts@arm.com>
+R:	Dev Jain <dev.jain@arm.com>
+L:	linux-mm@kvack.org
+S:	Maintained
+W:	http://www.linux-mm.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	Documentation/admin-guide/mm/transhuge.rst
+F:	include/linux/huge_mm.h
+F:	include/linux/khugepaged.h
+F:	include/trace/events/huge_memory.h
+F:	mm/huge_memory.c
+F:	mm/khugepaged.c
+F:	tools/testing/selftests/mm/khugepaged.c
+F:	tools/testing/selftests/mm/split_huge_page_test.c
+F:	tools/testing/selftests/mm/transhuge-stress.c
+
 MEMORY MANAGEMENT - USERFAULTFD
 M:	Andrew Morton <akpm@linux-foundation.org>
 R:	Peter Xu <peterx@redhat.com>
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

maintainers-add-mm-gup-section.patch
mm-vma-fix-incorrectly-disallowed-anonymous-vma-merges.patch
tools-testing-add-procmap_query-helper-functions-in-mm-self-tests.patch
tools-testing-selftests-assert-that-anon-merge-cases-behave-as-expected.patch
mm-move-mmap-vma-locking-logic-into-specific-files.patch
mm-establish-mm-vma_execc-for-shared-exec-mm-vma-functionality.patch
mm-abstract-initial-stack-setup-to-mm-subsystem.patch
mm-move-dup_mmap-to-mm.patch
mm-perform-vma-allocation-freeing-duplication-in-mm.patch
mm-introduce-new-mmap_prepare-file-callback.patch
mm-secretmem-convert-to-mmap_prepare-hook.patch
mm-vma-remove-mmap-retry-merge.patch


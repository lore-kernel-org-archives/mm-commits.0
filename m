Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE49E28C03A
	for <mm-commits@vger.kernel.org>; Fri,  4 Jul 2025 22:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751667554; cv=none; b=e1rQv2hWcOcaFc1MTz415oW3jZML90aussK9m/sqdXlO8GYGj/JtRbxkCUzUDKJw27Nn2SdVLDuFcIWsKwwqQf5EEe1jhvLQTJVmvoNh6cw3cqhXuE7J1j9M2nVkiey79+78f6/NQxgRvqdq8j7a1aJ9qdhLwzX77RqvsmRk0oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751667554; c=relaxed/simple;
	bh=c+7lfhrTyqgkN5JJ+km7CJsawtiwK8mdtgvnyHC1QOc=;
	h=Date:To:From:Subject:Message-Id; b=qp7t7x4nMHb8VwhgSi6H8vP20qE81bwePGf1OLZiVAn50Dzn+x7BEHJ3XCXssSXwQGKchIbFNIIqL4Nbi784jxqbKVI7Z+loJWMXJRl6KdhigvYu/qZelgyjd8lJeVzdFqs9geuEwEUQSI1qntXYt0fMokr/I5D+nR/PJMJiL68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dv+Ek6AB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dv+Ek6AB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DCD5C4CEE3;
	Fri,  4 Jul 2025 22:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751667554;
	bh=c+7lfhrTyqgkN5JJ+km7CJsawtiwK8mdtgvnyHC1QOc=;
	h=Date:To:From:Subject:From;
	b=dv+Ek6AB/nVVUwlZAf8I2iar/U2vGjEZr0jgHz3aYGUmF5onbqOGq5Pzyzc7Ly0Kb
	 MYR1V+Imd4gyFlvS05A46D0aI2g+9QgKV9fruxtpjPeqdLc2b1i+9fNciqjjg3wBEz
	 fJ9rIqiwOYewN8tKl2+HWhtNM5utB8aGTth10RkY=
Date: Fri, 04 Jul 2025 15:19:13 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,hughd@google.com,dev.jain@arm.com,david@redhat.com,baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fault-in-complete-folios-instead-of-individual-pages-for-tmpfs.patch added to mm-new branch
Message-Id: <20250704221914.7DCD5C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fault in complete folios instead of individual pages for tmpfs
has been added to the -mm mm-new branch.  Its filename is
     mm-fault-in-complete-folios-instead-of-individual-pages-for-tmpfs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fault-in-complete-folios-instead-of-individual-pages-for-tmpfs.patch

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: fault in complete folios instead of individual pages for tmpfs
Date: Fri, 4 Jul 2025 11:19:26 +0800

After commit acd7ccb284b8 ("mm: shmem: add large folio support for
tmpfs"), tmpfs can also support large folio allocation (not just PMD-sized
large folios).

However, when accessing tmpfs via mmap(), although tmpfs supports large
folios, we still establish mappings at the base page granularity, which is
unreasonable.

We can map multiple consecutive pages of tmpfs folios at once according to
the size of the large folio.  On one hand, this can reduce the overhead of
page faults; on the other hand, it can leverage hardware architecture
optimizations to reduce TLB misses, such as contiguous PTEs on the ARM
architecture.

Moreover, tmpfs mount will use the 'huge=' option to control large folio
allocation explicitly.  So it can be understood that the process's RSS
statistics might increase, and I think this will not cause any obvious
effects for users.

Performance test:
I created a 1G tmpfs file, populated with 64K large folios, and write-accessed it
sequentially via mmap(). I observed a significant performance improvement:

Before the patch:
real	0m0.158s
user	0m0.008s
sys	0m0.150s

After the patch:
real	0m0.021s
user	0m0.004s
sys	0m0.017s

Link: https://lkml.kernel.org/r/440940e78aeb7430c5cc8b6d2088ae98265b9809.1751599072.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memory.c~mm-fault-in-complete-folios-instead-of-individual-pages-for-tmpfs
+++ a/mm/memory.c
@@ -5376,10 +5376,10 @@ fallback:
 
 	/*
 	 * Using per-page fault to maintain the uffd semantics, and same
-	 * approach also applies to non-anonymous-shmem faults to avoid
+	 * approach also applies to non shmem/tmpfs faults to avoid
 	 * inflating the RSS of the process.
 	 */
-	if (!vma_is_anon_shmem(vma) || unlikely(userfaultfd_armed(vma)) ||
+	if (!vma_is_shmem(vma) || unlikely(userfaultfd_armed(vma)) ||
 	    unlikely(needs_fallback)) {
 		nr_pages = 1;
 	} else if (nr_pages > 1) {
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-fix-the-inaccurate-memory-statistics-issue-for-users.patch
selftests-khugepaged-fix-the-shmem-collapse-failure.patch
selftests-mm-add-shmem-collapse-as-a-default-test-item.patch
mm-huge_memory-fix-the-check-for-allowed-huge-orders-in-shmem.patch
khugepaged-allow-khugepaged-to-check-all-anonymous-mthp-orders.patch
khugepaged-kick-khugepaged-for-enabling-none-pmd-sized-mthps.patch
mm-fault-in-complete-folios-instead-of-individual-pages-for-tmpfs.patch


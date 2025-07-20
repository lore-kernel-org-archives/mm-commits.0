Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D34B1361
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752976866; cv=none; b=YDN9abDbywCoci/FPW6fCpp5IUk+AzEpD4U2aB1R5ReT09Vxp0jQhJfUGjjmGIk4rZiYluUTpJDGLTSGKr3pHpo0h4xL5nrSW1+OqnO2T4hYqpsLmQcHF2gYBoV7PrFwkIy28AZtLRNJm+2DFpFaBqFNAj8lFGWeEfrxAF404Sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752976866; c=relaxed/simple;
	bh=maQpSyKyynaPtlvtP4+iVf15RqYf4Z4IQPr4x9Xy8i4=;
	h=Date:To:From:Subject:Message-Id; b=jYbQ9ljtoEFf3N74tvp2XSSpSagPwsytbcNogzkon6xEgHsklioKVtu5r0fMm6Q2xEjkyRttlRFO71V69U9iCU9/plTO8+MNzmwEOlpMWDC565LHeoS4+N7I3pihRpN4NvrgpIy28vDX4HoafY/WrttFhktcmbpdQESMyNBaI54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bUX/9ABn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bUX/9ABn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C70F0C4CEE3;
	Sun, 20 Jul 2025 02:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752976865;
	bh=maQpSyKyynaPtlvtP4+iVf15RqYf4Z4IQPr4x9Xy8i4=;
	h=Date:To:From:Subject:From;
	b=bUX/9ABnauMwQUaYAFWbQBpIRfJoxO5DYRZ4HdairqIX0VxybJF05pEgHjJEURCnv
	 ofAwA2OPagI3wGHhsTeMREIA+O/0UrBVVcp7P7hw6L+0HDxgVP+5z8TGlAwie1lZpp
	 HofZwanDPgZDi/x2m/MQ5CDKahv9RLkv47pVAXyY=
Date: Sat, 19 Jul 2025 19:01:05 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vishal.moola@gmail.com,vbabka@suse.cz,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,hughd@google.com,dev.jain@arm.com,david@redhat.com,baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-fault-in-complete-folios-instead-of-individual-pages-for-tmpfs.patch removed from -mm tree
Message-Id: <20250720020105.C70F0C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fault in complete folios instead of individual pages for tmpfs
has been removed from the -mm tree.  Its filename was
     mm-fault-in-complete-folios-instead-of-individual-pages-for-tmpfs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Fixes: acd7ccb284b8 ("mm: shmem: add large folio support for tmpfs")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memory.c~mm-fault-in-complete-folios-instead-of-individual-pages-for-tmpfs
+++ a/mm/memory.c
@@ -5383,10 +5383,10 @@ fallback:
 
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



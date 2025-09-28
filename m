Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B4BE34BA4D
	for <mm-commits@vger.kernel.org>; Sun, 28 Sep 2025 18:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759085533; cv=none; b=ZP1TAZxnz7YlScC1br2Ju7T2YgrCH7rVkB8mPa/3Cd9MWgUhpmzji0twRoQFls2B1LP9jix9fXcDs3/TS1FpiQOhd1jYkOV9rupl8v2Ov8pI1EgtHWM5D94Q8KGs+XDcR7w0s9aIErJrCvle4YRmngq3JoOn+U9G1gPaJ4VIF0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759085533; c=relaxed/simple;
	bh=bsL3rPVP4NTPdnJz1YN1JKtcuSU++Lc8myyctLOhpNY=;
	h=Date:To:From:Subject:Message-Id; b=DWWelhnkd9yGTm+pbcXzSg/s4jw/aVjQjwUMWe0NdW1IfcBSbj39DfrhjrEaHzNFDgXnMuNeNU3CwD0b5MB0PwJw/liR7mqIKwTllneh5wKLRkM6nLX5vm6zZOFS+sA7CAf3qtxEnFTiQVW9nXt+bbJucskK6uAnyIsOuOAuaFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wb/VxTnl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wb/VxTnl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B638C4CEF0;
	Sun, 28 Sep 2025 18:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759085533;
	bh=bsL3rPVP4NTPdnJz1YN1JKtcuSU++Lc8myyctLOhpNY=;
	h=Date:To:From:Subject:From;
	b=wb/VxTnljOBpGu4Cew9NX8eQpFugqpt8FVtifEeivZm0VvwdkCvybXmuFzg4cJizi
	 uKdqBXe4PiOgX3Br7ChfRAL9G23QxTjWLq3JLSDCvY9h4s5rFlozTL0cPejZa3keuw
	 TmewpzGbUKnm6Ku2pXpxjVqiKucYxWs6ab87F2wM=
Date: Sun, 28 Sep 2025 11:52:12 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,lorenzo.stoakes@oracle.com,hannes@cmpxchg.org,david@redhat.com,baolin.wang@linux.alibaba.com,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-fault-try-to-map-the-entire-file-folio-in-finish_fault.patch removed from -mm tree
Message-Id: <20250928185213.0B638C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/fault: try to map the entire file folio in finish_fault()
has been removed from the -mm tree.  Its filename was
     mm-fault-try-to-map-the-entire-file-folio-in-finish_fault.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kiryl Shutsemau <kas@kernel.org>
Subject: mm/fault: try to map the entire file folio in finish_fault()
Date: Tue, 23 Sep 2025 12:07:09 +0100

finish_fault() uses per-page fault for file folios.  This only occurs for
file folios smaller than PMD_SIZE.

The comment suggests that this approach prevents RSS inflation.  However,
it only prevents RSS accounting.  The folio is still mapped to the
process, and the fact that it is mapped by a single PTE does not affect
memory pressure.  Additionally, the kernel's ability to map large folios
as PMD if they are large enough does not support this argument.

When possible, map large folios in one shot.  This reduces the number of
minor page faults and allows for TLB coalescing.

Mapping large folios at once will allow the rmap code to mlock it on add,
as it will recognize that it is fully mapped and mlocking is safe.

Link: https://lkml.kernel.org/r/20250923110711.690639-5-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/mm/memory.c~mm-fault-try-to-map-the-entire-file-folio-in-finish_fault
+++ a/mm/memory.c
@@ -5516,13 +5516,8 @@ fallback:
 
 	nr_pages = folio_nr_pages(folio);
 
-	/*
-	 * Using per-page fault to maintain the uffd semantics, and same
-	 * approach also applies to non shmem/tmpfs faults to avoid
-	 * inflating the RSS of the process.
-	 */
-	if (!vma_is_shmem(vma) || unlikely(userfaultfd_armed(vma)) ||
-	    unlikely(needs_fallback)) {
+	/* Using per-page fault to maintain the uffd semantics */
+	if (unlikely(userfaultfd_armed(vma)) || unlikely(needs_fallback)) {
 		nr_pages = 1;
 	} else if (nr_pages > 1) {
 		pgoff_t idx = folio_page_idx(folio, page);
_

Patches currently in -mm which might be from kas@kernel.org are



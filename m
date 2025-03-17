Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 340F11DA61D
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188511; cv=none; b=FuovjskLyLacpXHpRf1oKPBVFpwB832jUnYa+ihgqM9vynZeYVdmJboyNVnRu4oOLyoWDzxyKSh7v7XOfqRZ49WQBgiRzgBz0rRYTw5JkzlogAkiCDZueHyyEs6WOsygcVDiTcFKwtJPJAl91vT+vLplcCRX5EuzYP72bWjYilo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188511; c=relaxed/simple;
	bh=UYHAkFFTEnpJ1fFEMEVY1vuwzCe6zYzi/nhmrKFeSOk=;
	h=Date:To:From:Subject:Message-Id; b=YLOpZSbxLTP2Y+SS9WSUqpnXobdS1sxZDsWmjdNW9ztfXvOq2aSwE60VXmX1HnCVOAWj3qFozNaeff4DQcbNUt6CQM++YAq2NCLbJioiEPHqziZ7iMwIkxXMpAEp7c9AXbJoxziDQDqI1RqRZ45wiKKVxbnFcrKo+ellae4s2RI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i/JQVrBQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i/JQVrBQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0650CC4CEEC;
	Mon, 17 Mar 2025 05:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188511;
	bh=UYHAkFFTEnpJ1fFEMEVY1vuwzCe6zYzi/nhmrKFeSOk=;
	h=Date:To:From:Subject:From;
	b=i/JQVrBQp6sD5T979U6qReKDq7sP9D4yLF6xoXKlXWvdM9xUPHpECGwfyS1s6xBfJ
	 SIMF0BdNYdoPjo4LDKYgkFi4EWGaIxybbur4yQuOe/wP2dpy7znuvMiJQTWV4qiEq9
	 +8xZDseloDG4xyCcOrHMfTtf2sp1ZjZHc1yoSyG0=
Date: Sun, 16 Mar 2025 22:15:10 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tglx@linutronix.de,mingo@redhat.com,jgross@suse.com,hpa@zytor.com,david@redhat.com,davem@davemloft.net,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,boris.ostrovsky@oracle.com,andreas@gaisler.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-proc-task_mmu-reduce-scope-of-lazy-mmu-region.patch removed from -mm tree
Message-Id: <20250317051511.0650CC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/proc/task_mmu: reduce scope of lazy mmu region
has been removed from the -mm tree.  Its filename was
     fs-proc-task_mmu-reduce-scope-of-lazy-mmu-region.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: fs/proc/task_mmu: reduce scope of lazy mmu region
Date: Mon, 3 Mar 2025 14:15:36 +0000

Update the way arch_[enter|leave]_lazy_mmu_mode() is called in
pagemap_scan_pmd_entry() to follow the normal pattern of holding the ptl
for user space mappings.  As a result the scope is reduced to only the pte
table, but that's where most of the performance win is.

While I believe there wasn't technically a bug here, the original scope
made it easier to accidentally nest or, worse, accidentally call something
like kmap() which would expect an immediate mode pte modification but it
would end up deferred.

Link: https://lkml.kernel.org/r/20250303141542.3371656-3-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Juergen Gross <jgross@suse.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juegren Gross <jgross@suse.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-reduce-scope-of-lazy-mmu-region
+++ a/fs/proc/task_mmu.c
@@ -2459,22 +2459,19 @@ static int pagemap_scan_pmd_entry(pmd_t
 	spinlock_t *ptl;
 	int ret;
 
-	arch_enter_lazy_mmu_mode();
-
 	ret = pagemap_scan_thp_entry(pmd, start, end, walk);
-	if (ret != -ENOENT) {
-		arch_leave_lazy_mmu_mode();
+	if (ret != -ENOENT)
 		return ret;
-	}
 
 	ret = 0;
 	start_pte = pte = pte_offset_map_lock(vma->vm_mm, pmd, start, &ptl);
 	if (!pte) {
-		arch_leave_lazy_mmu_mode();
 		walk->action = ACTION_AGAIN;
 		return 0;
 	}
 
+	arch_enter_lazy_mmu_mode();
+
 	if ((p->arg.flags & PM_SCAN_WP_MATCHING) && !p->vec_out) {
 		/* Fast path for performing exclusive WP */
 		for (addr = start; addr != end; pte++, addr += PAGE_SIZE) {
@@ -2543,8 +2540,8 @@ flush_and_return:
 	if (flush_end)
 		flush_tlb_range(vma, start, addr);
 
-	pte_unmap_unlock(start_pte, ptl);
 	arch_leave_lazy_mmu_mode();
+	pte_unmap_unlock(start_pte, ptl);
 
 	cond_resched();
 	return ret;
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-use-ptep_get-instead-of-directly-dereferencing-pte_t.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D36AB1C84B2
	for <mm-commits@vger.kernel.org>; Sat,  2 Aug 2025 18:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754160886; cv=none; b=pU+r1V7t2r3Sibj1q56JrFQy9lJ7rB8dkrtNzS1zkzZKsTXeaM2ug+fWncWgqtUdFzYQVipR3LfKGd3nhKJCQD6URFxviLfk+SJMQ6bWhLlh6fMJamUF/+L2dinCyM0y+ilo25qTISN18r5nKP95aIRXqMrKno9IcIO62cXfSig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754160886; c=relaxed/simple;
	bh=NEu6LOUMqWACnd3kwoA48XGX5CtuB0vrMGoI4CgGWWc=;
	h=Date:To:From:Subject:Message-Id; b=H5tvreFeYY0/69TiFZfaInvpehyFwccSasFNuBOchP30fkCYnsii0I7SAt1hbgDVNU0Qw+zd+6ZCPsya+LzQn6BMDiSg5Ccb/BB08TGhNFAo5xJVMn0BphfkDzdVnu/ICaKhPy4VDp7cTdgMUNPHZP4134dLNwwDvTKASSeqHdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CMButpD2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CMButpD2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7985C4CEEF;
	Sat,  2 Aug 2025 18:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754160886;
	bh=NEu6LOUMqWACnd3kwoA48XGX5CtuB0vrMGoI4CgGWWc=;
	h=Date:To:From:Subject:From;
	b=CMButpD2NU3Ux1httg2oJldl3PTXULoCZ0fMyzja9AY1U1Z5uQXx68ZKgEb1wejGY
	 0K73e1V4j2F+suujPkOgU83XZc4alqq21yEIXkQ/J3fw2WmRMmi76zdb02TFs4C2CN
	 yF9cM2rhgaIie4VZa/BZKGRYrA9Oy6NPTwmWkplg=
Date: Sat, 02 Aug 2025 11:54:46 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,hughd@google.com,dev.jain@arm.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-swap-fix-major-fault-counting.patch removed from -mm tree
Message-Id: <20250802185446.A7985C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/shmem, swap: fix major fault counting
has been removed from the -mm tree.  Its filename was
     mm-shmem-swap-fix-major-fault-counting.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/shmem, swap: fix major fault counting
Date: Mon, 28 Jul 2025 15:53:06 +0800

If the swapin failed, don't update the major fault count.  There is a long
existing comment for doing it this way, now with previous cleanups, we can
finally fix it.

Link: https://lkml.kernel.org/r/20250728075306.12704-9-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/mm/shmem.c~mm-shmem-swap-fix-major-fault-counting
+++ a/mm/shmem.c
@@ -2356,13 +2356,6 @@ static int shmem_swapin_folio(struct ino
 	/* Look it up and read it in.. */
 	folio = swap_cache_get_folio(swap, NULL, 0);
 	if (!folio) {
-		/* Or update major stats only when swapin succeeds?? */
-		if (fault_type) {
-			*fault_type |= VM_FAULT_MAJOR;
-			count_vm_event(PGMAJFAULT);
-			count_memcg_event_mm(fault_mm, PGMAJFAULT);
-		}
-
 		if (data_race(si->flags & SWP_SYNCHRONOUS_IO)) {
 			/* Direct swapin skipping swap cache & readahead */
 			folio = shmem_swap_alloc_folio(inode, vma, index,
@@ -2381,6 +2374,11 @@ static int shmem_swapin_folio(struct ino
 				goto failed;
 			}
 		}
+		if (fault_type) {
+			*fault_type |= VM_FAULT_MAJOR;
+			count_vm_event(PGMAJFAULT);
+			count_memcg_event_mm(fault_mm, PGMAJFAULT);
+		}
 	}
 
 	if (order > folio_order(folio)) {
_

Patches currently in -mm which might be from kasong@tencent.com are



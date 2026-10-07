Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891402DEA7B
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334249; cv=none; b=FOWW/WoWZGlshH/wXPoed3htDc2+I2vcvldqfNqPqTImW4w0iu3ngV7upLSf2Bil8yZvGQRn2Q0dIRnKJgd3WXfchn5LjM4bFav9/zSnlwqbA06+t+7cU0sbFp8felWQxEiG3dEBJnuA/q1NCDDfTesff+KbJeLI8NdBdxLIC3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334249; c=relaxed/simple;
	bh=nM+bGsSKTGxScdFaofbGo65gkTZRPJqEvnh7+TMlX8M=;
	h=Date:To:From:Subject:Message-Id; b=tL8NB4bXI/XFIWp4qeQNwMLBBT5RT7alp/+1vb+doX5GzQSVhmbfKOK7YCbygvAxtxsKcCRumm33G+g/HNNdyDGsOVl/9tqwJyg0VHT8lWnEYI2KniVlkbisZihx6ZcCgwDpHdyc0vK4u1VxlOi/k42R0j0fWAvrVGETkuIeW8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XQmb0JY3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XQmb0JY3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60CC51F0089B;
	Wed,  7 Oct 2026 00:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334248;
	bh=OtESW5Xp2k5LFcw0sOQ0jGYXhqT/bxWm96yKginKDME=;
	h=Date:To:From:Subject;
	b=XQmb0JY3h4K9fGPaVQP0NO1rf1QSvKkBX2Ut3q26TpTthF1DEcNlkOac5zdxIPhsz
	 b4wS21LL8obUNUlIA7S5qJPpAUvddLVfVyk9WvbGaHylgIB0MiepDpybObFA9Hw09j
	 zBzzTnAEgRpbgSANa646Mb/rLk/cnS1WDSQqhL/A=
Date: Tue, 06 Oct 2026 17:50:47 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shikemeng@huaweicloud.com,rppt@kernel.org,pfalcato@suse.de,peterx@redhat.com,nphamcs@gmail.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kasong@tencent.com,jannh@google.com,hughd@google.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,chengming.zhou@linux.dev,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-fail-the-fault-on-a-malformed-swap-entry-instead-of-retrying-it.patch removed from -mm tree
Message-Id: <20261007005048.60CC51F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fail the fault on a malformed swap entry instead of retrying it
has been removed from the -mm tree.  Its filename was
     mm-fail-the-fault-on-a-malformed-swap-entry-instead-of-retrying-it.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: mm: fail the fault on a malformed swap entry instead of retrying it
Date: Tue, 18 Aug 2026 03:06:24 -0700

do_swap_page() returns 0 when get_swap_device() fails, which the fault
handler reads as "handled".  For an entry that can never become valid the
retry takes the same fault again, so the thread spins forever, retrying on
the same fault.

Return VM_FAULT_SIGBUS (Bad access) for a malformed entry (pr_err() was
called at get_swap_device()).

Link: https://lore.kernel.org/20260818-swap-v3-2-d3fa52598a59@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 mm/memory.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/memory.c~mm-fail-the-fault-on-a-malformed-swap-entry-instead-of-retrying-it
+++ a/mm/memory.c
@@ -4958,8 +4958,11 @@ vm_fault_t do_swap_page(struct vm_fault
 
 	/* Prevent swapoff from happening to us, and reject a bad entry. */
 	si = get_swap_device(entry);
-	if (IS_ERR_OR_NULL(si))
+	if (IS_ERR_OR_NULL(si)) {
+		if (IS_ERR(si))
+			ret = VM_FAULT_SIGBUS;
 		goto out;
+	}
 
 	folio = swap_cache_get_folio(entry);
 	if (folio)
_

Patches currently in -mm which might be from leitao@debian.org are

documentation-kmemleak-describe-the-metadata-pool-not-the-early-log.patch
documentation-kmemleak-fix-stale-statements-about-scanning.patch
mm-kmemleak-raise-min_unref_scans-to-3-for-verbose-auto-scan.patch
mm-shmem-report-rcu-tasks-quiescent-states-while-undoing-a-range.patch
mm-kmemleak-move-the-struct-page-scan-into-a-helper.patch
mm-kmemleak-scan-the-struct-page-array-in-max_scan_size-batches.patch


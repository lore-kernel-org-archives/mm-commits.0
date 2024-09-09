Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82303130495
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725924814; cv=none; b=VjZIUhL7T4Wte6rUOjYf3ExnTQz+XN99R+lSMBUrA98WvVw777fK4UFd9PyUzTdvOxRw4raPASYIIbQgdnbVTgLHxHCrUEZIxEQLL6t5DQMy0wP6SH+WN3HKqTMrkIyg/0cOidGa3q38Qf/o21dxkIQ8k5rmq0CGZ5tm0R03iZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725924814; c=relaxed/simple;
	bh=wiE6OYNpDzVsjZgpiJrXUJg1fb62pLgTtOKjXVCv8ss=;
	h=Date:To:From:Subject:Message-Id; b=PL/G0cyURCLsDXa5G+h1KGLm+y9FsfFasfphJTl2Zg/xbNTXGlLfIAWzyt8nv++kFIfVINAwc5r66kWggBXLQF8g7E/MWOucps9+o31eSw0qWeNJDNA15eSvdv93nzrP2+QR19lNEGObOQs8Tkg4JOKli0Ug9D51vBaFuYDd0tY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1g8zlyVx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1g8zlyVx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0104BC4CEC6;
	Mon,  9 Sep 2024 23:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725924814;
	bh=wiE6OYNpDzVsjZgpiJrXUJg1fb62pLgTtOKjXVCv8ss=;
	h=Date:To:From:Subject:From;
	b=1g8zlyVxg2sMoLbKLCNHsoY3BSjSl91rB5x0SYCMxCTUlGZJpIvkwveoJ1wENsqJY
	 peSH60/ZmvLVF6HZ1Xn4HWCQZehu7cR/KPCKAEW9i8QIwGVMRBxeqEEVEfLPK8uLwn
	 RzNkgD3nQwNyaFmkiQ6FiFwOG3rEMm5iGaZvDkC8=
Date: Mon, 09 Sep 2024 16:33:33 -0700
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,mjguzik@gmail.com,dave@stgolabs.net,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-hugetlb-sort-out-global-lock-annotations-fix.patch removed from -mm tree
Message-Id: <20240909233334.0104BC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-hugetlb-sort-out-global-lock-annotations-fix
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-sort-out-global-lock-annotations-fix.patch

This patch was dropped because it was folded into mm-hugetlb-sort-out-global-lock-annotations.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hugetlb-sort-out-global-lock-annotations-fix
Date: Wed Aug 28 12:48:16 PM PDT 2024

move section directives to the end of the definitions, per convention

Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-sort-out-global-lock-annotations-fix
+++ a/mm/hugetlb.c
@@ -72,14 +72,14 @@ static unsigned int default_hugepages_in
  * Protects updates to hugepage_freelists, hugepage_activelist, nr_huge_pages,
  * free_huge_pages, and surplus_huge_pages.
  */
-__cacheline_aligned_in_smp DEFINE_SPINLOCK(hugetlb_lock);
+DEFINE_SPINLOCK(hugetlb_lock) __cacheline_aligned_in_smp;
 
 /*
  * Serializes faults on the same logical page.  This is used to
  * prevent spurious OOMs when the hugepage pool is fully utilized.
  */
-static __ro_after_init int num_fault_mutexes;
-__ro_after_init struct mutex *hugetlb_fault_mutex_table;
+static int num_fault_mutexes __ro_after_init;
+struct mutex *hugetlb_fault_mutex_table __ro_after_init;
 
 /* Forward declaration */
 static int hugetlb_acct_memory(struct hstate *h, long delta);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-hugetlb-sort-out-global-lock-annotations.patch
mm-hugetlb-sort-out-global-lock-annotations-fix-fix.patch
mmtmpfs-consider-end-of-file-write-in-shmem_is_huge-checkpatch-fixes.patch
mm-page_alloc-fix-build-with-config_unaccepted_memory=n.patch
mm-vma-return-the-exact-errno-in-vms_gather_munmap_vmas-fix.patch


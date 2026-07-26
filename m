Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B66C02931F2
	for <mm-commits@vger.kernel.org>; Sun, 26 Jul 2026 02:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785033218; cv=none; b=L2pJBJMV4H83wyRVThBWoStURhxhjlO3DdiRlka885JiM/EEE7r92Sxlf5NSgBbgi+FwdGUldtr/JVrsTYVBYoaH7hN6f469VF4gFAcCobePRaLDRoGgjg97aF9hoCGWPhXSKknGyILrkZ89Rc5ytjWGl0h3KSzo6TwcDplU22k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785033218; c=relaxed/simple;
	bh=FmIDQffuoBrzeZCSQuubINamzl3hivJg7DAW0rfexCw=;
	h=Date:To:From:Subject:Message-Id; b=TQU5Jcp4Zw649CZHYzJXw9nXgX9HFf1YsxvjoHDmJ9Mlkt+GAlwcVJUGg9glS/fgiRg+zBEzXGRuyW3S4YizzZiEkDDv7JxZE5jnCt4uDWbhbJF78c+SQyf1aHV7n6ZJ0cVgdTQucnwTqSIeREwZ6OrTV1q/z5ixvFiT3o/x6Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IMKtuVA7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IMKtuVA7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 492591F000E9;
	Sun, 26 Jul 2026 02:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785033217;
	bh=q6v//l8b5GKrEAoq+OpZBnRfjXeK4qdKemISpEjn4wU=;
	h=Date:To:From:Subject;
	b=IMKtuVA7S97AVj02Xrj5yLpdV//PRuZM2EzTaaW/r5Qo/kwkZrFBlxNHsm+SV0BTJ
	 P7nnkz8y9CSzKa0VvEcpeNxNkwa9Y+fPCTXyqVpKDQXhG8+ax+n9tfl2PAPCxHiQzt
	 2kKk50LIpxkK/S3+ekH183cBvGALFlb9nz5pF8s4=
Date: Sat, 25 Jul 2026 19:33:36 -0700
To: mm-commits@vger.kernel.org,skinsburskii@gmail.com,leon@kernel.org,jgg@nvidia.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hmmc-fix-build-with-config_mmu_notifier=n.patch added to mm-unstable branch
Message-Id: <20260726023337.492591F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hmm.c: fix build with CONFIG_MMU_NOTIFIER=n
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hmmc-fix-build-with-config_mmu_notifier=n.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hmmc-fix-build-with-config_mmu_notifier=n.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/hmm.c: fix build with CONFIG_MMU_NOTIFIER=n
Date: Sat Jul 25 07:12:21 PM PDT 2026

With microblaze
https://download.01.org/0day-ci/archive/20260702/202607021433.DYT5fDqE-lkp@intel.com/config
(CONFIG_MMU_NOTIFIER=n):

mm/hmm.c: In function 'hmm_range_fault_unlocked_timeout':
mm/hmm.c:804:25: error: implicit declaration of function 'mmu_interval_read_begin'; did you mean 'mmu_interval_check_retry'? [-Wimplicit-function-declaration]
  804 |                         mmu_interval_read_begin(range->notifier);
      |                         ^~~~~~~~~~~~~~~~~~~~~~~
      |                         mmu_interval_check_retry


Cc: Stanislav Kinsburskii <skinsburskii@gmail.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmu_notifier.h |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/include/linux/mmu_notifier.h~mm-hmmc-fix-build-with-config_mmu_notifier=n
+++ a/include/linux/mmu_notifier.h
@@ -576,6 +576,19 @@ static inline void _mmu_notifier_range_i
 	_mmu_notifier_range_init(range, start, end)
 
 static inline bool
+mmu_interval_check_retry(struct mmu_interval_notifier *interval_sub,
+			 unsigned long seq)
+{
+	return true;
+}
+
+static inline unsigned long
+mmu_interval_read_begin(struct mmu_interval_notifier *interval_sub)
+{
+	return 0;
+}
+
+static inline bool
 mmu_notifier_range_blockable(const struct mmu_notifier_range *range)
 {
 	return true;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-mincore-use-walk_page_range_vma-in-do_mincore-fix.patch
csky-implement-flush_cache_vmap-in-c.patch
mm-annotate-data-race-in-cpu_needs_drain-fix.patch
mm-zsmalloc-encode-class-index-in-obj-value-for-lockless-class-lookup-fix.patch
mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix.patch
mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix-fix.patch
mm-rmap-use-huge_ptep_get-in-try_to_migrate_one-checkpatch-fixes.patch
mm-mprotect-use-huge_ptep_get-for-hugetlb-fix.patch
mm-drop-stale-folio_ref_count==1-check-in-do_swap_page-reuse-logic-fix.patch
alloc_tag-add-ioctl-to-proc-allocinfo-fix.patch
mm-hmmc-fix-build-with-config_mmu_notifier=n.patch
mm-vma-add-and-use-vma__pgoff-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch


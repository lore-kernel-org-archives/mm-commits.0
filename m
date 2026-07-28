Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA62617A2E8
	for <mm-commits@vger.kernel.org>; Tue, 28 Jul 2026 00:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785198637; cv=none; b=oYnuqf8GuR/DrmLnGg0xiTunpJhA/cQfHX8nKU1RJ6zsV+fHCTUdJ32CswkQoJA+MyJfIZ0i97a8sSZ8rHBB39EcwNm+YKr6nCWln/QgisCxfK1qLs9/mLiZXcLlvsKqAHZPENo/8MsxFcLEjClyHcirerZqiztf2d2CqDicnfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785198637; c=relaxed/simple;
	bh=qmisD4mSdfvoXR1b9UJ3DszXkzskLZ/MzeIXYN2xLR8=;
	h=Date:To:From:Subject:Message-Id; b=lTGl+QBlCKWPTqZ4k5g+02I5/GkQy+WZ8qqKQE9szn92GOlN5GQtRoyJNqK9cv8alq/BgXzuL+9Y9NAyzCNNKHaKECFS0QvLn6jfGUBkBdVAwrRBbMQQ8F73jRgUzd0Fjv4YdR+sU3soCHbiWPuwHP7WJe1QQiMRcNUW+R84x8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p63BhfI2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p63BhfI2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C5631F000E9;
	Tue, 28 Jul 2026 00:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785198635;
	bh=7PkkFPT0Awj5oEeY2NZE2RGLTPXRIxWbb+WbIBCTPqg=;
	h=Date:To:From:Subject;
	b=p63BhfI2fdgsZuoVYQIkpVZBHVZd4TqKK1dlPGy3DDAA2NYSG6ByXbLaqtlF9GlFD
	 rlMwcKNqtqLdtrUaAa1ZFZ/m0Hb17qlX+dWAqxrHtAMnQ9YgJKVJe53YU7TtPNEtIC
	 omC+Cr5wALZ342jn55L8jmzJfgzHCk/UK+0b3CWA=
Date: Mon, 27 Jul 2026 17:30:34 -0700
To: mm-commits@vger.kernel.org,skinsburskii@gmail.com,leon@kernel.org,jgg@nvidia.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-hmmc-fix-build-with-config_mmu_notifier=n.patch removed from -mm tree
Message-Id: <20260728003035.3C5631F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hmm.c: fix build with CONFIG_MMU_NOTIFIER=n
has been removed from the -mm tree.  Its filename was
     mm-hmmc-fix-build-with-config_mmu_notifier=n.patch

This patch was dropped because an updated version will be issued

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
mm-vma-add-and-use-vma__pgoff-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch


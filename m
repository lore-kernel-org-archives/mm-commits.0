Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1863B1C5D5E
	for <mm-commits@vger.kernel.org>; Sun, 11 Oct 2026 05:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791697012; cv=none; b=OxC300CsN5NMyW/D/nd35XEzMbbO6ppLbNB7kT2oZCNRgMVaV1XnbdkHQ7uK6blOuZ08L4F7yS/JrJpRsLsMbFVTXGyBKruUTkh8PCtRS5uO+rEkvdX65buq2xHiAgBB4S0CVA3uiuwJQFA6eMLKruT+dB9CFuHDnEs8cD/SHyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791697012; c=relaxed/simple;
	bh=FtW2iPKzocwuP0jHHd9u9ftFqG4BjhPxxmnGrO7Y5mA=;
	h=Date:To:From:Subject:Message-Id; b=t22aWdP2gVS0KXkD+XOxEzP5+RxYKNnm5xNPMjJVuEmbwGlzBapto5He60rJvpErHFT4FlAxoQ67KBXqTurdslVk0T5gpN7XA1u+0MXABfqqZM92kElvACot/p7/syAGt9di++kDIp/hrQqtNiO1P/L7OX8r+oPTxaKVzzc6zxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QOBp1Mos; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QOBp1Mos"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 838D61F0089B;
	Sun, 11 Oct 2026 05:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791697010;
	bh=2p+phjvIfBWvXzeETLctiILSsA/OiSs65TSoW5G6tq0=;
	h=Date:To:From:Subject;
	b=QOBp1MosugDIVyYX/owmx/Y2P9d65Jv9yswnHoWEA/FaitLcsxErjuH6nhxDTQp/T
	 4W5fgAbN9hs1A7lCtPJQsO/JnWaczM1NONYf9anRMoOca5T4GKrzW4XyGZplgcLnqu
	 8c43HOzG2PcEH9X2OKjAobBFBsA8voYl0YPnS8kA=
Date: Sat, 10 Oct 2026 22:36:49 -0700
To: mm-commits@vger.kernel.org,yi1.lai@intel.com,usama.arif@linux.dev,hughd@google.com,baolin.wang@linux.alibaba.com,qi.zheng@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-assign-a-lock-class-to-the-unused-huge-shrinklist.patch added to mm-new branch
Message-Id: <20261011053650.838D61F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shmem: assign a lock class to the unused huge shrinklist
has been added to the -mm mm-new branch.  Its filename is
     mm-shmem-assign-a-lock-class-to-the-unused-huge-shrinklist.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-assign-a-lock-class-to-the-unused-huge-shrinklist.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Qi Zheng <qi.zheng@linux.dev>
Subject: mm: shmem: assign a lock class to the unused huge shrinklist
Date: Sun, 11 Oct 2026 12:59:56 +0800

The unused huge shrinklist shares the default list_lru lock class with the
dentry LRU.  Although they use distinct lock instances, lockdep conflates
their dependencies and reports a circular locking dependency:

	WARNING: possible circular locking dependency detected

Give the unused huge shrinklist a dedicated lock class to fix this
false-positive lockdep warning.

Link: https://lore.kernel.org/20261011045956.30277-1-qi.zheng@linux.dev
Fixes: b9b1861d4f7a ("mm: shmem: make unused huge shrinker memcg aware")
Signed-off-by: Qi Zheng <qi.zheng@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: kernel test robot <yi1.lai@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202610091403.d1d8080b-lkp@intel.com
Cc: Hugh Dickins <hughd@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Usama Arif <usama.arif@linux.dev>
---

 mm/shmem.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/shmem.c~mm-shmem-assign-a-lock-class-to-the-unused-huge-shrinklist
+++ a/mm/shmem.c
@@ -5161,6 +5161,9 @@ static const struct dentry_operations sh
 
 static int shmem_fill_super(struct super_block *sb, struct fs_context *fc)
 {
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	static struct lock_class_key shmem_unused_huge_lock_key;
+#endif
 	struct shmem_options *ctx = fc->fs_private;
 	struct inode *inode;
 	struct shmem_sb_info *sbinfo;
@@ -5239,7 +5242,8 @@ static int shmem_fill_super(struct super
 		goto failed;
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (list_lru_init_memcg(&sbinfo->shrinklist, sb->s_shrink))
+	if (list_lru_init_memcg_key(&sbinfo->shrinklist, sb->s_shrink,
+				    &shmem_unused_huge_lock_key))
 		goto failed;
 #endif
 
_

Patches currently in -mm which might be from qi.zheng@linux.dev are

mm-shmem-assign-a-lock-class-to-the-unused-huge-shrinklist.patch


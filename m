Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B0C486B90
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791866059; cv=none; b=rQlkbOcE+3k9WGacqDtRgP09V6etpLLReXEyU3ZN13LxScDmzXLCWyFTYd1OTCzR/TG8oThWFKpWX4HgSbgdU5cJcNeXC/HL2yXE3NZn9R+Z/WI+RWboXcqjMa9HXb6lcbIF1XHQBSiJiMfZ8U046Fg+z7x6yk/HaieEZEnEdIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791866059; c=relaxed/simple;
	bh=lN20/N8vS+Ywl4PfiQejjW4PrJAscIkcaoECDjhN10A=;
	h=Date:To:From:Subject:Message-Id; b=Uv74gibYElh4Nfy+M+NubiCY8g+NRfwwTzJkPFROW9V5Rcl/JbkzUMkTVWTjQwUiRQmaOKZ3PXB5PQuHWdFyi+kLY3/1ejuzbaewdoIJJLPDx+gLEUDYhBHNaKKZuPp/Rk9ziqM8pcvugHXubMsWo7s+HemdRWg/7vU63PSsoqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=euD/zQP2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="euD/zQP2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42B7B1F0089A;
	Tue, 13 Oct 2026 04:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791866054;
	bh=316xhpP7PQl/KvpfHqYUpexXJUn0Qc2qaMv7qnMbvFA=;
	h=Date:To:From:Subject;
	b=euD/zQP2QAJZahU/QCCQ5QME/aE9CPnUf5gSfHHLzuEPjoF9iuBSoDGNgSEglbCjo
	 XxHivimo8DpKorQIce2//9s5eQn94KX2WuPDBL91mMXR5hzUUIqAx/J2RR3BWpjqEq
	 h6UtTsNXQfdeC58z/zWHkziHBdQjm2dW5swVXHk8=
Date: Mon, 12 Oct 2026 21:34:13 -0700
To: mm-commits@vger.kernel.org,yi1.lai@intel.com,usama.arif@linux.dev,hughd@google.com,baolin.wang@linux.alibaba.com,qi.zheng@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-assign-a-lock-class-to-the-unused-huge-shrinklist.patch removed from -mm tree
Message-Id: <20261013043414.42B7B1F0089A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: assign a lock class to the unused huge shrinklist
has been removed from the -mm tree.  Its filename was
     mm-shmem-assign-a-lock-class-to-the-unused-huge-shrinklist.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -5160,6 +5160,9 @@ static const struct dentry_operations sh
 
 static int shmem_fill_super(struct super_block *sb, struct fs_context *fc)
 {
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	static struct lock_class_key shmem_unused_huge_lock_key;
+#endif
 	struct shmem_options *ctx = fc->fs_private;
 	struct inode *inode;
 	struct shmem_sb_info *sbinfo;
@@ -5238,7 +5241,8 @@ static int shmem_fill_super(struct super
 		goto failed;
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (list_lru_init_memcg(&sbinfo->shrinklist, sb->s_shrink))
+	if (list_lru_init_memcg_key(&sbinfo->shrinklist, sb->s_shrink,
+				    &shmem_unused_huge_lock_key))
 		goto failed;
 #endif
 
_

Patches currently in -mm which might be from qi.zheng@linux.dev are



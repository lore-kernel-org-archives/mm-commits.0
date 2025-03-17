Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0068634E
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188547; cv=none; b=AQfXwAks7bbV0zhQgdJ7jBaTi4L6BRB2nWzlqjp3Q2pa6OfnOp7FAkVGbbzJ5r8BWtdtYcuvQ02lO0bCF5MO8tcT+qZwBgKQK4fYZImEKRvKBJ4EipMrDXgjPgYPEg0QGQWKEOZY2aPHN9DMGGJITULPvwVNM3s5egPgb4L0+Mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188547; c=relaxed/simple;
	bh=C9nysCUgskktGlM/WcFD3NAc/SZ6S7f5DKl0xwf5ZMk=;
	h=Date:To:From:Subject:Message-Id; b=GEMmx8FqR4oKji5ePLleFrYN34PTSDjl63zlMPE+zFsaLLVRL0e/7plSPCB3ucMw7PuvxWFHV/rxcbhXtO2duuGodCmQcHJYBbmG7cQHdDquHD+UnmnJ2e3Tya3bmYE+8oUm67obsb737nrco+qIleClIEQ6iDUOM0KHSVtgHQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l74yr2Fy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l74yr2Fy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0B39C4CEEC;
	Mon, 17 Mar 2025 05:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188547;
	bh=C9nysCUgskktGlM/WcFD3NAc/SZ6S7f5DKl0xwf5ZMk=;
	h=Date:To:From:Subject:From;
	b=l74yr2FyPmgB8Lesdkob75w2vNnoxJO9uV/yk9lE0mpkbgdne/8UK22z74PEMien6
	 vhTbnKB8PQ5DZKgdaheiBScQSp16pmh0z8hkpmH+3AvjLvz2nptZ9SkOQtZ7dIHUaR
	 8CPbFPVRFqs7WV9j56Co5D+Yls7J9UNhHF/VAg/4=
Date: Sun, 16 Mar 2025 22:15:47 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,roman.gushchin@linux.dev,muchun.song@linux.dev,david@fromorbit.com,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shrinker-fix-name-consistency-issue-in-shrinker_debugfs_rename.patch removed from -mm tree
Message-Id: <20250317051547.B0B39C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/shrinker: fix name consistency issue in shrinker_debugfs_rename()
has been removed from the -mm tree.  Its filename was
     mm-shrinker-fix-name-consistency-issue-in-shrinker_debugfs_rename.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liu Ye <liuye@kylinos.cn>
Subject: mm/shrinker: fix name consistency issue in shrinker_debugfs_rename()
Date: Wed, 5 Mar 2025 15:17:59 +0800

After calling debugfs_change_name function, the return value should be
checked and the old name restored.  If debugfs_change_name fails, the new
name memory should be freed.  The effect is that the shrinker->name is not
consistent with the name displayed in debugfs.

Link: https://lkml.kernel.org/r/20250305071759.661055-1-liuye@kylinos.cn
Signed-off-by: Liu Ye <liuye@kylinos.cn>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by：Qi Zheng <zhengqi.arch@bytedance.co
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shrinker_debug.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/shrinker_debug.c~mm-shrinker-fix-name-consistency-issue-in-shrinker_debugfs_rename
+++ a/mm/shrinker_debug.c
@@ -214,10 +214,14 @@ int shrinker_debugfs_rename(struct shrin
 	ret = debugfs_change_name(shrinker->debugfs_entry, "%s-%d",
 			shrinker->name, shrinker->debugfs_id);
 
+	if (ret) {
+		shrinker->name = old;
+		kfree_const(new);
+	} else {
+		kfree_const(old);
+	}
 	mutex_unlock(&shrinker_mutex);
 
-	kfree_const(old);
-
 	return ret;
 }
 EXPORT_SYMBOL(shrinker_debugfs_rename);
_

Patches currently in -mm which might be from liuye@kylinos.cn are

mm-vmalloc-refactoring-function-__vmalloc_node_range_noprof.patch
mm-debug-add-line-breaks.patch


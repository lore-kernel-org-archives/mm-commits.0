Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6532114386D
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854751; cv=none; b=C+DReHGqaxkL5WuqS6m/p2nBEsuB82tfQawbEjlj4joAbxmBFGCZhFnHne7vqPRWkZpeAro95IAEg0zlRz30kmKxnyGFtl1zTJBfAbilPdJ3zIPHCYtnqzNeyjn/i+nLlKkfi+4fBOH0x9OS2ANxQlX+viuQUb9/ch9Svd70Jds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854751; c=relaxed/simple;
	bh=nKDfOWTJ8TuKu52M+Z8w5uUmOTsQpuuLbp3KzfAGl3w=;
	h=Date:To:From:Subject:Message-Id; b=pk3QT2nCx/fcf14mc0e0k7sszIWCUdxC276OX2nZO9tJTxYNZzJjbfG6YC17MUzAIVmFDQVPseVc/9Z8XVem8jiXZkE5U37YJzsgqGu1Is2M2l+mSipz5nf6xpMqSTXP0NG/XPLS74JmJquf5olF26vV88YxRm9fbjGLAL1PXv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rC326HqK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rC326HqK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30358C4CECF;
	Wed,  6 Nov 2024 00:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854751;
	bh=nKDfOWTJ8TuKu52M+Z8w5uUmOTsQpuuLbp3KzfAGl3w=;
	h=Date:To:From:Subject:From;
	b=rC326HqKCOjiKFFUvaPikiPdZ+8D/rcBnS61lXBrpVjYd+lgKQ2CH7Qf2hrDauiRj
	 1ze5mQ/H7bxafBNtR7W7gIfRSz7CB+WfyZFP+kjQ/UU98smbMS0Q6W/ywZfsk7Jn+V
	 eNJkzcsPKGS24xp58rgNqIBC+xj71pyCa4SJV5mE=
Date: Tue, 05 Nov 2024 16:59:10 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,willy@infradead.org,wajdi.k.feghali@intel.com,usamaarif642@gmail.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,nphamcs@gmail.com,nanhai.zou@intel.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,21cnbao@gmail.com,kanchana.p.sridhar@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-modify-zswap_stored_pages-to-be-atomic_long_t.patch removed from -mm tree
Message-Id: <20241106005911.30358C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: modify zswap_stored_pages to be atomic_long_t
has been removed from the -mm tree.  Its filename was
     mm-zswap-modify-zswap_stored_pages-to-be-atomic_long_t.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Subject: mm: zswap: modify zswap_stored_pages to be atomic_long_t
Date: Mon, 30 Sep 2024 22:32:20 -0700

For zswap_store() to support large folios, we need to be able to do a
batch update of zswap_stored_pages upon successful store of all pages in
the folio.  For this, we need to add folio_nr_pages(), which returns a
long, to zswap_stored_pages.

Link: https://lkml.kernel.org/r/20241001053222.6944-6-kanchana.p.sridhar@intel.com
Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Wajdi Feghali <wajdi.k.feghali@intel.com>
Cc: "Zou, Nanhai" <nanhai.zou@intel.com>
Cc: Barry Song <21cnbao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/meminfo.c     |    2 +-
 include/linux/zswap.h |    2 +-
 mm/zswap.c            |   19 +++++++++++++------
 3 files changed, 15 insertions(+), 8 deletions(-)

--- a/fs/proc/meminfo.c~mm-zswap-modify-zswap_stored_pages-to-be-atomic_long_t
+++ a/fs/proc/meminfo.c
@@ -91,7 +91,7 @@ static int meminfo_proc_show(struct seq_
 #ifdef CONFIG_ZSWAP
 	show_val_kb(m, "Zswap:          ", zswap_total_pages());
 	seq_printf(m,  "Zswapped:       %8lu kB\n",
-		   (unsigned long)atomic_read(&zswap_stored_pages) <<
+		   (unsigned long)atomic_long_read(&zswap_stored_pages) <<
 		   (PAGE_SHIFT - 10));
 #endif
 	show_val_kb(m, "Dirty:          ",
--- a/include/linux/zswap.h~mm-zswap-modify-zswap_stored_pages-to-be-atomic_long_t
+++ a/include/linux/zswap.h
@@ -7,7 +7,7 @@
 
 struct lruvec;
 
-extern atomic_t zswap_stored_pages;
+extern atomic_long_t zswap_stored_pages;
 
 #ifdef CONFIG_ZSWAP
 
--- a/mm/zswap.c~mm-zswap-modify-zswap_stored_pages-to-be-atomic_long_t
+++ a/mm/zswap.c
@@ -43,7 +43,7 @@
 * statistics
 **********************************/
 /* The number of compressed pages currently stored in zswap */
-atomic_t zswap_stored_pages = ATOMIC_INIT(0);
+atomic_long_t zswap_stored_pages = ATOMIC_INIT(0);
 
 /*
  * The statistics below are not protected from concurrent access for
@@ -802,7 +802,7 @@ static void zswap_entry_free(struct zswa
 		obj_cgroup_put(entry->objcg);
 	}
 	zswap_entry_cache_free(entry);
-	atomic_dec(&zswap_stored_pages);
+	atomic_long_dec(&zswap_stored_pages);
 }
 
 /*********************************
@@ -1233,7 +1233,7 @@ static unsigned long zswap_shrinker_coun
 		nr_stored = memcg_page_state(memcg, MEMCG_ZSWAPPED);
 	} else {
 		nr_backing = zswap_total_pages();
-		nr_stored = atomic_read(&zswap_stored_pages);
+		nr_stored = atomic_long_read(&zswap_stored_pages);
 	}
 
 	if (!nr_stored)
@@ -1502,7 +1502,7 @@ bool zswap_store(struct folio *folio)
 	}
 
 	/* update stats */
-	atomic_inc(&zswap_stored_pages);
+	atomic_long_inc(&zswap_stored_pages);
 	count_vm_event(ZSWPOUT);
 
 	return true;
@@ -1651,6 +1651,13 @@ static int debugfs_get_total_size(void *
 }
 DEFINE_DEBUGFS_ATTRIBUTE(total_size_fops, debugfs_get_total_size, NULL, "%llu\n");
 
+static int debugfs_get_stored_pages(void *data, u64 *val)
+{
+	*val = atomic_long_read(&zswap_stored_pages);
+	return 0;
+}
+DEFINE_DEBUGFS_ATTRIBUTE(stored_pages_fops, debugfs_get_stored_pages, NULL, "%llu\n");
+
 static int zswap_debugfs_init(void)
 {
 	if (!debugfs_initialized())
@@ -1674,8 +1681,8 @@ static int zswap_debugfs_init(void)
 			   zswap_debugfs_root, &zswap_written_back_pages);
 	debugfs_create_file("pool_total_size", 0444,
 			    zswap_debugfs_root, NULL, &total_size_fops);
-	debugfs_create_atomic_t("stored_pages", 0444,
-				zswap_debugfs_root, &zswap_stored_pages);
+	debugfs_create_file("stored_pages", 0444,
+			    zswap_debugfs_root, NULL, &stored_pages_fops);
 
 	return 0;
 }
_

Patches currently in -mm which might be from kanchana.p.sridhar@intel.com are



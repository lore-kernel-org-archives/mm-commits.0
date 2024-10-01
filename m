Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 915301CDA29
	for <mm-commits@vger.kernel.org>; Tue,  1 Oct 2024 22:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727820802; cv=none; b=Rl3hasN3MNehH7NqzYioI29sK6YYZWSEy0JVbTs5YsiEM8iFLDqXRzCH8Y8k1yrnjpEWZgQSLnw7jn1YirxXmpQM2fnIryA1UvvHAtAqMU/EDSLFrfQndfz9pIhmM1rTHLJ8B23/X3pAjah3Krp61WFDKVAjEvTk0h9ac34v56M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727820802; c=relaxed/simple;
	bh=IDstN8G6yz9M1nVvXe23IhUIeBnXGiSJROlbVhINeng=;
	h=Date:To:From:Subject:Message-Id; b=llUfAbWfwYPBtt1CKsdjoPIF4/d4/r/YKg0JBGPu5HG+J6TBuRQERvaaeG9HyT9KF8Shp8ntpA2uIFcHBEiz8/fxLOjH5x1DWnWYkkv+chyyxNm+bOF1X4Tv/bgT0z8cznDBatgZqSMzQkHM9icZWMZIVCKEdzN1mxT1k/i0hA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XAFHOt3y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XAFHOt3y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A6CAC4CEC6;
	Tue,  1 Oct 2024 22:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727820802;
	bh=IDstN8G6yz9M1nVvXe23IhUIeBnXGiSJROlbVhINeng=;
	h=Date:To:From:Subject:From;
	b=XAFHOt3yK+zDNF94uR+Q+as/djXY95q2qd+hyUXzCLMek6k0TW/Khs2y6A5A7BBmC
	 d4XtjKc0K5Qp8NvI1UeftEXIyF8f9xTwtG8LM+zCuNq3ok5lc1mM3OI0BZ39w+coBx
	 l+Dv2Mg856UE4e60QBH2L4G3JXdwGSHoISYIr59E=
Date: Tue, 01 Oct 2024 15:13:21 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,willy@infradead.org,wajdi.k.feghali@intel.com,usamaarif642@gmail.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,nphamcs@gmail.com,nanhai.zou@intel.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,kanchana.p.sridhar@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-modify-zswap_stored_pages-to-be-atomic_long_t.patch added to mm-unstable branch
Message-Id: <20241001221322.3A6CAC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: modify zswap_stored_pages to be atomic_long_t.
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-modify-zswap_stored_pages-to-be-atomic_long_t.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-modify-zswap_stored_pages-to-be-atomic_long_t.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Subject: mm: zswap: modify zswap_stored_pages to be atomic_long_t.
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
@@ -1232,7 +1232,7 @@ static unsigned long zswap_shrinker_coun
 		nr_stored = memcg_page_state(memcg, MEMCG_ZSWAPPED);
 	} else {
 		nr_backing = zswap_total_pages();
-		nr_stored = atomic_read(&zswap_stored_pages);
+		nr_stored = atomic_long_read(&zswap_stored_pages);
 	}
 
 	if (!nr_stored)
@@ -1501,7 +1501,7 @@ bool zswap_store(struct folio *folio)
 	}
 
 	/* update stats */
-	atomic_inc(&zswap_stored_pages);
+	atomic_long_inc(&zswap_stored_pages);
 	count_vm_event(ZSWPOUT);
 
 	return true;
@@ -1650,6 +1650,13 @@ static int debugfs_get_total_size(void *
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
@@ -1673,8 +1680,8 @@ static int zswap_debugfs_init(void)
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

mm-define-obj_cgroup_get-if-config_memcg-is-not-defined.patch
mm-zswap-modify-zswap_compress-to-accept-a-page-instead-of-a-folio.patch
mm-zswap-rename-zswap_pool_get-to-zswap_pool_tryget.patch
mm-change-count_objcg_event-to-count_objcg_events-for-batch-event-updates.patch
mm-zswap-modify-zswap_stored_pages-to-be-atomic_long_t.patch
mm-zswap-support-large-folios-in-zswap_store.patch
mm-swap-count-successful-large-folio-zswap-stores-in-hugepage-zswpout-stats.patch


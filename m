Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53AAC2EB874
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334234; cv=none; b=N1kDwAH7YHsDqqOo08spqUcdjyv7m1yyjWORLX4KzS8Lj/JFYw5HnWvIJpEkPISL98j1AJRaJUnSAsoYZP//wLP8b+suiKXS/E5Vw5OXi6jtZRRs9f/F3vC0CoOEhiKyJizCaST0K2jj0o+Mirm2xFR6AiSgT3pOrDoShcMlA+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334234; c=relaxed/simple;
	bh=k2iCUuyDJF+tyg1baA5vrZTODrnSy8yGvT3C+xQkQCo=;
	h=Date:To:From:Subject:Message-Id; b=jCwqDj0kdeaS99bU4qW3UYj+LyuWy1dtySV/XJJ0OLTf447y1rH+nfCQ8yCC06YKFUO320ibrHG/9HuQ8JQLHfQeJrlvueO0zQD4S33vnhzdh0yiJ3pD51633JMawTEYNOZQtMT1mljgisZQCEelZdMrk1z8Dyr9v52A517i2XU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cTrIae/q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cTrIae/q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 290AA1F0089B;
	Wed,  7 Oct 2026 00:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334233;
	bh=rxeeTqze11wRDO2LVEoqDWxgwbOvP2C9U4kq9tP1nZE=;
	h=Date:To:From:Subject;
	b=cTrIae/q6BAp3C1VBifkFPhL11LvvOXpEX/oG9l9nHsiQiWpsfhJDyTOb9c3l/k5f
	 rfDMkj/WfMuaj+Iondmrz1ijF2szSgV7TaNbHhEkRxCSzzR5XIdQerCk24cx0GKw2m
	 GtSIrBEEtcqdAh4kLwqmsYfpM88sKYGsfet1VpmY=
Date: Tue, 06 Oct 2026 17:50:32 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,ljs@kernel.org,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-rename-__swap_writepage-to-__swap_writeout.patch removed from -mm tree
Message-Id: <20261007005033.290AA1F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/swap: rename __swap_writepage() to __swap_writeout()
has been removed from the -mm tree.  Its filename was
     mm-swap-rename-__swap_writepage-to-__swap_writeout.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tal Zussman <tz2294@columbia.edu>
Subject: mm/swap: rename __swap_writepage() to __swap_writeout()
Date: Sat, 29 Aug 2026 15:09:05 -0400

Commit 84798514db50 ("mm: Remove swap_writepage() and shmem_writepage()")
renamed swap_writepage() to swap_writeout().  Rename __swap_writepage(),
which operates on a folio, to match its caller.  Update a stale reference
to swap_writepage() in swapfile.c as well.

Link: https://lore.kernel.org/20260829-b4-page_io-folios-v2-6-649728091117@columbia.edu
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---

 mm/page_io.c  |    4 ++--
 mm/swap.h     |    2 +-
 mm/swapfile.c |    2 +-
 mm/zswap.c    |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

--- a/mm/page_io.c~mm-swap-rename-__swap_writepage-to-__swap_writeout
+++ a/mm/page_io.c
@@ -248,7 +248,7 @@ int swap_writeout(struct swap_io_ctx *ct
 	}
 	rcu_read_unlock();
 
-	__swap_writepage(ctx, folio);
+	__swap_writeout(ctx, folio);
 	return 0;
 out_unlock:
 	folio_unlock(folio);
@@ -369,7 +369,7 @@ static void swap_add_folio(struct swap_i
 	}
 }
 
-void __swap_writepage(struct swap_io_ctx *ctx, struct folio *folio)
+void __swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 {
 	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
 
--- a/mm/swapfile.c~mm-swap-rename-__swap_writepage-to-__swap_writeout
+++ a/mm/swapfile.c
@@ -2928,7 +2928,7 @@ EXPORT_SYMBOL_GPL(add_swap_extent);
 /*
  * A `swap extent' is a simple thing which maps a contiguous range of pages
  * onto a contiguous range of disk blocks.  A rbtree of swap extents is
- * built at swapon time and is then used at swap_writepage/swap_read_folio
+ * built at swapon time and is then used at swap_writeout/swap_read_folio
  * time for locating where on disk a page belongs.
  *
  * If the swapfile is an S_ISBLK block device, a single extent is installed.
--- a/mm/swap.h~mm-swap-rename-__swap_writepage-to-__swap_writeout
+++ a/mm/swap.h
@@ -258,7 +258,7 @@ void swap_read_folio(struct swap_io_ctx
 void swap_read_submit(struct swap_io_ctx *ctx);
 void swap_write_submit(struct swap_io_ctx *ctx);
 int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio);
-void __swap_writepage(struct swap_io_ctx *ctx, struct folio *folio);
+void __swap_writeout(struct swap_io_ctx *ctx, struct folio *folio);
 
 /* linux/mm/swap_state.c */
 extern struct address_space swap_space __read_mostly;
--- a/mm/zswap.c~mm-swap-rename-__swap_writepage-to-__swap_writeout
+++ a/mm/zswap.c
@@ -1037,7 +1037,7 @@ static int zswap_writeback_entry(struct
 	folio_set_reclaim(folio);
 
 	/* start writeback */
-	__swap_writepage(&ctx, folio);
+	__swap_writeout(&ctx, folio);
 	swap_write_submit(&ctx);
 
 out:
_

Patches currently in -mm which might be from tz2294@columbia.edu are

mm-remove-pagewriteback.patch
mm-swap-add-folio_swap_entry-and-folio_page_swap_entry.patch
mm-swap-add-folio_swap_entry-and-folio_page_swap_entry-fix.patch
mm-huge_memory-add-a-comment-to-the-open-coded-swap-entry.patch
mm-rmap-use-folio_page_swap_entry-in-ttu_anon_swapbacked_folio.patch
mm-zswap-use-folio_swap_entry-in-zswap_store_page.patch
mm-swapfile-use-folio_page_swap_entry.patch
arm64-mte-make-mte_save_tags-and-mte_restore_tags-static.patch
arm64-mte-pass-the-swap-entry-to-mte_save_tags.patch
mm-swap-remove-page_swap_entry.patch
mm-memcontrol-take-a-const-folio-in-folio_memcg-and-friends.patch
mm-memcontrol-constify-obj_cgroup_memcg-and-friends.patch
mm-memcontrol-constify-the-lruvec-helpers.patch
mm-page_io-take-a-const-folio-in-bio_associate_blkg_from_folio.patch
mm-memcontrol-constify-the-mem_cgroup-accessors.patch
mm-page_counter-constify-page_counter_read-and-page_counter_margin.patch
mm-memcontrol-constify-the-reclaim-protection-helpers.patch
mm-memcontrol-constify-the-memcg-and-lruvec-stat-readers.patch
mm-memcontrol-constify-the-swap-accounting-helpers.patch
mm-memcontrol-constify-mem_cgroup_swappiness-and-mem_cgroup_get_max.patch
mm-memcontrol-constify-the-zswap-and-socket-pressure-helpers.patch
vmcore-convert-mmap_vmcore_fault-to-use-folios.patch


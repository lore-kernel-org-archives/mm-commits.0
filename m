Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51E72F852
	for <mm-commits@vger.kernel.org>; Tue, 19 Aug 2025 02:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755571700; cv=none; b=Eg8R7sTxiarYcSHRA3J/NgTGXQ5qnQo2XfdrOYtiOeMkUw6KEAfYtK3uIxNg6gK9B6cyJD2CYJzyjPEfC8tsON+J0aRTPKVvr6D5VI3qP7f6AU5ag+TztnOjQi5iLJTQd7QvKZzQ2qDVYTAS/+Z0GRoqGwEjn4wgBIgGMSSy1cQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755571700; c=relaxed/simple;
	bh=/RUrk3YdI2H177QkgflQuE8/S7pDW+qEcNKkW5wSvN0=;
	h=Date:To:From:Subject:Message-Id; b=t5qS+xLTWgpChv+JjTvFs3pQKvgv7bASY2HOUPRXwtlnL+EnffVmFQw0jzCQa59emqPJ2GHRJQEbyi+Bn3g50cJUexqM4QZgWPcC24+rc2GtbDyfBetUR+dLUPZ8Bm6o9sDdB8/k16XKQh4pl+j3vF5+BojDoJyJSuW1GVhiosQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0JG3rwE+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0JG3rwE+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 401CAC4CEED;
	Tue, 19 Aug 2025 02:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755571700;
	bh=/RUrk3YdI2H177QkgflQuE8/S7pDW+qEcNKkW5wSvN0=;
	h=Date:To:From:Subject:From;
	b=0JG3rwE+zcqRcC0cM+4Wq4J1uHUHsOiakBxyH88t4tXGSA4xCoCesS4RKClDPk+/k
	 qy+T4IfS7l29OxRnSaYHp4+mSnBoNUqJjOi9ZNL2twJXCscCHxAXP6gLpB4xbvj8WP
	 B+32OCbk6kNDn4XLTWs5qgzUJcSbr3JvJsSN+Sy4=
Date: Mon, 18 Aug 2025 19:48:19 -0700
To: mm-commits@vger.kernel.org,wqu@suse.com,willy@infradead.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,josef@toxicpanda.com,hannes@cmpxchg.org,dsterba@suse.com,clm@fb.com,boris@bur.io,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-vmstat-for-cgroup-uncharged-pages.patch added to mm-new branch
Message-Id: <20250819024820.401CAC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add vmstat for cgroup uncharged pages
has been added to the -mm mm-new branch.  Its filename is
     mm-add-vmstat-for-cgroup-uncharged-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-vmstat-for-cgroup-uncharged-pages.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Boris Burkov <boris@bur.io>
Subject: mm: add vmstat for cgroup uncharged pages
Date: Mon, 18 Aug 2025 17:36:54 -0700

Uncharged pages are tricky to track by their essential "uncharged" nature.
To maintain good accounting, introduce a vmstat counter tracking all
uncharged pages.  Since this is only meaningful when cgroups are
configured, only expose the counter when CONFIG_MEMCG is set.

Confirmed that these work as expected at a high level by mounting a btrfs
using AS_UNCHARGED for metadata pages, and seeing the counter rise with fs
usage then go back to a minimal level after drop_caches and finally down
to 0 after unmounting the fs.

Link: https://lkml.kernel.org/r/04b3a5c9944d79072d752c85dac1294ca9bee183.1755562487.git.boris@bur.io
Signed-off-by: Boris Burkov <boris@bur.io>
Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Tested-by: syzbot@syzkaller.appspotmail.com
Cc: Chris Mason <clm@fb.com>
Cc: David Sterba <dsterba@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qu Wenruo <wqu@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    3 +++
 mm/filemap.c           |   17 +++++++++++++++++
 mm/vmstat.c            |    3 +++
 3 files changed, 23 insertions(+)

--- a/include/linux/mmzone.h~mm-add-vmstat-for-cgroup-uncharged-pages
+++ a/include/linux/mmzone.h
@@ -259,6 +259,9 @@ enum node_stat_item {
 	NR_HUGETLB,
 #endif
 	NR_BALLOON_PAGES,
+#ifdef CONFIG_MEMCG
+	NR_UNCHARGED_FILE_PAGES,
+#endif
 	NR_VM_NODE_STAT_ITEMS
 };
 
--- a/mm/filemap.c~mm-add-vmstat-for-cgroup-uncharged-pages
+++ a/mm/filemap.c
@@ -146,6 +146,19 @@ static void page_cache_delete(struct add
 	mapping->nrpages -= nr;
 }
 
+#ifdef CONFIG_MEMCG
+static void filemap_mod_uncharged_vmstat(struct folio *folio, int sign)
+{
+	long nr = folio_nr_pages(folio) * sign;
+
+	mod_node_page_state(folio_pgdat(folio), NR_UNCHARGED_FILE_PAGES, nr);
+}
+#else
+static void filemap_mod_uncharged_vmstat(struct folio *folio, int sign)
+{
+}
+#endif
+
 static void filemap_unaccount_folio(struct address_space *mapping,
 		struct folio *folio)
 {
@@ -190,6 +203,8 @@ static void filemap_unaccount_folio(stru
 		__lruvec_stat_mod_folio(folio, NR_FILE_THPS, -nr);
 		filemap_nr_thps_dec(mapping);
 	}
+	if (test_bit(AS_UNCHARGED, &folio->mapping->flags))
+		filemap_mod_uncharged_vmstat(folio, -1);
 
 	/*
 	 * At this point folio must be either written or cleaned by
@@ -987,6 +1002,8 @@ int filemap_add_folio(struct address_spa
 		if (!(gfp & __GFP_WRITE) && shadow)
 			workingset_refault(folio, shadow);
 		folio_add_lru(folio);
+		if (!charge_mem_cgroup)
+			filemap_mod_uncharged_vmstat(folio, 1);
 	}
 	return ret;
 }
--- a/mm/vmstat.c~mm-add-vmstat-for-cgroup-uncharged-pages
+++ a/mm/vmstat.c
@@ -1290,6 +1290,9 @@ const char * const vmstat_text[] = {
 	[I(NR_HUGETLB)]				= "nr_hugetlb",
 #endif
 	[I(NR_BALLOON_PAGES)]			= "nr_balloon_pages",
+#ifdef CONFIG_MEMCG
+	[I(NR_UNCHARGED_FILE_PAGES)]		= "nr_uncharged_file_pages",
+#endif
 #undef I
 
 	/* system-wide enum vm_stat_item counters */
_

Patches currently in -mm which might be from boris@bur.io are

mm-filemap-add-as_uncharged.patch
mm-add-vmstat-for-cgroup-uncharged-pages.patch
btrfs-set-as_uncharged-on-the-btree_inode.patch


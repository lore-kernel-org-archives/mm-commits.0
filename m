Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D2D82EEE61
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334232; cv=none; b=Y+3ioXjXYTjm6RgZdszR6aCVihGsC7C+p7mcKpd3U7V6yoTHiKEnD+XVKFdOj6RPxO/JTGouCJG9+wG1C2h82ZjluQSn0/ORgkldgRIr1oOuxPiQ9tPr7zzoI9FRmoiWMuSW7xJYUzKyE9AmV2wtKwEbufpbzSjiLIb4lnYkyWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334232; c=relaxed/simple;
	bh=P5OJ/RBct2zu0GpjNSfTY7nbJh7VGefBNkVBIUqUfxY=;
	h=Date:To:From:Subject:Message-Id; b=bhBYrgnAaxs13dAFiPGKI5pfv0AOc8TPIqFCrbTsYZYxtlW4YMt6uy7Fl7lmAOsDxyhiMx8tsXUz3XFmx+aRtlRBZ7gcu4ovEVkfMt50mtPFKRm+RAsENxQYZyFZtybL9nPTiQbQRIwyOVpcdZ6/eqoQH5LrnhkGNGuxn5kCJ0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yr+D/c4b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yr+D/c4b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01B2E1F0089B;
	Wed,  7 Oct 2026 00:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334231;
	bh=NMVpYLJwgL2TQsA2b0iDR4tvXm7fg0595z1J14Ymjw8=;
	h=Date:To:From:Subject;
	b=yr+D/c4bAI3pcXhz0o6Rk9HX6itWbrTG3os2218KkeMAfwxmaduENbtfXL8moRRJF
	 6cZeTj/fMKtcI72Orr5mPh1w9FHpJPGTOmOARbz8VOUNWdHYqlws/cSIdPyRTk2/tQ
	 67zNe0qdsb3Dh4/Dsre8G3yaKDGhcscySjJ9t1w8=
Date: Tue, 06 Oct 2026 17:50:30 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,ljs@kernel.org,hannes@cmpxchg.org,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_io-rename-bio_associate_blkg_from_page.patch removed from -mm tree
Message-Id: <20261007005031.01B2E1F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_io: rename bio_associate_blkg_from_page()
has been removed from the -mm tree.  Its filename was
     mm-page_io-rename-bio_associate_blkg_from_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tal Zussman <tz2294@columbia.edu>
Subject: mm/page_io: rename bio_associate_blkg_from_page()
Date: Sat, 29 Aug 2026 15:09:03 -0400

This function takes a folio.  Rename it to bio_associate_blkg_from_folio()
accordingly.  While at it, convert the macro in the !CONFIG_MEMCG ||
!CONFIG_BLK_CGROUP case to a function.

Link: https://lore.kernel.org/20260829-b4-page_io-folios-v2-4-649728091117@columbia.edu
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---

 mm/page_io.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/page_io.c~mm-page_io-rename-bio_associate_blkg_from_page
+++ a/mm/page_io.c
@@ -277,7 +277,7 @@ static bool folio_blkg_can_merge(struct
 	return can_merge;
 }
 
-static void bio_associate_blkg_from_page(struct bio *bio, struct folio *folio)
+static void bio_associate_blkg_from_folio(struct bio *bio, struct folio *folio)
 {
 	struct cgroup_subsys_state *css;
 
@@ -298,7 +298,9 @@ static bool folio_blkg_can_merge(struct
 {
 	return true;
 }
-#define bio_associate_blkg_from_page(bio, folio)		do { } while (0)
+static void bio_associate_blkg_from_folio(struct bio *bio, struct folio *folio)
+{
+}
 #endif /* CONFIG_MEMCG && CONFIG_BLK_CGROUP */
 
 static mempool_t *sio_pool;
@@ -596,7 +598,7 @@ static void swap_bdev_submit_write(struc
 			REQ_OP_WRITE | REQ_SWAP);
 	bio->bi_iter.bi_size = sio->len;
 	bio->bi_iter.bi_sector = swap_folio_sector(bio_first_folio_all(bio));
-	bio_associate_blkg_from_page(bio, bio_first_folio_all(bio));
+	bio_associate_blkg_from_folio(bio, bio_first_folio_all(bio));
 
 	if (ctx->sis->flags & SWP_SYNCHRONOUS_IO) {
 		submit_bio_wait(bio);
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


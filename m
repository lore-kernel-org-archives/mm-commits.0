Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B311F37AA6F;
	Wed,  4 Mar 2026 17:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772646298; cv=none; b=n+z1FqVplIp652E4KtZleNWKS06rk4o34IU4GTpLe9zFyHbqcN+nx6/nBF0GzKeChv2dFtAKjj8kutoeTE5TFwfTUfPDckD5eBxhbXc23VwQdbVN1BXfBqYUSkdn4n0a8QU/LFd3gK+5I7ea7EGeguEXYHQmhKpee28CN6Jvd+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772646298; c=relaxed/simple;
	bh=N45L0ugmbNtJ3TvoHt6ChBJoC2ObNnEE3HBLjcVwPno=;
	h=Date:To:From:Subject:Message-Id; b=POh2jSslbYBsEBjTFF3LaFPGEXEss20So2qty9NrDtwo5extLIkGp8gfACuUCvqkhydO0Rv8wJvsAXnrpVsYhIsy7n0lrYpMxxnp6QQPSt3Wvxm2DQl82VIr0yisfO5rMPjHvtBuR4IJqLgynQRs1NtIwWpNTlrmXhls7uAtSlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OVF4/ujN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OVF4/ujN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A654C4CEF7;
	Wed,  4 Mar 2026 17:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772646298;
	bh=N45L0ugmbNtJ3TvoHt6ChBJoC2ObNnEE3HBLjcVwPno=;
	h=Date:To:From:Subject:From;
	b=OVF4/ujN0wsB+RQiEQhXKDL5h0ZSYRuS0Iy5pCJ/6o1IwBOaOAUXWE1tpXz+57iu8
	 WxtPTI/rCWK3hgVcssicjiFy1IeyyDvV1aBj85dsNtwby4YI8DpdGj2f8vxKy8fqOg
	 rC02+sWXd18N0NUsFzB67ar9mBMdBWcTG+jE8cL4=
Date: Wed, 04 Mar 2026 09:44:57 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,rppt@kernel.org,pasha.tatashin@soleen.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-memfd_luo-always-dirty-all-folios.patch removed from -mm tree
Message-Id: <20260304174458.5A654C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memfd_luo: always dirty all folios
has been removed from the -mm tree.  Its filename was
     mm-memfd_luo-always-dirty-all-folios.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
Subject: mm: memfd_luo: always dirty all folios
Date: Mon, 23 Feb 2026 18:39:29 +0100

A dirty folio is one which has been written to.  A clean folio is its
opposite.  Since a clean folio has no user data, it can be freed under
memory pressure.

memfd preservation with LUO saves the flag at preserve().  This is
problematic.  The folio might get dirtied later.  Saving it at freeze()
also doesn't work, since the dirty bit from PTE is normally synced at
unmap and there might still be mappings of the file at freeze().

To see why this is a problem, say a folio is clean at preserve, but gets
dirtied later.  The serialized state of the folio will mark it as clean. 
After retrieve, the next kernel will see the folio as clean and might try
to reclaim it under memory pressure.  This will result in losing user
data.

Mark all folios of the file as dirty, and always set the
MEMFD_LUO_FOLIO_DIRTY flag.  This comes with the side effect of making all
clean folios un-reclaimable.  This is a cost that has to be paid for
participants of live update.  It is not expected to be a common use case
to preserve a lot of clean folios anyway.

Since the value of pfolio->flags is a constant now, drop the flags
variable and set it directly.

Link: https://lkml.kernel.org/r/20260223173931.2221759-3-pratyush@kernel.org
Fixes: b3749f174d68 ("mm: memfd_luo: allow preserving memfd")
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memfd_luo.c |   26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

--- a/mm/memfd_luo.c~mm-memfd_luo-always-dirty-all-folios
+++ a/mm/memfd_luo.c
@@ -146,7 +146,6 @@ static int memfd_luo_preserve_folios(str
 	for (i = 0; i < nr_folios; i++) {
 		struct memfd_luo_folio_ser *pfolio = &folios_ser[i];
 		struct folio *folio = folios[i];
-		unsigned int flags = 0;
 
 		err = kho_preserve_folio(folio);
 		if (err)
@@ -154,8 +153,26 @@ static int memfd_luo_preserve_folios(str
 
 		folio_lock(folio);
 
-		if (folio_test_dirty(folio))
-			flags |= MEMFD_LUO_FOLIO_DIRTY;
+		/*
+		 * A dirty folio is one which has been written to. A clean folio
+		 * is its opposite. Since a clean folio does not carry user
+		 * data, it can be freed by page reclaim under memory pressure.
+		 *
+		 * Saving the dirty flag at prepare() time doesn't work since it
+		 * can change later. Saving it at freeze() also won't work
+		 * because the dirty bit is normally synced at unmap and there
+		 * might still be a mapping of the file at freeze().
+		 *
+		 * To see why this is a problem, say a folio is clean at
+		 * preserve, but gets dirtied later. The pfolio flags will mark
+		 * it as clean. After retrieve, the next kernel might try to
+		 * reclaim this folio under memory pressure, losing user data.
+		 *
+		 * Unconditionally mark it dirty to avoid this problem. This
+		 * comes at the cost of making clean folios un-reclaimable after
+		 * live update.
+		 */
+		folio_mark_dirty(folio);
 
 		/*
 		 * If the folio is not uptodate, it was fallocated but never
@@ -174,12 +191,11 @@ static int memfd_luo_preserve_folios(str
 			flush_dcache_folio(folio);
 			folio_mark_uptodate(folio);
 		}
-		flags |= MEMFD_LUO_FOLIO_UPTODATE;
 
 		folio_unlock(folio);
 
 		pfolio->pfn = folio_pfn(folio);
-		pfolio->flags = flags;
+		pfolio->flags = MEMFD_LUO_FOLIO_DIRTY | MEMFD_LUO_FOLIO_UPTODATE;
 		pfolio->index = folio->index;
 	}
 
_

Patches currently in -mm which might be from pratyush@kernel.org are

memfd-export-memfd_addget_seals.patch
mm-memfd_luo-preserve-file-seals.patch
kho-move-alloc-tag-init-to-kho_init_foliopages.patch


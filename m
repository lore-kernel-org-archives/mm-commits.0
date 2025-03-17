Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9096C217F55
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188479; cv=none; b=FqazBDUNkhDpKv+7L8KOqZVuV2ytk9lLGGWxQukD7mN9jC98Ulh5ijQTYWEHOKDx9Y56X+Bo6I2sn2tmcutVghJDpT6z/15RZyS799591U140MODvC9b/GURvp4CBTDPgWLEVCZW6/pPxk1WOpD30aXfOsF0z4MfgdEmM5oVxOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188479; c=relaxed/simple;
	bh=R2w+qvDAUGgsrCh2OzVmRm7koJRc/8eW9pvyMqDydmU=;
	h=Date:To:From:Subject:Message-Id; b=lIWWy0sPFTOEuetie0f0gl8yA3zHbIYXdCcPnqBppDjsK3qArfJofyDMyZXTNqyfvbPZKucoOG0mcsZ7hn05qaZHhnY+k4nAiiG5f9wNXv8Xp80OKuch+6R0JUG72OFF/C02znACbuvZfOfLoU+CQrqFAZgLkL7EMZGjh2kSh60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qBAkjson; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qBAkjson"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63E6BC4CEEC;
	Mon, 17 Mar 2025 05:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188479;
	bh=R2w+qvDAUGgsrCh2OzVmRm7koJRc/8eW9pvyMqDydmU=;
	h=Date:To:From:Subject:From;
	b=qBAkjsonlBfdVtfajlSO3Mog/S3KeY4448GuSfiKaZPUrdes12wv3NWbXYK7ah5Kf
	 IQ+Gry5hwOjzGHYfaz7phJ/aZUxPLH3muCp+9K56bITfjOb/mcfS/7/kuImiswKpKT
	 Kx4sKf2/WCPiuMxhWm2xYgO2EUG7td33OGnBfw9g=
Date: Sun, 16 Mar 2025 22:14:38 -0700
To: mm-commits@vger.kernel.org,djwong@kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-assert-the-folio-is-locked-in-folio_start_writeback.patch removed from -mm tree
Message-Id: <20250317051439.63E6BC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: assert the folio is locked in folio_start_writeback()
has been removed from the -mm tree.  Its filename was
     mm-assert-the-folio-is-locked-in-folio_start_writeback.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: assert the folio is locked in folio_start_writeback()
Date: Wed, 26 Feb 2025 15:36:12 +0000

The folio must be locked when we start writeback in order to prevent
writeback from being started twice on the same folio.  I don't expect this
to catch any problems, but it should be good documentation.

Link: https://lkml.kernel.org/r/20250226153614.3774896-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/page-writeback.c~mm-assert-the-folio-is-locked-in-folio_start_writeback
+++ a/mm/page-writeback.c
@@ -3109,6 +3109,7 @@ void __folio_start_writeback(struct foli
 	int access_ret;
 
 	VM_BUG_ON_FOLIO(folio_test_writeback(folio), folio);
+	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 
 	if (mapping && mapping_use_writeback_tags(mapping)) {
 		XA_STATE(xas, &mapping->i_pages, folio_index(folio));
_

Patches currently in -mm which might be from willy@infradead.org are

dax-remove-access-to-page-index.patch
dax-use-folios-more-widely-within-dax.patch
hugetlb-convert-hugetlb_vma_maps_page-to-hugetlb_vma_maps_pfn.patch
hugetlb-convert-adjust_range_hwpoison-to-take-a-folio.patch
mm-convert-lru_add_page_tail-to-lru_add_split_folio.patch
mm-separate-folio_split_memcg_refs-from-split_page_memcg.patch
mm-simplify-split_page_memcg.patch
mm-remove-references-to-folio-in-split_page_memcg.patch
mm-simplify-folio_memcg_charged.patch
mm-remove-references-to-folio-in-__memcg_kmem_uncharge_page.patch
ocfs2-use-memcpy_to_folio-in-ocfs2_symlink_get_block.patch
ocfs2-remove-reference-to-bh-b_page.patch


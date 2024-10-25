Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 239A21925AB
	for <mm-commits@vger.kernel.org>; Fri, 25 Oct 2024 19:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729885083; cv=none; b=E9LgSQnUGNj8ljYkhLDSM0Kx2LZcxY/46bOKfpmPe43SRSo/VbUwAHf7EMG64mw2bjZshrREI6TBwCzDEE8GI/75ifIFRaQuArTKnLq6Jucg0Zi7I/akh6wZQAyxaur3MjeMF/3DyrLrukxqScw+nTMIcGyrjwInCP4k4sLFCbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729885083; c=relaxed/simple;
	bh=vtKxyKgj1pPvP1yIoifr8pEAJhtYSFIo6FyNHUVY+Cs=;
	h=Date:To:From:Subject:Message-Id; b=CQOpnp5dwBpjtE3k0GEorcN2bi/zGQMpIEXSDUoZ/jowlT+Uc1x7+9Nm8VWz1QOXtT7v+NDr32k3ekmJJbqip1KELr3mj4GIvfHGQpu1wxX844V6zpngOtO1GSJII5WKZYbv8qv38QlSmoFLsG62P3QCmOTIo2oSccivtlU0WG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=js26ou8e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="js26ou8e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8740C4CEC3;
	Fri, 25 Oct 2024 19:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729885083;
	bh=vtKxyKgj1pPvP1yIoifr8pEAJhtYSFIo6FyNHUVY+Cs=;
	h=Date:To:From:Subject:From;
	b=js26ou8ecLRYc3dhGcWKkbZLhmw2PLb1J0LXJaKDHWt9Mrt1uuPlLJXERvbhm41uW
	 wLKBYV9DHS3MzEAX+Kz/u8rWfHSUguGWfAWH6YKLiNKHRxeLzPgG25ECw3ZRCd6d2M
	 PIfQHRes0ftTVEV3XtcpC9t0UwbqJDytPoFPHmWE=
Date: Fri, 25 Oct 2024 12:38:02 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-convert-metadata-aops-from-writepage-to-writepages.patch added to mm-nonmm-unstable branch
Message-Id: <20241025193802.E8740C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: convert metadata aops from writepage to writepages
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-convert-metadata-aops-from-writepage-to-writepages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-convert-metadata-aops-from-writepage-to-writepages.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: nilfs2: convert metadata aops from writepage to writepages
Date: Thu, 24 Oct 2024 18:25:46 +0900

By implementing ->writepages instead of ->writepage, we remove a layer of
indirect function calls from the writeback path and the last use of struct
page in nilfs2.

[konishi.ryusuke@gmail.com: fixed panic by using buffer_migrate_folio_norefs]
Link: https://lkml.kernel.org/r/20241002150036.1339475-5-willy@infradead.org
Link: https://lkml.kernel.org/r/20241024092602.13395-13-konishi.ryusuke@gmail.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/mdt.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

--- a/fs/nilfs2/mdt.c~nilfs2-convert-metadata-aops-from-writepage-to-writepages
+++ a/fs/nilfs2/mdt.c
@@ -399,10 +399,9 @@ int nilfs_mdt_fetch_dirty(struct inode *
 	return test_bit(NILFS_I_DIRTY, &ii->i_state);
 }
 
-static int
-nilfs_mdt_write_page(struct page *page, struct writeback_control *wbc)
+static int nilfs_mdt_write_folio(struct folio *folio,
+		struct writeback_control *wbc)
 {
-	struct folio *folio = page_folio(page);
 	struct inode *inode = folio->mapping->host;
 	struct super_block *sb;
 	int err = 0;
@@ -435,11 +434,23 @@ nilfs_mdt_write_page(struct page *page,
 	return err;
 }
 
+static int nilfs_mdt_writeback(struct address_space *mapping,
+		struct writeback_control *wbc)
+{
+	struct folio *folio = NULL;
+	int error;
+
+	while ((folio = writeback_iter(mapping, wbc, folio, &error)))
+		error = nilfs_mdt_write_folio(folio, wbc);
+
+	return error;
+}
 
 static const struct address_space_operations def_mdt_aops = {
 	.dirty_folio		= block_dirty_folio,
 	.invalidate_folio	= block_invalidate_folio,
-	.writepage		= nilfs_mdt_write_page,
+	.writepages		= nilfs_mdt_writeback,
+	.migrate_folio		= buffer_migrate_folio_norefs,
 };
 
 static const struct inode_operations def_mdt_iops;
_

Patches currently in -mm which might be from willy@infradead.org are

ksm-use-a-folio-in-try_to_merge_one_page.patch
ksm-convert-cmp_and_merge_page-to-use-a-folio.patch
ksm-convert-should_skip_rmap_item-to-take-a-folio.patch
mm-add-pageanonnotksm.patch
mm-add-pageanonnotksm-fix.patch
mm-remove-pageksm.patch
gup-convert-foll_touch-case-in-follow_page_pte-to-folio.patch
mm-convert-page_to_pgoff-to-page_pgoff.patch
mm-use-page_pgoff-in-more-places.patch
mm-renovate-page_address_in_vma.patch
mm-mass-constification-of-folio-page-pointers.patch
bootmem-stop-using-page-index.patch
mm-remove-references-to-page-index-in-huge_memoryc.patch
mm-use-page-private-instead-of-page-index-in-percpu.patch
nilfs2-remove-nilfs_writepage.patch
nilfs2-convert-nilfs_page_count_clean_buffers-to-take-a-folio.patch
nilfs2-convert-nilfs_recovery_copy_block-to-take-a-folio.patch
nilfs2-convert-metadata-aops-from-writepage-to-writepages.patch


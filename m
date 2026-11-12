Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794510688;
	b=am+0bK4bWcztIoQR0G1hEjGLl8hZIdTpNvhrIUjt4mMMo5kFYXKhGd5y2bToPVO2lFwR
	 UkzFtJOF7nvJzu4a1MtT8uTP9yXDmqc7hp/qCUa8Jcq0C3ykpONDv52u+xJ/+GG4MVBZP
	 M6VcsW8od/xSNK3496YobYRGFgkgy04EfkEVNFUfBtp1r6WoJWEqsHV09EpUzRGDiQM6H
	 bVHsMDPjn4Wp6o47sBnpbgxEZ7mS5tjcldN2fDqME7U6sSzhQGkumE6WcX4cqQlXPEo+5
	 xSqloI02vk+Wvd3wYVI3mOgXxdfJv+EDzq+HUdcBQy8TBwKpdHTZV7G+a+qPeI12bkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794510688;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=dTU+KmXvtkMp8FNEMoHtNopz+BB/gbvCiwAOSkQx9pk=;
	b=loCBMCVtldgvomIqBX1lr4y4GmPVe10Rqdx/nIve5lJZHyAwIdDf7UPVAMbOw1gGzJrm
	 34yIbB3YZmbOpXvG91fjEJc3veYYrG0kfcO1MQbHgRS0UnkLd+U7EOIuaUJN+5R/QmDXX
	 0sDjDY5TlYIZL20GhoNOrEvIbtX4Zv8Gam+5QNyGD7ImcxComsTNdOq3B/vZp4MCmWXIw
	 ActrLe4pGXfrmFYXccQFJNo3u22hiycrFWW6KrczWmoeFq1c4uNsAlxurSr+HBN8g73oZ
	 0FXXF4yz4SdlSBkiHiHUKGr8DCIZXgoKXxx673d/wxFF7mJMDaalud93AZTp3pVwmHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="O3+b/Jap";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60FDB606A327
	for <mm-commits@vger.kernel.org>; Thu, 12 Nov 2026 19:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=O3+b/Jap
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA7111F000C5;
	Thu, 12 Nov 2026 19:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794510688;
	bh=dTU+KmXvtkMp8FNEMoHtNopz+BB/gbvCiwAOSkQx9pk=;
	h=Date:To:From:Subject;
	b=O3+b/Japh0jVywF6ZEVRjjLTkyB7NkkFCm1wOm6DQpOO3jaFEA9xWj/yZ2M58Fov6
	 DIh4BdLlyFSlbSw+WstMI0m0+z9qf9zeUiby0Jm4bkcVio6xhA4uhTVbv2B24c6NWp
	 Jq/uCyVjNIXFTWTnUv3MlG5l8vs3KqB1vwBB+DxA=
Date: Thu, 12 Nov 2026 11:11:27 -0800
To: mm-commits@vger.kernel.org,phillip.lougher@gmail.com,
	phillip@squashfs.org.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-fix-regression-in-squashfs_copy_cache.patch added to mm-nonmm-unstable branch
Message-Id: <20261112191127.EA7111F000C5@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: Squashfs: fix regression in squashfs_copy_cache()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-fix-regression-in-squashfs_copy_cache.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-fix-regression-in-squashfs_copy_cache.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: Squashfs: fix regression in squashfs_copy_cache()
Date: Wed, 11 Nov 2026 23:44:01 +0000

In a recent commit updating the code to use folios, the bytes variable
was changed from signed to unsigned in squashfs_copy_cache().

The bytes variable is used in a loop where PAGE_SIZE bytes are
subtracted from it each time around the loop, and where the loop
terminates once bytes is less than or equal to zero.

The effect of the change in signedness is bytes no longer becomes
negative when it is not a multiple of PAGE_SIZE, and the loop does not
terminate when it should do, and instead folios are created and filled
after file EOF.

These beyond EOF folios are not visible to user-space and hence this is
a silent regression.

This commit fixes the code to only subtract the minimum of bytes or
PAGE_SIZE, and which ensures the variable does not underflow.

Link: https://lore.kernel.org/20261111234402.252354-22-phillip@squashfs.org.uk
Fixes: 5641371fd0b3 ("squashfs; convert squashfs_copy_cache() to take a folio")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Phillip Lougher <phillip.lougher@gmail.com>
---

 fs/squashfs/file.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/fs/squashfs/file.c~squashfs-fix-regression-in-squashfs_copy_cache
+++ a/fs/squashfs/file.c
@@ -410,6 +410,7 @@ void squashfs_copy_cache(struct folio *f
 	struct squashfs_sb_info *msblk = inode->i_sb->s_fs_info;
 	s64 i, mask = (1 << (msblk->block_log - PAGE_SHIFT)) - 1;
 	s64 start_index = folio->index & ~mask, end_index = start_index | mask;
+	size_t avail;
 
 	/*
 	 * Loop copying datablock into pages.  As the datablock likely covers
@@ -417,12 +418,13 @@ void squashfs_copy_cache(struct folio *f
 	 * grab the pages from the page cache, except for the page that we've
 	 * been called to fill.
 	 */
-	for (i = start_index; i <= end_index && bytes > 0; i++,
-			bytes -= PAGE_SIZE, offset += PAGE_SIZE) {
+	for (i = start_index; i <= end_index && bytes; i++,
+			bytes -= avail, offset += avail) {
 		struct folio *push_folio;
-		size_t avail = buffer ? min(bytes, PAGE_SIZE) : 0;
 		bool updated = false;
 
+		avail = min(bytes, PAGE_SIZE);
+
 		TRACE("bytes %zu, i %lld, available_bytes %zu\n", bytes, i, avail);
 
 		push_folio = (i == folio->index) ? folio :
@@ -436,7 +438,7 @@ void squashfs_copy_cache(struct folio *f
 		if (folio_test_uptodate(push_folio))
 			goto skip_folio;
 
-		updated = squashfs_fill_page(push_folio, buffer, offset, avail);
+		updated = squashfs_fill_page(push_folio, buffer, offset, buffer ? avail : 0);
 skip_folio:
 		folio_end_read(push_folio, updated);
 		if (i != folio->index)
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are

squashfs-convert-squashfs_compressed_-to-inline-functions.patch
squashfs-convert-squashfs_inode_-and-squashfs_mkinode-to-inline-functions.patch
squashfs-convert-squashfs_fragment_-to-inline-functions.patch
squashfs-convert-squashfs_lookup_-to-inline-functions.patch
squashfs-convert-squashfs_id_-to-inline-functions.patch
squashfs-convert-squashfs_xattr_-to-inline-functions.patch
squashfs-fix-offset-in-squashfs_read_inode-trace-statements.patch
squashfs-fix-fragment-bytes-overflow-on-32-bit-architectures.patch
squashfs-fix-fragment-index-table-length-too-large-exploit.patch
squashfs-sanity-check-inode-metadata-block-location.patch
squashfs-sanity-check-directory-metadata-block-location.patch
squashfs-widen-xattr-count-variables-and-add-sanity-check.patch
squashfs-very-large-files-can-exceed-an-int-block-count.patch
squashfs-add-more-sanity-checking-to-squashfs_block_size.patch
squashfs-sanity-check-fragment-block-location-and-range.patch
squashfs-sanity-check-block-list-sizes-and-range.patch
squashfs-dont-store-large-export-table-indexes-in-memory.patch
squashfs-dont-store-large-fragment-table-indexes-in-memory.patch
squashfs-dont-store-large-xattr-id-table-indexes-in-memory.patch
squashfs-fix-variables-in-directory-code-and-add-more-sanity-checks.patch
squashfs-fix-regression-in-squashfs_copy_cache.patch
squashfs-check-index-isnt-greater-than-s64_max-in-squashfs_read_data.patch


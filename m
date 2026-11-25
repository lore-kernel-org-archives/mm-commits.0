Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795586071;
	b=LczzH7sORCY66gDfxLHpMbafQz/tv+MQ8gyCbpH+J5zlOI92RHtyd1tghIRoCuldDJPj
	 ST2S+nc8YIJoKKVFzdaZowm9u9wzlBuRn3WsLyLApnKe0pW8gurziniDgodJfpT+tOafe
	 RNO/X17SD9iNyJpLeAL1+stHxw/h5aWBcMzLVFiO0FXYY6wKR1/xHQ3oBd7zVy+4wupMD
	 Fx46XpPVcOOvfu+eA7k6BZgLGlnE+VfhPZ3LVHfn02U4Dbe30xXneOntj6X12XyGvBsH1
	 3PuXkIwwDCMlTj3t8B0aD1IUPEQPXe7/cz1/G0ZeFZmxid7KcZMs/G4duw5VjF38+yA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795586071;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=Sqi977StwtldtMnP7atNd72qsHkDDUZhhfjBkPfy6To=;
	b=uJ1UfFaq2kS4A5M2e443WwY6B4Rv7Z+Mhf7qf5GDZh+VbtVJc3zMiBI137aCnCmGw0eR
	 yQQNS7n5J2w6x874okztr7qCQMxTPrnJwl3TDPCXA6SYPTK894gzY3hEW96em79jgbdb3
	 duNK3FdASIX99q1keaf/4hCat/pf0jVYBpeUBxJutGEtARlvJN4XfSx8yXtrhnsCi2SLO
	 FWkRcf/gj6Urr9F8v7JTmHaBCuIjnHC4zHK2DmrtM4+80Pvaw/yTLAypxww1wlucnVJpZ
	 ONzxhjzgBgVUG2JKaYzuknKlcqWMVZxbHzC5vvfqx38DRZsrUMlQC9Qx06EuwAxgf4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=kW2AwjuE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5253F606A321
	for <mm-commits@vger.kernel.org>; Wed, 25 Nov 2026 05:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=kW2AwjuE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB32A1F000D3;
	Wed, 25 Nov 2026 05:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795586070;
	bh=Sqi977StwtldtMnP7atNd72qsHkDDUZhhfjBkPfy6To=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=kW2AwjuEKec5+ruohQqq9G9egzVBrhgRhh7yi5FLiUzQmTyJdBFe/7O7bUA5iEz74
	 t0LaHm+3sAlWIzc0phII4XM+6FC161xBRziUxQiYyJfCjKdFCdIZba+JyLdh7CVWOO
	 wrhv2PSxX4jnZzPGtOI3s5+gltLcuELEAw1693SQ=
Date: Tue, 24 Nov 2026 21:54:30 -0800
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261125014737.347231-23-phillip@squashfs.org.uk>
References: <20261125014737.347231-23-phillip@squashfs.org.uk>
Subject: + squashfs-fix-regression-in-squashfs_copy_cache.patch added to mm-nonmm-unstable branch
Message-Id: <20261125055430.BB32A1F000D3@smtp.kernel.org>
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
Date: Wed, 25 Nov 2026 01:47:36 +0000

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

Link: https://patch.msgid.link/20261125014737.347231-23-phillip@squashfs.org.uk
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

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
squashfs-dont-compute-start-or-alloc-memory-on-empty-directory-or-index.patch
squashfs-fix-fragment-bytes-overflow-on-32-bit-architectures.patch
squashfs-fix-fragment-index-table-length-too-large-exploit.patch
squashfs-sanity-check-inode-metadata-block-location.patch
squashfs-sanity-check-directory-metadata-block-location.patch
squashfs-widen-xattr-count-variables-and-add-sanity-check.patch
squashfs-very-large-files-can-exceed-an-int-or-size_t.patch
squashfs-add-more-sanity-checking-to-squashfs_block_size.patch
squashfs-sanity-check-fragment-block-location-and-range.patch
squashfs-sanity-check-block-list-sizes-and-range.patch
squashfs-dont-store-large-export-table-indexes-in-memory.patch
squashfs-dont-store-large-fragment-table-indexes-in-memory.patch
squashfs-dont-store-large-xattr-id-table-indexes-in-memory.patch
squashfs-fix-variables-in-directory-code-and-add-more-sanity-checks.patch
squashfs-fix-regression-in-squashfs_copy_cache.patch
squashfs-check-index-isnt-greater-than-s64_max-in-squashfs_read_data.patch


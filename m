Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795406646;
	b=N6V7vivZ+vfUTThVaUGfQaiNJXqMeaw/FwICcbeNriYmkO3XIK480dAQxs3Jbu2B9N36
	 jC/6B490jzXqNlj7R6Lr8u2oh1xQ3mIQ9mc50wqu3AufCqmobV8WiMUIUnzCjdeRbTNw5
	 FAtQMMiBbnFeoHX48mn1G0BoCRoejRvpd5L9K8HbxvSH/TitGX9+hJwnJaqICbeS3qQ7v
	 tr+YGKFvHiByRc8A2SC68Ox5s9ucC1Uh8084gqUjXVvGCyujS6Rw9lpUnl8J31EK+WuL/
	 7aSW8It/bIEx0+dP6oOVBsrK8NUhy+1+SMKeayUIMWUS0+OXDkFHPV+PEXQ3LtQmDRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795406646;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=yhoNGnLd/Lb7ZqWyq7Uqu5y49fUR51DNuTlz8uGoHqE=;
	b=PZcqxzJUn32Eh5pYAwqpm4ewVjUhkrsqaDsGclunSvrQw3Q2MwdCKM+TZx6Od60/MmEs
	 /wdCFFnUSDQaRbQos7LAKZOfG2UedBvR7j3ZZt3JBxwoRCfTYL5guYcA4WSBcRFhFLARt
	 TUMBNZdqZgnYWpZJ2rfzkz3xEYOTZQROFr6vN72/X1z+dh10DxhbgU1oERvBdGgSXj8K1
	 bygMUJp9WYRdvhT4Mg43vANEmFFFUTO6qlK2EdiDJgzTAaroCPhhEKqlHJ1HRkxMxWpCy
	 wSu7SeA7vo33nGaydtu9YsFjbvtNEAHPTZCacYuyztmpKIChdPcBXNQ6oSSx4aLGPfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="RIAfe/IP";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F169606A31A
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 04:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=RIAfe/IP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37A4C1F000CA;
	Mon, 23 Nov 2026 04:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795406646;
	bh=yhoNGnLd/Lb7ZqWyq7Uqu5y49fUR51DNuTlz8uGoHqE=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=RIAfe/IPHFcjU5m1785P4wh6d6CiyQOY3XoAJrePhpgU7B/ppJt+Q0wNf4rwKrUsS
	 yI9UMVPE/sk4gA+7r8BT1vdtUoH8F7wB1v4qlfdrI19z/hqSx/j6ECRPZdMX5yXWeV
	 xlv9Z+XgW30e0yopq8By0Aq1rHlvwnZPHPdo743E=
Date: Sun, 22 Nov 2026 20:04:05 -0800
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261111234402.252354-22-phillip@squashfs.org.uk>
References: <20261111234402.252354-22-phillip@squashfs.org.uk>
Subject: [to-be-updated] squashfs-fix-regression-in-squashfs_copy_cache.patch removed from -mm tree
Message-Id: <20261123040406.37A4C1F000CA@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: Squashfs: fix regression in squashfs_copy_cache()
has been removed from the -mm tree.  Its filename was
     squashfs-fix-regression-in-squashfs_copy_cache.patch

This patch was dropped because an updated version will be issued

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

Link: https://patch.msgid.link/20261111234402.252354-22-phillip@squashfs.org.uk
Fixes: 5641371fd0b3 ("squashfs; convert squashfs_copy_cache() to take a folio")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Phillip Lougher <phillip.lougher@gmail.com>

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

squashfs-check-index-isnt-greater-than-s64_max-in-squashfs_read_data.patch
a.patch


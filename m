Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795585322;
	b=RLYgMiyd9Z0JXSP5dl1AfckheD2oKPXJA5YuvpP0+BbgdSpgpqJLCBpwOA+DgZzvW8lx
	 xm4V/g6ujpMpko41fhnRgZJWVHQ05KGh1TfT/vxY1wpMSepXodpAXWpU2j/tdnRchfo+R
	 ra7pJiLPw05ENi/dBV5SzuYoqW11HHDWg00xkDnrFqVxi5R90BVHLGqJr2+OUUkke2xkB
	 Kyuo9e61D9WM2HTVk70eCh+X08cgSSFdxiiISNXCA+AvYuO/6rElefxayfXRb5by9Sb2k
	 C5/1MqvvIVyRoMb1aFcho3q78TV9JpXszpWB/sEY63cczn8fdCJbip/3nFoWTOh9ibw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795585322;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=lkiavDE7rvIcjHygb77NhVCrDEdlmelBfHz2HXFjpl8=;
	b=q5oWUEI9PeFbELgyGiFXtMPI61+d+j99v5n0QAMAkwkkNHsPuvQN30So4Y0II0COXtP5
	 7/ZML/ZIjx/14lbf27fBBHDckhr7jBbgu+oQNLuKhkx0mDAWFEBWoJyC0Ju0PIDUVIUJ3
	 SF/qkiVN/4IcZgjvbcixJJjGRKipLMjW+sjBcmMzf3xEuGHVP2PsRRxLTSwcH5n2ZKULi
	 jjHKTo7Mr7yRhTz1H/bSjPwVMpWs2gDrVpcEcnITM7M22LbgNmTfTFUSTBriHALetdb8v
	 OcU0gZZegQcaNzvlhUSJ/3Yh4LNGBNK3Rxcnp0Fojhw5vz/tod1cip3aQ2XFZl4UEdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=crW3M5lo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D989A606A31E
	for <mm-commits@vger.kernel.org>; Wed, 25 Nov 2026 05:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=crW3M5lo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90ABA1F000C0;
	Wed, 25 Nov 2026 05:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795585322;
	bh=lkiavDE7rvIcjHygb77NhVCrDEdlmelBfHz2HXFjpl8=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=crW3M5lo/Fcz/SG7WgXyn2SlkA2acWAXWSF4l+fHcmXMKov26Isz59yfTOy/VOBhP
	 9KpAA2YWsCkW7uXcO/q3yyWIDd4zk74GoOZEjGRxKng96xlcJGOoi8Ft7yf++8q9bb
	 wcUOmaHuKfgBwpGjU4PNbGabl8QWZ0ntete742KE=
Date: Tue, 24 Nov 2026 21:42:02 -0800
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261123034304.261742-23-phillip@squashfs.org.uk>
References: <20261123034304.261742-23-phillip@squashfs.org.uk>
Subject: [to-be-updated] squashfs-fix-regression-in-squashfs_copy_cache.patch removed from -mm tree
Message-Id: <20261125054202.90ABA1F000C0@smtp.kernel.org>
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
Date: Mon, 23 Nov 2026 03:43:03 +0000

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

Link: https://patch.msgid.link/20261123034304.261742-23-phillip@squashfs.org.uk
Fixes: 5641371fd0b3 ("squashfs; convert squashfs_copy_cache() to take a folio")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christian Loehle <christian.loehle@arm.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Phillip Lougher <phillip.lougher@gmail.com>
Cc: syzbot ci <syzbot+ci04e7314748e3f6be@syzkaller.appspotmail.com>

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


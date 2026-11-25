Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795585289;
	b=5n9ElNP05wGkiXma+4kb/yqNG7rAlQ4KWVBHENQMMz2CLsMAKCB5BcBscj+ltOz5p93B
	 0h4CvZ01DhaARY6SpR6wswoGi323Jf7qYUyZN3Lr+8xf4l2FdbVqNRO6gEGpRfGEQc/Pd
	 iXcPqa/UWqOnZaRCYLOb/wzwP5Lh0aK/ZjHGz4Qr2hDQ7mwOmp7mqFIAWu86Dz22SZo5z
	 V0Jm6etgYJw3B1eNFY0TnyWMiiaGIB/7MH1mBiaCBq90IAggA4WVhZppbDdpkgHpbYvCy
	 /Xwhc7ZJsTIyS2rWFv+JoWlX5t12dgiUfozlHuZukBzbi+ZwyT69CKtT9A9mQ0GWa6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795585289;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=U2gFMGw+ZwCX/vHb3tDJQHbFluRLqgjLKyfbuL+O17c=;
	b=HHIIvK8sJdly9oreMgT45UEYv51GXnu6g2Ga1L/q4YDjUFlsAYJFjc9S4CQiHHNZsNlg
	 fXKyxdai6Z72GLO9WOSYGGc1a+CCW3h5fhNuiZbWnScC8t1ZYgeKAT9r7XU+M4GAZD6ib
	 nNxkfvjsTSvFzi2/nspPozxq8MD9qLaK3tMovSloiNQwNZGvHVA8miym03bdxVIYiaEoa
	 Roa2/it4FJZvkIAEMuRwh2jTbJUSLL8XlUwh8oRS1/MnuTP3BPHoWRGwspx36+FOt1/fG
	 B7DPgxEF7rCAeerWrZ/gMkjAlYqOKBhJpy6vT7GJmU9PJB6MAD8cWIveg4OFBftf+CQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=eYBbrWY9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A0EA606A31E
	for <mm-commits@vger.kernel.org>; Wed, 25 Nov 2026 05:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=eYBbrWY9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B52251F000C0;
	Wed, 25 Nov 2026 05:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795585288;
	bh=U2gFMGw+ZwCX/vHb3tDJQHbFluRLqgjLKyfbuL+O17c=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=eYBbrWY96FqSGTOKw9n1Zug+PyqAFe9Zzo/nZQu7Ghm39Bv8pt+coTSKRw/vZyEth
	 W264JlJ8W4F/TWljBO/CETYVwRU5E3XTd24xGhoFuNKNo3N0oCODjqk3AtnjC0f9ik
	 GdzPFRkaTXpjLcohozRtGuKY7LoBXVh3JwQfomQ8=
Date: Tue, 24 Nov 2026 21:41:28 -0800
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261123034304.261742-8-phillip@squashfs.org.uk>
References: <20261123034304.261742-8-phillip@squashfs.org.uk>
Subject: [to-be-updated] squashfs-fix-offset-in-squashfs_read_inode-trace-statements.patch removed from -mm tree
Message-Id: <20261125054128.B52251F000C0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: Squashfs: fix offset in squashfs_read_inode() TRACE statements
has been removed from the -mm tree.  Its filename was
     squashfs-fix-offset-in-squashfs_read_inode-trace-statements.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: Squashfs: fix offset in squashfs_read_inode() TRACE statements
Date: Mon, 23 Nov 2026 03:42:48 +0000

The offset used in the TRACE statements has been advanced past the start
of the inode header by the squashfs_read_metadata() call.  This means
the offset printed is incorrect.

Fix this by using the original offset, which is obtained by calling
squashfs_inode_offset(ino).

Link: https://patch.msgid.link/20261123034304.261742-8-phillip@squashfs.org.uk
Fixes: 6545b246a2c8 ("Squashfs: inode operations")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christian Loehle <christian.loehle@arm.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Phillip Lougher <phillip.lougher@gmail.com>
Cc: syzbot ci <syzbot+ci04e7314748e3f6be@syzkaller.appspotmail.com>

 fs/squashfs/inode.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

--- a/fs/squashfs/inode.c~squashfs-fix-offset-in-squashfs_read_inode-trace-statements
+++ a/fs/squashfs/inode.c
@@ -184,7 +184,8 @@ int squashfs_read_inode(struct inode *in
 
 		TRACE("File inode %x:%x, start_block %llx, block_list_start "
 			"%llx, offset %x\n", squashfs_inode_blk(ino),
-			offset, squashfs_i(inode)->start, block, offset);
+			squashfs_inode_offset(ino),
+			squashfs_i(inode)->start, block, offset);
 		break;
 	}
 	case SQUASHFS_LREG_TYPE: {
@@ -244,7 +245,8 @@ int squashfs_read_inode(struct inode *in
 
 		TRACE("File inode %x:%x, start_block %llx, block_list_start "
 			"%llx, offset %x\n", squashfs_inode_blk(ino),
-			offset, squashfs_i(inode)->start, block, offset);
+			squashfs_inode_offset(ino), squashfs_i(inode)->start,
+			block, offset);
 		break;
 	}
 	case SQUASHFS_DIR_TYPE: {
@@ -266,7 +268,8 @@ int squashfs_read_inode(struct inode *in
 		squashfs_i(inode)->parent = le32_to_cpu(sqsh_ino->parent_inode);
 
 		TRACE("Directory inode %x:%x, start_block %llx, offset %x\n",
-				squashfs_inode_blk(ino), offset,
+				squashfs_inode_blk(ino),
+				squashfs_inode_offset(ino),
 				squashfs_i(inode)->start,
 				le16_to_cpu(sqsh_ino->offset));
 		break;
@@ -293,7 +296,8 @@ int squashfs_read_inode(struct inode *in
 		squashfs_i(inode)->parent = le32_to_cpu(sqsh_ino->parent_inode);
 
 		TRACE("Long directory inode %x:%x, start_block %llx, offset "
-				"%x\n", squashfs_inode_blk(ino), offset,
+				"%x\n", squashfs_inode_blk(ino),
+				squashfs_inode_offset(ino),
 				squashfs_i(inode)->start,
 				le16_to_cpu(sqsh_ino->offset));
 		break;
@@ -337,8 +341,8 @@ int squashfs_read_inode(struct inode *in
 		}
 
 		TRACE("Symbolic link inode %x:%x, start_block %llx, offset "
-				"%x\n", squashfs_inode_blk(ino), offset,
-				block, offset);
+				"%x\n", squashfs_inode_blk(ino),
+				squashfs_inode_offset(ino), block, offset);
 		break;
 	}
 	case SQUASHFS_BLKDEV_TYPE:
@@ -361,7 +365,8 @@ int squashfs_read_inode(struct inode *in
 		squashfs_i(inode)->parent = 0;
 
 		TRACE("Device inode %x:%x, rdev %x\n",
-				squashfs_inode_blk(ino), offset, rdev);
+				squashfs_inode_blk(ino),
+				squashfs_inode_offset(ino), rdev);
 		break;
 	}
 	case SQUASHFS_LBLKDEV_TYPE:
@@ -386,7 +391,8 @@ int squashfs_read_inode(struct inode *in
 		squashfs_i(inode)->parent = 0;
 
 		TRACE("Device inode %x:%x, rdev %x\n",
-				squashfs_inode_blk(ino), offset, rdev);
+				squashfs_inode_blk(ino),
+				squashfs_inode_offset(ino), rdev);
 		break;
 	}
 	case SQUASHFS_FIFO_TYPE:
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are

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


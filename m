Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795406617;
	b=Z1pN1jQSbrw3Y5AKlJREMyiGEZBIOn0eFRzrCm8rSfcLyM/guBMXLU1fqkrrm6BRZF+F
	 dw6zokA8MochSrkK3EeVB20Ab4qxR8mZnroBeW0/gYEOLkwFn8ByYlc6PbBcBSJtitiOk
	 aOY1x8hr3MBR2JkcnIfzduV7wUbpFUTPga+CKEKqQb9jh6SXxP32tjSIU2uMA7eALaY/g
	 OwXxkNiknEKfooywkHlyx1V0DaNYwEKfJ+4Pk4EMfFKPEFlYu6GStR2nlPWuen/xOsPqq
	 16bub0kkWveOHfjOh5x47BxOSttw8bZ8GN3ZCzodU12HHtmZocJzDaAdqmgxd+QF94Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795406617;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=o5/RMuCqKj87bbbEBn8um+5bBQ3iC5D0ORnii8sCqek=;
	b=M3WcNsYZnrVP1Au1/c/VwQowtyHB55IINg7bdxetvUt1Xe030f7RYh9ISWcN7B4UN3I1
	 0qPM2etJ7LJi6Su8FUggWFaa3M9Rpt9bpP1g3BbdLK273sSWrMxVyb8MBd6GdWxjcdM2g
	 EJgBcfTi1y8Fd9QUx/owIuYtDUFg4N2e7zbkynIz2tMDqWDsIpVDvAgdFjgRCqIo1VMBc
	 RBkJfJM+aG+j5efS7B2a1+3Y4po9kr4PMgEnLXOQbXCEn5D/cGfPTWB1n/wekf/nFhzH/
	 rIRmjEkQFDgJM79BL5sMiHEchxuzwktBgNkb5ckmSIWmPZeuZ/901k9+o51FpBu2/7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=AIXVxlaF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82DED606A31E
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 04:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=AIXVxlaF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3D791F000D8;
	Mon, 23 Nov 2026 04:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795406617;
	bh=o5/RMuCqKj87bbbEBn8um+5bBQ3iC5D0ORnii8sCqek=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=AIXVxlaFT/aiDIo8QrJzC9zcZ3Y5kjMRU3Fi894m97d3/9+w2x9grMMxBfMjcAmwB
	 ua0Wa+uyhnuC7Zka68oB2IQD1o90s49hJQaSn4GQ5UjDc4P+0oAxYm6WOAxnAZVgN6
	 KcWC2EoFCHl1uOYmslNTxScwJdthT264MYE5D66I=
Date: Sun, 22 Nov 2026 20:03:36 -0800
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261111234402.252354-8-phillip@squashfs.org.uk>
References: <20261111234402.252354-8-phillip@squashfs.org.uk>
Subject: [to-be-updated] squashfs-fix-offset-in-squashfs_read_inode-trace-statements.patch removed from -mm tree
Message-Id: <20261123040336.F3D791F000D8@smtp.kernel.org>
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
Date: Wed, 11 Nov 2026 23:43:47 +0000

The offset used in the TRACE statements has been advanced past the start
of the inode header by the squashfs_read_metadata() call.  This means
the offset printed is incorrect.

Fix this by using the original offset, which is obtained by calling
squashfs_inode_offset(ino).

Link: https://patch.msgid.link/20261111234402.252354-8-phillip@squashfs.org.uk
Fixes: 6545b246a2c8 ("Squashfs: inode operations")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Phillip Lougher <phillip.lougher@gmail.com>

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
a.patch


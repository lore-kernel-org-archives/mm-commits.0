Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795586013;
	b=tckzRsNQqgPiO0hDPDfL2UGuTEOE+oa/RxzxiMXQ50dnxhDQ5vxq0ZuuhIjFVtyUJ+Y2
	 RIDTeYkfgqpDeMZGhS0u9NEVuZOIpqx/U0rO5nrLqhhot1BTRj669UV6BUFO8gozV9Ubh
	 GG/8XUQOqHxVeCMTBTzEsQXA3a47HBtCcBTQh8/wNkZsEHS1PEF4x+jGMe7y7W+5pxxRC
	 1vj0688OVlOZhq6pQvRMLJfWZrSqcLQv4BLUqYk73n1/yWgBHjEoT9Cm5L8wjV9/3q3n0
	 EUrp1DiUK658x6ghNaXQAQW74P1dDl6OojrB7IryvDf0hxok+FyBts66WPK2ohmnEag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795586013;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=jMSoDtRwU1YFHl3ZiiaraRjgKzbfrkJx8QPGOMG+2PA=;
	b=vMg48LgCjVok0DEdJ4welC8Gh84LLc70i+5CxojrwF/00x9YJU6KOy75DxNsNp/vaJpu
	 NV4yrY1wiOyXcFtOpEYqMbzu0efjM6WsSnSMUeV9g38f3ZqnvrzR3xeNDAyeIiztJewfw
	 Gh1Xe9lvlX9/wzgrBP3VsmDYqokq2ljPTnqjx0HHFvGQpIUZv5zd11BoAkYL7F/wOAB3T
	 J0ncfe9HTux6P0uyGwECXUsfaOm/1ITqP+AvpwPeketx6ZZ7AbWtwueSgmLUQtp8zEMQy
	 1qeEoAEWAtJyK1EeQv5SVH4kCGZMxxhR4slPQNj1rG2HcqbwRzqwy8K09pX8LyLW2gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=fD7iz+yo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C91606A31E
	for <mm-commits@vger.kernel.org>; Wed, 25 Nov 2026 05:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=fD7iz+yo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C627D1F000C6;
	Wed, 25 Nov 2026 05:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795586012;
	bh=jMSoDtRwU1YFHl3ZiiaraRjgKzbfrkJx8QPGOMG+2PA=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=fD7iz+yoN++bYZyZBxdWlC861tAjccxok3DK5xQNkZ8y/mQIhsN40Bvm8eiJd6t5U
	 hJ6gRKAt2Q6wpciI3s8lOyQoDCYSitIlGJTTvxudgB5b9/NrJUO/yhaYMnF01PtUt5
	 i5L5+jzkh+AkQwrL6IsGZaDt1qEyV7JDqG/bmODk=
Date: Tue, 24 Nov 2026 21:53:32 -0800
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261125014737.347231-8-phillip@squashfs.org.uk>
References: <20261125014737.347231-8-phillip@squashfs.org.uk>
Subject: + squashfs-fix-offset-in-squashfs_read_inode-trace-statements.patch added to mm-nonmm-unstable branch
Message-Id: <20261125055332.C627D1F000C6@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: Squashfs: fix offset in squashfs_read_inode() TRACE statements
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-fix-offset-in-squashfs_read_inode-trace-statements.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-fix-offset-in-squashfs_read_inode-trace-statements.patch

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
Subject: Squashfs: fix offset in squashfs_read_inode() TRACE statements
Date: Wed, 25 Nov 2026 01:47:21 +0000

The offset used in the TRACE statements has been advanced past the start
of the inode header by the squashfs_read_metadata() call.  This means
the offset printed is incorrect.

Fix this by using the original offset, which is obtained by calling
squashfs_inode_offset(ino).

Link: https://patch.msgid.link/20261125014737.347231-8-phillip@squashfs.org.uk
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

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


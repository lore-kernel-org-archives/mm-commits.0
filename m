Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D3B6110
	for <mm-commits@vger.kernel.org>; Wed, 10 Apr 2024 20:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712781188; cv=none; b=h2uiW4SFCX50Y/Nir8OwxLy99IBoySzGSRVnvOAo55CUBtAxsUF8rSPYlQc+nJMIOK/Ep6hjJIs7E/MSdhcmPYNWmqCTCKX1RgAtF7bxbbM5dHEsebPfEKYMIkJHT7k8ooGfOCbq0tcedLjtlHlJNxoGPJ2pJ1wyV4Gg0z+K3Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712781188; c=relaxed/simple;
	bh=ySvwXRM6sqTyuqwuVcP1MkuDJDJy6/b2w5ZTyj4GoCc=;
	h=Date:To:From:Subject:Message-Id; b=YqoJSFZ/mASOcNcaf6+HVEVU4K2bdGR98I1c/4Ig8u9FoP3zN3st5fGLuQJS8hNgNzEAkYRZa0cCYYwtOYOf5HI6HJlPJaDss48/Nikb8hoIe7RZakauPvvM9Sjv7mE7887HQ46dw+4GukPek12BaQYnjNXCF/mem90LJPiw9vU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xTq0YK7m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xTq0YK7m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09226C433F1;
	Wed, 10 Apr 2024 20:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712781188;
	bh=ySvwXRM6sqTyuqwuVcP1MkuDJDJy6/b2w5ZTyj4GoCc=;
	h=Date:To:From:Subject:From;
	b=xTq0YK7mSXNpC3Dus7r9WsWkJW54Eh3zRzyP5+0vSUifH9M2zCF++DoSNmXTHCtvl
	 hEWU6PkVCaI2C+Ra1H+4gPriYtC7loqOagthtG18sTycR09N4PFi52Ty36RK0uvyft
	 dDe3HStu2mi1iIDYdHTYPciHYfFIsNvmZor/gaOg=
Date: Wed, 10 Apr 2024 13:33:07 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,yang.lee@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-add-kernel-doc-comments-to-nilfs_btree_convert_and_insert.patch added to mm-nonmm-unstable branch
Message-Id: <20240410203308.09226C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: add kernel-doc comments to nilfs_btree_convert_and_insert()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-add-kernel-doc-comments-to-nilfs_btree_convert_and_insert.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-add-kernel-doc-comments-to-nilfs_btree_convert_and_insert.patch

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
From: Yang Li <yang.lee@linux.alibaba.com>
Subject: nilfs2: add kernel-doc comments to nilfs_btree_convert_and_insert()
Date: Wed, 10 Apr 2024 16:56:28 +0900

This commit adds kernel-doc style comments with complete parameter
descriptions for the function nilfs_btree_convert_and_insert.

Link: https://lkml.kernel.org/r/20240410075629.3441-3-konishi.ryusuke@gmail.com
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/btree.c |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

--- a/fs/nilfs2/btree.c~nilfs2-add-kernel-doc-comments-to-nilfs_btree_convert_and_insert
+++ a/fs/nilfs2/btree.c
@@ -1857,13 +1857,22 @@ nilfs_btree_commit_convert_and_insert(st
 }
 
 /**
- * nilfs_btree_convert_and_insert -
- * @bmap:
- * @key:
- * @ptr:
- * @keys:
- * @ptrs:
- * @n:
+ * nilfs_btree_convert_and_insert - Convert and insert entries into a B-tree
+ * @btree: NILFS B-tree structure
+ * @key: Key of the new entry to be inserted
+ * @ptr: Pointer (block number) associated with the key to be inserted
+ * @keys: Array of keys to be inserted in addition to @key
+ * @ptrs: Array of pointers associated with @keys
+ * @n: Number of keys and pointers in @keys and @ptrs
+ *
+ * This function is used to insert a new entry specified by @key and @ptr,
+ * along with additional entries specified by @keys and @ptrs arrays, into a
+ * NILFS B-tree.
+ * It prepares the necessary changes by allocating the required blocks and any
+ * necessary intermediate nodes. It converts configurations from other forms of
+ * block mapping (the one that currently exists is direct mapping) to a B-tree.
+ *
+ * Return: 0 on success or a negative error code on failure.
  */
 int nilfs_btree_convert_and_insert(struct nilfs_bmap *btree,
 				   __u64 key, __u64 ptr,
_

Patches currently in -mm which might be from yang.lee@linux.alibaba.com are

fs-add-kernel-doc-comments-to-fat_parse_long.patch
nilfs2-add-kernel-doc-comments-to-nilfs_do_roll_forward.patch
nilfs2-add-kernel-doc-comments-to-nilfs_btree_convert_and_insert.patch
nilfs2-add-kernel-doc-comments-to-nilfs_remove_all_gcinodes.patch


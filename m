Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA26082486
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104488; cv=none; b=L6dGX9sr7iulbLFAVagYb3tcBvA0ILxWayZSYYwadqUU/geEYgBp9X4HcmxKEqrfERFycVfK6BXa8rDQgSAO5LUaUE5jzZroIXXSA4jDUNha4f3piIOgVZB/+HGfJZ3p9aBwQsfCWmxJOnwa5MKyecZTec+icAkggF6rvq/0ccc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104488; c=relaxed/simple;
	bh=7rvT7PA6aFdXExPk7pRwc2h4ldcOGw+cD+q4mvx/TQI=;
	h=Date:To:From:Subject:Message-Id; b=bLyiqgpkmckWVM6erkHxYHPDHIYWb08tUSA0hq5TSlH836ypyChvQSNvGpa9684YNfLff6y4YxjXuaC6CI7Dwr+Zvu8YgzIIucqbBQCvA/bD+rpJgUbdkO9iT3nb8fFT+XMU37ri2lVVbXft+notvO6TdtI2l8uRy4DHZAacVag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ziKp9JVr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ziKp9JVr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70EC0C113CD;
	Fri, 26 Apr 2024 04:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104488;
	bh=7rvT7PA6aFdXExPk7pRwc2h4ldcOGw+cD+q4mvx/TQI=;
	h=Date:To:From:Subject:From;
	b=ziKp9JVrEO7zYQ4BAiLLEVHs/1lnFvr7SiBnyuIpc4ULYZzitNMiX1o/dyfOOgJT1
	 F6DcRj7kfr3s7mVJbSxiBlwRM+GlAWOgWbWJHVTgQDgvOhN3svk/Dqqyi4IhYNu3fH
	 NW0QRJwM6xSQpXyVz39uzlScYuJfAsfxlvTKyGCA=
Date: Thu, 25 Apr 2024 21:08:07 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,yang.lee@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-add-kernel-doc-comments-to-nilfs_btree_convert_and_insert.patch removed from -mm tree
Message-Id: <20240426040808.70EC0C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: add kernel-doc comments to nilfs_btree_convert_and_insert()
has been removed from the -mm tree.  Its filename was
     nilfs2-add-kernel-doc-comments-to-nilfs_btree_convert_and_insert.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



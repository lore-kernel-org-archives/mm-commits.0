Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C66A14F100
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248823; cv=none; b=abQIe7ZKgYDAoT43jJ3qx9HxeS2C9haNcsZ+FIBFaQnKtZyocMwvCnazKNNDJSBV2Jzked8nihRt9b95/WN3Y1fQdwPypoMSJ0u/MX0Urcdo5Y4H6WWB3CGMPd8o7dNUyhj7lKQNnSX4JVb49gywshTZiH/XpE9yO+77ZRvCvT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248823; c=relaxed/simple;
	bh=9rODbnu4jayLyhAkqWte6VOAAvY6XySF+g3A5rKN0k0=;
	h=Date:To:From:Subject:Message-Id; b=A1Jbv8VY80FFo7hV7+dOwqtXMPbxozuh0X2IVQafgdWXMrk4tVcTSpCFiKO7Hs7npzmI0uztezdJHy/N38vCGEMXGHbQJmxkZJZ3pNyNBq+rXLJknpKhgR0UdN1Q9MpzVNQriKfFosrMcN8cYO89v+Q+3T73kRcycJGXJvKBuZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K+mON82S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K+mON82S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53CD4C4CEC2;
	Mon,  2 Sep 2024 03:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248823;
	bh=9rODbnu4jayLyhAkqWte6VOAAvY6XySF+g3A5rKN0k0=;
	h=Date:To:From:Subject:From;
	b=K+mON82SnMgCs1qOgFfHuYtKlzzKwWrvsiqVj3T06E0f6QHjaY7TJMdN7WBb9r2ma
	 lwf070SVB1C38h5klD/ti5CDbPYjv8ZZp3MHETknfckOilA1rQglK+bi0nT0dJonDN
	 iUr6B5PqeIF8Gn9PnfjJo8tCQUcLhO+s94GtlZwE=
Date: Sun, 01 Sep 2024 20:47:02 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-fix-incorrect-kernel-doc-declaration-of-nilfs_palloc_req-structure.patch removed from -mm tree
Message-Id: <20240902034703.53CD4C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: fix incorrect kernel-doc declaration of nilfs_palloc_req structure
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-incorrect-kernel-doc-declaration-of-nilfs_palloc_req-structure.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: fix incorrect kernel-doc declaration of nilfs_palloc_req structure
Date: Fri, 16 Aug 2024 16:43:15 +0900

The "struct" keyword is missing from the kernel-doc comment of the
nilfs_palloc_req structure, so add it to eliminate the following warning
output by the kernel-doc script:

 fs/nilfs2/alloc.h:46: warning: cannot understand function prototype:
  'struct nilfs_palloc_req '

Link: https://lkml.kernel.org/r/20240816074319.3253-5-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/alloc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nilfs2/alloc.h~nilfs2-fix-incorrect-kernel-doc-declaration-of-nilfs_palloc_req-structure
+++ a/fs/nilfs2/alloc.h
@@ -37,7 +37,7 @@ void *nilfs_palloc_block_get_entry(const
 int nilfs_palloc_count_max_entries(struct inode *, u64, u64 *);
 
 /**
- * nilfs_palloc_req - persistent allocator request and reply
+ * struct nilfs_palloc_req - persistent allocator request and reply
  * @pr_entry_nr: entry number (vblocknr or inode number)
  * @pr_desc_bh: buffer head of the buffer containing block group descriptors
  * @pr_bitmap_bh: buffer head of the buffer containing a block group bitmap
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are



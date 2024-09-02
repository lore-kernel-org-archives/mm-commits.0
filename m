Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE6669959
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248853; cv=none; b=ZLDE8tGn1u/qUHeRLiwL1JaTwhdE4wGyFbaoGlt6pozEDxdmKv1/zprcEs5TCtNq+hmtFxVXTuD9Hm3Yc5IBLs6ZpfZflhgn1TrMccpFEly4lvIlbf93U1zSJZdh47HILNgQV8QlZEjLEmyPDV0oY0LqlyOyfQ3OzHObLOAEk34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248853; c=relaxed/simple;
	bh=ohqnwCnmyW9Vbnsj3ZyA6Isyy/+YkdkfQX+uDTIJzd8=;
	h=Date:To:From:Subject:Message-Id; b=PSHdS6UxxSrQlisyWht+JRYqalvjdkHHO/avJUMrIL7BVIF4ES6LdUVD5cAnpGDLS3tWzeWi4W7wSQ8SNG0EM90jDYzoq1yJS+cbSRuDlntAAhEI4BrbJED85mQAH9vnjS+qFgcNY3A8MiBpy+H+4/24iyfnf/sz0crsUnnFnpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lwnZwIQA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lwnZwIQA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73A15C4CEC2;
	Mon,  2 Sep 2024 03:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248852;
	bh=ohqnwCnmyW9Vbnsj3ZyA6Isyy/+YkdkfQX+uDTIJzd8=;
	h=Date:To:From:Subject:From;
	b=lwnZwIQArWvuGzShH8zi/HHGbfxAkN4ukNPfiKSu4P9Ld1jWWsDBhe2hVY3Q0/Wef
	 o3wwJ0PH5wbeJOf45gq7THvNBGGtsLJucX5+GRIycmgIIzkPdWb3iMa+mLNEruwD3H
	 q4CNrHs2bqz6xDormiebIWGWToHjrHQKAfi9If7g=
Date: Sun, 01 Sep 2024 20:47:31 -0700
To: mm-commits@vger.kernel.org,huangxiaojia2@huawei.com,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-use-the-bits_per_long-macro.patch removed from -mm tree
Message-Id: <20240902034732.73A15C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: use the BITS_PER_LONG macro
has been removed from the -mm tree.  Its filename was
     nilfs2-use-the-bits_per_long-macro.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: use the BITS_PER_LONG macro
Date: Tue, 27 Aug 2024 02:41:10 +0900

The macros NILFS_BMAP_KEY_BIT and NILFS_BMAP_NEW_PTR_INIT calculate,
within their definitions, the number of bits in an unsigned long variable.
Use the BITS_PER_LONG macro to make them simpler.

Link: https://lkml.kernel.org/r/20240826174116.5008-3-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Huang Xiaojia <huangxiaojia2@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/bmap.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/fs/nilfs2/bmap.h~nilfs2-use-the-bits_per_long-macro
+++ a/fs/nilfs2/bmap.h
@@ -87,9 +87,8 @@ struct nilfs_bmap_operations {
 
 
 #define NILFS_BMAP_SIZE		(NILFS_INODE_BMAP_SIZE * sizeof(__le64))
-#define NILFS_BMAP_KEY_BIT	(sizeof(unsigned long) * 8 /* CHAR_BIT */)
-#define NILFS_BMAP_NEW_PTR_INIT	\
-	(1UL << (sizeof(unsigned long) * 8 /* CHAR_BIT */ - 1))
+#define NILFS_BMAP_KEY_BIT	BITS_PER_LONG
+#define NILFS_BMAP_NEW_PTR_INIT	(1UL << (BITS_PER_LONG - 1))
 
 static inline int nilfs_bmap_is_new_ptr(unsigned long ptr)
 {
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are



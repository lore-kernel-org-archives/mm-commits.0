Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E67864596E
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291552; cv=none; b=LbFy8Hzqye7z+lnyEqBXImps9PQoxfduaInXsQ3SuvwlBVcmDYdbXPQAL4RXtGiN2FP77Uo+w0SCcrVoVhb4CbZTAkWc7cr8n0mLNXFSGflKVIi30uGDi0w031Wp0w8t+tFsqMHQdZN4xGW6k3lPk6t82ifDXEnyhYDCYBHLJCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291552; c=relaxed/simple;
	bh=+TCBaOxRifbPo6HW2jTKXAn7lQR4CWDt7iveg7o8A9Y=;
	h=Date:To:From:Subject:Message-Id; b=u1FKO7aVHirj4zo5moToH6Qb5ORxaQo8qjCUFRJa94q6JXvv8KfQS1/5ckfg0Uxp0Zyw9aOjvHBIJ5MdXwgpyj/3Aey3j6drKItHS/9P7qqx4+JpDW0xbXm68hLwbd3Z+t6FPGWZZs/GnbIPYzGkOe/it8ojNAJyZg9JYmcFJcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o92vwq/T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o92vwq/T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64221C32782;
	Tue, 25 Jun 2024 04:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291551;
	bh=+TCBaOxRifbPo6HW2jTKXAn7lQR4CWDt7iveg7o8A9Y=;
	h=Date:To:From:Subject:From;
	b=o92vwq/TjqPBJvljJ4sMlgknFHk15PdIIjoaugDHKzi5Fls8PtdOxtMV+ffVR/m0e
	 dowipuwbmBAxL7voWHi9cHZRyW9lNsiz71nWRrISWQI58By5rlMWEStqeeBP6fELGf
	 VQMLSg3Mue/mNNYX/r+4yTFrEeg44DKpvu+uMRiQ=
Date: Mon, 24 Jun 2024 21:59:10 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,xiubli@redhat.com,willy@infradead.org,v-songbaohua@oppo.com,trond.myklebust@hammerspace.com,ryan.roberts@arm.com,neilb@suse.de,minchan@kernel.org,marc.dionne@auristor.com,konishi.ryusuke@gmail.com,jlayton@kernel.org,jaegeuk@kernel.org,idryomov@gmail.com,hughd@google.com,dhowells@redhat.com,david@redhat.com,chrisl@kernel.org,chao@kernel.org,anna@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] nfs-remove-nfs_page_lengthg-and-usage-of-page_index.patch removed from -mm tree
Message-Id: <20240625045911.64221C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: NFS: remove nfs_page_lengthg and usage of page_index
has been removed from the -mm tree.  Its filename was
     nfs-remove-nfs_page_lengthg-and-usage-of-page_index.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: NFS: remove nfs_page_lengthg and usage of page_index
Date: Wed, 22 May 2024 01:58:46 +0800

This function is no longer used after commit 4fa7a717b432 ("NFS: Fix up
nfs_vm_page_mkwrite() for folios"), all users have been converted to use
folio instead, just delete it to remove usage of page_index.

Link: https://lkml.kernel.org/r/20240521175854.96038-5-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Anna Schumaker <anna@kernel.org>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Chao Yu <chao@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Marc Dionne <marc.dionne@auristor.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: NeilBrown <neilb@suse.de>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Xiubo Li <xiubli@redhat.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/internal.h |   19 -------------------
 1 file changed, 19 deletions(-)

--- a/fs/nfs/internal.h~nfs-remove-nfs_page_lengthg-and-usage-of-page_index
+++ a/fs/nfs/internal.h
@@ -800,25 +800,6 @@ static inline void nfs_folio_mark_unstab
 /*
  * Determine the number of bytes of data the page contains
  */
-static inline
-unsigned int nfs_page_length(struct page *page)
-{
-	loff_t i_size = i_size_read(page_file_mapping(page)->host);
-
-	if (i_size > 0) {
-		pgoff_t index = page_index(page);
-		pgoff_t end_index = (i_size - 1) >> PAGE_SHIFT;
-		if (index < end_index)
-			return PAGE_SIZE;
-		if (index == end_index)
-			return ((i_size - 1) & ~PAGE_MASK) + 1;
-	}
-	return 0;
-}
-
-/*
- * Determine the number of bytes of data the page contains
- */
 static inline size_t nfs_folio_length(struct folio *folio)
 {
 	loff_t i_size = i_size_read(folio_file_mapping(folio)->host);
_

Patches currently in -mm which might be from kasong@tencent.com are



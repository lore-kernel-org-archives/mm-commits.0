Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A2651494C0
	for <mm-commits@vger.kernel.org>; Tue, 21 May 2024 19:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716321483; cv=none; b=laf2/3kpn5E8oTJyzqSCjqBS2Cxzs1Y+q9mr9EZnZkE7sOqM8uWGvypYh33rc5glNwR4x2HvDm87SH0aYt8Gh6VqAPuRH4wJ6zvWjtfg2aIECVlIuyPO8Ey/sVt7/fRnlWmsLuQdqDqFHoaJO41dswhI/mphjmqpaSAPyAzW6VI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716321483; c=relaxed/simple;
	bh=OoRJJyVxfQ1amaFjH5qEqzbONV1uy/PRNzPGK5jwlJI=;
	h=Date:To:From:Subject:Message-Id; b=GupHT0oBz3SGH3JWF2k0AHsxNicb57OHUq7fWAbaWogCjXSaS67OMZGv3HZ/f22Xt5MZkHMGEMcs4Po2nNlVH8rSX4sayTU65sYMAgeg0LkC0f6xuf+5MALu/ijtJQfTmztAxQb3qwhtagXWKpzYTkSQDtaLB+zLX6BRvt7bmcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sGPoX5pn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sGPoX5pn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B069CC2BD11;
	Tue, 21 May 2024 19:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716321482;
	bh=OoRJJyVxfQ1amaFjH5qEqzbONV1uy/PRNzPGK5jwlJI=;
	h=Date:To:From:Subject:From;
	b=sGPoX5pnbOHu7tfmwywGJufKedaeZQh1ZXI4c7n/urz93MxKgkCy9xMxMU7RS+lMZ
	 IPJtLc3pMkySIVPDiu8wRBCnnfslgl9sfaI+silByoPr044wY1hdXOxjY7w0xQPbCK
	 ky5cJM6b/AmKBQ9ohCzE9NujjWoyAdraxTNzbW90=
Date: Tue, 21 May 2024 12:58:02 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,xiubli@redhat.com,willy@infradead.org,v-songbaohua@oppo.com,trond.myklebust@hammerspace.com,ryan.roberts@arm.com,neilb@suse.de,minchan@kernel.org,marc.dionne@auristor.com,konishi.ryusuke@gmail.com,jlayton@kernel.org,jaegeuk@kernel.org,idryomov@gmail.com,hughd@google.com,dhowells@redhat.com,david@redhat.com,chrisl@kernel.org,chao@kernel.org,anna@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nfs-remove-nfs_page_lengthg-and-usage-of-page_index.patch added to mm-unstable branch
Message-Id: <20240521195802.B069CC2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: NFS: remove nfs_page_lengthg and usage of page_index
has been added to the -mm mm-unstable branch.  Its filename is
     nfs-remove-nfs_page_lengthg-and-usage-of-page_index.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nfs-remove-nfs_page_lengthg-and-usage-of-page_index.patch

This patch will later appear in the mm-unstable branch at
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
@@ -793,25 +793,6 @@ static inline void nfs_folio_mark_unstab
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

f2fs-drop-usage-of-page_index.patch
nilfs2-drop-usage-of-page_index.patch
ceph-drop-usage-of-page_index.patch
nfs-remove-nfs_page_lengthg-and-usage-of-page_index.patch
afs-drop-usage-of-folio_file_pos.patch
netfs-drop-usage-of-folio_file_pos.patch
nfs-drop-usage-of-folio_file_pos.patch
mm-swap-get-the-swap-device-offset-directly.patch
mm-remove-page_file_offset-and-folio_file_pos.patch
mm-drop-page_index-and-simplify-folio_index.patch
mm-swap-reduce-swap-cache-search-space.patch


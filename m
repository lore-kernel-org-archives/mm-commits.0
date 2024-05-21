Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D701494C0
	for <mm-commits@vger.kernel.org>; Tue, 21 May 2024 19:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716321495; cv=none; b=IrJc/VOIuJheWgFcX41/gdILMSBuyV8cTDUs28gNHdM5dVWUlgbYz7URMwmX3dnopAc5i+ylSqt9V5ENehAKNWlpxjB7388GHo1deYKg5fm7fgHe7lHmVob6UO60zDfOYevzBDfUr7+QGcw4eUW4iJ2Nr1xF2hJkAwlLz8cKSKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716321495; c=relaxed/simple;
	bh=zzV39VJY5zxvxtnUrjZoktiUrtcnRXEuVtgq15iRC9Y=;
	h=Date:To:From:Subject:Message-Id; b=e/64cJxzVVnCZa4K3nY3mPKwS6xtIMC3zu6CPDJHhwp6QkAnm0YUHDCUwxMbBOemB2w0aczoWVE/s3fJ/c14jqil2k+5X0ET9SvgupHpYF2T4j2Sre5F56nZ5ZUmD/W5aoAwJHCDDF41az8zi9VdRfBdj38FJgJYo8SUYac3Xyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SrZiH3U3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SrZiH3U3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4899C2BD11;
	Tue, 21 May 2024 19:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716321494;
	bh=zzV39VJY5zxvxtnUrjZoktiUrtcnRXEuVtgq15iRC9Y=;
	h=Date:To:From:Subject:From;
	b=SrZiH3U3TNEZMxuKCqfTp5jGo0jb9P386TpUeDBk5SHkZoUjwhfxpyd92/eAdtGmW
	 v2bCC/D5EoN3lnC139kbwqA4Zi9mEjLcXjmyaNQBpfa9uoF1HsOAEJ6g31J/vhQ2tt
	 K8twe8Ptd/IUOqvu+geu7MJBaYzM8yJntyevfHb4=
Date: Tue, 21 May 2024 12:58:14 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,xiubli@redhat.com,willy@infradead.org,v-songbaohua@oppo.com,trond.myklebust@hammerspace.com,ryan.roberts@arm.com,neilb@suse.de,minchan@kernel.org,marc.dionne@auristor.com,konishi.ryusuke@gmail.com,jlayton@kernel.org,jaegeuk@kernel.org,idryomov@gmail.com,hughd@google.com,dhowells@redhat.com,david@redhat.com,chrisl@kernel.org,chao@kernel.org,anna@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-page_file_offset-and-folio_file_pos.patch added to mm-unstable branch
Message-Id: <20240521195814.C4899C2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove page_file_offset and folio_file_pos
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-page_file_offset-and-folio_file_pos.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-page_file_offset-and-folio_file_pos.patch

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
Subject: mm: remove page_file_offset and folio_file_pos
Date: Wed, 22 May 2024 01:58:51 +0800

These two helpers were useful for mixed usage of swap cache and page
cache, which help retrieve the corresponding file or swap device offset of
a page or folio.

They were introduced in commit f981c5950fa8 ("mm: methods for teaching
filesystems about PG_swapcache pages") and used in commit d56b4ddf7781
("nfs: teach the NFS client how to treat PG_swapcache pages"), suppose to
be used with direct_IO for swap over fs.

But after commit e1209d3a7a67 ("mm: introduce ->swap_rw and use it for
reads from SWP_FS_OPS swap-space"), swap with direct_IO is no more, and
swap cache mapping is never exposed to fs.

Now we have dropped all users of page_file_offset and folio_file_pos, so
they can be deleted.

Link: https://lkml.kernel.org/r/20240521175854.96038-10-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Anna Schumaker <anna@kernel.org>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Chao Yu <chao@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
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
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Xiubo Li <xiubli@redhat.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |   17 -----------------
 1 file changed, 17 deletions(-)

--- a/include/linux/pagemap.h~mm-remove-page_file_offset-and-folio_file_pos
+++ a/include/linux/pagemap.h
@@ -920,11 +920,6 @@ static inline loff_t page_offset(struct
 	return ((loff_t)page->index) << PAGE_SHIFT;
 }
 
-static inline loff_t page_file_offset(struct page *page)
-{
-	return ((loff_t)page_index(page)) << PAGE_SHIFT;
-}
-
 /**
  * folio_pos - Returns the byte position of this folio in its file.
  * @folio: The folio.
@@ -934,18 +929,6 @@ static inline loff_t folio_pos(struct fo
 	return page_offset(&folio->page);
 }
 
-/**
- * folio_file_pos - Returns the byte position of this folio in its file.
- * @folio: The folio.
- *
- * This differs from folio_pos() for folios which belong to a swap file.
- * NFS is the only filesystem today which needs to use folio_file_pos().
- */
-static inline loff_t folio_file_pos(struct folio *folio)
-{
-	return page_file_offset(&folio->page);
-}
-
 /*
  * Get the offset in PAGE_SIZE (even for hugetlb folios).
  */
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


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D18771494C0
	for <mm-commits@vger.kernel.org>; Tue, 21 May 2024 19:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716321479; cv=none; b=iIx4/Sf/aGvjgDw4WcH0sfNPbyI89odwaTsg6cPPca8kpu1Nr8DcJsg/Fr6RFAIuSs+ix2YPCSg5EoNkM+8QMHN5yyW/LVYgtVyQ3FZWW0KnIr4QH5Df6w7JbLabqQw8bK92bDOe3PXMPWO2ihEXGGNRTFvCcLCrO52NdQCbZWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716321479; c=relaxed/simple;
	bh=vPZQxW6tC1ghCRPVuGT7yFtPAJ2iHOZ7dqYcNEBcM50=;
	h=Date:To:From:Subject:Message-Id; b=cDycB6fKNgurLvp3eIHwgbRt059IYZbk8Jxj69RggPKezsxNoK0eujDwCG1gdLJSB7wPK2goGu1itgcy4BHEm/Yrn2HjZApGCvXXd6Kq08UfT0bN3ETs1QRTFDnqzSdgpw2Pe1w9x8jtin1GT93g6HaDWB2N+1rcWEEas1hP2Jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z8fcExR1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z8fcExR1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F045C2BD11;
	Tue, 21 May 2024 19:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716321478;
	bh=vPZQxW6tC1ghCRPVuGT7yFtPAJ2iHOZ7dqYcNEBcM50=;
	h=Date:To:From:Subject:From;
	b=Z8fcExR1S7y4/aTrJHNGHKlb1mVzlcOr36+Nh8JfZdJzJMHhd95L28cScUpLdprR/
	 H3ZXAv3BNzBthQvYVYeWIE9vWY7pdlYd1/cEM7v7DuNdHLrC6RlOGMrtXlRZm/snop
	 +jcNDATwHeD5Hr3ozTiPVRMZG007XpBWPf5z1N3w=
Date: Tue, 21 May 2024 12:57:57 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,xiubli@redhat.com,willy@infradead.org,v-songbaohua@oppo.com,trond.myklebust@hammerspace.com,ryan.roberts@arm.com,neilb@suse.de,minchan@kernel.org,marc.dionne@auristor.com,konishi.ryusuke@gmail.com,jlayton@kernel.org,jaegeuk@kernel.org,idryomov@gmail.com,hughd@google.com,dhowells@redhat.com,david@redhat.com,chrisl@kernel.org,chao@kernel.org,anna@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-drop-usage-of-page_index.patch added to mm-unstable branch
Message-Id: <20240521195758.4F045C2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: drop usage of page_index
has been added to the -mm mm-unstable branch.  Its filename is
     nilfs2-drop-usage-of-page_index.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-drop-usage-of-page_index.patch

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
Subject: nilfs2: drop usage of page_index
Date: Wed, 22 May 2024 01:58:44 +0800

page_index is only for mixed usage of page cache and swap cache, for pure
page cache usage, the caller can just use page->index instead.

It can't be a swap cache page here (being part of buffer head), so just
drop it.  And while we are at it, optimize the code by retrieving the
offset of the buffer head within the folio directly using bh_offset, and
get rid of the loop and usage of page helpers.

Link: https://lkml.kernel.org/r/20240521175854.96038-3-ryncsn@gmail.com
Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
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
Cc: Minchan Kim <minchan@kernel.org>
Cc: NeilBrown <neilb@suse.de>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Xiubo Li <xiubli@redhat.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/bmap.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/fs/nilfs2/bmap.c~nilfs2-drop-usage-of-page_index
+++ a/fs/nilfs2/bmap.c
@@ -450,15 +450,9 @@ int nilfs_bmap_test_and_clear_dirty(stru
 __u64 nilfs_bmap_data_get_key(const struct nilfs_bmap *bmap,
 			      const struct buffer_head *bh)
 {
-	struct buffer_head *pbh;
-	__u64 key;
+	loff_t pos = folio_pos(bh->b_folio) + bh_offset(bh);
 
-	key = page_index(bh->b_page) << (PAGE_SHIFT -
-					 bmap->b_inode->i_blkbits);
-	for (pbh = page_buffers(bh->b_page); pbh != bh; pbh = pbh->b_this_page)
-		key++;
-
-	return key;
+	return pos >> bmap->b_inode->i_blkbits;
 }
 
 __u64 nilfs_bmap_find_target_seq(const struct nilfs_bmap *bmap, __u64 key)
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


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA27D13CF9E
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291558; cv=none; b=iJJURbR2VQe0btLA44jtL0sQk9AW7NaDF17NpMGXGPbX4C5r7YljSP3omZgOEp0VakAZOoRNrruuE1+SAyaftMTBA8nrAU5RG+D35BBAzNdjgpMDueMsy95Hvygpz/6xn6sXU2DFB/jderVqAj3QRdkDao8xq6uOMKb5H1YpS8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291558; c=relaxed/simple;
	bh=5rcOuof+8i1aP++NDjaU0A7nMDwHRHIlnVMDGtLfqbs=;
	h=Date:To:From:Subject:Message-Id; b=MuhavqWyfhfp0Onic8F9Yyy6tVogNtUEz+5HlX1yn8zykqGmwWwdz7kEgyI+1eeGJyyeBO+t43bZTOBC/ijkQXzFjW02FChya+9nj13h+tq38ShNk4TWYRM5EJYXrMtRuewrnMxqpMA8rspY9g4WFXCJbwhQETPSuTFBuTU1Sug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=imMvRGNB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="imMvRGNB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4151C32782;
	Tue, 25 Jun 2024 04:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291557;
	bh=5rcOuof+8i1aP++NDjaU0A7nMDwHRHIlnVMDGtLfqbs=;
	h=Date:To:From:Subject:From;
	b=imMvRGNBRMuh2g3bS5jAl/ZxJfBgLixwqNotzd6LdBfLeGT8kqLPBu1r82QC0GSPx
	 KIqj3Zox758rnj6GvExJtxwBcsXSQ2FjFkXBxo50qP/6bKbuyFXxutmy/LfC5qMOYl
	 YHSMKlDOD/WeC6kJCFzxQYQmM4EeIGSDKBiJJsKA=
Date: Mon, 24 Jun 2024 21:59:17 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,xiubli@redhat.com,willy@infradead.org,v-songbaohua@oppo.com,trond.myklebust@hammerspace.com,ryan.roberts@arm.com,neilb@suse.de,minchan@kernel.org,marc.dionne@auristor.com,konishi.ryusuke@gmail.com,jlayton@kernel.org,jaegeuk@kernel.org,idryomov@gmail.com,hughd@google.com,dhowells@redhat.com,david@redhat.com,chrisl@kernel.org,chao@kernel.org,anna@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-page_file_offset-and-folio_file_pos.patch removed from -mm tree
Message-Id: <20240625045917.B4151C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove page_file_offset and folio_file_pos
has been removed from the -mm tree.  Its filename was
     mm-remove-page_file_offset-and-folio_file_pos.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -932,11 +932,6 @@ static inline loff_t page_offset(struct
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
@@ -946,18 +941,6 @@ static inline loff_t folio_pos(struct fo
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



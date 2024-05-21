Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50E9E1494C0
	for <mm-commits@vger.kernel.org>; Tue, 21 May 2024 19:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716321487; cv=none; b=LJNx+A5280GnuQ2B5wDrAtstpFGhiZrvyKelz0fvVGiGVN3ZeXinlJfEOUxiFQEhhGNPLjmgN6ZBqnCamRjeD1RwSKnr1T3KXb2dok82hoc3ZUgNkYV8bUdW+XLKfn+bHuxPGMgqBtuO9ihuGUZ7qHxxegDGrY9TWD++3j94BKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716321487; c=relaxed/simple;
	bh=JbhLDsisvoIGFAfPIJkTx+zwgC+gbaj/iw2cP5jj0V8=;
	h=Date:To:From:Subject:Message-Id; b=iqV7dRM9MNV7P50cDCH7g0sz5sOd4ZHfWDVMoTOvFMdqpNhwpjKiuusUje8QEsIiuStQapuGmGSEuu9MGawG7QCyDCckjtnvIWWGGf5GCm1UGu4DuZdUx0p0I/sEuvOdfl4N5XlKEraeYnNLTacPogHS/6Uezi2OFy4+HCQ9pmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OoMX8kwR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OoMX8kwR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D6BAC2BD11;
	Tue, 21 May 2024 19:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716321487;
	bh=JbhLDsisvoIGFAfPIJkTx+zwgC+gbaj/iw2cP5jj0V8=;
	h=Date:To:From:Subject:From;
	b=OoMX8kwR7p/ac8wKcvdMWZrUaqLGir4GEdLxjgLhtlTiW4ymnuRptV8aDmzPi3pNK
	 zud7/X3GTBSEjPcOynI7sfqfQIRr0OCVJEFg9z9j3WSimi6Djzp+uAboDMmkLewpAC
	 8hCm4v6cdrcYMiGCoV+LV7XyN+c9s8/YY2c7lomg=
Date: Tue, 21 May 2024 12:58:06 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,xiubli@redhat.com,willy@infradead.org,v-songbaohua@oppo.com,trond.myklebust@hammerspace.com,ryan.roberts@arm.com,neilb@suse.de,minchan@kernel.org,marc.dionne@auristor.com,konishi.ryusuke@gmail.com,jlayton@kernel.org,jaegeuk@kernel.org,idryomov@gmail.com,hughd@google.com,dhowells@redhat.com,david@redhat.com,chrisl@kernel.org,chao@kernel.org,anna@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + netfs-drop-usage-of-folio_file_pos.patch added to mm-unstable branch
Message-Id: <20240521195807.1D6BAC2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: netfs: drop usage of folio_file_pos
has been added to the -mm mm-unstable branch.  Its filename is
     netfs-drop-usage-of-folio_file_pos.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/netfs-drop-usage-of-folio_file_pos.patch

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
Subject: netfs: drop usage of folio_file_pos
Date: Wed, 22 May 2024 01:58:48 +0800

folio_file_pos is only needed for mixed usage of page cache and swap
cache, for pure page cache usage, the caller can just use folio_pos
instead.

It can't be a swap cache page here.  Swap mapping may only call into fs
through swap_rw and that is not supported for netfs.  So just drop it and
use folio_pos instead.

Link: https://lkml.kernel.org/r/20240521175854.96038-7-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Anna Schumaker <anna@kernel.org>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Chao Yu <chao@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
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

 fs/netfs/buffered_read.c  |    4 ++--
 fs/netfs/buffered_write.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/fs/netfs/buffered_read.c~netfs-drop-usage-of-folio_file_pos
+++ a/fs/netfs/buffered_read.c
@@ -271,7 +271,7 @@ int netfs_read_folio(struct file *file,
 	_enter("%lx", folio->index);
 
 	rreq = netfs_alloc_request(mapping, file,
-				   folio_file_pos(folio), folio_size(folio),
+				   folio_pos(folio), folio_size(folio),
 				   NETFS_READPAGE);
 	if (IS_ERR(rreq)) {
 		ret = PTR_ERR(rreq);
@@ -470,7 +470,7 @@ retry:
 	}
 
 	rreq = netfs_alloc_request(mapping, file,
-				   folio_file_pos(folio), folio_size(folio),
+				   folio_pos(folio), folio_size(folio),
 				   NETFS_READ_FOR_WRITE);
 	if (IS_ERR(rreq)) {
 		ret = PTR_ERR(rreq);
--- a/fs/netfs/buffered_write.c~netfs-drop-usage-of-folio_file_pos
+++ a/fs/netfs/buffered_write.c
@@ -54,7 +54,7 @@ static enum netfs_how_to_modify netfs_ho
 {
 	struct netfs_folio *finfo = netfs_folio_info(folio);
 	struct netfs_group *group = netfs_folio_group(folio);
-	loff_t pos = folio_file_pos(folio);
+	loff_t pos = folio_pos(folio);
 
 	_enter("");
 
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


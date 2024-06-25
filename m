Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC0213CF9E
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291554; cv=none; b=bwhERf//YBhBfhaDDUDWhUudOQQidEyGqCWRWyocmAA0BIZekJsTxnt4tr2nEsy/kSCU/xV5H++OFjfltHCVBQqX590Bf49CeutiveXU2PzNf3SibcsuubGw1Y1wB1FKs7ETDethVEOatfoO2MwxiEQtYQsz6mtKC534j3yiN3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291554; c=relaxed/simple;
	bh=vIltf97+LkDtr5otVuUmUUcsqF7qBxGllNr5tdeoXuI=;
	h=Date:To:From:Subject:Message-Id; b=SoQ8FB2esAuKzrolCg6W4oBgEEq8TTXbJf3eKNJWnc4m8hBm9W3ueQxIUlyt5r5rTFNMfTw2XAJI3ZQQvUz3lZfaDoa+8fCpFjv+ysmKFZej3fHGWjKdDPS0A7XXepf3Y0ZGS8UAiBxKwhY14rWSHfC1hTzGuv3voUag4uHUJN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CTKKJxqW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CTKKJxqW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4991C32782;
	Tue, 25 Jun 2024 04:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291553;
	bh=vIltf97+LkDtr5otVuUmUUcsqF7qBxGllNr5tdeoXuI=;
	h=Date:To:From:Subject:From;
	b=CTKKJxqWBD8upJinyGcMjYyDI+/HQVjUWKWwgxXaQ9R15wJsgLK4MXUAHjiuRcIFU
	 ACID6jyyulJsnfa0CbL4Y69nHp+RAjVOAtp2CQ/nXXx3wCY853+lZlOH4dADcrNr6y
	 PIhI5P4QphQNFzUl2wOpKgD1ojYU0SbRLGpmquBA=
Date: Mon, 24 Jun 2024 21:59:13 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,xiubli@redhat.com,willy@infradead.org,v-songbaohua@oppo.com,trond.myklebust@hammerspace.com,ryan.roberts@arm.com,neilb@suse.de,minchan@kernel.org,marc.dionne@auristor.com,konishi.ryusuke@gmail.com,jlayton@kernel.org,jaegeuk@kernel.org,idryomov@gmail.com,hughd@google.com,dhowells@redhat.com,david@redhat.com,chrisl@kernel.org,chao@kernel.org,anna@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] netfs-drop-usage-of-folio_file_pos.patch removed from -mm tree
Message-Id: <20240625045913.D4991C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: netfs: drop usage of folio_file_pos
has been removed from the -mm tree.  Its filename was
     netfs-drop-usage-of-folio_file_pos.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



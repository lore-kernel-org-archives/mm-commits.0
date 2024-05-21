Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AC511494C0
	for <mm-commits@vger.kernel.org>; Tue, 21 May 2024 19:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716321480; cv=none; b=KoHrKovr3xw9Ogab1oumxMzlJea48eeML7Mmlt+M+/WYS0+RgGwb0XNuVKVSBkjll38IYuTHvNbzWpYZKLe1gvmN4tsP6SA7fYvmcfKOAGjToAn2PqwGhXjypZnLN53HKmAAAJFqafgCqTcuWEPC0+einXKXWQ9Eoug1s5AozEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716321480; c=relaxed/simple;
	bh=AYa78bVmYO1fYoO4kpCzl84bvglfxYKsHYYJByHYicA=;
	h=Date:To:From:Subject:Message-Id; b=MJTHbHF6RoMVwGzVBH/69iV0HzNYz5dBbs6ercDkHsTJTAnfRirWbBmKtQzzN/uG2ombyW/1KNNMB7PgJqhE4SGhmTannXjCKCjoE8Wfi+HljSIlvDpd5Ec+gBxYYwMN4WmwtM3yGSx9CzGUEjX8wPyXmhXgoGKF0iZbu8HyJlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=je6cgb0b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="je6cgb0b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53FB7C2BD11;
	Tue, 21 May 2024 19:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716321480;
	bh=AYa78bVmYO1fYoO4kpCzl84bvglfxYKsHYYJByHYicA=;
	h=Date:To:From:Subject:From;
	b=je6cgb0bbKmYcXIdwNvHXrXT3Lgwu+6akjiZiavc1d0FbIspZvmU7GAOgPaAKIkvM
	 Sf3o3lx4DhM2r3PkbGfABOyIos2DE9zH0+QOR+PkNO3lMUTNcATjuqSZ1tzOpzB7wC
	 1W4TqUT+SbPu1QWKi+68iLdpNbh7kopaHGCDT5hM=
Date: Tue, 21 May 2024 12:57:59 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,xiubli@redhat.com,willy@infradead.org,v-songbaohua@oppo.com,trond.myklebust@hammerspace.com,ryan.roberts@arm.com,neilb@suse.de,minchan@kernel.org,marc.dionne@auristor.com,konishi.ryusuke@gmail.com,jlayton@kernel.org,jaegeuk@kernel.org,idryomov@gmail.com,hughd@google.com,dhowells@redhat.com,david@redhat.com,chrisl@kernel.org,chao@kernel.org,anna@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ceph-drop-usage-of-page_index.patch added to mm-unstable branch
Message-Id: <20240521195800.53FB7C2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ceph: drop usage of page_index
has been added to the -mm mm-unstable branch.  Its filename is
     ceph-drop-usage-of-page_index.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ceph-drop-usage-of-page_index.patch

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
Subject: ceph: drop usage of page_index
Date: Wed, 22 May 2024 01:58:45 +0800

page_index is needed for mixed usage of page cache and swap cache, for
pure page cache usage, the caller can just use page->index instead.

It can't be a swap cache page here, so just drop it.

Link: https://lkml.kernel.org/r/20240521175854.96038-4-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: Xiubo Li <xiubli@redhat.com>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Anna Schumaker <anna@kernel.org>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Chao Yu <chao@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Marc Dionne <marc.dionne@auristor.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: NeilBrown <neilb@suse.de>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ceph/dir.c   |    2 +-
 fs/ceph/inode.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ceph/dir.c~ceph-drop-usage-of-page_index
+++ a/fs/ceph/dir.c
@@ -141,7 +141,7 @@ __dcache_find_get_entry(struct dentry *p
 	if (ptr_pos >= i_size_read(dir))
 		return NULL;
 
-	if (!cache_ctl->page || ptr_pgoff != page_index(cache_ctl->page)) {
+	if (!cache_ctl->page || ptr_pgoff != cache_ctl->page->index) {
 		ceph_readdir_cache_release(cache_ctl);
 		cache_ctl->page = find_lock_page(&dir->i_data, ptr_pgoff);
 		if (!cache_ctl->page) {
--- a/fs/ceph/inode.c~ceph-drop-usage-of-page_index
+++ a/fs/ceph/inode.c
@@ -1863,7 +1863,7 @@ static int fill_readdir_cache(struct ino
 	unsigned idx = ctl->index % nsize;
 	pgoff_t pgoff = ctl->index / nsize;
 
-	if (!ctl->page || pgoff != page_index(ctl->page)) {
+	if (!ctl->page || pgoff != ctl->page->index) {
 		ceph_readdir_cache_release(ctl);
 		if (idx == 0)
 			ctl->page = grab_cache_page(&dir->i_data, pgoff);
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


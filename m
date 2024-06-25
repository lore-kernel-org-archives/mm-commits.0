Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 608574596E
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291550; cv=none; b=WnRMen/Q9j2IaAwgWI9KwjIsbKrx2H4lCkRKwgOyBEMH+AW9GRhvmc0PtBmDM2Wkd6JioCNgfaATukCzEOPnVElVfNi8Xg9UFQTG3xADI3GLGl2b4t+MTSCOacrf5OyGnPo3YkBnR4LuWxhk/tGuY/lhlAiyEDwAPFk2M+gIp0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291550; c=relaxed/simple;
	bh=+Edo+jdHJ15GLJV77VSn7V8bg7eH4AIGi77/TmsTEkY=;
	h=Date:To:From:Subject:Message-Id; b=U57twA5EaD8eQCLtTj1g9uVWVmVogKH1irqgbglxIB/MA2dNipBpv+JdJlSgeyG02LwPJCK/RS3HA8YyNnk1V/KrbhzRsghphxw7dXu+BzFujZ7nRRmHktJ+gRObhTrwTAWr+eiYR14UuzXzy5scZZ4CeFNQftNwvboJkQu8k/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EYJKFzad; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EYJKFzad"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C396C32782;
	Tue, 25 Jun 2024 04:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291550;
	bh=+Edo+jdHJ15GLJV77VSn7V8bg7eH4AIGi77/TmsTEkY=;
	h=Date:To:From:Subject:From;
	b=EYJKFzadnUObvh9lf//lst9aPH0/RIk+uWS3YCF4KdcACEGX81NYRPXJtPsD8Q91q
	 cstgQ5MtdG1LPS7vpkltHa+NcScegVM10nqMgMmHG9IT/dnCN+tPkaE09Ey70j/dBz
	 4Etqnaw4j6Qb/WZxqGBc0BhpoHewxoCKMkSUc188=
Date: Mon, 24 Jun 2024 21:59:09 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,xiubli@redhat.com,willy@infradead.org,v-songbaohua@oppo.com,trond.myklebust@hammerspace.com,ryan.roberts@arm.com,neilb@suse.de,minchan@kernel.org,marc.dionne@auristor.com,konishi.ryusuke@gmail.com,jlayton@kernel.org,jaegeuk@kernel.org,idryomov@gmail.com,hughd@google.com,dhowells@redhat.com,david@redhat.com,chrisl@kernel.org,chao@kernel.org,anna@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] ceph-drop-usage-of-page_index.patch removed from -mm tree
Message-Id: <20240625045910.2C396C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ceph: drop usage of page_index
has been removed from the -mm tree.  Its filename was
     ceph-drop-usage-of-page_index.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



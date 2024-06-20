Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC48C46525;
	Thu, 20 Jun 2024 20:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718915843; cv=none; b=SZDV7+v83holPFOPFtkmydQF/2EIfaERLyUCh5Zj0M5aBeBYsLu/uXd2m0EE76QftzlWlwsBB2FRl+Hd5pneILtk9EnRMHNqMguzEptTgPc4ymKq/4PxOLAspMB4tXhtgxQ4BkdIhUzXGW8PYSc1S3yiMBiSgrmY45UEfUW/7A0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718915843; c=relaxed/simple;
	bh=2QphAtNlL0asJpw/IuuHHDJ/1rS3BcY2DD7KN6Mh9xc=;
	h=Date:To:From:Subject:Message-Id; b=WmOsVqzOmEaGMTAdfTvEQHjrisETZiu0MB5rZ3G7Kc4PgXeVTzhGsuufjrcUaWTauSYsgwJp3GKrhafBzVLmmI6je2id8+VRUtArfgZzlHmSKt0vTg3H2czL7WqZJUU19FXsZvNMXolYIIH5ieYLy+e1WKcZYN/lyYz7FCrRjCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DnDC/6dQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DnDC/6dQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62944C2BD10;
	Thu, 20 Jun 2024 20:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718915841;
	bh=2QphAtNlL0asJpw/IuuHHDJ/1rS3BcY2DD7KN6Mh9xc=;
	h=Date:To:From:Subject:From;
	b=DnDC/6dQmH0nMBDWIUrhdiMp8/5CdVd6xF8BI0jcccCZL6zEgamAqkaCacC9dsyg5
	 tQwBsG3r9MNnzYABhK9489crYM+pgWzwCmm8eDv336/3iZtEuxsBl/3Y3FsSVDUepl
	 rT2gGyIBn7h8y/eBuMZdlXQmXQxufnwTXNjoz6s8=
Date: Thu, 20 Jun 2024 13:37:20 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,trondmy@kernel.org,tom@talpey.com,stable@vger.kernel.org,sprasad@microsoft.com,sfrench@samba.org,ryan.roberts@arm.com,ronniesahlberg@gmail.com,pc@manguebit.com,neilb@suse.de,jlayton@kernel.org,hch@lst.de,hanchuanhua@oppo.com,chrisl@kernel.org,bharathsm@microsoft.com,anna@kernel.org,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] cifs-drop-the-incorrect-assertion-in-cifs_swap_rw.patch removed from -mm tree
Message-Id: <20240620203721.62944C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: cifs: drop the incorrect assertion in cifs_swap_rw()
has been removed from the -mm tree.  Its filename was
     cifs-drop-the-incorrect-assertion-in-cifs_swap_rw.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Barry Song <v-songbaohua@oppo.com>
Subject: cifs: drop the incorrect assertion in cifs_swap_rw()
Date: Tue, 18 Jun 2024 19:22:58 +1200

Since commit 2282679fb20b ("mm: submit multipage write for SWP_FS_OPS
swap-space"), we can plug multiple pages then unplug them all together. 
That means iov_iter_count(iter) could be way bigger than PAGE_SIZE, it
actually equals the size of iov_iter_npages(iter, INT_MAX).

Note this issue has nothing to do with large folios as we don't support
THP_SWPOUT to non-block devices.

Link: https://lkml.kernel.org/r/20240618072258.33128-1-21cnbao@gmail.com
Fixes: 2282679fb20b ("mm: submit multipage write for SWP_FS_OPS swap-space")
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Reported-by: Christoph Hellwig <hch@lst.de>
Closes: https://lore.kernel.org/linux-mm/20240614100329.1203579-1-hch@lst.de/
Cc: NeilBrown <neilb@suse.de>
Cc: Anna Schumaker <anna@kernel.org>
Cc: Steve French <sfrench@samba.org>
Cc: Trond Myklebust <trondmy@kernel.org>
Cc: Chuanhua Han <hanchuanhua@oppo.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Paulo Alcantara <pc@manguebit.com>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/smb/client/file.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/smb/client/file.c~cifs-drop-the-incorrect-assertion-in-cifs_swap_rw
+++ a/fs/smb/client/file.c
@@ -3200,8 +3200,6 @@ static int cifs_swap_rw(struct kiocb *io
 {
 	ssize_t ret;
 
-	WARN_ON_ONCE(iov_iter_count(iter) != PAGE_SIZE);
-
 	if (iov_iter_rw(iter) == READ)
 		ret = netfs_unbuffered_read_iter_locked(iocb, iter);
 	else
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-remove-the-implementation-of-swap_free-and-always-use-swap_free_nr.patch
mm-introduce-pte_move_swp_offset-helper-which-can-move-offset-bidirectionally.patch
mm-introduce-arch_do_swap_page_nr-which-allows-restore-metadata-for-nr-pages.patch
mm-swap-reuse-exclusive-folio-directly-instead-of-wp-page-faults.patch
mm-introduce-pmdpte_needs_soft_dirty_wp-helpers-for-softdirty-write-protect.patch
mm-set-pte-writable-while-pte_soft_dirty-is-true-in-do_swap_page.patch
mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap.patch
mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap-fix-2.patch
mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false.patch
mm-remove-folio_test_anonfolio==false-path-in-__folio_add_anon_rmap.patch
selftests-mm-introduce-a-test-program-to-assess-swap-entry-allocation-for-thp_swapout.patch


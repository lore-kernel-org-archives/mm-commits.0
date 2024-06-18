Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E2A615E5BB;
	Tue, 18 Jun 2024 19:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718740784; cv=none; b=FO6a6GZZn8ZsWpGCUaFC0hsorN0dgeXjxI9/LXKcchv5MU28bCw6O1w9agKweuUKyeVQ1+vtzeWCeut2ZwMG/jUmepDZfe123Y5EjKZn67JNwbD5BhIhlG6Xs7HPGlWJN75Xgr+Fsg2uqHmedoEj8ATUbJca4OI7nx+AO57pRrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718740784; c=relaxed/simple;
	bh=/bu1e0pO7TCPSv7bzfXFuzJbW4kFFAUPlXhVvX7lTSE=;
	h=Date:To:From:Subject:Message-Id; b=Al4xroFlpdVu5kG+ltj30SJ8P+GqD5ZC/6BBz+X8opAim0+FimHeHJXVGegoIwlHK64xVF70qgWSmai9eDMGhB3DCIZcGX4vceErqqj0vhYvH+058GGqwez7a8Gb2c4mtlI/HqEJ7dvjFUcgVYy/vmF77EIrI+JoJ/W6dpvgb54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Uo8UmBz6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Uo8UmBz6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC07BC3277B;
	Tue, 18 Jun 2024 19:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718740784;
	bh=/bu1e0pO7TCPSv7bzfXFuzJbW4kFFAUPlXhVvX7lTSE=;
	h=Date:To:From:Subject:From;
	b=Uo8UmBz6vMZ+SsVJhbQFagcz41LQmCAh/vRgmuSlI5uCaWW2LZL9l4pCSVVVTRwFm
	 oo5NYpD4rTI7jPn9eKeYIIiozrhtUIRWD1wgnbfqtOkdL5g8B0Xctpgk6GTIrVfcGL
	 tLOwDn8J2cKhAO9bbfxIIs2mGkgo+lZK1bOi+5pI=
Date: Tue, 18 Jun 2024 12:59:43 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,trondmy@kernel.org,tom@talpey.com,stable@vger.kernel.org,sprasad@microsoft.com,sfrench@samba.org,ryan.roberts@arm.com,ronniesahlberg@gmail.com,pc@manguebit.com,neilb@suse.de,jlayton@kernel.org,hch@lst.de,hanchuanhua@oppo.com,chrisl@kernel.org,bharathsm@microsoft.com,anna@kernel.org,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + cifs-drop-the-incorrect-assertion-in-cifs_swap_rw.patch added to mm-hotfixes-unstable branch
Message-Id: <20240618195943.EC07BC3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: cifs: drop the incorrect assertion in cifs_swap_rw()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     cifs-drop-the-incorrect-assertion-in-cifs_swap_rw.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/cifs-drop-the-incorrect-assertion-in-cifs_swap_rw.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

cifs-drop-the-incorrect-assertion-in-cifs_swap_rw.patch
mm-remove-the-implementation-of-swap_free-and-always-use-swap_free_nr.patch
mm-introduce-pte_move_swp_offset-helper-which-can-move-offset-bidirectionally.patch
mm-introduce-arch_do_swap_page_nr-which-allows-restore-metadata-for-nr-pages.patch
mm-swap-reuse-exclusive-folio-directly-instead-of-wp-page-faults.patch
mm-introduce-pmdpte_needs_soft_dirty_wp-helpers-for-softdirty-write-protect.patch
mm-set-pte-writable-while-pte_soft_dirty-is-true-in-do_swap_page.patch


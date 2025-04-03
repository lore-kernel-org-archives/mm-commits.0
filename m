Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C19282E339D;
	Thu,  3 Apr 2025 03:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743650507; cv=none; b=A89w/D+o40CjVf+tbeB3GuOZlcqYLvjRCN30IfbWZa0ItT/eY/ClAJJy/jY1SZH+bmJ9rm5p7mrjpMwUXuZrkqMxmH2TwyhyB2vFsGJO3ag0qh2C8lGu5OnvHq6BHObR37veP4BbPVzvzYTMQ8o3EqR7IeU3V4l/0HEMu77fgFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743650507; c=relaxed/simple;
	bh=5fKQHTxIJz4md57RvQCs7DCmphnWJa4ijOfl4NulFuc=;
	h=Date:To:From:Subject:Message-Id; b=d2KxcRHuzZ+k1ftSzEg/pEWvJNjX9YmX0OqIJa5S79pDSegwDBvBBzJ+C40g873yLRZ2ryz38PtyZaUHd7NAT2PMIhme+tGg5U2AwHdHiL8FS0+HFrzrXR2hIwSJik543e0RLXh+tUTcuiHZkmeqhjjjFJDkKe0Go4Wse4GhZII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rNBnevn3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rNBnevn3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 311BDC4CEDD;
	Thu,  3 Apr 2025 03:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743650507;
	bh=5fKQHTxIJz4md57RvQCs7DCmphnWJa4ijOfl4NulFuc=;
	h=Date:To:From:Subject:From;
	b=rNBnevn3S1nHzB+yc+fiuT8fCi5P2PDhIM8KQmlJXgsSY8DhI5FFGnVP5XS/Kpfap
	 UQi56b9ADCi55kQWKBDhdEiZRYFmgisPpeXxfD6RYKWpvMFjUcrOzEHBudXtQpjLPB
	 jkAoGNmW8hnloLtnMAkMbRbxX15Yrl0dB0Qlfuj8=
Date: Wed, 02 Apr 2025 20:21:46 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,stable@vger.kernel.org,shengyong1@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-iov_iter-fix-to-increase-non-slab-folio-refcount.patch added to mm-hotfixes-unstable branch
Message-Id: <20250403032147.311BDC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/iov_iter: fix to increase non slab folio refcount
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     lib-iov_iter-fix-to-increase-non-slab-folio-refcount.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-iov_iter-fix-to-increase-non-slab-folio-refcount.patch

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
From: Sheng Yong <shengyong1@xiaomi.com>
Subject: lib/iov_iter: fix to increase non slab folio refcount
Date: Tue, 1 Apr 2025 22:47:12 +0800

When testing EROFS file-backed mount over v9fs on qemu, I encountered a
folio UAF issue.  The page sanity check reports the following call trace. 
The root cause is that pages in bvec are coalesced across a folio bounary.
The refcount of all non-slab folios should be increased to ensure
p9_releas_pages can put them correctly.

BUG: Bad page state in process md5sum  pfn:18300
page: refcount:0 mapcount:0 mapping:00000000d5ad8e4e index:0x60 pfn:0x18300
head: order:0 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
aops:z_erofs_aops ino:30b0f dentry name(?):"GoogleExtServicesCn.apk"
flags: 0x100000000000041(locked|head|node=0|zone=1)
raw: 0100000000000041 dead000000000100 dead000000000122 ffff888014b13bd0
raw: 0000000000000060 0000000000000020 00000000ffffffff 0000000000000000
head: 0100000000000041 dead000000000100 dead000000000122 ffff888014b13bd0
head: 0000000000000060 0000000000000020 00000000ffffffff 0000000000000000
head: 0100000000000000 0000000000000000 ffffffffffffffff 0000000000000000
head: 0000000000000010 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
Call Trace:
 dump_stack_lvl+0x53/0x70
 bad_page+0xd4/0x220
 __free_pages_ok+0x76d/0xf30
 __folio_put+0x230/0x320
 p9_release_pages+0x179/0x1f0
 p9_virtio_zc_request+0xa2a/0x1230
 p9_client_zc_rpc.constprop.0+0x247/0x700
 p9_client_read_once+0x34d/0x810
 p9_client_read+0xf3/0x150
 v9fs_issue_read+0x111/0x360
 netfs_unbuffered_read_iter_locked+0x927/0x1390
 netfs_unbuffered_read_iter+0xa2/0xe0
 vfs_iocb_iter_read+0x2c7/0x460
 erofs_fileio_rq_submit+0x46b/0x5b0
 z_erofs_runqueue+0x1203/0x21e0
 z_erofs_readahead+0x579/0x8b0
 read_pages+0x19f/0xa70
 page_cache_ra_order+0x4ad/0xb80
 filemap_readahead.isra.0+0xe7/0x150
 filemap_get_pages+0x7aa/0x1890
 filemap_read+0x320/0xc80
 vfs_read+0x6c6/0xa30
 ksys_read+0xf9/0x1c0
 do_syscall_64+0x9e/0x1a0
 entry_SYSCALL_64_after_hwframe+0x71/0x79

Link: https://lkml.kernel.org/r/20250401144712.1377719-1-shengyong1@xiaomi.com
Fixes: b9c0e49abfca ("mm: decline to manipulate the refcount on a slab page")
Signed-off-by: Sheng Yong <shengyong1@xiaomi.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/iov_iter.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/iov_iter.c~lib-iov_iter-fix-to-increase-non-slab-folio-refcount
+++ a/lib/iov_iter.c
@@ -1191,7 +1191,7 @@ static ssize_t __iov_iter_get_pages_allo
 			return -ENOMEM;
 		p = *pages;
 		for (int k = 0; k < n; k++) {
-			struct folio *folio = page_folio(page);
+			struct folio *folio = page_folio(page + k);
 			p[k] = page + k;
 			if (!folio_test_slab(folio))
 				folio_get(folio);
_

Patches currently in -mm which might be from shengyong1@xiaomi.com are

lib-iov_iter-fix-to-increase-non-slab-folio-refcount.patch


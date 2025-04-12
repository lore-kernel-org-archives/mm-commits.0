Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F3BC134D4;
	Sat, 12 Apr 2025 00:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744417998; cv=none; b=UKbbyDvWR7WIfo8yf6fTuosj9WhdE4nFh7mpLhMVN2rB2TZCkpR8ERqOcrDNWyIyEmWdOOP8tvQqp3ke6Wry/rAZFRZIALRFMTzIxjcJre4CaISTUM/FiHQxdKz2ysNAS4VxPMBpWvHo/7J8tY7d2N/ytsPZV18wL7xzS7QYu94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744417998; c=relaxed/simple;
	bh=QvQLQvUsfFxQ/HgsJPCZdh6AHYZ5/v3mon4wsv6UMgE=;
	h=Date:To:From:Subject:Message-Id; b=Q6k2ePnG6BtAKxtF/+7aUk30OUXz7glanqLCNvCsq5HROnY7nVJaasNzFMLLLIOlHAKitZeQ7WZ1sw4N7pr13WUwtxf5CimGabAz4aZF8WSTdTBvAP5euq8SRfFh3SbuPbzE2uWFkRCc83Y6vd5P2oy5Gblw78CU7dv7xP/hwM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Rzvkm/gj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Rzvkm/gj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A645C4CEE2;
	Sat, 12 Apr 2025 00:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744417997;
	bh=QvQLQvUsfFxQ/HgsJPCZdh6AHYZ5/v3mon4wsv6UMgE=;
	h=Date:To:From:Subject:From;
	b=Rzvkm/gjLIUIIj2t6aVHeARFl5fxsW/Qx/cGYisSaZdY9Dx02B+L2SuEmSqqVE7DO
	 Vk7Zr8IFkY1XloYescQ/f9eSVgwTjjmBoSu34GhVh9ifcfAyDuOsCTVx5sAlzSnp8a
	 CDHM93WLCrbD/LezlBd1trfXV2IH7Lz78zTkECRw=
Date: Fri, 11 Apr 2025 17:33:17 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,stable@vger.kernel.org,shengyong1@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] lib-iov_iter-fix-to-increase-non-slab-folio-refcount.patch removed from -mm tree
Message-Id: <20250412003317.8A645C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/iov_iter: fix to increase non slab folio refcount
has been removed from the -mm tree.  Its filename was
     lib-iov_iter-fix-to-increase-non-slab-folio-refcount.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



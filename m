From: akpm@osdl.org
Subject: - io-accounting-read-accounting-nfs-fix-fix.patch removed from -mm tree
Date: Fri, 08 Dec 2006 03:51:11 -0800
Message-ID: <200612081151.kB8BpBuU019693@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52256 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938051AbWLHLvc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 06:51:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@gmail.com, wfg@mail.ustc.edu.cn, mm-commits@vger.kernel.org


The patch titled
     io accounting minor fix
has been removed from the -mm tree.  Its filename was
     io-accounting-read-accounting-nfs-fix-fix.patch

This patch was dropped because it was folded into io-accounting-read-accounting-nfs-fix.patch

------------------------------------------------------
Subject: io accounting minor fix
From: Fengguang Wu <fengguang.wu@gmail.com>

Account only successful nfs/fuse reads.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/readahead.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/readahead.c~io-accounting-read-accounting-nfs-fix-fix mm/readahead.c
--- a/mm/readahead.c~io-accounting-read-accounting-nfs-fix-fix
+++ a/mm/readahead.c
@@ -145,7 +145,6 @@ int read_cache_pages(struct address_spac
 			page_cache_release(page);
 			continue;
 		}
-		task_io_account_read(PAGE_CACHE_SIZE);
 		ret = filler(data, page);
 		if (!pagevec_add(&lru_pvec, page))
 			__pagevec_lru_add(&lru_pvec);
@@ -153,6 +152,7 @@ int read_cache_pages(struct address_spac
 			put_pages_list(pages);
 			break;
 		}
+		task_io_account_read(PAGE_CACHE_SIZE);
 	}
 	pagevec_lru_add(&lru_pvec);
 	return ret;
_

Patches currently in -mm which might be from fengguang.wu@gmail.com are

io-accounting-read-accounting-nfs-fix.patch
io-accounting-read-accounting-nfs-fix-fix.patch


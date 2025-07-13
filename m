Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE1421ADA2
	for <mm-commits@vger.kernel.org>; Sun, 13 Jul 2025 23:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752450085; cv=none; b=FAROzLqL245Gs4Yq2gtP/V7A0v/kGdBXMGFScuveD9Xq9fPSwj1bnyoHOg1aatyGdtj23aolr3C1zxHYbfKJxHBkv8j6Fn9k8WVEDwqcwewpElK2Uo2XVXasiLkPRvuvVe8swwWq2q9Fsw7foBgMW1JRO6q9hAx9wluB1esqLkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752450085; c=relaxed/simple;
	bh=ygGFfhiIkAq3stOq8Yc7ZFDweFR5bfBXOdVrmJIJRlo=;
	h=Date:To:From:Subject:Message-Id; b=nEhDRopLL5JmOTKQWp5uRJGIzYmCd3EWY6kfA+xTNfL5JA0X+0Figu/MBn7dHxKSu63yOwiSQG9cBiaNt7NbpCPxtzMarta590ZoVTbwk51lP8xTxPuC//cH7unJW+5xI/mQIh7vq2qdOv4qCk84ybBzBL3DZyJwY/VbaIL2Z1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2X4AXeXW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2X4AXeXW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 002FBC4CEE3;
	Sun, 13 Jul 2025 23:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752450085;
	bh=ygGFfhiIkAq3stOq8Yc7ZFDweFR5bfBXOdVrmJIJRlo=;
	h=Date:To:From:Subject:From;
	b=2X4AXeXWJeyG0ZTs55IZmbdzYCLkrch7MiPZnZwE1jEyE5wTsgBF0LZwtWuNAeY0H
	 TR3r5YusWv709m/hjoS3FiumuIt5eDHfOIW1WRpFpr7Y954jopaTOtQ2zhIFmiZ/73
	 7ANq/Ya/Pqg38T28fmhd+tO8DxM0zgsDHZqDc/8k=
Date: Sun, 13 Jul 2025 16:41:24 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,ying.huang@linux.alibaba.com,xu.xin16@zte.com.cn,xuanzhuo@linux.alibaba.com,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,senozhatsky@chromium.org,rppt@kernel.org,riel@surriel.com,rakie.kim@sk.com,peterx@redhat.com,osalvador@suse.de,npiggin@gmail.com,nao.horiguchi@gmail.com,mst@redhat.com,mpe@ellerman.id.au,minchan@kernel.org,mhocko@suse.com,matthew.brost@intel.com,maddy@linux.ibm.com,lorenzo.stoakes@oracle.com,linmiaohe@huawei.com,liam.howlett@oracle.com,joshua.hahnjy@gmail.com,jhubbard@nvidia.com,jgg@ziepe.ca,jerrin.shaji-george@broadcom.com,jasowang@redhat.com,jack@suse.cz,jackmanb@google.com,harry.yoo@oracle.com,hannes@cmpxchg.org,gregkh@linuxfoundation.org,gourry@gourry.net,eperezma@redhat.com,corbet@lwn.net,christophe.leroy@csgroup.eu,chengming.zhou@linux.dev,byungchul@sk.com,brauner@kernel.org,arnd@arndb.de,apopple@nvidia.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_isolation-drop-__folio_test_movable-check-for-large-folios.patch removed from -mm tree
Message-Id: <20250713234125.002FBC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_isolation: drop __folio_test_movable() check for large folios
has been removed from the -mm tree.  Its filename was
     mm-page_isolation-drop-__folio_test_movable-check-for-large-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/page_isolation: drop __folio_test_movable() check for large folios
Date: Fri, 4 Jul 2025 12:25:11 +0200

Currently, we only support migration of individual movable_ops pages, so
we can not run into that.

Link: https://lkml.kernel.org/r/20250704102524.326966-18-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Eugenio Pé rez <eperezma@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Jerrin Shaji George <jerrin.shaji-george@broadcom.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Mathew Brost <matthew.brost@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: xu xin <xu.xin16@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_isolation.c~mm-page_isolation-drop-__folio_test_movable-check-for-large-folios
+++ a/mm/page_isolation.c
@@ -92,7 +92,7 @@ static struct page *has_unmovable_pages(
 				h = size_to_hstate(folio_size(folio));
 				if (h && !hugepage_migration_supported(h))
 					return page;
-			} else if (!folio_test_lru(folio) && !__folio_test_movable(folio)) {
+			} else if (!folio_test_lru(folio)) {
 				return page;
 			}
 
_

Patches currently in -mm which might be from david@redhat.com are

mm-convert-fpb_ignore_-into-fpb_respect_.patch
mm-smaller-folio_pte_batch-improvements.patch
mm-split-folio_pte_batch-into-folio_pte_batch-and-folio_pte_batch_flags.patch
mm-remove-boolean-output-parameters-from-folio_pte_batch_ext.patch
mm-memory-introduce-is_huge_zero_pfn-and-use-it-in-vm_normal_page_pmd.patch


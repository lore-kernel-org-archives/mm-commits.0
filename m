Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7161EF38E
	for <mm-commits@vger.kernel.org>; Sun, 13 Jul 2025 23:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752450073; cv=none; b=sC6WDrl9AwE6V+NNBwUk4+5ZsD2HHO/y78kCZzJr9E+pY0Dj/BA27g0gkixs1LqbukD05GczH0aoBrJgZKAmoOXsOVy7NKtzCNcXQEQ8zatBwEas9VX2NUzNX7TcGWTpSLSDrkD2fcWQAyJqVGZxMesNiNgWWaWf+UMqP5QoERg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752450073; c=relaxed/simple;
	bh=uowfk+NUZ951P37eKu2yuopOmp2qAb8v4K2sBRORgL4=;
	h=Date:To:From:Subject:Message-Id; b=KJPAguhk8FqGKhOW3AAC1pCeS2GCW9pu8v+Kvc6/EaIukbCZRXnNN9v1EoUtEHNqiZQqs8qSd8fG/LLba/gFtt6T54gn2kj27ix2GwH+07eNHEkpIdCi5iCG7ncHsctN4q5wwQsWnSYUhhnMSPVZhBr0DEE4vvtwJEVsw17m7/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TjGA4Rdk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TjGA4Rdk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF77DC4CEE3;
	Sun, 13 Jul 2025 23:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752450072;
	bh=uowfk+NUZ951P37eKu2yuopOmp2qAb8v4K2sBRORgL4=;
	h=Date:To:From:Subject:From;
	b=TjGA4RdktX9Ib9IWFMcUgaNrXqg8t1TyYQdSPp2QPHC3OezclYCQZVhWXb68gzoaT
	 5Nai3pi+fHNkNA2H1frPIQWi2RyGZEWBYh053B2DmziupozQ81dyJDTTeJM/w3aPet
	 ZWbfzZNcTYvpOMFEtgdtRba0qnauBNC77D0zzwzI=
Date: Sun, 13 Jul 2025 16:41:12 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,ying.huang@linux.alibaba.com,xu.xin16@zte.com.cn,xuanzhuo@linux.alibaba.com,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,senozhatsky@chromium.org,rppt@kernel.org,riel@surriel.com,rakie.kim@sk.com,peterx@redhat.com,osalvador@suse.de,npiggin@gmail.com,nao.horiguchi@gmail.com,mst@redhat.com,mpe@ellerman.id.au,minchan@kernel.org,mhocko@suse.com,matthew.brost@intel.com,maddy@linux.ibm.com,lorenzo.stoakes@oracle.com,linmiaohe@huawei.com,liam.howlett@oracle.com,joshua.hahnjy@gmail.com,jhubbard@nvidia.com,jgg@ziepe.ca,jerrin.shaji-george@broadcom.com,jasowang@redhat.com,jack@suse.cz,jackmanb@google.com,harry.yoo@oracle.com,hannes@cmpxchg.org,gregkh@linuxfoundation.org,gourry@gourry.net,eperezma@redhat.com,corbet@lwn.net,christophe.leroy@csgroup.eu,chengming.zhou@linux.dev,byungchul@sk.com,brauner@kernel.org,arnd@arndb.de,apopple@nvidia.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate-remove-folio_test_movable-and-folio_movable_ops.patch removed from -mm tree
Message-Id: <20250713234112.CF77DC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/migrate: remove folio_test_movable() and folio_movable_ops()
has been removed from the -mm tree.  Its filename was
     mm-migrate-remove-folio_test_movable-and-folio_movable_ops.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/migrate: remove folio_test_movable() and folio_movable_ops()
Date: Fri, 4 Jul 2025 12:25:04 +0200

Folios will have nothing to do with movable_ops page migration.  These
functions are now unused, so let's remove them.

Note that __folio_test_movable() and friends will be removed separately
next, after more rework.

Link: https://lkml.kernel.org/r/20250704102524.326966-11-david@redhat.com
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

 include/linux/migrate.h |   14 --------------
 1 file changed, 14 deletions(-)

--- a/include/linux/migrate.h~mm-migrate-remove-folio_test_movable-and-folio_movable_ops
+++ a/include/linux/migrate.h
@@ -118,20 +118,6 @@ static inline void __ClearPageMovable(st
 }
 #endif
 
-static inline bool folio_test_movable(struct folio *folio)
-{
-	return PageMovable(&folio->page);
-}
-
-static inline
-const struct movable_operations *folio_movable_ops(struct folio *folio)
-{
-	VM_BUG_ON(!__folio_test_movable(folio));
-
-	return (const struct movable_operations *)
-		((unsigned long)folio->mapping - PAGE_MAPPING_MOVABLE);
-}
-
 static inline
 const struct movable_operations *page_movable_ops(struct page *page)
 {
_

Patches currently in -mm which might be from david@redhat.com are

mm-convert-fpb_ignore_-into-fpb_respect_.patch
mm-smaller-folio_pte_batch-improvements.patch
mm-split-folio_pte_batch-into-folio_pte_batch-and-folio_pte_batch_flags.patch
mm-remove-boolean-output-parameters-from-folio_pte_batch_ext.patch
mm-memory-introduce-is_huge_zero_pfn-and-use-it-in-vm_normal_page_pmd.patch


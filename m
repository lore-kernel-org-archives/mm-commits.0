Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1537331A46
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498666; cv=none; b=ngMPuu2DtX4xaXrSIs4ncjyBw/0Ib6xn77RJK6QzTlPaDW22aVbSi8RKKNah7l+sw43UfOsPvNP6YA47AKx6/PVKm1lcsiMCLtEU0kmWH51WN3xSy6a3OBnbcYoIR6hzTDXoFOa/MZUv3qAG2AmvLOGM/C8EFWiFrOEfJe3lsAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498666; c=relaxed/simple;
	bh=CYqHY1U0L/3F9fOlwGoQXdg+SVpTPV9OGWxtde/XfvM=;
	h=Date:To:From:Subject:Message-Id; b=mFY730IQ1vI7ze03ulqL1sGeXxRBIddTamqhvfSX7roTtieJNxQOrS9jrnx4oqiBzb4BKi8wg6v/7K2jsF4dCHxxfqyRwMQQw0F2T5KTRPq0tGgNUCFP03EgnPSl5cfe64WKRSHZCTcXmSxHZwdIgwYptSEAomDIJxgjRcUjfrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JpY8MQnW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JpY8MQnW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 207D8C19424;
	Sat, 18 Apr 2026 07:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498666;
	bh=CYqHY1U0L/3F9fOlwGoQXdg+SVpTPV9OGWxtde/XfvM=;
	h=Date:To:From:Subject:From;
	b=JpY8MQnWSpXxBRIpCIlz0FSoX/Hg2w6S5YE6tFLlPDIdN7f0P4ofWesKgsdrLChFW
	 bekL1efMOSHZvTlXGbH5dh7EMSmc8xIpwWDWathezg7irLyzPWmZxNGPOt+ab8iGVy
	 uvRyaMpnPV2lbB9IKBRBI/4MlGZDQrA9NLHrn26g=
Date: Sat, 18 Apr 2026 00:51:00 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,yuanchu@google.com,yosry@kernel.org,weixugc@google.com,vbabka@kernel.org,usamaarif642@gmail.com,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mkoutny@suse.com,mhocko@suse.com,ljs@kernel.org,Liam.Howlett@oracle.com,lance.yang@linux.dev,kamalesh.babulal@oracle.com,imran.f.khan@oracle.com,hughd@google.com,harry.yoo@oracle.com,hannes@cmpxchg.org,hamzamahfooz@linux.microsoft.com,david@kernel.org,chenridong@huawei.com,chengming.zhou@linux.dev,bhe@redhat.com,axelrasmussen@google.com,apais@linux.microsoft.com,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-lru-add-vm_warn_on_once_folio-to-lru-maintenance-helpers.patch removed from -mm tree
Message-Id: <20260418075105.207D8C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: lru: add VM_WARN_ON_ONCE_FOLIO to lru maintenance helpers
has been removed from the -mm tree.  Its filename was
     mm-lru-add-vm_warn_on_once_folio-to-lru-maintenance-helpers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: lru: add VM_WARN_ON_ONCE_FOLIO to lru maintenance helpers
Date: Thu, 5 Mar 2026 19:52:51 +0800

We must ensure the folio is deleted from or added to the correct lruvec
list.  So, add VM_WARN_ON_ONCE_FOLIO() to catch invalid users.  The
VM_BUG_ON_PAGE() in move_pages_to_lru() can be removed as
add_page_to_lru_list() will perform the necessary check.

Link: https://lore.kernel.org/2c90fc006d9d730331a3caeef96f7e5dabe2036d.1772711148.git.zhengqi.arch@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Allen Pais <apais@linux.microsoft.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chen Ridong <chenridong@huawei.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Imran Khan <imran.f.khan@oracle.com>
Cc: Kamalesh Babulal <kamalesh.babulal@oracle.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yosry Ahmed <yosry@kernel.org>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |    6 ++++++
 mm/vmscan.c               |    1 -
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/include/linux/mm_inline.h~mm-lru-add-vm_warn_on_once_folio-to-lru-maintenance-helpers
+++ a/include/linux/mm_inline.h
@@ -348,6 +348,8 @@ void lruvec_add_folio(struct lruvec *lru
 {
 	enum lru_list lru = folio_lru_list(folio);
 
+	VM_WARN_ON_ONCE_FOLIO(!folio_matches_lruvec(folio, lruvec), folio);
+
 	if (lru_gen_add_folio(lruvec, folio, false))
 		return;
 
@@ -362,6 +364,8 @@ void lruvec_add_folio_tail(struct lruvec
 {
 	enum lru_list lru = folio_lru_list(folio);
 
+	VM_WARN_ON_ONCE_FOLIO(!folio_matches_lruvec(folio, lruvec), folio);
+
 	if (lru_gen_add_folio(lruvec, folio, true))
 		return;
 
@@ -376,6 +380,8 @@ void lruvec_del_folio(struct lruvec *lru
 {
 	enum lru_list lru = folio_lru_list(folio);
 
+	VM_WARN_ON_ONCE_FOLIO(!folio_matches_lruvec(folio, lruvec), folio);
+
 	if (lru_gen_del_folio(lruvec, folio, false))
 		return;
 
--- a/mm/vmscan.c~mm-lru-add-vm_warn_on_once_folio-to-lru-maintenance-helpers
+++ a/mm/vmscan.c
@@ -1916,7 +1916,6 @@ static unsigned int move_folios_to_lru(s
 			continue;
 		}
 
-		VM_BUG_ON_FOLIO(!folio_matches_lruvec(folio, lruvec), folio);
 		lruvec_add_folio(lruvec, folio);
 		nr_pages = folio_nr_pages(folio);
 		nr_moved += nr_pages;
_

Patches currently in -mm which might be from songmuchun@bytedance.com are



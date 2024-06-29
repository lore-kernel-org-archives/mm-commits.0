Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAEAAB66F
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628203; cv=none; b=dodO2dISvCHXJtDSyazDyRdM9RoHC20MVCT+a3iIXdm0Sd7JcY3vFj/3Tiyjr5c/gPZAIU48bByYYu7u5jXfZzM5SApEcD+LwMsEsrEi43L7m7uZuLZ+xm54wLLQWG+39ZbRvdYXmLagOml7lJuGVcybyfRar9jqglNfUwsP+Uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628203; c=relaxed/simple;
	bh=sn3gTpYfu/WxbgJMu/gbKgRXE6zC23ekGuoU9DD2wAU=;
	h=Date:To:From:Subject:Message-Id; b=e3EoLU8hL/Z732KScu4kuvjIZr+Fdt2C1rzLHsqc0u4p2CeG1BzmhhmLfCKi06sv/O/+noDZqntXrAG1dKeRophBh6F0W6OMyE+6WZ8YK5jHGmPPa3PrWueJ9W4PpOpauiFfE7+h+2qxK9VfLKuWX5FnBuN+amjC7do5SoCCH/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nb9q64hk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nb9q64hk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79AC5C116B1;
	Sat, 29 Jun 2024 02:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628203;
	bh=sn3gTpYfu/WxbgJMu/gbKgRXE6zC23ekGuoU9DD2wAU=;
	h=Date:To:From:Subject:From;
	b=nb9q64hkX8Q5UiK4OtEuJHF1jUjhCNS0PHFSLnLjMyz3ti0NQva/OTiYQzLs3D3jZ
	 r87hYywrg6BlwetauXE7EBSmrjNn8LW7HuUYya2iyY61vyxAw1EkPFgQeDxXRyDqTw
	 UKAOgk7nEnO557idkhZL6SZHjy39sAYdb0mpY77M=
Date: Fri, 28 Jun 2024 19:30:03 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,deller@gmx.de,david@redhat.com,daniel@ffwll.ch,corbet@lwn.net,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fb_defio-use-a-folio-in-fb_deferred_io_work.patch removed from -mm tree
Message-Id: <20240629023003.79AC5C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fb_defio: use a folio in fb_deferred_io_work()
has been removed from the -mm tree.  Its filename was
     fb_defio-use-a-folio-in-fb_deferred_io_work.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: fb_defio: use a folio in fb_deferred_io_work()
Date: Tue, 4 Jun 2024 19:48:21 +0800

Replaces three calls to compound_head() with one, which removes last
caller of page_mkclean().

Link: https://lkml.kernel.org/r/20240604114822.2089819-4-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Helge Deller <deller@gmx.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbdev/core/fb_defio.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/video/fbdev/core/fb_defio.c~fb_defio-use-a-folio-in-fb_deferred_io_work
+++ a/drivers/video/fbdev/core/fb_defio.c
@@ -244,10 +244,11 @@ static void fb_deferred_io_work(struct w
 	/* here we mkclean the pages, then do all deferred IO */
 	mutex_lock(&fbdefio->lock);
 	list_for_each_entry(pageref, &fbdefio->pagereflist, list) {
-		struct page *cur = pageref->page;
-		lock_page(cur);
-		page_mkclean(cur);
-		unlock_page(cur);
+		struct folio *folio = page_folio(pageref->page);
+
+		folio_lock(folio);
+		folio_mkclean(folio);
+		folio_unlock(folio);
 	}
 
 	/* driver's callback with pagereflist */
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-move-memory_failure_queue-into-copy_mc__highpage.patch
mm-add-folio_mc_copy.patch
mm-migrate-split-folio_migrate_mapping.patch
mm-migrate-support-poisoned-recover-from-migrate-folio.patch
fs-hugetlbfs-support-poisoned-recover-from-hugetlbfs_migrate_folio.patch
mm-migrate-remove-folio_migrate_copy.patch


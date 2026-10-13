Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C56D318C02E
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865916; cv=none; b=TSelCDqfyH/t8D38/dNQ4FuzzUijbfHln5ZUwyvW1ITxBHtbPpfl78Bt77lNomKgQgLF8JwiqTy6H7ad5tjtCIYtGb6sqkbpQDr6EPmoDifNOF3xASEAlFseVLHviPa+4PxOMAMcX+q2NB3m8NeXg6my8C/sQvCLF4i3F21rhjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865916; c=relaxed/simple;
	bh=lezyS+Phia0CWuRvsm/sCtOFrXWIfTyA1lEQIKdbwYA=;
	h=Date:To:From:Subject:Message-Id; b=q5dAQqdGXHswF1t20WwrokUy2HNLDkan/Gfa6ERUJcEOhr47f5mxV6kjeG8Bh6XPhUv/aK3v2UcfBkegRg2IGXrNEXTqt7Nhpeipu2C/5VOncdZ1Z849q4v6wgFunanqfNu4U7MrFCAvQB2oirBAx0kwQxb6mwMGclrxcoNzZaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Kh5tPaul; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Kh5tPaul"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A4A41F000FF;
	Tue, 13 Oct 2026 04:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865915;
	bh=MYBmvjaXaprLUoHw4GMOpPWkxK6xIlS820DDf5UarqE=;
	h=Date:To:From:Subject;
	b=Kh5tPaulOPKx8H5K0DrGOLHVVsozMlTfiXxEO0PGrlRohmFtIlnWtPHVpavkzqGRB
	 QWjDt9sw8VFJ4QczmrdQDB9H5T60dLb4MLHIxPKuTnkzE6HQmF3JFzXe0XzrlP1rZp
	 UXklRCCcw4iSrvEhqud42AtwAUQVuqmW1AasxY6A=
Date: Mon, 12 Oct 2026 21:31:55 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-group-xa_init-with-vbq-field-initializations.patch removed from -mm tree
Message-Id: <20261013043155.9A4A41F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc: group xa_init with vbq field initializations
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-group-xa_init-with-vbq-field-initializations.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ye Liu <liuye@kylinos.cn>
Subject: mm/vmalloc: group xa_init with vbq field initializations
Date: Tue, 15 Sep 2026 10:43:30 +0800

Patch series "mm/vmalloc: minor cleanups", v2.

Small cleanup series for mm/vmalloc.c, no functional changes:

- Group xa_init() with the other vmap_block_queue field initializations
  in vmalloc_init(), instead of after the unrelated vfree_deferred setup.

- Extract vmap_insert_free_area() helper to deduplicate the allocate-
  and-insert pattern that appeared both inside the loop body and after
  the loop in vmap_init_free_space().

- Extract show_busy_info() from vmalloc_info_show(), mirroring the
  existing show_purge_info() pattern, so the top-level show function
  only orchestrates the two data sources.


This patch (of 3):

Move xa_init() next to the other vbq field initializations instead of
after the unrelated vfree_deferred setup.

Link: https://lore.kernel.org/20260915-vmalloc_study-v2-0-cc4dfe635e22@linux.dev
Link: https://lore.kernel.org/20260915-vmalloc_study-v2-1-cc4dfe635e22@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---

 mm/vmalloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-group-xa_init-with-vbq-field-initializations
+++ a/mm/vmalloc.c
@@ -5561,10 +5561,11 @@ void __init vmalloc_init(void)
 		vbq = &per_cpu(vmap_block_queue, i);
 		spin_lock_init(&vbq->lock);
 		INIT_LIST_HEAD(&vbq->free);
+		xa_init(&vbq->vmap_blocks);
+
 		p = &per_cpu(vfree_deferred, i);
 		init_llist_head(&p->list);
 		INIT_WORK(&p->wq, delayed_vfree_work);
-		xa_init(&vbq->vmap_blocks);
 	}
 
 	/*
_

Patches currently in -mm which might be from liuye@kylinos.cn are

mm-vmalloc-fix-vmalloc_dump_obj-address-alignment-for-last-page-lookups.patch
mm-vmalloc-fix-vmalloc_dump_obj-cross-zone-va-lookup.patch


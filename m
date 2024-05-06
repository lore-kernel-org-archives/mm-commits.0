Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26B05250
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714955330; cv=none; b=TAF/ZWpKaAe9ika97Qk2CA57xdinYweCPE5TLYU/5QkENxm7uek9JzbgVEgjHzFqsYeyNBzC6CgfGKwcyxhZ2d/gy8jTdg5W7hKYuPa9lnuCgypFiI2UGBNuWmD2FUoN6xoEgP7L3gja/KrgurEBzQcm9aTRGJiDjcSa6RmgiI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714955330; c=relaxed/simple;
	bh=IhkFotdn2zPkBDFha9DcsjAmKR8EEHaQkSvcXMPXLJ8=;
	h=Date:To:From:Subject:Message-Id; b=Ng1UWFWwIT4Gxa+ZoQTTSi2t0kU0cLZice6YQQcnt0cPM9ZV8JtH6MjJAnOJSt0a0ap6701qxyCvep5990/AbelmXZk8zsRvkMfY/nRhTVQx2N3n6yA1gaokWIlyFiaJzZJ4KVfJCYUOiw0VBcyNNShNghgLk/vkcs4yJ8Y7au4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qQY+Aa9k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qQY+Aa9k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70510C4AF18;
	Mon,  6 May 2024 00:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714955330;
	bh=IhkFotdn2zPkBDFha9DcsjAmKR8EEHaQkSvcXMPXLJ8=;
	h=Date:To:From:Subject:From;
	b=qQY+Aa9k9nmZ0pDwgzHirkSNT81M5LprHYvszZ1NgXpNNiN5TYulZISErPeHO9J3L
	 GzlRCVvUTi3dS7yMEkCgPQwIz1oUfoodG+GfPobF8gKquyQDyQRmQ3K3JjkK1EUCQx
	 a884NRF7caq95/i7tF0Y0wg0InRhmy1ISktvL2Jc=
Date: Sun, 05 May 2024 17:28:49 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,lstoakes@gmail.com,hch@lst.de,baohua@kernel.org,hailong.liu@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-vmalloc-fix-return-value-of-vb_alloc-if-size-is-0.patch removed from -mm tree
Message-Id: <20240506002850.70510C4AF18@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc: fix return value of vb_alloc if size is 0
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-fix-return-value-of-vb_alloc-if-size-is-0.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Hailong.Liu" <hailong.liu@oppo.com>
Subject: mm/vmalloc: fix return value of vb_alloc if size is 0
Date: Fri, 26 Apr 2024 10:41:49 +0800

vm_map_ram() uses IS_ERR() to validate the return value of vb_alloc().  If
vm_map_ram(page, 0, 0) is executed, vb_alloc(0, GFP_KERNEL) would return
NULL.  In such a case, IS_ERR() cannot handle the return value and lead to
kernel panic by vmap_pages_range_noflush() at last.  To resolve this
issue, return ERR_PTR(-EINVAL) if the size is 0.

Link: https://lkml.kernel.org/r/20240426024149.21176-1-hailong.liu@oppo.com
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Hailong.Liu <hailong.liu@oppo.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-fix-return-value-of-vb_alloc-if-size-is-0
+++ a/mm/vmalloc.c
@@ -2710,7 +2710,7 @@ static void *vb_alloc(unsigned long size
 		 * get_order(0) returns funny result. Just warn and terminate
 		 * early.
 		 */
-		return NULL;
+		return ERR_PTR(-EINVAL);
 	}
 	order = get_order(size);
 
_

Patches currently in -mm which might be from hailong.liu@oppo.com are



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F410013B5A2
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719289749; cv=none; b=T8X0DmSu9XOi2AmQx2XwUzlLrJN/DUPxjhkKj8nv7BSlnzhM9UHbmidZoCYk1SCwXvmREBkf4M/BK2xeD0WA0gsoI+12ylONR2iZgNfvO08/E3zhX2MESuGwplHlK/Xe5xq6LAfE4sx2/iIfWa6sQCJw3AQWIun8WGmFYaOE2+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719289749; c=relaxed/simple;
	bh=CTVptiFamZDe1mKEDKv1P5xDVwaS/b0F1ssb8QXMvWY=;
	h=Date:To:From:Subject:Message-Id; b=Fva3CSViXGZBLWHsXPvm1i79fxPrNeP1DBLhb+ldOMJEeZrOHe29+xHNohJkVMXgxN4Rt6CH1DlAT08NF91XTHsDSgH9I2/V6juqiS8o58o8dSjsSEY35NOY791NeuVdetzJVYpcyUexdGtsin4SP1NIMoajwzU8YvZJufYiXn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g97TzMKx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g97TzMKx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62EC5C32782;
	Tue, 25 Jun 2024 04:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719289748;
	bh=CTVptiFamZDe1mKEDKv1P5xDVwaS/b0F1ssb8QXMvWY=;
	h=Date:To:From:Subject:From;
	b=g97TzMKxpSwOpuLY5wWp/bY4DtuQP3Az+XMhlZbg3kgG5fewa78Tzn9LaQppyd4Ar
	 Del5b7zKok+dzgVC1/PILAwUYKOPzIKMtA1zTRtZ76cNZmdtsIp/SvWbyuxzOP42ki
	 jAE6lj1cpaWIMa/wdwAY0K+KaIMn/3NV0xDM9/pI=
Date: Mon, 24 Jun 2024 21:29:07 -0700
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,david@redhat.com,dan.carpenter@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] fs-proc-move-page_mapcount-to-fs-proc-internalh-fix.patch removed from -mm tree
Message-Id: <20240625042908.62EC5C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/proc/task_mmu: fix uninitialized variable in pagemap_pmd_range()
has been removed from the -mm tree.  Its filename was
     fs-proc-move-page_mapcount-to-fs-proc-internalh-fix.patch

This patch was dropped because it was folded into fs-proc-move-page_mapcount-to-fs-proc-internalh.patch

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@linaro.org>
Subject: fs/proc/task_mmu: fix uninitialized variable in pagemap_pmd_range()
Date: Thu, 13 Jun 2024 17:34:33 +0300

The "folio" pointer is tested for NULL, but it's either valid or
uninitialized.  Initialize it to NULL.

Link: https://lkml.kernel.org/r/9d6eaba7-92f8-4a70-8765-38a519680a87@moroto.mountain
Fixes: 84f57f8b8914 ("fs/proc: move page_mapcount() to fs/proc/internal.h")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/task_mmu.c~fs-proc-move-page_mapcount-to-fs-proc-internalh-fix
+++ a/fs/proc/task_mmu.c
@@ -1495,7 +1495,7 @@ static int pagemap_pmd_range(pmd_t *pmdp
 		u64 flags = 0, frame = 0;
 		pmd_t pmd = *pmdp;
 		struct page *page = NULL;
-		struct folio *folio;
+		struct folio *folio = NULL;
 
 		if (vma->vm_flags & VM_SOFTDIRTY)
 			flags |= PM_SOFT_DIRTY;
_

Patches currently in -mm which might be from dan.carpenter@linaro.org are

fs-proc-move-page_mapcount-to-fs-proc-internalh.patch
checkpatch-check-for-missing-fixes-tags.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28BD2290F
	for <mm-commits@vger.kernel.org>; Mon,  4 Nov 2024 04:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730696073; cv=none; b=bOttpSPUifFj5culj1pAkd3xko8qg7G7tRGivORJr4/4J/ae4vdVZdCr0s83u8BaDZ0km9hhmsGmVse/zgwiLMx3Tb4XlqXZu/p1vLGkTlCnLEZ3+GE7FkVt1hXjyBY7gzzPVwhaCwsDcORzIDq8aw4khtPuyh2tgWhY4CnIKxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730696073; c=relaxed/simple;
	bh=cbzz49+KQzEoqAW4hhffoXOtJnP/vr6eYvtudq5dykE=;
	h=Date:To:From:Subject:Message-Id; b=kixKEO/WXF1cUxaFht5pos09kmzoPZLJEfGNh7I8MHhlYM2Mza8jZMkEYRCGf5tpaMEecq8b6zCE9jPKRW9fTtz34Q/if18Hqq9OBZGTh03DJfJIo2F9hQvKiyeaWjwgUAwv26ZBGufnYwpsDq16hd1bworMkKUJ3vPbS1S745I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CaVcY5NV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CaVcY5NV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9987C4CECE;
	Mon,  4 Nov 2024 04:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730696073;
	bh=cbzz49+KQzEoqAW4hhffoXOtJnP/vr6eYvtudq5dykE=;
	h=Date:To:From:Subject:From;
	b=CaVcY5NVII313Dvk2yrE0vF61y/v8Q0zHAEz1OpXGQ4gjkS66AS9d+YQwF1n1Cxek
	 MH+KuB7Jv/kkObgibentwxa1f9ua6VHG7JlJK7JdsxzsykBjqxb0XIzj/LXE5leJFw
	 vBn9PnmEPiQZRCBck5SAKfAOpmVJ5uE3+6O5y4lg=
Date: Sun, 03 Nov 2024 20:54:32 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,dan.carpenter@linaro.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] alloc_tag-load-module-tags-into-separate-contiguous-memory-fix-fix.patch removed from -mm tree
Message-Id: <20241104045432.E9987C4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: alloc_tag-load-module-tags-into-separate-contiguous-memory-fix-fix
has been removed from the -mm tree.  Its filename was
     alloc_tag-load-module-tags-into-separate-contiguous-memory-fix-fix.patch

This patch was dropped because it was folded into alloc_tag-load-module-tags-into-separate-contiguous-memory.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: alloc_tag-load-module-tags-into-separate-contiguous-memory-fix-fix
Date: Sun Nov  3 08:26:32 PM PST 2024

update comment, per Dan

Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/alloc_tag.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/alloc_tag.c~alloc_tag-load-module-tags-into-separate-contiguous-memory-fix-fix
+++ a/lib/alloc_tag.c
@@ -260,7 +260,7 @@ static void *reserve_module_tags(struct
 	unsigned long offset;
 	void *ret = NULL;
 
-	/* If no tags return NULL */
+	/* If no tags return error */
 	if (size < sizeof(struct alloc_tag))
 		return ERR_PTR(-EINVAL);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-keep-track-of-free-highatomic-fix.patch
mm-refactor-arch_calc_vm_flag_bits-and-arm64-mte-handling-fix.patch
mm-fix-__wp_page_copy_user-fallback-path-for-remote-mm-fix.patch
mm-memoryc-remove-stray-newline-at-top-of-file.patch
alloc_tag-load-module-tags-into-separate-contiguous-memory.patch
tools-mm-free-the-allocated-memory-fix.patch
memcg-v1-no-need-for-memcg-locking-for-mglru-fix.patch
mm-vma-the-pgoff-is-correct-if-can_merge_right-fix.patch
memcg-workingset-remove-folio_memcg_rcu-usage-fix.patch
bootmem-stop-using-page-index-fix.patch
vma-detect-infinite-loop-in-vma-tree-fix.patch
maple_tree-add-a-test-checking-storing-null-fix.patch
fs-proc-kcorec-fix-coccinelle-reported-error-instances-fix.patch


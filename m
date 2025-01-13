Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF2679E1;
	Mon, 13 Jan 2025 03:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736737445; cv=none; b=Was/JkjkpagmgAXH055eJq9Dnqn0BEj66EAwXDDulSt/bxEw0lR3ReQ3pyoCPNzf04nwaX+M5pNBXIfWovZDMrJWRN1VU0OIObjVv1N4B5l00eSoqFPp1sga6XZtn4v79E3Id3bKqELJ17uuzSaAm1HQtL+ZXU1eRiO9toJjWjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736737445; c=relaxed/simple;
	bh=Pn5uXofGmXkv/OmYnZb6LLzS2LOvVggJstpdmZ55V+w=;
	h=Date:To:From:Subject:Message-Id; b=JnFiR+cCMYpnvAR44FpwnFPrD7JDKIlJwHEYXABxtJGtabhFkXy9E1EHRCwI4vegZz3hzw8Jgyr3GFODO5/4bhOKC+KtyG/wGJmTdaMkn+JlIItf29oBn3SRkQe47Ahh543r1ZblvvCe5zcIddz4JhP3aQJ019CWL5debPqQdmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kyC3D1yZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kyC3D1yZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B255BC4CEDF;
	Mon, 13 Jan 2025 03:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736737444;
	bh=Pn5uXofGmXkv/OmYnZb6LLzS2LOvVggJstpdmZ55V+w=;
	h=Date:To:From:Subject:From;
	b=kyC3D1yZrZNZXx0+yO93NpHCyDpwYnxnQqOQWCrdsXcDYlETR2dOoas+DzMxItXrA
	 qtlkhOL8ef0OxKd2eD4t70m49DN5LIsFV7sdEclkQIs89173OvFOE5/kNHPQdzwZ4M
	 0zazvabvxFwwFSi0x19zaWJkpT7DFI7ySEvnMc4Y=
Date: Sun, 12 Jan 2025 19:04:04 -0800
To: mm-commits@vger.kernel.org,ubizjak@gmail.com,stable@vger.kernel.org,catalin.marinas@arm.com,guoweikang.kernel@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-kmemleak-fix-percpu-memory-leak-detection-failure.patch removed from -mm tree
Message-Id: <20250113030404.B255BC4CEDF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/kmemleak: fix percpu memory leak detection failure
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-fix-percpu-memory-leak-detection-failure.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Guo Weikang <guoweikang.kernel@gmail.com>
Subject: mm/kmemleak: fix percpu memory leak detection failure
Date: Fri, 27 Dec 2024 17:23:10 +0800

kmemleak_alloc_percpu gives an incorrect min_count parameter, causing
percpu memory to be considered a gray object.

Link: https://lkml.kernel.org/r/20241227092311.3572500-1-guoweikang.kernel@gmail.com
Fixes: 8c8685928910 ("mm/kmemleak: use IS_ERR_PCPU() for pointer in the percpu address space")
Signed-off-by: Guo Weikang <guoweikang.kernel@gmail.com>
Acked-by: Uros Bizjak <ubizjak@gmail.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Guo Weikang <guoweikang.kernel@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kmemleak.c~mm-kmemleak-fix-percpu-memory-leak-detection-failure
+++ a/mm/kmemleak.c
@@ -1093,7 +1093,7 @@ void __ref kmemleak_alloc_percpu(const v
 	pr_debug("%s(0x%px, %zu)\n", __func__, ptr, size);
 
 	if (kmemleak_enabled && ptr && !IS_ERR_PCPU(ptr))
-		create_object_percpu((__force unsigned long)ptr, size, 0, gfp);
+		create_object_percpu((__force unsigned long)ptr, size, 1, gfp);
 }
 EXPORT_SYMBOL_GPL(kmemleak_alloc_percpu);
 
_

Patches currently in -mm which might be from guoweikang.kernel@gmail.com are

mm-shmem-refactor-to-reuse-vfs_parse_monolithic_sep-for-option-parsing.patch
mm-early_ioremap-add-null-pointer-checks-to-prevent-null-pointer-dereference.patch
mm-memblock-add-memblock_alloc_or_panic-interface.patch
arch-s390-save_area_alloc-default-failure-behavior-changed-to-panic.patch
mm-memmap-prevent-double-scanning-of-memmap-by-kmemleak.patch


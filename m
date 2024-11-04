Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9097E20ED
	for <mm-commits@vger.kernel.org>; Mon,  4 Nov 2024 04:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730694482; cv=none; b=MUlw2lLAFRzv8hTIExvpWR2ftvAJjpaOZcPVrhqbbqRod0DNvqnt7+My7OYGK/h8+//UNyoSIzozuzWpYp+1vRlo0Y+OL2gKLFLcpA3WfyDkxq3eJzmbUO9qXvK1UYmse7ShWaeAxnu4Jjd+DA8DRNqHkkCRrxdsX4qyUix2wKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730694482; c=relaxed/simple;
	bh=nU2lMvYATzQMoAp8VuQuMcvarpfWllgNn6FJtj9BqDY=;
	h=Date:To:From:Subject:Message-Id; b=OY36JFiqLF3YcBFDgh2BgKmvD+OKcMyw85S/vi5UMhJi9+LqeIAYjpDrTKRGFqGwd061BDyfKlpOeCsR9PtWpJuXTGof5samXTk5gSwn1s5+01GYRDMIJCekhljIW6orrSuaAsFVDR22SUHBaKIlMQ2C1O9EPjVCITQ5ZexBmN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vCT8nQCx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vCT8nQCx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21AAFC4CECE;
	Mon,  4 Nov 2024 04:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730694482;
	bh=nU2lMvYATzQMoAp8VuQuMcvarpfWllgNn6FJtj9BqDY=;
	h=Date:To:From:Subject:From;
	b=vCT8nQCx7E5hLQUCqID8vx3RQHWZ1RGn5sz9YO3Q1/uFm20yLi4evIhTm7e3Ktnu3
	 89nUiO6IpejKjn3PulPwlkinCtKzbr5kEzlJntuxhWU1hEUVe18A2ZQmt2iGebX1iA
	 4a8p8Fau8pMmmX+gLZd/csdm6wAI535fFu5Y89f8=
Date: Sun, 03 Nov 2024 20:28:01 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,dan.carpenter@linaro.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alloc_tag-load-module-tags-into-separate-contiguous-memory-fix-fix.patch added to mm-unstable branch
Message-Id: <20241104042802.21AAFC4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: alloc_tag-load-module-tags-into-separate-contiguous-memory-fix-fix
has been added to the -mm mm-unstable branch.  Its filename is
     alloc_tag-load-module-tags-into-separate-contiguous-memory-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alloc_tag-load-module-tags-into-separate-contiguous-memory-fix-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
mm-consolidate-common-checks-in-hugetlb_get_unmapped_area-fix.patch
mm-memoryc-remove-stray-newline-at-top-of-file.patch
mm-kasan-kmsan-copy_from-to_kernel_nofault-fix.patch
bootmem-stop-using-page-index-fix.patch
alloc_tag-load-module-tags-into-separate-contiguous-memory-fix-fix.patch
tools-mm-free-the-allocated-memory-fix.patch
memcg-v1-no-need-for-memcg-locking-for-mglru-fix.patch
mm-vma-the-pgoff-is-correct-if-can_merge_right-fix.patch
memcg-workingset-remove-folio_memcg_rcu-usage-fix.patch
vma-detect-infinite-loop-in-vma-tree-fix.patch
maple_tree-add-a-test-checking-storing-null-fix.patch
fs-proc-kcorec-fix-coccinelle-reported-error-instances-fix.patch


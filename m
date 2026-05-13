Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C03482D6E44;
	Wed, 13 May 2026 18:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778697308; cv=none; b=jOziSRnaJsQb8q9Zhx4sePwR83/ue7SAglbitvHp3txVnVNDJDTZIC5FRv8CHvjAgp94MbdYy71tgiRQtpD7wNSB3QUG0923vftWd61AKB2YOpORl2dCDecxeyW9Vx6aLzycdb2CGxd1xfH+W9I9dK6iTsMiQiVVgh8jxLtVfHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778697308; c=relaxed/simple;
	bh=GfJ3DboiwFm8hVMw/nXzl/gOAngVCipYQtAF1PsoRmM=;
	h=Date:To:From:Subject:Message-Id; b=YAY+LTwlkgbg9/C/cnPDs4JamKyqPB2bmX21Vr+yxiNbwxND01klVPEJ2K8vi0kFKZ1HBpAsNlIBGkWVLij30L7YoRkwdI4tw4tclnSLrv6RQZsNtBDKxuzMOEO7pVs5vWluPiyCR4T3movP7Asr9ULSZ1/qATepapmcuWOAvH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MddIMw4e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MddIMw4e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BC6BC19425;
	Wed, 13 May 2026 18:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778697308;
	bh=GfJ3DboiwFm8hVMw/nXzl/gOAngVCipYQtAF1PsoRmM=;
	h=Date:To:From:Subject:From;
	b=MddIMw4eMv+y+uiMqZPtDEiyF5FpD3OMb+emYvOJTBbbfPzYExid7pQ0Vf5W7G107
	 UjYeKIRMOZ+LwGmE6NXurhw1aQgX4Zb4+QMIUXSeeedPI+7yUWKpU8FffTy6U8g19S
	 wo3yIqchx6UWxvoeOWl4/0SHXWO5LarWe6framDo=
Date: Wed, 13 May 2026 11:35:07 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,leon@kernel.org,jgg@ziepe.ca,balbirs@nvidia.com,hao.ge@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_hmm-use-kvfree-to-free-kvcalloc-allocations.patch added to mm-new branch
Message-Id: <20260513183508.3BC6BC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/test_hmm: use kvfree() to free kvcalloc() allocations
has been added to the -mm mm-new branch.  Its filename is
     lib-test_hmm-use-kvfree-to-free-kvcalloc-allocations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_hmm-use-kvfree-to-free-kvcalloc-allocations.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Hao Ge <hao.ge@linux.dev>
Subject: lib/test_hmm: use kvfree() to free kvcalloc() allocations
Date: Wed, 13 May 2026 16:25:25 +0800

Coccinelle scripts/coccinelle/api/kfree_mismatch.cocci reports
the following warnings:

  lib/test_hmm.c:1256:15-16: WARNING kvmalloc is used to allocate this memory at line 1191
  lib/test_hmm.c:1257:15-16: WARNING kvmalloc is used to allocate this memory at line 1196

Fix this by replacing kfree() with kvfree() to correctly handle the
vmalloc() fallback path of kvcalloc().

Link: https://lore.kernel.org/20260513082525.154036-1-hao.ge@linux.dev
Fixes: 775465fd26a3 ("lib/test_hmm: add zone device private THP test infrastructure")
Signed-off-by: Hao Ge <hao.ge@linux.dev>
Acked-by: Balbir Singh <balbirs@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_hmm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/test_hmm.c~lib-test_hmm-use-kvfree-to-free-kvcalloc-allocations
+++ a/lib/test_hmm.c
@@ -1253,8 +1253,8 @@ out:
 	mmap_read_unlock(mm);
 	mmput(mm);
 free_mem:
-	kfree(src_pfns);
-	kfree(dst_pfns);
+	kvfree(src_pfns);
+	kvfree(dst_pfns);
 	return ret;
 }
 
_

Patches currently in -mm which might be from hao.ge@linux.dev are

mm-alloc_tag-replace-fixed-size-early-pfn-array-with-dynamic-linked-list.patch
proc-meminfo-expose-per-node-balloon-pages-in-node-meminfo.patch
lib-test_hmm-use-kvfree-to-free-kvcalloc-allocations.patch


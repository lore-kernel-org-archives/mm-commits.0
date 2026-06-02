Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4DF93B9DA6;
	Tue,  2 Jun 2026 22:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439047; cv=none; b=t7TCm8qx4161PUyCK3Hnbq/5FezQIGnMv99ifWyUb1ZOGpmc2ckNOdRui8/BhpFDv1bPG1uozrK2GZRHJT8QSQDeF4MFPoywSdHHoNOVQ5XPVtln+b0YrR52+2BSxSIB+cUQMTQus4/rNbM+Xvxks7WoHHWTWBIvbNuYljGqehE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439047; c=relaxed/simple;
	bh=VP0R7RNz75xJ07LKP90CKFDLA9SY4d7LegCKYlEBDoA=;
	h=Date:To:From:Subject:Message-Id; b=nGoJCF29JlVAzm6zyMQ2oc+uGij4WD3OhsVmp1pcI0W62rroqMV3+ORGRpFRGcYeQnMqi3TjD6nI43A/XHrKjWF7lRXktFbWJUJI1saxLFg7H/DMRGlrk7VG8X5ZZH381EHWcd2f8wiNuXNF0DM9O1UbdERtpZWB/JGj6bMH63Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Pl6Xzubx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Pl6Xzubx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CA471F00898;
	Tue,  2 Jun 2026 22:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439046;
	bh=qbRlAWsgr1TdRrcDEw3oglB0aOZuixTT5FXG0Ok4bL4=;
	h=Date:To:From:Subject;
	b=Pl6Xzubx5GcBj5kauLRAkSeqwxauMYOZTO5kztOHyEXvAztGwP8hX3MDIvx9KEhdo
	 s71mc0pgVZjkeaaYhKv+VKOUF3bxGgSzLwSnq1yV2jx4w7DiJKiJWgRtzat0xB0o8N
	 y7X077lO9nakoesBKSXCLE3A6PFvOHMLAdUOs13g=
Date: Tue, 02 Jun 2026 15:24:05 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,leon@kernel.org,jgg@ziepe.ca,balbirs@nvidia.com,hao.ge@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-test_hmm-use-kvfree-to-free-kvcalloc-allocations.patch removed from -mm tree
Message-Id: <20260602222406.5CA471F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/test_hmm: use kvfree() to free kvcalloc() allocations
has been removed from the -mm tree.  Its filename was
     lib-test_hmm-use-kvfree-to-free-kvcalloc-allocations.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
alloc_tag-fix-use-after-free-in-proc-allocinfo-after-module-unload.patch
lib-test_hmm-fix-memory-leak-in-dmirror_migrate_to_system.patch


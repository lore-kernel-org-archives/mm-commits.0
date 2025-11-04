Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99B0427979A
	for <mm-commits@vger.kernel.org>; Tue,  4 Nov 2025 03:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762226812; cv=none; b=uwmjC92/O4xTMmCIPU/5cxsRz6dQPfjokr9OMcEqYPwLYks0LU83BVknZ1DcDq4eISqMf+Xhl8pVNj+69vpwHdS2HjQYwF/0PABKn88QaTVSFVZMB0V6psD8xWOj1qiNGsTjB1D+o7tAqwyWNgFjqMBVuRd5KKdmC66ipiVxTsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762226812; c=relaxed/simple;
	bh=65c63uSLMazrS48aq/rHYWukNdiwRMHOkmjBXICmX9g=;
	h=Date:To:From:Subject:Message-Id; b=ckTQgLeEyEjciBuq0gZrt1IeoTfq8j6VvpcuNn0BPt5csE/a9byj5Gd3WgjylVcbFFfOQW0CMdI3RG2fP6CYH9uBGrlaXWKNWjcdRN3kJBjC3p/wkTPAYP3JRUn0V7K0081+TzPOqgGmhGGGLxRA3kD28QwwxTYTyN+dJ9b1l2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A0BeraDg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A0BeraDg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BD7AC113D0;
	Tue,  4 Nov 2025 03:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762226812;
	bh=65c63uSLMazrS48aq/rHYWukNdiwRMHOkmjBXICmX9g=;
	h=Date:To:From:Subject:From;
	b=A0BeraDgIV5NSW05PB9SJUw88dtMmnYaURLXktNnJWnazf8l8K5C01NDo3NQIX1/8
	 y9yXsKcfMUQ8z+1xBbT/DdS/znPRVgN8zcOSQULTlRc1hN6Z7GlBO0J2gHrAi5yuyk
	 t2o3rZs2BIQzGdoll8HDV7XEyBKcuXYvmXoJ+Jp4=
Date: Mon, 03 Nov 2025 19:26:51 -0800
To: mm-commits@vger.kernel.org,yanjun.zhu@linux.dev,tj@kernel.org,rppt@kernel.org,rdunlap@infradead.org,pratyush@kernel.org,ojeda@kernel.org,masahiroy@kernel.org,jgg@ziepe.ca,jgg@nvidia.com,horms@kernel.org,graf@amazon.com,corbet@lwn.net,changyuanl@google.com,brauner@kernel.org,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-update-kho-maintainers.patch added to mm-nonmm-unstable branch
Message-Id: <20251104032652.2BD7AC113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: update KHO maintainers
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     maintainers-update-kho-maintainers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-update-kho-maintainers.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: MAINTAINERS: update KHO maintainers
Date: Sat, 1 Nov 2025 10:23:24 -0400

Changyuan does not have cycles to commit to the upstream work of KHO. 
Remove from KHO maintainers.

Link: https://lkml.kernel.org/r/20251101142325.1326536-9-pasha.tatashin@soleen.com
Signed-off-by: Changyuan Lyu <changyuanl@google.com>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Simon Horman <horms@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-update-kho-maintainers
+++ a/MAINTAINERS
@@ -13789,7 +13789,7 @@ F:	kernel/kexec*
 KEXEC HANDOVER (KHO)
 M:	Alexander Graf <graf@amazon.com>
 M:	Mike Rapoport <rppt@kernel.org>
-M:	Changyuan Lyu <changyuanl@google.com>
+M:	Pasha Tatashin <pasha.tatashin@soleen.com>
 L:	kexec@lists.infradead.org
 L:	linux-mm@kvack.org
 S:	Maintained
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

liveupdate-kho-warn-and-fail-on-metadata-or-preserved-memory-in-scratch-area.patch
liveupdate-kho-increase-metadata-bitmap-size-to-page_size.patch
liveupdate-kho-allocate-metadata-directly-from-the-buddy-allocator.patch
kho-make-debugfs-interface-optional.patch
kho-add-interfaces-to-unpreserve-folios-page-ranges-and-vmalloc.patch
memblock-unpreserve-memory-in-case-of-error.patch
test_kho-unpreserve-memory-in-case-of-error.patch
kho-dont-unpreserve-memory-during-abort.patch
liveupdate-kho-move-to-kernel-liveupdate.patch
maintainers-update-kho-maintainers.patch


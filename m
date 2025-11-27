Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 829CB31579B
	for <mm-commits@vger.kernel.org>; Thu, 27 Nov 2025 22:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764282368; cv=none; b=dX23y6VGeF2pOapepfYe6EHSbpBCRPT5VWvna/pdWfCwo3sH+zNmn01H/cfDispsGh+Hl3zytgjnbO7Lo7iBhxwvI4qcnZvFxOaWvSCSSce4D+tI1FRZ9fXTP1ZZoZ5NGSv2kBTkA9B7mS1QkVJNFQxUlmaFqwLz42QxMng6m8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764282368; c=relaxed/simple;
	bh=rfDfXU+YuySJeX6qol7FvW3gUkAb/CLW3aq1pL8c9U8=;
	h=Date:To:From:Subject:Message-Id; b=b7we+7+a6Xzn3hJLNz3OTvCjA/Dg/ujVd/nxlT/8NTVQpI88CaOb/9Bv8omsMAF5DneBbV7qF2zQJSti4CF0Gd32jsdAKY/YvzLC01S/SAU7ndGPRHUh3wozHg7kQhtwXJqGyaKgFlWPoX73I71NFfOYVbIZYiqJJuSIWD+MbKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pnwv+sRd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pnwv+sRd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 545F6C4CEF8;
	Thu, 27 Nov 2025 22:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764282368;
	bh=rfDfXU+YuySJeX6qol7FvW3gUkAb/CLW3aq1pL8c9U8=;
	h=Date:To:From:Subject:From;
	b=pnwv+sRd6LOPKOEU1VDRe7jBmK48iZ1z97s9shK1Bd+JyVjRdZ5/8dsvyNvOstMp3
	 beQcixLUNUSNVdJZoYpM+Qg1doERmvxr4ZeKQgJ4qCSsUAlEYKh/txt8r2lWLxHrgh
	 qgAC2M+WvZ/+5zBs9dh8dvwfqtDmNLqV4QbJd6pQ=
Date: Thu, 27 Nov 2025 14:26:07 -0800
To: mm-commits@vger.kernel.org,yanjun.zhu@linux.dev,tj@kernel.org,rppt@kernel.org,rdunlap@infradead.org,pratyush@kernel.org,ojeda@kernel.org,masahiroy@kernel.org,jgg@ziepe.ca,jgg@nvidia.com,horms@kernel.org,graf@amazon.com,corbet@lwn.net,changyuanl@google.com,brauner@kernel.org,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] maintainers-update-kho-maintainers.patch removed from -mm tree
Message-Id: <20251127222608.545F6C4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: update KHO maintainers
has been removed from the -mm tree.  Its filename was
     maintainers-update-kho-maintainers.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -13791,7 +13791,7 @@ F:	kernel/kexec*
 KEXEC HANDOVER (KHO)
 M:	Alexander Graf <graf@amazon.com>
 M:	Mike Rapoport <rppt@kernel.org>
-M:	Changyuan Lyu <changyuanl@google.com>
+M:	Pasha Tatashin <pasha.tatashin@soleen.com>
 R:	Pratyush Yadav <pratyush@kernel.org>
 L:	kexec@lists.infradead.org
 L:	linux-mm@kvack.org
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

liveupdate-luo_flb-introduce-file-lifecycle-bound-global-state.patch
tests-liveupdate-add-in-kernel-liveupdate-test.patch


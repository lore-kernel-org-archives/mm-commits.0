Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84AD13368B9
	for <mm-commits@vger.kernel.org>; Wed,  4 Mar 2026 01:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772586603; cv=none; b=XN+iP9qUrGdGQzg7FoPvGGZI+DTU9KPrE5Rjs089sCVgUZqpu/0Hcvt7tQX/gInHpxyiwvvDNeMrx5FSAMNujpja37kbghoGMGwiZiV9jwkq4+WTPbNzQ/n9a0pL+M55BA1vx8bNdUQ9tPJiNkYbcrumqKhFvr/lJorAL0e3GEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772586603; c=relaxed/simple;
	bh=m3o0Ces6nn+lWvk+ZPQ1HlKcxtVjt+p128Mt42WlGck=;
	h=Date:To:From:Subject:Message-Id; b=aF+wj4blZx20AcY7v0d/x59Vr70j2AXUzBqFF0wTWOulrSC8D53e4AvvcXIDY0x9tHGlGRDqGcwyCsXIrup9+oo/qKZsia8bSv1f96vt1HkFT5GQGCbAeyBN43zMxVeP+Dj6tcb51kieW1XyzDyKs0KaPrbFIoGkkEAdCUctK1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Rb65AhQy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Rb65AhQy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16BDAC116C6;
	Wed,  4 Mar 2026 01:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772586603;
	bh=m3o0Ces6nn+lWvk+ZPQ1HlKcxtVjt+p128Mt42WlGck=;
	h=Date:To:From:Subject:From;
	b=Rb65AhQy9LcEipnVk8SHYi7jt8tN8E6hJxWY3TYSYWM23u2ItiH9Uy4d8703g9L0Z
	 GHVMVnhLJow7M2/3Xwwp7smnA+WVEN4clyNPyS0dywOkqyz9pJRtI5Fzo1hrECNeBT
	 SNh/14/GPCVyk2ClQ62l9QHswrknOkrq9oUUN22w=
Date: Tue, 03 Mar 2026 17:10:02 -0800
To: mm-commits@vger.kernel.org,david@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-fix-a-folio_split-race-condition-with-folio_try_get-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20260304011003.16BDAC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-huge_memory-fix-a-folio_split-race-condition-with-folio_try_get-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-huge_memory-fix-a-folio_split-race-condition-with-folio_try_get-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-fix-a-folio_split-race-condition-with-folio_try_get-fix.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Zi Yan <ziy@nvidia.com>
Subject: mm-huge_memory-fix-a-folio_split-race-condition-with-folio_try_get-fix
Date: Tue, 3 Mar 2026 11:26:41 -0500

move comment, per David

Link: https://lkml.kernel.org/r/5C9FA053-A4C6-4615-BE05-74E47A6462B3@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-fix-a-folio_split-race-condition-with-folio_try_get-fix
+++ a/mm/huge_memory.c
@@ -3656,17 +3656,15 @@ static int __split_unmapped_folio(struct
 			 * uniform split has xas_split_alloc() called before
 			 * irq is disabled to allocate enough memory, whereas
 			 * non-uniform split can handle ENOMEM.
+			 * Use the to-be-split folio, so that a parallel
+			 * folio_try_get() waits on it until xarray is updated
+			 * with after-split folios and the original one is
+			 * unfrozen.
 			 */
 			if (split_type == SPLIT_TYPE_UNIFORM) {
 				xas_split(xas, old_folio, old_order);
 			} else {
 				xas_set_order(xas, folio->index, split_order);
-				/*
-				 * use the to-be-split folio, so that a parallel
-				 * folio_try_get() waits on it until xarray is
-				 * updated with after-split folios and
-				 * the original one is unfrozen.
-				 */
 				xas_try_split(xas, old_folio, old_order);
 				if (xas_error(xas))
 					return xas_error(xas);
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-cma-move-put_page_testzero-out-of-vm_warn_on-in-cma_release.patch
mm-huge_memory-fix-a-folio_split-race-condition-with-folio_try_get.patch
mm-huge_memory-fix-a-folio_split-race-condition-with-folio_try_get-fix.patch


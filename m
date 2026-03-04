Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4773C3BED31
	for <mm-commits@vger.kernel.org>; Wed,  4 Mar 2026 17:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772646070; cv=none; b=EuhkAB9HGilb1uRmX1N3d2YzGvLUcJSdP0pJ2p30XQzuCbOn+Shiu1Gw7AbHfuUyrR994FNl+UZr7oirHv0T1d8Rpr5hU4blu3S/2qQHkwckfF0YNrgsibBGGa0vWcv6zmfiMnR9clXZMacmPO+gb7QFGGdHen0mJ9izc2uFkr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772646070; c=relaxed/simple;
	bh=waO9jm8+lSJJqHpTdbJlhFeQwPdm7FjwCXB0e89tUH0=;
	h=Date:To:From:Subject:Message-Id; b=Xe/nsrvDqDobBPtxXUXM78CDqBKU3uchQSOjTDdkB8B3muaL2gXbTesInYrz5NIndmLm7leAUfXmCQ24UmxRi80WsRoFcv4IcvyS0xepX9AgF08Kbe5Zkb2qllDItc4d9xwfbZPTibfMwkrXXgVuEPo64IAOEkNidopHCukp4OM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CMc80Pjn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CMc80Pjn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB9F4C19425;
	Wed,  4 Mar 2026 17:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772646069;
	bh=waO9jm8+lSJJqHpTdbJlhFeQwPdm7FjwCXB0e89tUH0=;
	h=Date:To:From:Subject:From;
	b=CMc80Pjn7DkIMcQjKDUyi1LyFNl0S153gheD+nhza9ruMurliJkDx82Fkk1anJaD5
	 sKOilCy8vkSXM4eNnxwKUBVK9N/LLme1zChMgfjyfzPpxUKeK2BZ7UrTT7duXulFOI
	 bJUB3JSEbXh6zlphgpmxQZve6JkQ6d1NnZTIzZj0=
Date: Wed, 04 Mar 2026 09:41:09 -0800
To: mm-commits@vger.kernel.org,david@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-huge_memory-fix-a-folio_split-race-condition-with-folio_try_get-fix.patch removed from -mm tree
Message-Id: <20260304174109.AB9F4C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-huge_memory-fix-a-folio_split-race-condition-with-folio_try_get-fix
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-fix-a-folio_split-race-condition-with-folio_try_get-fix.patch

This patch was dropped because it was folded into mm-huge_memory-fix-a-folio_split-race-condition-with-folio_try_get.patch

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
@@ -3652,17 +3652,15 @@ static int __split_unmapped_folio(struct
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


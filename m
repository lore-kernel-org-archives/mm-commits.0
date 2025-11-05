Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC241D5151;
	Wed,  5 Nov 2025 23:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762387133; cv=none; b=QKBlL4PCzWAHxLFymkTuX8z13SmuKTw9drU4YrRRw2Byf/zF1LxGb/0gB7oDXUlHsqfwVYNlVY5n437BNECAom0xr09qQJnuU5UaJccUZTAuwqXRJBGz+N3jA6+PfhS/UuUdNibh7nAZMofUg7UTNRBQnQN6kbnzOi4nty4bO+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762387133; c=relaxed/simple;
	bh=twFpIo4KfTnKr3nXoYN9uYKscwGeun6j1FvX4UGvHgY=;
	h=Date:To:From:Subject:Message-Id; b=Fp6D3g6DN0TLuqMtlGneSM1vgnuxDKXStPkth2PqKTU4fhlXKJ0knYyaYGWkHytHYI2K6Zu5PdhOaIVCrv+e0XqqRoQIpuFH9389Y4sKD4wD1BZ+RjW8Vpkoj/uptLm1kAMt3cxXZSvPOOqxRQVrV3soIS4QJsCYIiu88IuPoOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Rg0MkhP7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Rg0MkhP7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFCC7C4CEF5;
	Wed,  5 Nov 2025 23:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762387132;
	bh=twFpIo4KfTnKr3nXoYN9uYKscwGeun6j1FvX4UGvHgY=;
	h=Date:To:From:Subject:From;
	b=Rg0MkhP7Oc+c13iPVEA50KrILqNN7Eoy2rdPaOU41tIIe8qi+niQnicwvBjckXCYC
	 a0xIg0EMV5KoGif8sQnj6F8w1Os971Hbt8eXPYlegI29jI0a5BODwgE4cY4q25AnlZ
	 QxpNk7Bd8GqFH3tpqtJ7P17mPLHfM5g2IIjpiA0g=
Date: Wed, 05 Nov 2025 15:58:52 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,ryan.roberts@arm.com,richard.weiyang@gmail.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-fix-folio-split-check-for-anon-folios-in-swapcache.patch added to mm-hotfixes-unstable branch
Message-Id: <20251105235852.AFCC7C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: fix folio split check for anon folios in swapcache.
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-huge_memory-fix-folio-split-check-for-anon-folios-in-swapcache.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-fix-folio-split-check-for-anon-folios-in-swapcache.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Zi Yan <ziy@nvidia.com>
Subject: mm/huge_memory: fix folio split check for anon folios in swapcache.
Date: Wed, 5 Nov 2025 11:29:10 -0500

Both uniform and non uniform split check missed the check to prevent
splitting anon folios in swapcache to non-zero order.  Fix the check.

Link: https://lkml.kernel.org/r/20251105162910.752266-1-ziy@nvidia.com
Fixes: 58729c04cf10 ("mm/huge_memory: add buddy allocator like (non-uniform) folio_split()")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reported-by: "David Hildenbrand (Red Hat)" <david@kernel.org>
Closes: https://lore.kernel.org/all/dc0ecc2c-4089-484f-917f-920fdca4c898@kernel.org/
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-fix-folio-split-check-for-anon-folios-in-swapcache
+++ a/mm/huge_memory.c
@@ -3522,7 +3522,8 @@ bool non_uniform_split_supported(struct
 		/* order-1 is not supported for anonymous THP. */
 		VM_WARN_ONCE(warns && new_order == 1,
 				"Cannot split to order-1 folio");
-		return new_order != 1;
+		if (new_order == 1)
+			return false;
 	} else if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
 	    !mapping_large_folio_support(folio->mapping)) {
 		/*
@@ -3553,7 +3554,8 @@ bool uniform_split_supported(struct foli
 	if (folio_test_anon(folio)) {
 		VM_WARN_ONCE(warns && new_order == 1,
 				"Cannot split to order-1 folio");
-		return new_order != 1;
+		if (new_order == 1)
+			return false;
 	} else  if (new_order) {
 		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
 		    !mapping_large_folio_support(folio->mapping)) {
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-huge_memory-do-not-change-split_huge_page-target-order-silently.patch
mm-huge_memory-preserve-pg_has_hwpoisoned-if-a-folio-is-split-to-0-order.patch
mm-huge_memory-fix-folio-split-check-for-anon-folios-in-swapcache.patch
mm-huge_memory-add-split_huge_page_to_order.patch
mm-memory-failure-improve-large-block-size-folio-handling.patch
mm-huge_memory-fix-kernel-doc-comments-for-folio_split-and-related.patch
mm-huge_memory-fix-kernel-doc-comments-for-folio_split-and-related-fix.patch


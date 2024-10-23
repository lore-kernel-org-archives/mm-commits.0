Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C9751A08C2
	for <mm-commits@vger.kernel.org>; Wed, 23 Oct 2024 20:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729716243; cv=none; b=lhgK0eMPAe9+IDKFvV5jwsXtkIeHcejaLlRbnWauaxSEqry5laolhtb5DFJWSxSCcbODBUyEJMTYSvkqp0864pq/Bj2GxuvD/u8zLes/Y8qUYcP3OGGXUk6ltpL8iObdy8pz8yxqd0qUxvVkUOhwCz93IOGuHaUo/7qWNjB4R4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729716243; c=relaxed/simple;
	bh=hgzTC1EaNyFNsKIvGMYrT7CrIdH/621/T3ITfsf7Xl8=;
	h=Date:To:From:Subject:Message-Id; b=MJO3hKLhJFCPW+V6o4lCVh7yJtUbrPY1hFxIZdFWdYprd9tWhrKh9xFvXrIBfNfu5LP89680PWr9yP1AK3uedDJd38v2YbHbh6JVCItQrEhM/3lw8XfE0EWmiPyBgmJl2AhoZs6ut8zOi5LCVAs89uPRvvSJ/fVmHg8xKiIs5Fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f59Ml7hG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f59Ml7hG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AA1FC4CEC6;
	Wed, 23 Oct 2024 20:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729716243;
	bh=hgzTC1EaNyFNsKIvGMYrT7CrIdH/621/T3ITfsf7Xl8=;
	h=Date:To:From:Subject:From;
	b=f59Ml7hGKBlbkVOWG9MRkAOG1aYEvt78zVJHUiqBvZaNkoGCFjfYYf9zl2S9M7bI/
	 1s7CCIbwFB4mCPJ2gRWg1UzmkaQnoo4x9S19UJf7Vywqo2YjBS0/HTEzefg+SmJWGT
	 qf7k19SwUWzv76UIoTRrkGbP3hONdakNn9CrJeHw=
Date: Wed, 23 Oct 2024 13:44:02 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,willy@infradead.org,usamaarif642@gmail.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,roman.gushchin@linux.dev,riel@surriel.com,npache@redhat.com,hannes@cmpxchg.org,david@redhat.com,corbet@lwn.net,cerasuolodomenico@gmail.com,baohua@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-avoid-vm_bug_on-when-try-to-map-an-anon-large-folio-to-zero-page.patch added to mm-hotfixes-unstable branch
Message-Id: <20241023204403.0AA1FC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: avoid VM_BUG_ON when try to map an anon large folio to zero page.
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-avoid-vm_bug_on-when-try-to-map-an-anon-large-folio-to-zero-page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-avoid-vm_bug_on-when-try-to-map-an-anon-large-folio-to-zero-page.patch

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
Subject: mm: avoid VM_BUG_ON when try to map an anon large folio to zero page.
Date: Wed, 23 Oct 2024 13:12:36 -0400

An anonymous large folio can be split into non order-0 folios,
try_to_map_unused_to_zeropage() should not VM_BUG_ON compound pages but
just return false.  This fixes the crash when splitting anonymous large
folios to non order-0 folios.

Link: https://lkml.kernel.org/r/20241023171236.1122535-1-ziy@nvidia.com
Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage when splitting isolated thp")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: kernel-team@meta.com
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/migrate.c~mm-avoid-vm_bug_on-when-try-to-map-an-anon-large-folio-to-zero-page
+++ a/mm/migrate.c
@@ -206,7 +206,8 @@ static bool try_to_map_unused_to_zeropag
 	pte_t newpte;
 	void *addr;
 
-	VM_BUG_ON_PAGE(PageCompound(page), page);
+	if (PageCompound(page))
+		return false;
 	VM_BUG_ON_PAGE(!PageAnon(page), page);
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(pte_present(*pvmw->pte), page);
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-avoid-vm_bug_on-when-try-to-map-an-anon-large-folio-to-zero-page.patch
mm-avoid-zeroing-user-movable-page-twice-with-init_on_alloc=1.patch


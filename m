Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 934AE42069
	for <mm-commits@vger.kernel.org>; Thu, 31 Oct 2024 03:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730344506; cv=none; b=SBAGYpphuxQrwB42UfLb7E4myVRxetSorhKi4wY7iE3Gikuq9wiPn/njlv/izesr4OD/j4VbP3i3HL/SZgm/m34YBh852G0VMkEEwuuQh2s4mIK9yQp0EUnu05WEOLwVFvLleRuFJFAe5c2FBberJXs03Vg8Iw/fnOmWoFCln0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730344506; c=relaxed/simple;
	bh=VwIUCKj4EUH7gCOJhnu5suCj8HoHtnenyuf6eTco+c8=;
	h=Date:To:From:Subject:Message-Id; b=nugJtrH+KoHZpnZFO6A6hJi0MkJElJZsyCHRIjQ599ZGmRS4H8lvam136zRzFHcc9WAM6biyj1z9l+d7GVFlgbsnXnhfhj6UOi0dAZ+kBFgESX65Q0sXD3MNOwej7pmc+iY3x0ve3JN0shzBgQsa26RUoNbv4jAB1CorlB9gLE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rD+e6wOt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rD+e6wOt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0197BC4CECE;
	Thu, 31 Oct 2024 03:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730344506;
	bh=VwIUCKj4EUH7gCOJhnu5suCj8HoHtnenyuf6eTco+c8=;
	h=Date:To:From:Subject:From;
	b=rD+e6wOtQ2rgUGYQzB6eawjcBjJXsMEZ7h8duPNluVsyrHo2xWidfvy4FXvL60sWS
	 rXijCmBy5fdd4ygiDs2RYMqn5KQhAU31yFjEhfo03G1pOaAFf56Yab6opjF8JZWUmB
	 mMhJTARwuVNPTxZxkYGT27cf2YleHl6mJTA2s91g=
Date: Wed, 30 Oct 2024 20:15:05 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,willy@infradead.org,usamaarif642@gmail.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,roman.gushchin@linux.dev,riel@surriel.com,npache@redhat.com,hannes@cmpxchg.org,david@redhat.com,corbet@lwn.net,cerasuolodomenico@gmail.com,baohua@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-avoid-vm_bug_on-when-try-to-map-an-anon-large-folio-to-zero-page.patch removed from -mm tree
Message-Id: <20241031031506.0197BC4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: avoid VM_BUG_ON when try to map an anon large folio to zero page.
has been removed from the -mm tree.  Its filename was
     mm-avoid-vm_bug_on-when-try-to-map-an-anon-large-folio-to-zero-page.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Usama Arif <usamaarif642@gmail.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
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

mm-avoid-zeroing-user-movable-page-twice-with-init_on_alloc=1.patch
mm-avoid-zeroing-user-movable-page-twice-with-init_on_alloc=1-fix.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC2B2D0634;
	Tue, 28 Oct 2025 23:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761693015; cv=none; b=P0qNs7H2cuA+6EaBykeuFcO8VPCUsIhAfO5sKa1HQKjHy3RdNMzzmZ5flwjgu5LLJsVdWvv6vsnqv4QdJ42CyArqC0eARvIGUL8FVF+++XSwKuTK/deVmfZDsuf4XnKjWSTL+Pchq91lI3RJxDwhmKz0r7XBn6SlAY3KDgycyAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761693015; c=relaxed/simple;
	bh=HQ5OuiNHcqt9r8gsflkpBn3jscyw7EbZR3y5hPvG3DI=;
	h=Date:To:From:Subject:Message-Id; b=pIDEAqTAGpMH+cmsZ//jupfwiWWiBlGWZZ8PhxN81C0MDZK4UfDzRWT87YI7FMeSou84hyT0PVg4CZxycPpXYg27z6V8DMrELy2Fhh6ZXE9VRUGOnpirkYLA9odxSMJ7iHncf24qAKWxFz4iTnMg1ewTwk4tWa8kJQcLtlX12LI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GjbqA4Vp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GjbqA4Vp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18473C4CEE7;
	Tue, 28 Oct 2025 23:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761693014;
	bh=HQ5OuiNHcqt9r8gsflkpBn3jscyw7EbZR3y5hPvG3DI=;
	h=Date:To:From:Subject:From;
	b=GjbqA4VpLtPiv3nSOq2rDIjeXwaX7y68LuzQLrbHEibPm1WE5I6LpnUuONWkmrASY
	 iFraeb7pOM7QpGBLWjx0J4D8NLcc1WBH4T9Ep/TL95aILmd+MDXwXM+yqHfDaTLX8H
	 dUaFRrldfoZzvNWqhi0ZDUT5HDR0J2S5JVvL/WJI=
Date: Tue, 28 Oct 2025 16:10:13 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,stable@vger.kernel.org,pfalcato@suse.de,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,david@redhat.com,baohua@kernel.org,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-honour-writable-bit-in-mremap-pte-batching.patch added to mm-hotfixes-unstable branch
Message-Id: <20251028231014.18473C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mremap: honour writable bit in mremap pte batching
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-mremap-honour-writable-bit-in-mremap-pte-batching.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-honour-writable-bit-in-mremap-pte-batching.patch

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
From: Dev Jain <dev.jain@arm.com>
Subject: mm/mremap: honour writable bit in mremap pte batching
Date: Tue, 28 Oct 2025 12:09:52 +0530

Currently mremap folio pte batch ignores the writable bit during figuring
out a set of similar ptes mapping the same folio.  Suppose that the first
pte of the batch is writable while the others are not - set_ptes will end
up setting the writable bit on the other ptes, which is a violation of
mremap semantics.  Therefore, use FPB_RESPECT_WRITE to check the writable
bit while determining the pte batch.

Link: https://lkml.kernel.org/r/20251028063952.90313-1-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Fixes: f822a9a81a31 ("mm: optimize mremap() by PTE batching")
Reported-by: David Hildenbrand <david@redhat.com>
Debugged-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>	[6.17+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mremap.c~mm-mremap-honour-writable-bit-in-mremap-pte-batching
+++ a/mm/mremap.c
@@ -187,7 +187,7 @@ static int mremap_folio_pte_batch(struct
 	if (!folio || !folio_test_large(folio))
 		return 1;
 
-	return folio_pte_batch(folio, ptep, pte, max_nr);
+	return folio_pte_batch_flags(folio, NULL, ptep, &pte, max_nr, FPB_RESPECT_WRITE);
 }
 
 static int move_ptes(struct pagetable_move_control *pmc,
_

Patches currently in -mm which might be from dev.jain@arm.com are

mm-mremap-honour-writable-bit-in-mremap-pte-batching.patch


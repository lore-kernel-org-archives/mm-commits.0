Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759132E8B80;
	Mon, 10 Nov 2025 05:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762752030; cv=none; b=qwIaJrpIcoZDoP2ulFLx0YnZCP2jRtAgKxjpkalBAxt5ZjNefURvtUz7EamE1h0ewFWAgnujFzfvpZcimDjLFXTWkWkg6Ki7PX2J706uC/2Tty5IbzHnbXrJohsGBj6GeR1zONqM0nyOPJvMx09LjCkx9TlKz0BpTdtOe4avyTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762752030; c=relaxed/simple;
	bh=ucCvGn8P7OhOUMz14qgPs+ZnGgWL3vTZJ9+vnyhjwow=;
	h=Date:To:From:Subject:Message-Id; b=gNYDBLDZ8shUW7xVswKIiEkEIyRLjTabme1GSbviTfcigUDTJPk0EiGeCKwCtXsgn96aD74ZVtXPWN0oxTKKwIuZi1SCLSbyLNWRHamt8PNH4S6npjdlq+BKLC3Y5fJbgIJdU6NDV8KuO//HXvLFNTHwU6Fb3fcVOIDtGIpaLzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MIDa90f7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MIDa90f7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 013B7C2BC87;
	Mon, 10 Nov 2025 05:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762752030;
	bh=ucCvGn8P7OhOUMz14qgPs+ZnGgWL3vTZJ9+vnyhjwow=;
	h=Date:To:From:Subject:From;
	b=MIDa90f7eBuzy1DZVlbm2WqfWLp+wx/JzZwJGI8GC5ueVlgLW5yQ9hRU7mu1GH36q
	 P9O0GApXjCED7yIWBI8rVgwNQmNN9soW/qY45LkI+64e5p6CUYRu+Sy6mCTHkolwGB
	 43ZBm1lBZkLQY0W2POiH2aMcwSBk0OFspTejem1U=
Date: Sun, 09 Nov 2025 21:20:29 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,stable@vger.kernel.org,pfalcato@suse.de,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,david@redhat.com,baohua@kernel.org,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-mremap-honour-writable-bit-in-mremap-pte-batching.patch removed from -mm tree
Message-Id: <20251110052030.013B7C2BC87@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mremap: honour writable bit in mremap pte batching
has been removed from the -mm tree.  Its filename was
     mm-mremap-honour-writable-bit-in-mremap-pte-batching.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



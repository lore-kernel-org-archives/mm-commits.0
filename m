Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F0C08488
	for <mm-commits@vger.kernel.org>; Sat, 13 Sep 2025 22:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757801844; cv=none; b=iVkLOGW5DcXNN2Cx8Osrn2AcO5xWltFp/VTi+/pdP9amA/JxYBrsxdAOvAbeRGsNYeQiSpX2KC2Et1+Fg/RLn1JopB2So3HMKyPgBNX9ckEcY9msOza3iq3FIcYII1QOjfyb2Gn0uL0hQPTIUaf1j1r+qtojNfaxEa0/BeIt6sQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757801844; c=relaxed/simple;
	bh=Xu5fwHLQlygmIIMhWe6nF0MEXSLZ68BPhCHKtEGAt24=;
	h=Date:To:From:Subject:Message-Id; b=HRsFYL+PR9DAp9MGYQWFDqsbvS7tjdNegoy2DI0vdAFmwU5PtK7LrvfwMJ9ainPxo6ygQsRXOEY2F5YqKHp7fpdUqOIX80YCh2pjnjXZ17KF2yriw88yel7/m+QSH3g3qvv2Fiae2X9zs2/feE322wqVnhKfY3MW9ytkE/F9mkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pbVActRU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pbVActRU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C81E9C4CEEB;
	Sat, 13 Sep 2025 22:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757801843;
	bh=Xu5fwHLQlygmIIMhWe6nF0MEXSLZ68BPhCHKtEGAt24=;
	h=Date:To:From:Subject:From;
	b=pbVActRURrvVdxvUKLa4XNFUic/56CjU2+Pv0TIqgndmSws7lPQJs5HHVFYsFn5w/
	 1+WgmNBVv04aH3JWJ3jYhLuhSHP2kGtiUUet1hHhUVyXM3l74SLaIKlzi9Mfy+Fn1L
	 uYEmLHrGMrB77DsYE5EfB2Bg0Ax8BCCNbkuzH08U=
Date: Sat, 13 Sep 2025 15:17:23 -0700
To: mm-commits@vger.kernel.org,v-songbaohua@oppo.com,surenb@google.com,peterx@redhat.com,kaleshsingh@google.com,david@redhat.com,baohua@kernel.org,lokeshgidra@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] userfaultfd-opportunistic-tlb-flush-batching-for-present-pages-in-move-v6.patch removed from -mm tree
Message-Id: <20250913221723.C81E9C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: userfaultfd-opportunistic-tlb-flush-batching-for-present-pages-in-move-v6
has been removed from the -mm tree.  Its filename was
     userfaultfd-opportunistic-tlb-flush-batching-for-present-pages-in-move-v6.patch

This patch was dropped because it was folded into userfaultfd-opportunistic-tlb-flush-batching-for-present-pages-in-move.patch

------------------------------------------------------
From: Lokesh Gidra <lokeshgidra@google.com>
Subject: userfaultfd-opportunistic-tlb-flush-batching-for-present-pages-in-move-v6
Date: Sat, 16 Aug 2025 12:11:23 -0700

make calculation of largest extent that can be batched unconditional on
length, per Barry

Link: https://lkml.kernel.org/r/20250816191123.3601561-1-lokeshgidra@google.com
Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
Acked-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/mm/userfaultfd.c~userfaultfd-opportunistic-tlb-flush-batching-for-present-pages-in-move-v6
+++ a/mm/userfaultfd.c
@@ -1081,11 +1081,8 @@ static long move_present_ptes(struct mm_
 	unsigned long src_start = src_addr;
 	unsigned long src_end;
 
-	if (len > PAGE_SIZE) {
-		len = pmd_addr_end(dst_addr, dst_addr + len) - dst_addr;
-		src_end = pmd_addr_end(src_addr, src_addr + len);
-	} else
-		src_end = src_addr + len;
+	len = pmd_addr_end(dst_addr, dst_addr + len) - dst_addr;
+	src_end = pmd_addr_end(src_addr, src_addr + len);
 	flush_cache_range(src_vma, src_addr, src_end);
 	double_pt_lock(dst_ptl, src_ptl);
 
_

Patches currently in -mm which might be from lokeshgidra@google.com are

userfaultfd-opportunistic-tlb-flush-batching-for-present-pages-in-move.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2141799F
	for <mm-commits@vger.kernel.org>; Mon, 18 Aug 2025 01:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755481780; cv=none; b=LRqdIv9Wj7kvZbY6tvra2XCJuChg0Zr1QddzWL+nPgwPMQRE6HbDYetbpRnj63GPdJrkcnP7XqW6NnLP4/1/VsLxQdTyzTLI6vNVhWtbRyfJD+MUqO6m1IjNKeNlSYUn/twoNmV8NYo4Bb9BkARbYD7JdUn2Q9Qm0KpOV8ph5oY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755481780; c=relaxed/simple;
	bh=Tb1Pc78HXP5m4e0WpGQNZOgeJgdvHy77XY5oC12Ov2s=;
	h=Date:To:From:Subject:Message-Id; b=VHiso4p64UyyGsiWim4Vi1aektk3dB9GQ+k7F/pdunh4LMCsaoixiMPyfvF9pFX7SOjZ++XahJocMIvD1vKt63d27+L4aNaULLRiKLT7EbieMtuffrh5ODJPBm91mz2Bt858cHuBcop2MgtDJRHorE0LoqF3rcaSaW/OWoAmA64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i3PrBJ75; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i3PrBJ75"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96094C4CEEB;
	Mon, 18 Aug 2025 01:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755481779;
	bh=Tb1Pc78HXP5m4e0WpGQNZOgeJgdvHy77XY5oC12Ov2s=;
	h=Date:To:From:Subject:From;
	b=i3PrBJ75BpGXcF8AVSO/M4+2q6V83gykq6krE+1/VpAIWXP7pObLyiYykGaJkX/lZ
	 IB58jwo6MmjG9RW8znUq7zoLu24C8WLO5B0QsfD7n971V/NmN8pBgCEBJGAJtp1rNY
	 dqII9Zq4hzKY1/e+5vUhT60FY7zLSpb9VXlK8JXs=
Date: Sun, 17 Aug 2025 18:49:38 -0700
To: mm-commits@vger.kernel.org,v-songbaohua@oppo.com,surenb@google.com,peterx@redhat.com,kaleshsingh@google.com,david@redhat.com,baohua@kernel.org,lokeshgidra@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-opportunistic-tlb-flush-batching-for-present-pages-in-move-v6.patch added to mm-unstable branch
Message-Id: <20250818014939.96094C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: userfaultfd-opportunistic-tlb-flush-batching-for-present-pages-in-move-v6
has been added to the -mm mm-unstable branch.  Its filename is
     userfaultfd-opportunistic-tlb-flush-batching-for-present-pages-in-move-v6.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-opportunistic-tlb-flush-batching-for-present-pages-in-move-v6.patch

This patch will later appear in the mm-unstable branch at
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
userfaultfd-opportunistic-tlb-flush-batching-for-present-pages-in-move-v6.patch


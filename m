Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F9818E11
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708643822; cv=none; b=Pcn/cy8jFvj59STT5RTK/s3IGymThoWzDYkQ4WN07QGuFYGetQQY8YiEDqKnhthftAHkzsiAVyaSAmsjvjcMXHJFujdsPKEBqE6fY2mxgu/8tp3OSr9Wq9kwa8+qfJaiOZc5EnLbhozhh6DXZ1nEMvOcj1iAenZJgCb2UwIsYhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708643822; c=relaxed/simple;
	bh=vTVb4RvixclrJjfVJvkrfKTgdJSqbsr05DKwQh9I0Pw=;
	h=Date:To:From:Subject:Message-Id; b=W8Ru0tnFI3PKn5J+a7aH/HmIm99Fgd2aui+q3JOT3SZtyFEiTLobQIFcrk512iJOFVs8pqYZ8yJ2pvo15dtiCaJNS1BCbeitkAN5nWor3c5FnicVHGGBMn5JB03JlLwLSYeYW+hZOA+rdPFs76VJuxe63voyKxBjenl6TI7i/q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=klKs0AN6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="klKs0AN6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4197DC433C7;
	Thu, 22 Feb 2024 23:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708643821;
	bh=vTVb4RvixclrJjfVJvkrfKTgdJSqbsr05DKwQh9I0Pw=;
	h=Date:To:From:Subject:From;
	b=klKs0AN6OVVlKWxcND7xyVyL/PN5QZiGNfF9ZxTclrLxCwM6gdWSDzotzpHkCqUTS
	 C20hBgvkwLcwD05Fa9wcXVUPkUNo4K2nwa1fEgXVIjW1zDoDaJsLth9QRWSpCHoaK/
	 fDPto+1p8woS9bDAWAK4XFvF9F8YqPcPj/0p/w9U=
Date: Thu, 22 Feb 2024 15:17:00 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,david@redhat.com,arnd@arndb.de,arnd@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-mmu_gather-add-tlb_remove_tlb_entries-fix.patch removed from -mm tree
Message-Id: <20240222231701.4197DC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mmu_gather: change __tlb_remove_tlb_entry() to an inline function
has been removed from the -mm tree.  Its filename was
     mm-mmu_gather-add-tlb_remove_tlb_entries-fix.patch

This patch was dropped because it was folded into mm-mmu_gather-add-tlb_remove_tlb_entries.patch

------------------------------------------------------
From: Arnd Bergmann <arnd@kernel.org>
Subject: mm/mmu_gather: change __tlb_remove_tlb_entry() to an inline function
Date: Wed, 21 Feb 2024 16:45:21 +0100

From: Arnd Bergmann <arnd@arndb.de>

clang complains about tlb_remove_tlb_entries() not using the 'ptep' variable
when __tlb_remove_tlb_entry() is an empty macro:

include/asm-generic/tlb.h:627:10: error: parameter 'ptep' set but not used [-Werror,-Wunused-but-set-parameter]

Change it to an equivalent inline function that avoids the warning since
the compiler can see how the variable gets passed into it.

Link: https://lkml.kernel.org/r/20240221154549.2026073-1-arnd@kernel.org
Fixes: 66958b447695 ("mm/mmu_gather: add tlb_remove_tlb_entries()")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/tlb.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/include/asm-generic/tlb.h~mm-mmu_gather-add-tlb_remove_tlb_entries-fix
+++ a/include/asm-generic/tlb.h
@@ -592,7 +592,9 @@ static inline void tlb_flush_p4d_range(s
 }
 
 #ifndef __tlb_remove_tlb_entry
-#define __tlb_remove_tlb_entry(tlb, ptep, address) do { } while (0)
+static inline void __tlb_remove_tlb_entry(struct mmu_gather *tlb, pte_t *ptep, unsigned long address)
+{
+}
 #endif
 
 /**
_

Patches currently in -mm which might be from arnd@kernel.org are

mm-mmu_gather-add-tlb_remove_tlb_entries.patch


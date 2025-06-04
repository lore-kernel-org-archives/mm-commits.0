Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815599444
	for <mm-commits@vger.kernel.org>; Wed,  4 Jun 2025 01:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749000630; cv=none; b=BVah4+cbXyUVfFR+zLZ6FFN3Ar+JbDrGdp338PYTvZJ2ZMGcXoLCSakeaovh17RzLOvSQiQhkDGZOrR6Kx+AZ0wFlB1Ad20U+2ZtosHfcSj/VGCmyy3qRMt0pfwuJ8AZ6iI65DTv4v05eVzpi4H42pqPzByjC0A4Eb8lcBaiFk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749000630; c=relaxed/simple;
	bh=4a3cGS9kg1O9SKRYeQBqAErPpnytXEflTRZjX1Ie0T0=;
	h=Date:To:From:Subject:Message-Id; b=rkrl5EohzSoZM2sLPfHOrOzHVP6d8uqNSRIu5oy+31Sh0TneRv9kMjz8ob9iue1sXC+2336lqHeYzYW/ZHIT4IAFj9UqsEx0//qMAcFmKQDxWT3AuZ7U2TZinLnpTV6qfFnSorEAXl2pFoe+dDfJWzvJ38SjqtG2fJ3ahYAIk4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IxP6l9w5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IxP6l9w5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4B55C4CEED;
	Wed,  4 Jun 2025 01:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749000630;
	bh=4a3cGS9kg1O9SKRYeQBqAErPpnytXEflTRZjX1Ie0T0=;
	h=Date:To:From:Subject:From;
	b=IxP6l9w5uEjGqNkAviiK+92KoQ1JTlEnqt3WzCrs4vNKQdZE53MLI9mXL1gjyaEps
	 MQJdKJlm32lvDZsbHksitdfSDfKhQhjPiONDr5SRSq8VDtFiB14AEK/Rb+CBGiDeQL
	 tirJiwD/5gAgHunf4ES+ZgEng4HFvTiTqDTn9nLc=
Date: Tue, 03 Jun 2025 18:30:29 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,peterz@infradead.org,npiggin@gmail.com,david@redhat.com,aneesh.kumar@kernel.org,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-tlb-trace-events-to-mmu-gather-and-tlb-invalidation.patch added to mm-hotfixes-unstable branch
Message-Id: <20250604013029.E4B55C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add tlb trace events to MMU GATHER AND TLB INVALIDATION
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-tlb-trace-events-to-mmu-gather-and-tlb-invalidation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-tlb-trace-events-to-mmu-gather-and-tlb-invalidation.patch

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
From: Tal Zussman <tz2294@columbia.edu>
Subject: MAINTAINERS: add tlb trace events to MMU GATHER AND TLB INVALIDATION
Date: Tue, 03 Jun 2025 18:50:17 -0400

The MMU GATHER AND TLB INVALIDATION entry lists other TLB-related files. 
Add the tlb.h tracepoint file there as well.

Link: https://lore.kernel.org/linux-mm/ce048e11-f79d-44a6-bacc-46e1ebc34b24@redhat.com/
Link: https://lkml.kernel.org/r/20250603-tlb-maintainers-v1-1-726d193c6693@columbia.edu
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-tlb-trace-events-to-mmu-gather-and-tlb-invalidation
+++ a/MAINTAINERS
@@ -16654,6 +16654,7 @@ L:	linux-mm@kvack.org
 S:	Maintained
 F:	arch/*/include/asm/tlb.h
 F:	include/asm-generic/tlb.h
+F:	include/trace/events/tlb.h
 F:	mm/mmu_gather.c
 
 MN88472 MEDIA DRIVER
_

Patches currently in -mm which might be from tz2294@columbia.edu are

maintainers-add-tlb-trace-events-to-mmu-gather-and-tlb-invalidation.patch


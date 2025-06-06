Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1981FAA
	for <mm-commits@vger.kernel.org>; Fri,  6 Jun 2025 05:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749186182; cv=none; b=Csx8/UhZjfpZ3+y7X68hTOQKTgt9G30DRBAxudKPG8fWXffdipa96DWL1N/sM+2Xqxz2gIDJJVs2sUMvMPp3pfu/UHwDGoD+C4iHL1h2Zl0J7GtcN1MvUTdU/0H3VS46K5tmJD700J8UCCNPT2D23vJu/nqMnev/Xal8w0M3n+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749186182; c=relaxed/simple;
	bh=izTQkq3PDyxKOtP+AtfaTB02jmGP6eCDRsfQO3hCFgc=;
	h=Date:To:From:Subject:Message-Id; b=OsvAkK/ovQlN/8zmMUmdf5Z3+JQDl3hJ0EQiUxWfgh7rA+AtIivClJZbmNfPJW7VT36viHjJPHyOelKp+q8J0nyN5OTLsuly8lNXjJSsr3UzKq/XtlmYvFzJtsJk3HqeZ1bCUGsCuV4q+IacFMEpU/Pyfs+Mt7k8FdRIZOgEn2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LgnD3xNX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LgnD3xNX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4498C4CEEB;
	Fri,  6 Jun 2025 05:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749186182;
	bh=izTQkq3PDyxKOtP+AtfaTB02jmGP6eCDRsfQO3hCFgc=;
	h=Date:To:From:Subject:From;
	b=LgnD3xNXLnuibTcDe9wAXpmja2lwoCtaGeQklW6rtFgme2XCimu/gI6vkFL97CjZn
	 2cJ35vTZagcW7K7LGlwtI3mNgXwgM42Vl30iGlbIyLoXPEs6j6I81bvuZWhDSqn6fJ
	 N9rzRzZmYmj3UqRAla52zjZmgbrmpmEtXQ7nQw6g=
Date: Thu, 05 Jun 2025 22:03:01 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,peterz@infradead.org,npiggin@gmail.com,david@redhat.com,aneesh.kumar@kernel.org,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-add-tlb-trace-events-to-mmu-gather-and-tlb-invalidation.patch removed from -mm tree
Message-Id: <20250606050301.E4498C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add tlb trace events to MMU GATHER AND TLB INVALIDATION
has been removed from the -mm tree.  Its filename was
     maintainers-add-tlb-trace-events-to-mmu-gather-and-tlb-invalidation.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: David Hildenbrand <david@redhat.com>
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



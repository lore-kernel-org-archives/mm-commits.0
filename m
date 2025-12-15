Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B3A322B62
	for <mm-commits@vger.kernel.org>; Mon, 15 Dec 2025 17:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765821001; cv=none; b=MV4TZ0bDW5Y5QdqSkkHQF4mInOJq1AO2666J70UXkeO20HSBDFs+dkTo+bUfyBj/P8KRmz3RIbapo7wQK9f5mZ7H3o9UDf5EAdOTkE2b7rzonoFtyLvaHdysPBl2anBTgfd6DACXJB9aGjwFlA6waUttbsH5D+AR+2p5eb93WTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765821001; c=relaxed/simple;
	bh=RZqmq3HWjzVR29tRy7PLcz1Lqd13rAMQA9AXZRCh2U4=;
	h=Date:To:From:Subject:Message-Id; b=SKQpS8AqMVbESRRZXHkkYZt942+oOR1Cy31bMfmdnyKoH0JnWWumGX/e4xSN+qCBVT9Y03fuKd6L68NQ5L2qqPFQnYsPQIhTB47hQKOdUBplf/WowE7CShNmLbK5E/2mPIGTPc7RWkZkEC3fu0Yu53oKKX7GQu/+ItQX9v4Ac/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l35tGbt+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l35tGbt+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD6C0C116B1;
	Mon, 15 Dec 2025 17:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765821001;
	bh=RZqmq3HWjzVR29tRy7PLcz1Lqd13rAMQA9AXZRCh2U4=;
	h=Date:To:From:Subject:From;
	b=l35tGbt+AN2UIZcz5cj23PGAjU4Pk3fwsgPH9CpT/jx/6cqHxB7vNuAdmiCavdaJ0
	 OWOVyeYnI/FAj0dxgd+UGJAi/SOHv2P+lyjuCCQYWFviltF7on5pTmPG6UtyDAqb5c
	 QWhrrhiXxZNDfJUX2G0937RklpF8eJQBf8+W0kUU=
Date: Mon, 15 Dec 2025 09:50:00 -0800
To: mm-commits@vger.kernel.org,urezki@gmail.com,anshuman.khandual@arm.com,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-clarify-why-vmap_range_noflush-might-sleep.patch added to mm-unstable branch
Message-Id: <20251215175000.DD6C0C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: clarify why vmap_range_noflush() might sleep
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-clarify-why-vmap_range_noflush-might-sleep.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-clarify-why-vmap_range_noflush-might-sleep.patch

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
From: Brendan Jackman <jackmanb@google.com>
Subject: mm/vmalloc: clarify why vmap_range_noflush() might sleep
Date: Mon, 15 Dec 2025 10:40:25 +0000

The only reason vmap_range_noflush() can sleep is because of pagetable
allocations.

The actual allocation mechanism is arch-specific so might_alloc() doesn't
work here (what GFP flags would be used?).  Hence, just add a comment.

Also note that this might do a TLB shootdown.  This is not actually
sleeping but it requires IRQs on for x86, and might_sleep() incidentally
serves to detect violations of that too.

Link: https://lkml.kernel.org/r/20251215-b4-vmalloc-might_alloc-v3-1-92dd8e406868@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/vmalloc.c~mm-vmalloc-clarify-why-vmap_range_noflush-might-sleep
+++ a/mm/vmalloc.c
@@ -305,6 +305,11 @@ static int vmap_range_noflush(unsigned l
 	int err;
 	pgtbl_mod_mask mask = 0;
 
+	/*
+	 * Might allocate pagetables (for most archs a more precise annotation
+	 * would be might_alloc(GFP_PGTABLE_KERNEL)). Also might shootdown TLB
+	 * (requires IRQs enabled on x86).
+	 */
 	might_sleep();
 	BUG_ON(addr >= end);
 
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-vmalloc-clarify-why-vmap_range_noflush-might-sleep.patch


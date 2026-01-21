Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA83730F92E
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768965989; cv=none; b=GuENTrEkCmvObuAL6Qn1Oxl6MA7doNYD2OEHqgiZ8QM5M33WnW3mdb7xmXv/s8bgE6jJpiskUTBZ5BukHoDYHMBbn74mwSziyXpuUb42LFCqgXMd41/JZ4EMKoWSpmyuPd0i/sNTDKJcOv7SNykrVCrF43s+WQYyUi/mybBP4kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768965989; c=relaxed/simple;
	bh=D1uEKVnhqfta7ppRCXGW/AzaxQ7hM+wRx0u1uWW2T5s=;
	h=Date:To:From:Subject:Message-Id; b=MdncS3l+tqnJc9q1d/lAl4IcaKim7pMR9kioHZwYiEwYnv/84XZirW6icNLZC3z/acCtv9SmLikfaMknQ6oeNkvknK+s122xPJztgHFUmrlwTfgYKbtWF0Mra8kXfrcrbBwTsq2aJJo/jP5Tul9FouclO+yLv4pCgNMB/J8Ddpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dUBJYGr6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dUBJYGr6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EBA5C16AAE;
	Wed, 21 Jan 2026 03:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768965989;
	bh=D1uEKVnhqfta7ppRCXGW/AzaxQ7hM+wRx0u1uWW2T5s=;
	h=Date:To:From:Subject:From;
	b=dUBJYGr6Cl96BNVZO1DN3N+S6KWy++KXZ+jImnrz+U66dmtnXKLCX5HzzOB+KlE8+
	 Ny2usJeloTa5Q25jmoVV1jKeyPtmKi1aMBvaPuVliF3hEtmjg6gLIm8kyJcKo9PfBW
	 Zqg+Vm2QlyHLTecM7YbR6+6XJJLf7r0SSX34dcd4=
Date: Tue, 20 Jan 2026 19:26:28 -0800
To: mm-commits@vger.kernel.org,urezki@gmail.com,anshuman.khandual@arm.com,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-clarify-why-vmap_range_noflush-might-sleep.patch removed from -mm tree
Message-Id: <20260121032629.3EBA5C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc: clarify why vmap_range_noflush() might sleep
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-clarify-why-vmap_range_noflush-might-sleep.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
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



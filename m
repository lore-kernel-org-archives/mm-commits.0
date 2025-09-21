Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0722C29D292
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489898; cv=none; b=uUsD/pE0OR68bTvMeiWLe2Cksk8SHPPYpapkoFqMu3J68L58+BYQz2FVhlZxug7S3A4q1ds49CPxg7qPC3shgSRysDTCjU1MIkzVkYxaGsuZ2tOZ0C5yycbDpgQRkOb9BnfE5IfmuL5+s+vXxz0Nw3ZRbM+64e3idawRXzj5Ew8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489898; c=relaxed/simple;
	bh=2D37IewZqbazPL4HMLO3iP2iRaOtbZgZxyLGc30Ibew=;
	h=Date:To:From:Subject:Message-Id; b=CE7W2kWg2useubXEbbunt6BOO7ByCsp4OrWpt/70YY1LL4EM+0lOQMfKojNMhsh7mfxXq36rM8+OisVDbOLZr1MI+jA/UeczwkUWhHKvvgVu6tN7LqGdSe8gLjzKhL5KE8QBgtnqyF8cXyW5XmfNBEHAAkdY9RVOVkmnWj1VLMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wxxwtlek; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wxxwtlek"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D01DDC4CEE7;
	Sun, 21 Sep 2025 21:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489897;
	bh=2D37IewZqbazPL4HMLO3iP2iRaOtbZgZxyLGc30Ibew=;
	h=Date:To:From:Subject:From;
	b=wxxwtleknJ/LS+kiKQGU7ekxGM3S/LhjV4TG4jNcPYDFA8GUTfhmmQ86+DjZV2JiW
	 gl7qLNQ43zbx9L0IOjeBzeTgSKWAFF6YjyhqqyMYC1XJOrgpHAPj8raRcyQEwmew6f
	 EP1meyLmm27WsIqLTiCaexODRhoSOlDDy2A9lGYE=
Date: Sun, 21 Sep 2025 14:24:57 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,sj@kernel.org,rppt@kernel.org,ritesh.list@gmail.com,peterz@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mst@redhat.com,mpe@ellerman.id.au,maddy@linux.ibm.com,luto@kernel.org,justin@coraid.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,axboe@kernel.dk,aou@eecs.berkeley.edu,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] aoe-stop-calling-page_address-in-free_page.patch removed from -mm tree
Message-Id: <20250921212457.D01DDC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: aoe: stop calling page_address() in free_page()
has been removed from the -mm tree.  Its filename was
     aoe-stop-calling-page_address-in-free_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: aoe: stop calling page_address() in free_page()
Date: Wed, 3 Sep 2025 11:59:16 -0700

free_page() should be used when we only have a virtual address.  We should
call __free_page() directly on our page instead.

Link: https://lkml.kernel.org/r/20250903185921.1785167-3-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Justin Sanders <justin@coraid.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoecmd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/aoe/aoecmd.c~aoe-stop-calling-page_address-in-free_page
+++ a/drivers/block/aoe/aoecmd.c
@@ -1761,6 +1761,6 @@ aoecmd_exit(void)
 	kfree(kts);
 	kfree(ktiowq);
 
-	free_page((unsigned long) page_address(empty_page));
+	__free_page(empty_page);
 	empty_page = NULL;
 }
_

Patches currently in -mm which might be from vishal.moola@gmail.com are



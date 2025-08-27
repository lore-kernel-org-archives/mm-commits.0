Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C4F4086A
	for <mm-commits@vger.kernel.org>; Wed, 27 Aug 2025 02:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756260014; cv=none; b=oNvQv+5SN03kaPdYMf8HozXdnoYEQrk/8U+sSnOpeMaZfA8pL0ZMXpKipE8kokkWbOYXRhiPQu/lnNjyNvxsCNgVB6pkgaqxAYaBC0x3hT7u4rS/tXyTDrUn6jM1wMnOp/7IiU+amQ+mQtDTLvBwm0cNH8biIjMdN+XWfoi6g6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756260014; c=relaxed/simple;
	bh=Kn/KaL2Gnw27uWj924qNaE9ylC7Gx6FnClBuMl8zZsE=;
	h=Date:To:From:Subject:Message-Id; b=hvpGbbAt93+gM7CkyMxT3Eg+Ll+bt8T8ZWuRDCTTdRe3je8LVZcX3nb9KYq814wdU14q50MAArumoRgMiGLmlrRxVXpqlbaieSIBwEl0UJ4sTd2N3cpUKDOwqp3B2GELp8cJpiHgiZ+uP/eKZ5rGUDx1aHBfsgSv/TXSuPd8xoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z201gyue; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z201gyue"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A59A2C4CEF1;
	Wed, 27 Aug 2025 02:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756260013;
	bh=Kn/KaL2Gnw27uWj924qNaE9ylC7Gx6FnClBuMl8zZsE=;
	h=Date:To:From:Subject:From;
	b=Z201gyue1T6KLnb4M05puplg0LFyCH/MRll/sEpNI6QyXaQ7WF3RVmyo2tTAwZI4d
	 RVmrwpQyeofgAy9c7CMGa43QBZTNidRyOhf6sasNa58Vg6Yn1731lhSMvZ/nrrOyvB
	 KrRYv6kfFsQYiVa2klG6evKlWQoM2l+hVVW4Yv7o=
Date: Tue, 26 Aug 2025 19:00:13 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,peterz@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mst@redhat.com,mpe@ellerman.id.au,maddy@linux.ibm.com,luto@kernel.org,justin@coraid.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,axboe@kernel.dk,aou@eecs.berkeley.edu,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + aoe-stop-calling-page_address-in-free_page.patch added to mm-new branch
Message-Id: <20250827020013.A59A2C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: aoe: stop calling page_address() in free_page()
has been added to the -mm mm-new branch.  Its filename is
     aoe-stop-calling-page_address-in-free_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/aoe-stop-calling-page_address-in-free_page.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: aoe: stop calling page_address() in free_page()
Date: Tue, 26 Aug 2025 13:56:12 -0700

free_page() should be used when we only have a virtual address.  We should
call __free_page() directly on our page instead.

Link: https://lkml.kernel.org/r/20250826205617.1032945-3-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Justin Sanders <justin@coraid.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Zijlstra <peterz@infradead.org>
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

mm-tag-kernel-stack-pages.patch
mm-page_alloc-add-kernel-docs-for-free_pages.patch
aoe-stop-calling-page_address-in-free_page.patch
x86-stop-calling-page_address-in-free_pages.patch
riscv-stop-calling-page_address-in-free_pages.patch
powerpc-stop-calling-page_address-in-free_pages.patch
arm64-stop-calling-page_address-in-free_pages.patch
virtio_balloon-stop-calling-page_address-in-free_pages.patch


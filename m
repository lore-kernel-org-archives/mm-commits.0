Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A7C2E8DF0
	for <mm-commits@vger.kernel.org>; Wed,  3 Sep 2025 20:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756932691; cv=none; b=AhpBLdYJrpGjf//OursjDEXArRXy/rxhzac43xqD5AzKKy8NDfO5Uw2lMoBZJ1+bfgPX0ZCIXj2/Jyq8t4nBvdwZVrOMfBA6CWGdR/BUE2PQVc+ILrhZV95Fo4nP4ew7yrd+qK0+CVlZv/rIGSyi6BSJ7Qjy+0LfV+HgLn81Qco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756932691; c=relaxed/simple;
	bh=pQkMoKvGGUk6P7z0tXy6kc7wm4XMk9ST67WE4gtXxOg=;
	h=Date:To:From:Subject:Message-Id; b=YUeslOraPMccMMxohOO8D3umoaeQ+smhiSChN8ufxuHo1uuRzPVZEHlgCOqsOlBLyx3edQy8TFtFIMDWI9XxtkmoMQS5JqkuUxpWYhy7wLImLIBS1fMp5pUohbnxfWGqpZYUUgC8UALczUZmCKkoE/RTbdukrI+FqsdlclHVwUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZL1ul2Zn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZL1ul2Zn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA297C4CEF5;
	Wed,  3 Sep 2025 20:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756932690;
	bh=pQkMoKvGGUk6P7z0tXy6kc7wm4XMk9ST67WE4gtXxOg=;
	h=Date:To:From:Subject:From;
	b=ZL1ul2Zn4SJqCo8j/jASKQ424mXT6f2xmyHuJiuLDmej7WxblzNdHYcIdY1w2BYEH
	 G4Mn5Q+jyE/s//TUNqzT4+6Zh/uLA5oCJhRR2x79SpGGl8sh1+uxPiRPlW0fguA/WY
	 zMcvq7jARw1KuWIqV15BxPjloigELEUa9mPsH+QU=
Date: Wed, 03 Sep 2025 13:51:30 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,sj@kernel.org,ritesh.list@gmail.com,peterz@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mst@redhat.com,mpe@ellerman.id.au,maddy@linux.ibm.com,luto@kernel.org,justin@coraid.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,axboe@kernel.dk,aou@eecs.berkeley.edu,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + aoe-stop-calling-page_address-in-free_page.patch added to mm-new branch
Message-Id: <20250903205130.CA297C4CEF5@smtp.kernel.org>
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
Date: Wed, 3 Sep 2025 11:59:16 -0700

free_page() should be used when we only have a virtual address.  We should
call __free_page() directly on our page instead.

Link: https://lkml.kernel.org/r/20250903185921.1785167-3-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: David Hildenbrand <david@redhat.com>
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

mm-tag-kernel-stack-pages.patch
mm-page_alloc-add-kernel-docs-for-free_pages.patch
aoe-stop-calling-page_address-in-free_page.patch
x86-stop-calling-page_address-in-free_pages.patch
riscv-stop-calling-page_address-in-free_pages.patch
powerpc-stop-calling-page_address-in-free_pages.patch
arm64-stop-calling-page_address-in-free_pages.patch
virtio_balloon-stop-calling-page_address-in-free_pages.patch


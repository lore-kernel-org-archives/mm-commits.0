Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C30A7D3FA
	for <mm-commits@vger.kernel.org>; Tue, 11 Jun 2024 18:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718130810; cv=none; b=GRZKFZRXj/JPBwXct7mf+2DqDbvnojyOWXCKmf+aC5yIJKUKu27F/G+Amqbuda69GL4dyeWLJMyawBmKRH1HtruBlFdlmlG3jJTDfH+jcgaYJxQWCjdTfuBjN1jlu2xUiK57wCucB5vhiXo6+Efvy5SVhjBJvTdCfafCeRbIAtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718130810; c=relaxed/simple;
	bh=L6ZhRXjhp7SywwBqeBSN+ItAImkq3mNX4d6PVterT5Y=;
	h=Date:To:From:Subject:Message-Id; b=MSIIg0g/jBNC0dz6Ng7xd3WhOkjZaURrBCMhgLV5mrOH+HJ1MRAiOA8qpDThHOH5Ms39tvoxnfThQCfFkItNIjN0lXMGmzCi//rO6VeR2tzKhkgnUTZKgPgLhS8hg//i+UXL4nzuTTEiOUcu5TzuF3gK7+cKqOHNBfhOSU4VYf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XG/tWocl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XG/tWocl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABE13C2BD10;
	Tue, 11 Jun 2024 18:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718130809;
	bh=L6ZhRXjhp7SywwBqeBSN+ItAImkq3mNX4d6PVterT5Y=;
	h=Date:To:From:Subject:From;
	b=XG/tWoclZZR/mRQmGd+IA+cOArzOCMmd7VOJTklrHuyUVaJUT0oBof++47dfUAaC6
	 BXc6AtiXZiOH/HdutsgmxO90ZAMG7uuHSwk6RlzcrJjcK14FnKXPQSHHUfQIugaSN6
	 8DK6vhMEmC0xfGHucS2LfaK8CtBYZw0s7/tQrqRo=
Date: Tue, 11 Jun 2024 11:33:29 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,david@redhat.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_initc-print-mem_init-info-after-defer_init-is-done.patch added to mm-unstable branch
Message-Id: <20240611183329.ABE13C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mm_init.c: print mem_init info after defer_init is done
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mm_initc-print-mem_init-info-after-defer_init-is-done.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_initc-print-mem_init-info-after-defer_init-is-done.patch

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
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/mm_init.c: print mem_init info after defer_init is done
Date: Tue, 11 Jun 2024 14:52:23 +0000

Current call flow looks like this:

start_kernel
  mm_core_init
    mem_init
    mem_init_print_info
  rest_init
    kernel_init
      kernel_init_freeable
        page_alloc_init_late
          deferred_init_memmap

If CONFIG_DEFERRED_STRUCT_PAGE_INIT, the time mem_init_print_info()
calls, pages are not totally initialized and freed to buddy.

This has one issue

  * nr_free_pages() just contains partial free pages in the system,
    which is not we expect.

Let's print the mem info after defer_init is done.

Also this would help changing totalram_pages accounting, since we plan
to move the accounting into __free_pages_core().

Link: https://lkml.kernel.org/r/20240611145223.16872-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/mm_init.c~mm-mm_initc-print-mem_init-info-after-defer_init-is-done
+++ a/mm/mm_init.c
@@ -2327,6 +2327,7 @@ void set_zone_contiguous(struct zone *zo
 	zone->contiguous = true;
 }
 
+static void __init mem_init_print_info(void);
 void __init page_alloc_init_late(void)
 {
 	struct zone *zone;
@@ -2353,6 +2354,8 @@ void __init page_alloc_init_late(void)
 	files_maxfiles_init();
 #endif
 
+	/* Accounting of total+free memory is stable at this point. */
+	mem_init_print_info();
 	buffer_init();
 
 	/* Discard memblock private memory */
@@ -2713,7 +2716,6 @@ void __init mm_core_init(void)
 	kmsan_init_shadow();
 	stack_depot_early_init();
 	mem_init();
-	mem_init_print_info();
 	kmem_cache_init();
 	/*
 	 * page_owner must be initialized after buddy is ready, and also after
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-mm_initc-print-mem_init-info-after-defer_init-is-done.patch


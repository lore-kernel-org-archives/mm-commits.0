Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A3EA1FAA
	for <mm-commits@vger.kernel.org>; Wed,  3 Jul 2024 01:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719971599; cv=none; b=Bwxi48NSpHRJsCOHbHx0UTamhG6/qxlkKRFekGWoUXg+Hc+00JcG8yd00nLPReqJ/CEP+kLbkT0YoGgh+L0593fri7VJWCqlom37NH582iAWlsC+O0Llc37e2cUiwKVx7tSzgpb5ieaEfOqgdu3qfEAebf2H7aezQv0GggqyeRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719971599; c=relaxed/simple;
	bh=m0lD6/Y6awgEY256okg6K/UCAPGuIhEs2Pk9xGLBEDI=;
	h=Date:To:From:Subject:Message-Id; b=QVsTq1OSB0J9D+YvgGRiDaSMK0MHhxE34uwZxwdk4NaaA9ePnA2kfRxBSTaBcHnIh0Sa5mLFk2WtJcisx+APxiLbTmzBTEDy7hTt9nE5gP/9Pj3AHfTwGOdSPRPv4zsHQiS9GZm+99OQQPTMyT7ha1dwIDM8jlEffqvGi0IIwLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h+8EU2XP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h+8EU2XP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2A99C116B1;
	Wed,  3 Jul 2024 01:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719971598;
	bh=m0lD6/Y6awgEY256okg6K/UCAPGuIhEs2Pk9xGLBEDI=;
	h=Date:To:From:Subject:From;
	b=h+8EU2XPM8n5s2FyWCDxLYVuX+E9xF+hv8EIRmGJ1TDtkAhciRqPyqaFHrLAeZgwL
	 07dNQLtBDUSeKO9m+S5O7XOpFp0QppdLbsarhdeWachFYrZoJfyXN44cnq96rZcV1v
	 FZX/s/A26dfVermE+RrDJxI3wSQfY4FV0hqq0afk=
Date: Tue, 02 Jul 2024 18:53:18 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,nicolas@fjasle.eu,nathan@kernel.org,masahiroy@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-put-__free_pages_core-in-__meminit-section.patch added to mm-unstable branch
Message-Id: <20240703015318.A2A99C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: put __free_pages_core() in __meminit section
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-put-__free_pages_core-in-__meminit-section.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-put-__free_pages_core-in-__meminit-section.patch

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
Subject: mm/page_alloc: put __free_pages_core() in __meminit section
Date: Tue, 2 Jul 2024 23:40:08 +0000

Function __free_pages_core() is only used in bootmem init and hot-add
memory init path. Let's put it in __meminit section.

Link: https://lkml.kernel.org/r/20240702234008.19101-3-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nicolas Schier <nicolas@fjasle.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-put-__free_pages_core-in-__meminit-section
+++ a/mm/page_alloc.c
@@ -1219,7 +1219,7 @@ static void __free_pages_ok(struct page
 	__count_vm_events(PGFREE, 1 << order);
 }
 
-void __free_pages_core(struct page *page, unsigned int order,
+void __meminit __free_pages_core(struct page *page, unsigned int order,
 		enum meminit_context context)
 {
 	unsigned int nr_pages = 1 << order;
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

kernel-forkc-get-totalram_pages-from-memblock-to-calculate-max_threads.patch
kernel-forkc-put-set_max_threads-task_struct_whitelist-in-__init-section.patch
mm-page_alloc-remove-prefetchw-on-freeing-page-to-buddy-system.patch
mm-use-zonelist_zone-to-get-zone.patch
modpost-meminit-is-not-in-init-section-when-config_memory_hotplug-set.patch
mm-page_alloc-put-__free_pages_core-in-__meminit-section.patch


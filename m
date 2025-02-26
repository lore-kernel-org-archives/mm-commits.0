Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C53256D
	for <mm-commits@vger.kernel.org>; Wed, 26 Feb 2025 02:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740536351; cv=none; b=Q03I7GXW1bQY8VNuC/XhAJdKfjmnL9YktAdwiGl8QZdfUJmBOFwd/87k1k/33p+YqR+cBfvC6Q1jR8/lkIm8NBfZ8VtW8QRFW0Bhj4hw4j5dWt7btMDKZXOYjpng/bQP6NHPpdJBBMZltQVBJtPu6g5ow3+gA20itLXDJxZ3HVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740536351; c=relaxed/simple;
	bh=dUDAdFwwzTJAFbCvd2my4gpxjSaYOZL9qRJXswXRMvU=;
	h=Date:To:From:Subject:Message-Id; b=A/b4/cS2nhD457ZZ/qmFaKQoa8xRgtsJwTrU44HkMkjWup6c5KJEFY8pnngppkrUlK6ZQEWZ0GK7CmocB40cp+nXgtfQ8btq+xqBzBLey33IzLSjFFjVUmKsCV2LOUKP4w2n51DkXAhEgGMLBxcZ8ysayiu5C2oaU2T6EzdhmE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iidzL0uB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iidzL0uB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84C05C4CEDD;
	Wed, 26 Feb 2025 02:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740536350;
	bh=dUDAdFwwzTJAFbCvd2my4gpxjSaYOZL9qRJXswXRMvU=;
	h=Date:To:From:Subject:From;
	b=iidzL0uBIW+63Y6ujP8AnQL5SqsfHZSdxHIQ2/0lRdmhzsh1gdI+IrBwFftcvwxXB
	 juvnNrvEu0MrdD7YP/Ci/nxTK3G3ioJIvYntNByjDp7Z3L3EmgRPygjYCQE7MKF8Rq
	 fgJ1HxRVb7aFPPLIkXa+lTgp6VYXhiYRyHbvRfZg=
Date: Tue, 25 Feb 2025 18:19:09 -0800
To: mm-commits@vger.kernel.org,richard.weiyang@gmail.com,muchun.song@linux.dev,fvdl@google.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_init-rename-init_reserved_page-to-init_deferred_page.patch added to mm-unstable branch
Message-Id: <20250226021910.84C05C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mm_init: rename init_reserved_page to init_deferred_page
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mm_init-rename-init_reserved_page-to-init_deferred_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_init-rename-init_reserved_page-to-init_deferred_page.patch

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
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: mm/mm_init: rename init_reserved_page to init_deferred_page
Date: Tue, 25 Feb 2025 10:30:17 +0200

When CONFIG_DEFERRED_STRUCT_PAGE_INIT is enabled, init_reserved_page()
function performs initialization of a struct page that would have been
deferred normally.

Rename it to init_deferred_page() to better reflect what the function does.

Link: https://lkml.kernel.org/r/20250225083017.567649-3-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/mm_init.c~mm-mm_init-rename-init_reserved_page-to-init_deferred_page
+++ a/mm/mm_init.c
@@ -728,7 +728,7 @@ defer_init(int nid, unsigned long pfn, u
 	return false;
 }
 
-static void __meminit init_reserved_page(unsigned long pfn, int nid)
+static void __meminit init_deferred_page(unsigned long pfn, int nid)
 {
 	if (early_page_initialised(pfn, nid))
 		return;
@@ -748,7 +748,7 @@ static inline bool defer_init(int nid, u
 	return false;
 }
 
-static inline void init_reserved_page(unsigned long pfn, int nid)
+static inline void init_deferred_page(unsigned long pfn, int nid)
 {
 }
 #endif /* CONFIG_DEFERRED_STRUCT_PAGE_INIT */
@@ -769,7 +769,7 @@ void __meminit reserve_bootmem_region(ph
 		if (pfn_valid(start_pfn)) {
 			struct page *page = pfn_to_page(start_pfn);
 
-			init_reserved_page(start_pfn, nid);
+			init_deferred_page(start_pfn, nid);
 
 			/*
 			 * no need for atomic set_bit because the struct
_

Patches currently in -mm which might be from rppt@kernel.org are

mm-mm_init-rename-__init_reserved_page_zone-to-__init_page_from_nid.patch
mm-mm_init-rename-init_reserved_page-to-init_deferred_page.patch


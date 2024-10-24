Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A15CE2FC52
	for <mm-commits@vger.kernel.org>; Thu, 24 Oct 2024 02:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729737878; cv=none; b=SoMDYILpl/SBtbk66WDqWWHiUjzttipdmOXrOTs6NPS7nJHe62gSaSVO7DsBc1z+xKop4DSaEHbzGvoLO2lxw3wawcTplbHBH/Z+JxsTHWGWRpFyJ9aMs8fytERrtYoqjKsdvlQclX22nFHcoFlIxzePCfrG6VQw+Kal8XnNMB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729737878; c=relaxed/simple;
	bh=mhv+37yHY4LA1kFbHqxPzjRZTnALyqPH9N8Gjfglk1w=;
	h=Date:To:From:Subject:Message-Id; b=nED96oF2JNopl2/NMgH88pcSuuie05wUM1kWm7WfFFdacUM4L+8QBqnkwTs5nzvci3J+FNvvUpDfm0VeWFXvwpStdPfBs/ogUbDjVAWBkH+kUOcESnbcnCjz8wW++KbS5sUcvOQJS2AXrwrTZBeNai1ujb4Wugb0vMmoC+8752A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QVnR2Ntv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QVnR2Ntv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3155AC4CEC6;
	Thu, 24 Oct 2024 02:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729737878;
	bh=mhv+37yHY4LA1kFbHqxPzjRZTnALyqPH9N8Gjfglk1w=;
	h=Date:To:From:Subject:From;
	b=QVnR2NtvSxPfBdAd5iOdxoP0ooXGcs6etK3X3uphyfGmTYvOqrfx4wCmIRn0xHyJj
	 esTFQVMbcSIKdtbmRAnIG1PAEqJADuCcw0QKdob6tXBpF1OlZOgKO2LhbpE+oTnPXB
	 KaGeIYMXhnP5KsirzBJn4fs+Hxbno88lgV9ZU460=
Date: Wed, 23 Oct 2024 19:44:37 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,willy@infradead.org,wangkefeng.wang@huawei.com,vbabka@suse.cz,ryan.roberts@arm.com,linmiaohe@huawei.com,keescook@chromium.org,jhubbard@nvidia.com,glider@google.com,david@redhat.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-avoid-zeroing-user-movable-page-twice-with-init_on_alloc=1-fix.patch added to mm-unstable branch
Message-Id: <20241024024438.3155AC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-avoid-zeroing-user-movable-page-twice-with-init_on_alloc=1-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-avoid-zeroing-user-movable-page-twice-with-init_on_alloc=1-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-avoid-zeroing-user-movable-page-twice-with-init_on_alloc=1-fix.patch

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
From: Zi Yan <ziy@nvidia.com>
Subject: mm-avoid-zeroing-user-movable-page-twice-with-init_on_alloc=1-fix
Date: Tue, 22 Oct 2024 10:33:40 -0400

comment fixes, per David

Link: https://lkml.kernel.org/r/97DB52E1-C594-49B5-9736-89AC302FAB01@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    5 +++++
 mm/memory.c      |    7 +++++++
 2 files changed, 12 insertions(+)

--- a/mm/huge_memory.c~mm-avoid-zeroing-user-movable-page-twice-with-init_on_alloc=1-fix
+++ a/mm/huge_memory.c
@@ -1165,6 +1165,11 @@ static struct folio *vma_alloc_anon_foli
 	}
 	folio_throttle_swaprate(folio, gfp);
 
+       /*
+	 * When a folio is not zeroed during allocation (__GFP_ZERO not used),
+	 * folio_zero_user() is used to make sure that the page corresponding
+	 * to the faulting address will be hot in the cache after zeroing.
+	 */
 	if (!alloc_zeroed())
 		folio_zero_user(folio, addr);
 	/*
--- a/mm/memory.c~mm-avoid-zeroing-user-movable-page-twice-with-init_on_alloc=1-fix
+++ a/mm/memory.c
@@ -4719,6 +4719,13 @@ static struct folio *alloc_anon_folio(st
 				goto next;
 			}
 			folio_throttle_swaprate(folio, gfp);
+			/*
+			 * When a folio is not zeroed during allocation
+			 * (__GFP_ZERO not used), folio_zero_user() is used
+			 * to make sure that the page corresponding to the
+			 * faulting address will be hot in the cache after
+			 * zeroing.
+			 */
 			if (!alloc_zeroed())
 				folio_zero_user(folio, vmf->address);
 			return folio;
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-avoid-vm_bug_on-when-try-to-map-an-anon-large-folio-to-zero-page.patch
mm-avoid-zeroing-user-movable-page-twice-with-init_on_alloc=1.patch
mm-avoid-zeroing-user-movable-page-twice-with-init_on_alloc=1-fix.patch


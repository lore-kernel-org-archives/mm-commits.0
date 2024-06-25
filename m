Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84B6917E45D
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 21:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719352531; cv=none; b=dM0NU84fby368c5/7TNwkj5zH6NZ4s4QP3sWDWbeSksmSnk0ohgtnfQt/1Ihzcj/sxv9FPqEx75Qi0BQT4XScx4OmebnfvE7z81L8Dw89kyAaCAeerkAWQyaqPhARj2meDXAti+EIsD1tQDnjSW6hB4nrFprFJ+hSmu3L2SeWDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719352531; c=relaxed/simple;
	bh=dIljdFO3DmkQ9uoIg9Aav3pdoYcGAI6VRD9eL9694mU=;
	h=Date:To:From:Subject:Message-Id; b=FelsYAxLvrnLW1dpsgqqMtNI6pcjN/BsyAxm8Vm208qSDTP4kDvI9OGvYfwVXGZuJca5EkYMSO1xko8CDWCxf3GvsqsuxAKUUTDEH1kAtqTRzGuOFUCMHLAQJ/CeDOge8a2qwK2fSWKd4VXyrB7YZKfGOovBIbLY5CmzRJKvQP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cFq9otdb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cFq9otdb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC3B2C32781;
	Tue, 25 Jun 2024 21:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719352531;
	bh=dIljdFO3DmkQ9uoIg9Aav3pdoYcGAI6VRD9eL9694mU=;
	h=Date:To:From:Subject:From;
	b=cFq9otdbvcWcgpcWWbklxxIiv5qCpv3mI00+1enIznMoCnO6S2if2hzK3ZXZ9XIoq
	 MBScxrQ2N+0i0VkQCx2mpTCG11WK98P8XNmFIr66UHD39WzpWE0h+w1xREJSTfAgEA
	 rdtQaUoUIlCucXPyy83ZJxeFCtK6zbNHf8WOw7qE=
Date: Tue, 25 Jun 2024 14:55:30 -0700
To: mm-commits@vger.kernel.org,ioworker0@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hack.patch added to mm-unstable branch
Message-Id: <20240625215530.EC3B2C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hack
has been added to the -mm mm-unstable branch.  Its filename is
     hack.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hack.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: hack
Date: Tue Jun 25 02:51:36 PM PDT 2024

um, Lance?

Cc: Lance Yang <ioworker0@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/huge_memory.c~hack
+++ a/mm/huge_memory.c
@@ -2696,7 +2696,6 @@ static bool __discard_anon_folio_pmd_loc
 	struct mm_struct *mm = vma->vm_mm;
 	int ref_count, map_count;
 	pmd_t orig_pmd = *pmdp;
-	struct page *page;
 
 	if (folio_test_dirty(folio) || pmd_dirty(orig_pmd))
 		return false;
@@ -2732,7 +2731,7 @@ static bool __discard_anon_folio_pmd_loc
 		return false;
 	}
 
-	folio_remove_rmap_pmd(folio, page, vma);
+	folio_remove_rmap_pmd(folio, pmd_page(orig_pmd), vma);
 	zap_deposited_table(mm, pmdp);
 	add_mm_counter(mm, MM_ANONPAGES, -HPAGE_PMD_NR);
 	if (vma->vm_flags & VM_LOCKED)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

hack.patch
mm-allow-reuse-of-the-lower-16-bit-of-the-page-type-with-an-actual-type-fix.patch
mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap-fix.patch
mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false-fix.patch
tools-mm-introduce-a-tool-to-assess-swap-entry-allocation-for-thp_swapout-fix.patch


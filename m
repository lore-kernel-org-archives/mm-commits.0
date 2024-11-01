Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA5BE57D
	for <mm-commits@vger.kernel.org>; Fri,  1 Nov 2024 01:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730423364; cv=none; b=k4naSf+Alk5YfmBFmFw+VF63Xcsc9kccyYIIKKin0xn890mo1nUAs1/9w5vUHp4PsC1eyjxOnGY+DG3WSHNNK8P1j8X34XQ0VsDupfKntibBby95dFXDvHZ8ONxmA0ivtFd5nExF/p+yhVxBWtE7Z3H26+O1U8R9J2L6JdLwpVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730423364; c=relaxed/simple;
	bh=lKAVrl3+SKaz6fX22Q7b3zjMHErDvDyJsYdH/H/W+iQ=;
	h=Date:To:From:Subject:Message-Id; b=WORUgseTG9DJCG/AHnXc/eSX1zRlspLMmTNkeHW6Z9MrVg85+NQDtoY+el73ejrA0PT8FN/MevN64pLmwl7h3tKjLQz5/uSp0q/BDXzp7Gt0O5DrCZL5RTGr5xPhfeKAXiyCQ2poa8KzxFiQJ86qcWJHFPL3Ujc+cjzYjhmrv8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lzYul1+U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lzYul1+U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A81C3C4CEC3;
	Fri,  1 Nov 2024 01:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730423363;
	bh=lKAVrl3+SKaz6fX22Q7b3zjMHErDvDyJsYdH/H/W+iQ=;
	h=Date:To:From:Subject:From;
	b=lzYul1+U2fB7+gjyvoBZ4OC66lB8YKVW33UkTlVkm9a/5mmgYtSIS9kqtUfMiep1U
	 ptM+RH+RSZuCgz6bs3ruHOtdUSh9EvK/iSyjSeV067RZ/bxeiP/JZYVqZ6AFelRUQT
	 SFA8yD3SK8pqmCvoXRZLv2e/tFKMA19VXXEfQe7M=
Date: Thu, 31 Oct 2024 18:09:23 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,weixugc@google.com,stevensd@google.com,seanjc@google.com,rientjes@google.com,pbonzini@redhat.com,oliver.upton@linux.dev,lkp@intel.com,dmatlack@google.com,axelrasmussen@google.com,jthoughton@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-multi-gen-lru-use-pteppmdp_clear_young_notify-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20241101010923.A81C3C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmscan.c:3498: undefined reference to `pmdp_test_and_clear_young'
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-multi-gen-lru-use-pteppmdp_clear_young_notify-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-multi-gen-lru-use-pteppmdp_clear_young_notify-fix.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: James Houghton <jthoughton@google.com>
Subject: mm/vmscan.c:3498: undefined reference to `pmdp_test_and_clear_young'
Date: Fri, 25 Oct 2024 19:21:06 +0000

fix link-time error

   ld: mm/vmscan.o: in function `walk_pmd_range_locked':
>> mm/vmscan.c:3498: undefined reference to `pmdp_test_and_clear_young'

Link: https://lore.kernel.org/linux-mm/20241019012940.3656292-3-jthoughton@google.com/
Link: https://lkml.kernel.org/r/20241025192106.957236-1-jthoughton@google.com
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202410252141.djLwbAYF-lkp@intel.com/
Signed-off-by: James Houghton <jthoughton@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Matlack <dmatlack@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: David Stevens <stevensd@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-multi-gen-lru-use-pteppmdp_clear_young_notify-fix
+++ a/mm/vmscan.c
@@ -3480,7 +3480,10 @@ static void walk_pmd_range_locked(pud_t
 		/* don't round down the first address */
 		addr = i ? (*first & PMD_MASK) + i * PMD_SIZE : *first;
 
-		if (pmd_present(pmd[i]) && !pmd_trans_huge(pmd[i])) {
+		if (!pmd_present(pmd[i]))
+			goto next;
+
+		if (!pmd_trans_huge(pmd[i])) {
 			if (!walk->force_scan && should_clear_pmd_young() &&
 			    !mm_has_notifiers(args->mm))
 				pmdp_test_and_clear_young(vma, addr, pmd + i);
_

Patches currently in -mm which might be from jthoughton@google.com are

mm-multi-gen-lru-use-pteppmdp_clear_young_notify-fix.patch
mm-add-missing-mmu_notifier_clear_young-for-mmu_notifier.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 298EC2356D2;
	Thu, 10 Jul 2025 22:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752186365; cv=none; b=b+xH4Y9HPZsVOBWuKp+HJASDxF3sfVVmPfPVlR8MXW2q0xV15VJzFeEsFhCv2Or1vtY6AGU725QqZ6AJlAio3lGd+K9ryIqtADTNKQj23EOTkzFEQLUe+YRvXL/lVuBn1oORqSVR1fK8zjQCkl4HeHa/yHK9aTzlDgPnSPw+2y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752186365; c=relaxed/simple;
	bh=iyJTP5SWsB2i90a19oBWqALGqsvzNyXo5DkiDW+YnSg=;
	h=Date:To:From:Subject:Message-Id; b=rKEUjIJycEBe1ke1xNScOq5PGP8S3yNtxMjHqhAbjbrMNtDW/SUsN+zz4nqjW/dd3ECH9gj58C+OU4gvCoQiYssXtH9/MhwHgptXjdME/9FA4aQ4UKJ/wCBtd52NVL810BNzPIIlTJDrQktyn0gcBO3mG3o8Cs5IWULJ1q0+wfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Nu+9wdSs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Nu+9wdSs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9891AC4CEE3;
	Thu, 10 Jul 2025 22:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752186364;
	bh=iyJTP5SWsB2i90a19oBWqALGqsvzNyXo5DkiDW+YnSg=;
	h=Date:To:From:Subject:From;
	b=Nu+9wdSsIND1wuOFvLO++qf31aOJZt/KemAgbtPKatfUrxpMizRLk5Jj5lOjNEv7Y
	 lZ0B9Vc6eiXgQWEJEqJFWjEHtugBrTfyNFeIpdLCq02aa/rXswaZ+b5yGJl6ieej26
	 i89beQjtwIc+4zV3iFHfPiK9DcU5kOOeVRUq1iGo=
Date: Thu, 10 Jul 2025 15:26:04 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,nathan@kernel.org,morbo@google.com,leonro@nvidia.com,justinstitt@google.com,jglisse@redhat.com,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hmm-move-pmd_to_hmm_pfn_flags-to-the-respective-ifdeffery.patch added to mm-new branch
Message-Id: <20250710222604.9891AC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hmm: move pmd_to_hmm_pfn_flags() to the respective #ifdeffery
has been added to the -mm mm-new branch.  Its filename is
     mm-hmm-move-pmd_to_hmm_pfn_flags-to-the-respective-ifdeffery.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hmm-move-pmd_to_hmm_pfn_flags-to-the-respective-ifdeffery.patch

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
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: mm/hmm: move pmd_to_hmm_pfn_flags() to the respective #ifdeffery
Date: Thu, 10 Jul 2025 11:23:53 +0300

When pmd_to_hmm_pfn_flags() is unused, it prevents kernel builds with
clang, `make W=1` and CONFIG_TRANSPARENT_HUGEPAGE=n:

  mm/hmm.c:186:29: warning: unused function 'pmd_to_hmm_pfn_flags' [-Wunused-function]

Fix this by moving the function to the respective existing ifdeffery
for its the only user.

See also:

  6863f5643dd7 ("kbuild: allow Clang to find unused static inline functions for W=1 build")

Link: https://lkml.kernel.org/r/20250710082403.664093-1-andriy.shevchenko@linux.intel.com
Fixes: 9d3973d60f0a ("mm/hmm: cleanup the hmm_vma_handle_pmd stub")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Cc: Andriy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Bill Wendling <morbo@google.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hmm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hmm.c~mm-hmm-move-pmd_to_hmm_pfn_flags-to-the-respective-ifdeffery
+++ a/mm/hmm.c
@@ -183,6 +183,7 @@ static inline unsigned long hmm_pfn_flag
 	return order << HMM_PFN_ORDER_SHIFT;
 }
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static inline unsigned long pmd_to_hmm_pfn_flags(struct hmm_range *range,
 						 pmd_t pmd)
 {
@@ -193,7 +194,6 @@ static inline unsigned long pmd_to_hmm_p
 	       hmm_pfn_flags_order(PMD_SHIFT - PAGE_SHIFT);
 }
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static int hmm_vma_handle_pmd(struct mm_walk *walk, unsigned long addr,
 			      unsigned long end, unsigned long hmm_pfns[],
 			      pmd_t pmd)
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

mm-hmm-move-pmd_to_hmm_pfn_flags-to-the-respective-ifdeffery.patch
panic-add-panic_sys_info-sysctl-to-take-human-readable-string-parameter-fix.patch


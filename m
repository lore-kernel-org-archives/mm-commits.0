Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 382277DA6A;
	Sun, 20 Jul 2025 02:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752976924; cv=none; b=Y+jPH62ccuR3TJMOYbYTJePH1NVuT3NgsRGSMkc4AGj37HvGXhT8EX7X3S2GqR4dHM2zDydg9XLLo4Ha9nNLELDftsz2sgLeNlNGNOfIvBjUMDEbg1WGzU6cGqr7pbbOjSfcDbYb7HNtxZMSpgw2ImeB+RpjFdNa5zgBewCdV8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752976924; c=relaxed/simple;
	bh=+TC7AhSX/YHo7W07SijnNW3U1hQo7WM26irAc/JT6xw=;
	h=Date:To:From:Subject:Message-Id; b=ZgegjfuEeRtXUbrWpqpo0iDfxPOMLV+ZL1jho/q4FJ8Zz6iTePsAAVCM2/iRt7l2VDjFItKZr7jCurXIQbzTOqmLvzdHfQqls5IFM2P4RfJYKnChblIU+fzwvj/xN78JuYj+xV3XpLIEZ+eaiXQprCNosuWy4wDk5UG3PRR1Pjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k5of67dr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k5of67dr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD216C4CEE3;
	Sun, 20 Jul 2025 02:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752976923;
	bh=+TC7AhSX/YHo7W07SijnNW3U1hQo7WM26irAc/JT6xw=;
	h=Date:To:From:Subject:From;
	b=k5of67drjYzAnKQ6+FjCV/qQGRDRP5WV+9XklsqDQCfJ6RaX/oWo/dISEUcEEl5sZ
	 bGJU9YetiuDOmo3LSvkFEL+bXuWt6SmUADxyDfl4ulI3cj8iP2bglrhlP7Uia6hcgm
	 B8MCTG5tJBBAhjZIIlRoyyj3haoxvwsprKesfAe0=
Date: Sat, 19 Jul 2025 19:02:02 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,nathan@kernel.org,morbo@google.com,leonro@nvidia.com,justinstitt@google.com,jglisse@redhat.com,apopple@nvidia.com,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hmm-move-pmd_to_hmm_pfn_flags-to-the-respective-ifdeffery.patch removed from -mm tree
Message-Id: <20250720020203.AD216C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hmm: move pmd_to_hmm_pfn_flags() to the respective #ifdeffery
has been removed from the -mm tree.  Its filename was
     mm-hmm-move-pmd_to_hmm_pfn_flags-to-the-respective-ifdeffery.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Fixes: 992de9a8b751 ("mm/hmm: allow to mirror vma of a file on a DAX backed filesystem")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
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



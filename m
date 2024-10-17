Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D471CC14B
	for <mm-commits@vger.kernel.org>; Thu, 17 Oct 2024 07:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729150128; cv=none; b=Cw8B72lM1krAx3UPYgn7NDsixI61xMzmnRmuWGSwUYCz9BoNCqX3JSg7foWf3VYoT0s85dtxEBelcikoVa+2y31qdGK98glec+yYKJNdFt0QcKmLLYecJ+st/DgDuQ32Y5UznkE2e49DrS4yxFaPZeJMPcJl4Foem4LjSxM0/YU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729150128; c=relaxed/simple;
	bh=F3volqvF5XfiV9TPtjl93WAMPYhXn+tekkHsWoH37o8=;
	h=Date:To:From:Subject:Message-Id; b=WzYY3f4hfSMLfU3qVs3YD6kz6awJeJz5Rx8nmbaqHDINQrO1LosyYxQvZXayK2HAVkCRYNujr8dg7rMOQTwhT+IAhMNfNBheVp5hbjJqXNLFpQ4R6vEuSJcSJsHaa8E+6gCsPFcZ+tEiGEbzDpkB0X1QYe83yXiFEGlI+IFVsGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uV+hxyYu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uV+hxyYu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9ABDC4CEC3;
	Thu, 17 Oct 2024 07:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729150128;
	bh=F3volqvF5XfiV9TPtjl93WAMPYhXn+tekkHsWoH37o8=;
	h=Date:To:From:Subject:From;
	b=uV+hxyYuCk3PbrWxVKDdiRJvnbkI+YMmeYDnM2qMpUYEVXTFbIV8Euyq4/AI07eA2
	 0+rQHXrNefx/M2qYxmAW6oRg3ilHj4kCWCDUBJO8+nUUl8tosTE72gBxKxlQlgR96T
	 m0bpZ0K3rX+/Vj7GENFxlCd/FObZQxkkmbMIkbEo=
Date: Thu, 17 Oct 2024 00:28:48 -0700
To: mm-commits@vger.kernel.org,ndesaulniers@google.com,nathan@kernel.org,morbo@google.com,justinstitt@google.com,hanchuanhua@oppo.com,baohua@kernel.org,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-remove-unused-stub-for-can_swapin_thp.patch removed from -mm tree
Message-Id: <20241017072848.A9ABDC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove unused stub for can_swapin_thp()
has been removed from the -mm tree.  Its filename was
     mm-remove-unused-stub-for-can_swapin_thp.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: mm: remove unused stub for can_swapin_thp()
Date: Tue, 8 Oct 2024 22:13:29 +0300

When can_swapin_thp() is unused, it prevents kernel builds with clang,
`make W=1` and CONFIG_WERROR=y:

mm/memory.c:4184:20: error: unused function 'can_swapin_thp' [-Werror,-Wunused-function]

Fix this by removing the unused stub.

See also commit 6863f5643dd7 ("kbuild: allow Clang to find unused static
inline functions for W=1 build").

Link: https://lkml.kernel.org/r/20241008191329.2332346-1-andriy.shevchenko@linux.intel.com
Fixes: 242d12c98174 ("mm: support large folios swap-in for sync io devices")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Barry Song <baohua@kernel.org>
Cc: Bill Wendling <morbo@google.com>
Cc: Chuanhua Han <hanchuanhua@oppo.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/mm/memory.c~mm-remove-unused-stub-for-can_swapin_thp
+++ a/mm/memory.c
@@ -4181,11 +4181,6 @@ fallback:
 	return __alloc_swap_folio(vmf);
 }
 #else /* !CONFIG_TRANSPARENT_HUGEPAGE */
-static inline bool can_swapin_thp(struct vm_fault *vmf, pte_t *ptep, int nr_pages)
-{
-	return false;
-}
-
 static struct folio *alloc_swap_folio(struct vm_fault *vmf)
 {
 	return __alloc_swap_folio(vmf);
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

x86-percpu-fix-clang-warning-when-dealing-with-unsigned-types.patch
percpu-add-a-test-case-for-the-specific-64-bit-value-addition.patch
resource-replace-open-coded-resource_intersection.patch
resource-introduce-is_type_match-helper-and-use-it.patch


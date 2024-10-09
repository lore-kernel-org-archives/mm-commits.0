Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E6417BB0C
	for <mm-commits@vger.kernel.org>; Wed,  9 Oct 2024 21:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728510116; cv=none; b=UIR20geT6Xw2Cy6nGX3tC4zUp0Kt/6XqQZmtZjfZAU25JuS2zZXOUnaQAVnRCjefdS4hPgsgCMD+lYU0oZ6OMDF19QwsJLEZRJe6R+dKhShRXsbqY5aB23dfq1LfkPkns56BEo/glCfY8MyQBBE3mTi5DgdKF5SgV5oAuv74nCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728510116; c=relaxed/simple;
	bh=HQ9OwxS+vjr9t0K1lo6nT6aSMrWOOLgAN9dJw7CKg0I=;
	h=Date:To:From:Subject:Message-Id; b=Vb3DrkIUdh4crMWEB0ft/H0oGDk7nJ9pyQ+lBd2taeD6cjRjyMHRI27lWdl4xVfdYKAphKUdWGQQ0pYbrsCnJCV/gw8rUqBnCSzBT8Kwsr3XMFaZSfS9wMwkPNuyS5CfQiz2Evn46WszIvWhOZOEcog+fvTuxOApjqgaFLc427M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DeyevPDG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DeyevPDG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4474AC4CECE;
	Wed,  9 Oct 2024 21:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728510116;
	bh=HQ9OwxS+vjr9t0K1lo6nT6aSMrWOOLgAN9dJw7CKg0I=;
	h=Date:To:From:Subject:From;
	b=DeyevPDG8hLhnM3ZasixEWhfw3mW70CWGPEw1BvzqNv4xL5L1td9GO1LBuvSMSh4I
	 52QMYo3HCWudgKFk2jnMkA0TlaxLPFADIlLjFBCBtqLuDYkmEcYdX6PX2RMG67R5A1
	 EHjFfiWLyqPV5q3GBFiYwjictJm7JSWzKAc6tQ0Q=
Date: Wed, 09 Oct 2024 14:41:55 -0700
To: mm-commits@vger.kernel.org,ndesaulniers@google.com,nathan@kernel.org,morbo@google.com,justinstitt@google.com,hanchuanhua@oppo.com,baohua@kernel.org,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-unused-stub-for-can_swapin_thp.patch added to mm-hotfixes-unstable branch
Message-Id: <20241009214156.4474AC4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove unused stub for can_swapin_thp()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-remove-unused-stub-for-can_swapin_thp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-unused-stub-for-can_swapin_thp.patch

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

mm-remove-unused-stub-for-can_swapin_thp.patch
resource-replace-open-coded-resource_intersection.patch
resource-introduce-is_type_match-helper-and-use-it.patch


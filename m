Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD5C345CC2
	for <mm-commits@vger.kernel.org>; Tue,  4 Nov 2025 21:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762292839; cv=none; b=lJKFBc97keaAmMGuEFYSLwavrjprBSxDaIUx+pCF2SSjeZKvpFSTH7LCvHQERJAEXiIzc0YKPbIy69h/iaUYJO3NmtQq8WriwGyVVX7ZWdSy12ndLNgg8XiLH2rlvM7CgqMWGhkcaEbWh+o7hrz1PZDFsgsTWt/PtJ5RpCgZffA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762292839; c=relaxed/simple;
	bh=mdPqXMcu1xydCGKtqJ4fKGViRHCjtLf4KYO5+6/wwjM=;
	h=Date:To:From:Subject:Message-Id; b=munJ3kEiEhDsg4jr1twkv32AQiDkpd7SkPw4SDivz6hhHie+RgndQQYx5Ru+b5IHPasS1kG8PHltCD+nerrTmPITAdwq9gaopuxnl+hiv/w4X8MmvOzoZeT3ha75wlo0MyqQkEfqzjIR5lJV8VBlZCfDz+EoJnXE1e1zHNwXVpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=w1P32hX5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="w1P32hX5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23495C4CEF7;
	Tue,  4 Nov 2025 21:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762292839;
	bh=mdPqXMcu1xydCGKtqJ4fKGViRHCjtLf4KYO5+6/wwjM=;
	h=Date:To:From:Subject:From;
	b=w1P32hX5cKpFUnBiGMSXf4U+tWpdrnYj+Q/728ZRLuxNB9UVVXNxZ7pxDV0iqiNai
	 9FJhfHOUB6p+5qpswRc0Fqpsy2Rfeth2YXWiVJF38NL3uFIheZH8G/MnqAQ5nGqgko
	 uP2zyEiQ8zGupZ8ljT1iZnXOxgddEnrvATNQDqhc=
Date: Tue, 04 Nov 2025 13:47:18 -0800
To: mm-commits@vger.kernel.org,aardelean@baylibre.com,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + util_macrosh-fix-kernel-doc-for-u64_to_user_ptr.patch added to mm-nonmm-unstable branch
Message-Id: <20251104214719.23495C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: util_macros.h: fix kernel-doc for u64_to_user_ptr()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     util_macrosh-fix-kernel-doc-for-u64_to_user_ptr.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/util_macrosh-fix-kernel-doc-for-u64_to_user_ptr.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
Subject: util_macros.h: fix kernel-doc for u64_to_user_ptr()
Date: Tue, 4 Nov 2025 19:38:34 +0100

The added documentation to u64_to_user_ptr() misspelled the function name.
Fix it.

Link: https://lkml.kernel.org/r/20251104183834.1046584-1-andriy.shevchenko@linux.intel.com
Fixes: 029c896c4105 ("kernel.h: move PTR_IF() and u64_to_user_ptr() to util_macros.h")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Alexandru Ardelean <aardelean@baylibre.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/util_macros.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/util_macros.h~util_macrosh-fix-kernel-doc-for-u64_to_user_ptr
+++ a/include/linux/util_macros.h
@@ -136,10 +136,10 @@
 #define PTR_IF(cond, ptr)	((cond) ? (ptr) : NULL)
 
 /**
- * to_user_ptr - cast a pointer passed as u64 from user space to void __user *
+ * u64_to_user_ptr - cast a pointer passed as u64 from user space to void __user *
  * @x: The u64 value from user space, usually via IOCTL
  *
- * to_user_ptr() simply casts a pointer passed as u64 from user space to void
+ * u64_to_user_ptr() simply casts a pointer passed as u64 from user space to void
  * __user * correctly. Using this lets us get rid of all the tiresome casts.
  */
 #define u64_to_user_ptr(x)		\
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

panic-sys_info-capture-si_bits_global-before-iterating-over-it.patch
panic-sys_info-align-constant-definition-names-with-parameters.patch
panic-sys_info-replace-struct-sys_info_name-with-plain-array-of-strings.patch
panic-sys_info-rewrite-a-fix-for-a-compilation-error-make-w=1.patch
panic-sys_info-deduplicate-local-variable-table-assignments.patch
panic-sys_info-factor-out-read-and-write-handlers.patch
util_macrosh-fix-kernel-doc-for-u64_to_user_ptr.patch


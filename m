Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695E653A7
	for <mm-commits@vger.kernel.org>; Fri,  7 Nov 2025 00:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762473986; cv=none; b=bM1omYivb0mHR0LCfcNJKU/JavGOiDRhuj3wCF1P/hfcQ2w5iZD9E6Vikw+7MkKYrECbmgga60E5auq55w+x2NiSt2v96d/IIMitg03MhP0jeySwaVWhDmIypbolQIm6K9wL+2khnykWs2ulTxJYuHd8YGcGf2vLlzcZhDWwXNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762473986; c=relaxed/simple;
	bh=SgHXQuIDFgt2/z/wai/vNDphNxB8l3eOXPjwjw43ofQ=;
	h=Date:To:From:Subject:Message-Id; b=j1lPh2XjSbQ/75xg4mjVQkaUsU0mvEk6kEpN2BngbsJL2WS+w4n7TNWrSx99K77FUy5j0EFd0v95Qy0CT1F0yQNTI3H/E4hmr2h3d37IQhz4T0riJwr3rLVStCL2QmLXUZNTLj/C104pwEqg5TE9+EPOXHrWfa10eIkonU1wvWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WggxTa63; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WggxTa63"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C02C16AAE;
	Fri,  7 Nov 2025 00:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762473986;
	bh=SgHXQuIDFgt2/z/wai/vNDphNxB8l3eOXPjwjw43ofQ=;
	h=Date:To:From:Subject:From;
	b=WggxTa63338HmFrTMvZL5PO8brcqBzfjsWzwP/7mEidf95yj0toiSc8LfwUesUefC
	 2iYv7aByUjlAsYYn+kYpJo/upgQ2hirgqRwhT8EbEdQzOolym5eXC/rhmucnZp7E3Y
	 5cjWmrJDuob67rZ70ikdTLVYvEvnt3/d9EkH0V1Y=
Date: Thu, 06 Nov 2025 16:06:24 -0800
To: mm-commits@vger.kernel.org,jic23@kernel.org,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mathh-amend-kernel-doc-and-add-a-note-about-signed-type-limits.patch added to mm-nonmm-unstable branch
Message-Id: <20251107000625.D6C02C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: math.h: amend abs() kernel-doc and add a note about signed type limits
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mathh-amend-kernel-doc-and-add-a-note-about-signed-type-limits.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mathh-amend-kernel-doc-and-add-a-note-about-signed-type-limits.patch

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
Subject: math.h: amend abs() kernel-doc and add a note about signed type limits
Date: Thu, 6 Nov 2025 16:20:51 +0100

- amend the kernel-doc so the description is decoupled from the
  parameter descriptions.

- add a note to explain behaviour for the signed types when supplied
  value is the minimum (e.g., INT_MIN for int type).

Link: https://lkml.kernel.org/r/20251106152051.2361551-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/math.h |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/include/linux/math.h~mathh-amend-kernel-doc-and-add-a-note-about-signed-type-limits
+++ a/include/linux/math.h
@@ -148,11 +148,16 @@ __STRUCT_FRACT(u32)
 
 /**
  * abs - return absolute value of an argument
- * @x: the value.  If it is unsigned type, it is converted to signed type first.
- *     char is treated as if it was signed (regardless of whether it really is)
- *     but the macro's return type is preserved as char.
+ * @x: the value.
  *
- * Return: an absolute value of x.
+ * If it is unsigned type, @x is converted to signed type first.
+ * char is treated as if it was signed (regardless of whether it really is)
+ * but the macro's return type is preserved as char.
+ *
+ * NOTE, for signed type if @x is the minimum, the returned result is undefined
+ * as there is not enough bits to represent it as a positive number.
+ *
+ * Return: an absolute value of @x.
  */
 #define abs(x)	__abs_choose_expr(x, long long,				\
 		__abs_choose_expr(x, long,				\
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

panic-sys_info-capture-si_bits_global-before-iterating-over-it.patch
panic-sys_info-align-constant-definition-names-with-parameters.patch
panic-sys_info-replace-struct-sys_info_name-with-plain-array-of-strings.patch
panic-sys_info-rewrite-a-fix-for-a-compilation-error-make-w=1.patch
panic-sys_info-deduplicate-local-variable-table-assignments.patch
panic-sys_info-factor-out-read-and-write-handlers.patch
util_macrosh-fix-kernel-doc-for-u64_to_user_ptr.patch
mathh-amend-kernel-doc-and-add-a-note-about-signed-type-limits.patch


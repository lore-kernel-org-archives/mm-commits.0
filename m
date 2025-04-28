Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5600627F747
	for <mm-commits@vger.kernel.org>; Mon, 28 Apr 2025 09:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745832687; cv=none; b=pCkgYYrgoiC7l6uT+hCcI0ltXjvUgaT9XXdzKX1GxCQFjr4tgm/g9dRHbvkKwBZU35v3cqVefiPSH5Vh3Pjhv4/J20+a2DSn9XxYn05OgB2MzQhOKD6bwrvCmDHRuTMtabWz7Y24CxCHX95ShfUfcFI0ksPAvLf46A/75GXiKMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745832687; c=relaxed/simple;
	bh=N8OOFpLwOJzQKNHCgkzCTGC9kJI3ufqtcwPc6rQcZzM=;
	h=Date:To:From:Subject:Message-Id; b=sC2ifX8Vf8oaMJQyIwqxBcwAd++P8FgvY9tJQaqEMzsrNg+DxDJXmJxtOqpTUZyurUivBh+FJgp7OeHHQR5s5Z/6yAv0UzLvo4sNOo3XxCGpz0wTYq75kbLa3K5SbHjvqWMO2+lS8tLFb/O5jHQptd0yzrb2xdijSc1V8/HVF50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dAPdyTBd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dAPdyTBd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4DF5C4CEE9;
	Mon, 28 Apr 2025 09:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745832686;
	bh=N8OOFpLwOJzQKNHCgkzCTGC9kJI3ufqtcwPc6rQcZzM=;
	h=Date:To:From:Subject:From;
	b=dAPdyTBdUPaeMmyAt38NF1Bvvkawf5TqHP9afQyIHFt+pUIrEZR0tkLwlQcQwzNi1
	 XOt+qxePTS8LPyKSJ3dUEv/VUchj4QjTXwkwowz/dS3X37unO0Fq4p40D04y02rRH1
	 9OYWieb9gGAddr/hezCRONkmLZ8OCZeF8yfcHrTo=
Date: Mon, 28 Apr 2025 02:31:26 -0700
To: mm-commits@vger.kernel.org,aardelean@baylibre.com,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + util_macrosh-fix-the-reference-in-kernel-doc.patch added to mm-nonmm-unstable branch
Message-Id: <20250428093126.C4DF5C4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: util_macros.h: fix the reference in kernel-doc
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     util_macrosh-fix-the-reference-in-kernel-doc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/util_macrosh-fix-the-reference-in-kernel-doc.patch

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
Subject: util_macros.h: fix the reference in kernel-doc
Date: Mon, 28 Apr 2025 10:27:37 +0300

In PTR_IF() description the text refers to the parameter as (ptr) while
the kernel-doc format asks for @ptr.  Fix this accordingly.

Link: https://lkml.kernel.org/r/20250428072737.3265239-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Alexandru Ardelean <aardelean@baylibre.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/util_macros.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/util_macros.h~util_macrosh-fix-the-reference-in-kernel-doc
+++ a/include/linux/util_macros.h
@@ -85,7 +85,7 @@
  * @ptr: A pointer to assign if @cond is true.
  *
  * PTR_IF(IS_ENABLED(CONFIG_FOO), ptr) evaluates to @ptr if CONFIG_FOO is set
- * to 'y' or 'm', or to NULL otherwise. The (ptr) argument must be a pointer.
+ * to 'y' or 'm', or to NULL otherwise. The @ptr argument must be a pointer.
  *
  * The macro can be very useful to help compiler dropping dead code.
  *
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

kernelh-move-ptr_if-and-u64_to_user_ptr-to-util_macrosh.patch
util_macrosh-fix-the-reference-in-kernel-doc.patch


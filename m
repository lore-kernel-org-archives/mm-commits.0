Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B381EDA35
	for <mm-commits@vger.kernel.org>; Thu, 24 Apr 2025 21:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745531778; cv=none; b=J5on66w2CC2juin4tC0jZiN5SeVdr9jGm5qBM35FbLfz0LoTCfGZwNnk6CnLirdojfot+S/9982a1cY7uWNMO2rgIUIewmPH8dY9mE2pugFfgTSfKlujp4WQJDTCV6sZKG75GG1IQ8KXPSyJGnxRh1FA4poMe0MvMAV+h1yIdwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745531778; c=relaxed/simple;
	bh=To/SK4nkJY8nSpqfV0M6Nk892PWBHBRYEeu2AWvqZPs=;
	h=Date:To:From:Subject:Message-Id; b=IQm0oAdsaamJ0Fsh2KL0E4cYBPI4fEKWXeHnOEMYi2pxftxnLycisbTiN5+5wCl1d1x92kfSCTCH3LWCDoMGT3fvjtM90qtNY5+uroAj/SFDMhx7Rn3EX50QjXyPyNLczLZNL/jiZRlFISfr2gHKfNs7K6Aeb552BUqq9fFo+WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sLyihegH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sLyihegH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03ACAC4CEE4;
	Thu, 24 Apr 2025 21:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745531778;
	bh=To/SK4nkJY8nSpqfV0M6Nk892PWBHBRYEeu2AWvqZPs=;
	h=Date:To:From:Subject:From;
	b=sLyihegHOBrO9zZQ9dCJpu9HvdYWoSH2e/TkMtX7r59P0ELrM6ut2nZVr2cjdHU8v
	 flmLpItc+KWeU+632ia4Af097cgscGUon00bVT2DbjSEPMYfRrvC2GGdc0MkUm73I2
	 BQNnJeUpfx3L5TkwhguzBBTgh1a3/fKAQGHqq/2M=
Date: Thu, 24 Apr 2025 14:56:17 -0700
To: mm-commits@vger.kernel.org,Marc.Herbert@linux.intel.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + compiler_typesh-fix-unused-variable-in-__compiletime_assert-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20250424215618.03ACAC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: compiler_typesh-fix-unused-variable-in-__compiletime_assert-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     compiler_typesh-fix-unused-variable-in-__compiletime_assert-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/compiler_typesh-fix-unused-variable-in-__compiletime_assert-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: compiler_typesh-fix-unused-variable-in-__compiletime_assert-fix
Date: Thu Apr 24 02:53:15 PM PDT 2025

regularize comment layout, reflow comment

Cc: Marc Herbert <Marc.Herbert@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler_types.h |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/include/linux/compiler_types.h~compiler_typesh-fix-unused-variable-in-__compiletime_assert-fix
+++ a/include/linux/compiler_types.h
@@ -525,10 +525,11 @@ struct ftrace_likely_data {
 	 sizeof(t) == sizeof(int) || sizeof(t) == sizeof(long))
 
 #ifdef __OPTIMIZE__
-/* #ifdef __OPTIMIZE__ is only a good approximation; for instance "make
- * CFLAGS_foo.o=-Og" defines __OPTIMIZE__, does not elide the
- * conditional code and can break compilation with wrong error
- * message(s). Combine with -U__OPTIMIZE__ when needed.
+/*
+ * #ifdef __OPTIMIZE__ is only a good approximation; for instance "make
+ * CFLAGS_foo.o=-Og" defines __OPTIMIZE__, does not elide the conditional code
+ * and can break compilation with wrong error message(s). Combine with
+ * -U__OPTIMIZE__ when needed.
  */
 # define __compiletime_assert(condition, msg, prefix, suffix)		\
 	do {								\
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

x86-disable-image-size-check-for-test-builds-fix.patch
x86-disable-image-size-check-for-test-builds-fix-fix.patch
mm-debug-fix-parameter-passed-to-page_mapcount_is_type-fix.patch
vmalloc-switch-to-for_each_vmap_node-helper-fix.patch
mm-add-zblock-allocator-fix.patch
compiler_typesh-fix-unused-variable-in-__compiletime_assert-fix.patch


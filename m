Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D645A33B6DC
	for <mm-commits@vger.kernel.org>; Sun,  1 Mar 2026 19:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772393162; cv=none; b=fgoFZ+zqfEs/D8iKB1mHtOIXw36Ie+opF1O1jN0k/B+1ttomhGOdOPvReLbjM7hV6D3KI36RVdtdA3esK6MXRdnd8sSA/DYyFH87zl12nmHFAfUyEJyD8M3wK66xuB/bApABCkme+5ZLRGs8lZRY7GfWcyQr0YD2ONUpLOla9O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772393162; c=relaxed/simple;
	bh=uOEtFGHp2b19p0wMMW8k7haQJL63iC7wMWXlNSFmPds=;
	h=Date:To:From:Subject:Message-Id; b=Mp5Bwr8axS/aGBTly3QcLNFAla59UrzaKf9goLnDeQPw6Tx7i1dzRpVb4VXf+DdWqE8epXvpSNoWQScC/Ruxu6+72MoGX24orMu5bC+7EYrOGlJksmpPZ77clPkmvBjh3lntczEQZxY7DPQeQQhwuC0XK4QM3wRo8FYbNu0yLZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lIZ7CpgJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lIZ7CpgJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A49BDC2BC86;
	Sun,  1 Mar 2026 19:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772393162;
	bh=uOEtFGHp2b19p0wMMW8k7haQJL63iC7wMWXlNSFmPds=;
	h=Date:To:From:Subject:From;
	b=lIZ7CpgJ+2H7x5HfNb9kvL4JQJXee6BqGw0r4aon6hetOCN9TH5sx7zAGDOtJJ/7A
	 3HiuWezS+l8qO+3RG/kwRNhB5/oe1uaadUpcFAa8la/QxotX9LEBKqKMFdMqfmDQpe
	 lDNVRt+dGN0ivczwhMCdn7IQNHlcZ69gjEEObo9c=
Date: Sun, 01 Mar 2026 11:26:02 -0800
To: mm-commits@vger.kernel.org,objecting@objecting.org,akpm@linux-foundation.org,hlcj1234567@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-glob-add-explicit-include-for-exporth.patch added to mm-nonmm-unstable branch
Message-Id: <20260301192602.A49BDC2BC86@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: glob: add explicit include for export.h
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-glob-add-explicit-include-for-exporth.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-glob-add-explicit-include-for-exporth.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Josh Law <hlcj1234567@gmail.com>
Subject: lib: glob: add explicit include for export.h
Date: Sun, 1 Mar 2026 15:21:41 +0000

Include <linux/export.h> explicitly instead of relying on it being
implicitly included by <linux/module.h> for the EXPORT_SYMBOL macro.

Link: https://lkml.kernel.org/r/20260301152143.2572137-1-objecting@objecting.org
Signed-off-by: Josh Law <objecting@objecting.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/glob.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/glob.c~lib-glob-add-explicit-include-for-exporth
+++ a/lib/glob.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: (GPL-2.0 OR MIT)
 #include <linux/module.h>
 #include <linux/glob.h>
+#include <linux/export.h>
 
 /*
  * The only reason this code can be compiled as a module is because the
_

Patches currently in -mm which might be from hlcj1234567@gmail.com are

lib-glob-add-missing-spdx-license-identifier.patch
lib-glob-fix-grammar-and-replace-non-inclusive-terminology.patch
lib-glob-add-explicit-include-for-exporth.patch
lib-glob-replace-bitwise-or-with-logical-operation-on-boolean.patch


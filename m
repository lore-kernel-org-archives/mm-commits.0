Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D5B26983E
	for <mm-commits@vger.kernel.org>; Wed, 23 Apr 2025 20:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745438815; cv=none; b=evuKSctqWB1VJek5dr03LFmJSM1U+nUcUGmriSajVOyuYnMzqKNbfEB3s08O2sMJ4tllLFLUcd4jDbr+KAjMwrCBqgAcR61Vdfgfh7nAp/WgZXvuTh8FqGRglRqVgijF1ATKHZM5uPvjMCrEvh7/qSYjnExjVxlnpIvLahsY4xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745438815; c=relaxed/simple;
	bh=Ex+vKn/45bVbgZW3cS2QA20ADmEPq8dYb1JvHWreFd4=;
	h=Date:To:From:Subject:Message-Id; b=Db1TPE8IgI/LnO87whQHEUf06ManOTSK0MOLbRHJQpmtNMkyI13+ZzlvuE6zR6HER9okujyODCZeJ2Jp4XH7Ps8YLfUHYM8OXFfD0l0p7NoyYCkPtw/VsLpF/Q6tK8f+RG0C/yO2ixk4gyiOcVhk+gDy1Q6BSeLTcsC93d7Oq5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Gr7HHdu/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Gr7HHdu/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06601C4CEE2;
	Wed, 23 Apr 2025 20:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745438815;
	bh=Ex+vKn/45bVbgZW3cS2QA20ADmEPq8dYb1JvHWreFd4=;
	h=Date:To:From:Subject:From;
	b=Gr7HHdu/L01jhaOwozo6LaQylED36BefvTWkDYTurWwDt+3S9NCNODunGd+FfRbNq
	 BGohDFt/tdpMBJhdSPW1TFOwUr0xMFX2qktB8Sb5fh82qET5/7rqw0SPaADMhOOHoU
	 nQJtutrUyDsnrNuttbaaiwjhaEqtxRwYNWdEK7qs=
Date: Wed, 23 Apr 2025 13:06:53 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,graf@amazon.com,changyuanl@google.com,bhe@redhat.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-add-kho-support-fix.patch added to mm-unstable branch
Message-Id: <20250423200655.06601C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kexec: include asm/early_ioremap.h
has been added to the -mm mm-unstable branch.  Its filename is
     x86-add-kho-support-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-add-kho-support-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: Arnd Bergmann <arnd@arndb.de>
Subject: kexec: include asm/early_ioremap.h
Date: Wed, 23 Apr 2025 18:29:18 +0200

early_memremap() is declared in a header that is only indirectly included
here:

kernel/kexec_handover.c:1116:8: error: call to undeclared function 'early_memremap'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
 1116 |         fdt = early_memremap(fdt_phys, fdt_len);
      |               ^

Link: https://lkml.kernel.org/r/20250423162924.2213664-1-arnd@kernel.org
Fixes: 4bfe738ce89a ("kexec: add KHO support to kexec file loads")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Alexander Graf <graf@amazon.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Changyuan Lyu <changyuanl@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_handover.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/kexec_handover.c~x86-add-kho-support-fix
+++ a/kernel/kexec_handover.c
@@ -18,6 +18,9 @@
 #include <linux/memblock.h>
 #include <linux/notifier.h>
 #include <linux/page-isolation.h>
+
+#include <asm/early_ioremap.h>
+
 /*
  * KHO is tightly coupled with mm init and needs access to some of mm
  * internal APIs.
_

Patches currently in -mm which might be from arnd@arndb.de are

x86-add-kho-support-fix.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A88176242
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742487; cv=none; b=sRebaqEaT1estA3s0VbLKrwBwxU2RZKgG5c5/AuNBakrkYkSpRZivDJmx8/twF1JxQ35Vh+Jf7X3QEJvEYLkJbM8bhQOBQNPUSbVxULlfbRnxoJj1KSeedsNE1E29l/2Zo++lAG9ZvLX0EtE/QCdl7zHFh2YzxzMQ5pnBeVr3EM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742487; c=relaxed/simple;
	bh=N6NSioRTjbwJOFtu5uP+I27A+qNxMmiop4MGYMUQpT4=;
	h=Date:To:From:Subject:Message-Id; b=GV5AifFz01EdDnfOBGMfS++3ACYNXDkvygSnQR6tOrJ2ZRzvEX8Pzn24adqjyMbAuc3OOTgE0IvKAqNoXTs7py+bBxcWK0+YoXk3WIp915VGH6uiV+yHw4V0kKXPo/cSFoCIlz52IKlf1TkgCdS06ulFTRhrmQPJ33D8Nfxn898=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sOJtElKe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sOJtElKe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25416C4CEE2;
	Mon, 13 Jan 2025 04:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742487;
	bh=N6NSioRTjbwJOFtu5uP+I27A+qNxMmiop4MGYMUQpT4=;
	h=Date:To:From:Subject:From;
	b=sOJtElKeEJBVH1CPBY8yGv+ZARq0s/XXym2Oy+CwdrB5ufB6t2IKwmusGonmeSolZ
	 852fDNUBBnAw+UgmJxzyZ2wCuiUII5L9ZALCC4QPZFmtlxcUSYibmsbdXl9EA2maLW
	 Onq7cwhkLV266jGUR1mcpFojJ+HstFsPSgmbIFo8=
Date: Sun, 12 Jan 2025 20:28:06 -0800
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,minchan@kernel.org,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zsmalloc-add-zpdesc-memory-descriptor-for-zswapzpool-fix.patch added to mm-unstable branch
Message-Id: <20250113042807.25416C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zsmalloc: fix function parameter kernel-doc notation
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zsmalloc-add-zpdesc-memory-descriptor-for-zswapzpool-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zsmalloc-add-zpdesc-memory-descriptor-for-zswapzpool-fix.patch

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
From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm/zsmalloc: fix function parameter kernel-doc notation
Date: Fri, 10 Jan 2025 22:33:05 -0800

Use the correct function parameter name to eliminate a kernel-doc
warning:

zpdesc.h:90: warning: Function parameter or struct member 'zp' not described in 'zpdesc_folio'
zpdesc.h:90: warning: Excess function parameter 'zpdesc' description in 'zpdesc_folio'

Link: https://lkml.kernel.org/r/20250111063305.911010-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zpdesc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/zpdesc.h~mm-zsmalloc-add-zpdesc-memory-descriptor-for-zswapzpool-fix
+++ a/mm/zpdesc.h
@@ -74,7 +74,7 @@ static_assert(sizeof(struct zpdesc) <= s
 
 /**
  * zpdesc_folio - The folio allocated for a zpdesc
- * @zpdesc: The zpdesc.
+ * @zp: The zpdesc.
  *
  * Zpdescs are descriptors for zpool memory. The zpool memory itself is
  * allocated as folios that contain the zpool objects, and zpdesc uses specific
_

Patches currently in -mm which might be from rdunlap@infradead.org are

mm-zsmalloc-add-zpdesc-memory-descriptor-for-zswapzpool-fix.patch
kasan-use-correct-kernel-doc-format.patch
latencytop-use-correct-kernel-doc-format-for-func-params.patch
kthread-modify-kernel-doc-function-name-to-match-code.patch
gcov-clang-use-correct-function-param-names.patch
ipc-utilc-complete-the-kernel-doc-function-descriptions.patch


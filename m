Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D0B33F7
	for <mm-commits@vger.kernel.org>; Sun, 12 Jan 2025 05:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736659932; cv=none; b=MI4cLvu2BjiPWTV0SX9BQ1ynJAgXAWGx0Dp71EzCh3q5WrdHPXHnC2KCJFOGVMK0Ka6jXbO2ry7PNtvOVTgvNMHFriThanF1CXIuc9waU0hrrbau6TG9tPAzKgBpPsd4zbsxOz0PCCQBK1iFAI+BLZK9NS8Z1ZKGZMt1u1ozUaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736659932; c=relaxed/simple;
	bh=8efscfiE84nQ2QmH++OnMmGqjYEyXtHVLyuSBGB/x+E=;
	h=Date:To:From:Subject:Message-Id; b=moGEJOr3vDwVajogBDbPqF2YS0zEMR3+cLy7I580qOsK7EWy4VVeOVB4v0hXAJLUAJOfSzxGXldwU3WSO88cwjV5++Fxmdl5q+XWlhfkYnmiHgMK3oNxGfFFJPUdh9tHMkhkGaV0ZoHD46JHiVgJcriOdGMmJSZ+ymcfyLGScak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CM4iicGt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CM4iicGt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D85AAC4CEE0;
	Sun, 12 Jan 2025 05:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736659931;
	bh=8efscfiE84nQ2QmH++OnMmGqjYEyXtHVLyuSBGB/x+E=;
	h=Date:To:From:Subject:From;
	b=CM4iicGtAdv+Ln67IIdRKk29LfAwln8SYKxS7sg5YI5qT6aFrSIejOX4nSyBiDKLq
	 +4JOX09VNoEMKxM9BzmbTtOdOUwW/DjILciD+2+p4+9++YEbe7WiCSPdcuFsezdAaL
	 0t6ezOxA0LX3y2w70Wsn/i5FG74HIXeoBMuB0T2U=
Date: Sat, 11 Jan 2025 21:32:11 -0800
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,minchan@kernel.org,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zsmalloc-fix-function-parameter-kernel-doc-notation.patch added to mm-unstable branch
Message-Id: <20250112053211.D85AAC4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zsmalloc: fix function parameter kernel-doc notation
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zsmalloc-fix-function-parameter-kernel-doc-notation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zsmalloc-fix-function-parameter-kernel-doc-notation.patch

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

--- a/mm/zpdesc.h~mm-zsmalloc-fix-function-parameter-kernel-doc-notation
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

mm-zsmalloc-fix-function-parameter-kernel-doc-notation.patch


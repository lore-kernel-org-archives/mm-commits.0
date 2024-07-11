Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A93DA19E83D
	for <mm-commits@vger.kernel.org>; Thu, 11 Jul 2024 19:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720727690; cv=none; b=YOMBIv+SlayOFshRGIIYSRBsPhkW36ubJ1y2zG3yr+E77wP7kcAAx77E0GgGjnONP909JtO5JV2G1CE5zgGVjMBpzzkGFtjbZ8l3PDZw/UAkv4Xg5fkM1afwLStJsRIeHzP8lV95siDua/WO0kIcNt2X0gByumYGFs6omZd5l20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720727690; c=relaxed/simple;
	bh=7GkllvVl6pMnEgRMzWXlzxvL2b0bb1/ddWfNiKU9R4M=;
	h=Date:To:From:Subject:Message-Id; b=jvL7fMA7aKeCxV1DPK4DTWfYai9TdgNn5j2amSxMJ3qSUzihK2dHl/d2DFWSc5f4k2ulHubCu0xQaW7bCVONURiJLpqnsAuK0Z2vwkiA2FpGkgXf2YXlrNME8hu9FCb8i/FxMqjB9DtaFOxiXLTf87xIF8YCSZOXgyQFpVgiW2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xfIb/TSD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xfIb/TSD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E9C3C4AF0B;
	Thu, 11 Jul 2024 19:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720727690;
	bh=7GkllvVl6pMnEgRMzWXlzxvL2b0bb1/ddWfNiKU9R4M=;
	h=Date:To:From:Subject:From;
	b=xfIb/TSDUI8zTiY9EzoXO+BNDzqd84oTFUJLJAujqnOtRJMRFqNbePv/vrRWNc8Ul
	 ourgYtIFDDoJGqoI3Vp2yQ/9+fncTpo6+qz0synGetYm1d3iTAXFE2Pnt5qyCRysDH
	 ENXsCfPhBAPBz7sfplgfdQEzfCSt0voxruHu5HRQ=
Date: Thu, 11 Jul 2024 12:54:49 -0700
To: mm-commits@vger.kernel.org,mhiramat@kernel.org,thorsten.blum@toblux.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + bootconfig-remove-duplicate-included-header-file-linux-bootconfigh.patch added to mm-nonmm-unstable branch
Message-Id: <20240711195450.2E9C3C4AF0B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: bootconfig: Remove duplicate included header file linux/bootconfig.h
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     bootconfig-remove-duplicate-included-header-file-linux-bootconfigh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/bootconfig-remove-duplicate-included-header-file-linux-bootconfigh.patch

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
From: Thorsten Blum <thorsten.blum@toblux.com>
Subject: bootconfig: Remove duplicate included header file linux/bootconfig.h
Date: Thu, 11 Jul 2024 10:43:16 +0200

The header file linux/bootconfig.h is included whether __KERNEL__ is
defined or not.

Include it only once before the #ifdef/#else/#endif preprocessor
directives and remove the following make includecheck warning:

  linux/bootconfig.h is included more than once

Move the comment to the top and delete the now empty #else block.

Link: https://lkml.kernel.org/r/20240711084315.1507-1-thorsten.blum@toblux.com
Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bootconfig.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

--- a/lib/bootconfig.c~bootconfig-remove-duplicate-included-header-file-linux-bootconfigh
+++ a/lib/bootconfig.c
@@ -4,8 +4,16 @@
  * Masami Hiramatsu <mhiramat@kernel.org>
  */
 
-#ifdef __KERNEL__
+/*
+ * NOTE: This is only for tools/bootconfig, because tools/bootconfig will
+ * run the parser sanity test.
+ * This does NOT mean lib/bootconfig.c is available in the user space.
+ * However, if you change this file, please make sure the tools/bootconfig
+ * has no issue on building and running.
+ */
 #include <linux/bootconfig.h>
+
+#ifdef __KERNEL__
 #include <linux/bug.h>
 #include <linux/ctype.h>
 #include <linux/errno.h>
@@ -24,16 +32,6 @@ const char * __init xbc_get_embedded_boo
 	return (*size) ? embedded_bootconfig_data : NULL;
 }
 #endif
-
-#else /* !__KERNEL__ */
-/*
- * NOTE: This is only for tools/bootconfig, because tools/bootconfig will
- * run the parser sanity test.
- * This does NOT mean lib/bootconfig.c is available in the user space.
- * However, if you change this file, please make sure the tools/bootconfig
- * has no issue on building and running.
- */
-#include <linux/bootconfig.h>
 #endif
 
 /*
_

Patches currently in -mm which might be from thorsten.blum@toblux.com are

lib-bchc-use-swap-to-improve-code.patch
bootconfig-remove-duplicate-included-header-file-linux-bootconfigh.patch


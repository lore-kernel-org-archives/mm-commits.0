Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D1F1C2308
	for <mm-commits@vger.kernel.org>; Fri, 27 Sep 2024 18:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727461520; cv=none; b=CEkNVTWldrhve+SjrmBtYm6rmHe2le1fi0dc0LuFFzLqYkTs3OqDyuVm/teOddXGAsnCx0MRxlquMuaW/fSbvtrySixP3StQATkMLLQ0b3jAi+zJ4f0ZbYrNrrxVcx/TZwK5FMyLnUo/IufuCEEfpSRFclz6p50ThLWC1Nn2mU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727461520; c=relaxed/simple;
	bh=K9J3BaHP9wu9OEY4QEpj3mEWD7GXyM5wNR5d15r4mY4=;
	h=Date:To:From:Subject:Message-Id; b=P+dg0QzTTeVMb/sX4pHPdR1VAMlV5vhO52NF/slu46XZPg9HlXGRPnEfbWqs+XFoQlbYCQxJH6knZ0/OmIDJXNgd9IZCdlJExKOKvRE87C/ciUU2C76uGXNmPL5t76ddOlpZfSGSbjoeWpBLX5lWXCAMp69LXKVNfCDDaP1qMw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pBUKPzxQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pBUKPzxQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE392C4CED1;
	Fri, 27 Sep 2024 18:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727461518;
	bh=K9J3BaHP9wu9OEY4QEpj3mEWD7GXyM5wNR5d15r4mY4=;
	h=Date:To:From:Subject:From;
	b=pBUKPzxQChLN6bhe6ZGpc9Q+neYXrGAbriUtslK0P3Sur5XDnr4kdxJRnsfmpZHoj
	 aZjNzwDw0AAi1LofNKG5D0mF4aytv9SLrn9O9UyVGFz2EYK7fu6ZJ1gGN9XQPrPANx
	 8rnwd3pkBR26su6/F4e6vKDufQXFN6AX7K/OSZ0s=
Date: Fri, 27 Sep 2024 11:25:18 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,pintu.ping@gmail.com,quic_pintu@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma-fix-useless-return-in-void-function.patch added to mm-unstable branch
Message-Id: <20240927182518.DE392C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/cma: fix useless return in void function
has been added to the -mm mm-unstable branch.  Its filename is
     mm-cma-fix-useless-return-in-void-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cma-fix-useless-return-in-void-function.patch

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
From: Pintu Kumar <quic_pintu@quicinc.com>
Subject: mm/cma: fix useless return in void function
Date: Fri, 27 Sep 2024 23:46:37 +0530

There is a unnecessary return statement at the end of void function
cma_activate_area.  This can be dropped.

While at it, also fix another warning related to unsigned.
These are reported by checkpatch as well.

WARNING: Prefer 'unsigned int' to bare use of 'unsigned'
+unsigned cma_area_count;

WARNING: void function return statements are not generally useful
+       return;
+}

Link: https://lkml.kernel.org/r/20240927181637.19941-1-quic_pintu@quicinc.com
Signed-off-by: Pintu Kumar <quic_pintu@quicinc.com>
Cc: Pintu Agarwal <pintu.ping@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/cma.c~mm-cma-fix-useless-return-in-void-function
+++ a/mm/cma.c
@@ -32,7 +32,7 @@
 #include "cma.h"
 
 struct cma cma_areas[MAX_CMA_AREAS];
-unsigned cma_area_count;
+unsigned int cma_area_count;
 static DEFINE_MUTEX(cma_mutex);
 
 phys_addr_t cma_get_base(const struct cma *cma)
@@ -135,7 +135,6 @@ out_error:
 	totalcma_pages -= cma->count;
 	cma->count = 0;
 	pr_err("CMA area %s could not be activated\n", cma->name);
-	return;
 }
 
 static int __init cma_init_reserved_areas(void)
_

Patches currently in -mm which might be from quic_pintu@quicinc.com are

mm-cma-fix-useless-return-in-void-function.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7CA55661
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737005727; cv=none; b=cLKZv9OR+BdWc9Ur+CRnEZK7vsf/nkGYdzf3Rs1FQ80C9rrdAmqFA/WypAAso/3xVzQV/+rWumA6r7SRsxEoxobREGYrQYudz9x7yLHH9oAub5TUxexkHlyeTcHHZf2nWlnhYa/6CS6tdZ5Yj634ubiBpnrtyOWKOAG8TGQ0bvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737005727; c=relaxed/simple;
	bh=/k45BXOcA1RrA2xhi/wuhfETI2WbNvXl9uuRtnzB+1A=;
	h=Date:To:From:Subject:Message-Id; b=W1r1ejlZmeXTxNZU/Y6mHC42i9vVFRIl3FaGTD7pwv2vdNLM+Eyds1MrVbh0l3AxdV4xdhpeUxgA3tn16hN5JUkfBqc/SMG1UCZLF13dRV95cvUJzK9Mp8Kry1v33EmbFZlLh6ZuwyjpcFpDonxvnTkrBFUpumM4i8ZAbstyKrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0W/3rKcG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0W/3rKcG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FB4DC4CED6;
	Thu, 16 Jan 2025 05:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737005727;
	bh=/k45BXOcA1RrA2xhi/wuhfETI2WbNvXl9uuRtnzB+1A=;
	h=Date:To:From:Subject:From;
	b=0W/3rKcG3e9A2Yggk4zgXBsZbKvt2jcioQJ5ta3ZNG+ICJ/MMGEXEX1ZpCX/G+2v9
	 8z6InlwfZESSk5ieVh7SQ9fCZgMJEryfgOUrDc/k20HyiWuOLsgaLClc4QqjlCdK/d
	 6vVVcLxPDVIS+TtdfncllaNu+MWwKQy4FvcoG0p8=
Date: Wed, 15 Jan 2025 21:35:26 -0800
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,minchan@kernel.org,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-zsmalloc-add-zpdesc-memory-descriptor-for-zswapzpool-fix.patch removed from -mm tree
Message-Id: <20250116053527.3FB4DC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zsmalloc: fix function parameter kernel-doc notation
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-add-zpdesc-memory-descriptor-for-zswapzpool-fix.patch

This patch was dropped because it was folded into mm-zsmalloc-add-zpdesc-memory-descriptor-for-zswapzpool.patch

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

mm-zsmalloc-add-zpdesc-memory-descriptor-for-zswapzpool.patch
kasan-use-correct-kernel-doc-format.patch
latencytop-use-correct-kernel-doc-format-for-func-params.patch
gcov-clang-use-correct-function-param-names.patch
ipc-utilc-complete-the-kernel-doc-function-descriptions.patch


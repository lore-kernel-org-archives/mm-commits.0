Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D417A136990
	for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2024 22:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711059470; cv=none; b=raHQQTH+cv/GCqhdRBvfizAFLVbBQpCXS5UtthyDCvn9vluZpOl3xjMb20AZMAvTuMcyzTwu/WvaIcdkwYbZfYLNXJr7wfqBgMNixtQET90a8JD5tz+5nZNkMgZxugn5h5tFbHMO3v2WqC8OcGQbgSZ5Evng8Zwz/pNhwziMV0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711059470; c=relaxed/simple;
	bh=9Hcp03DIC+sUPGFA5PULCRXMQaGtZ5ph4MAGQgWRyuo=;
	h=Date:To:From:Subject:Message-Id; b=U2PjJRaI9Jr9g6aKfGAxiUtOkdwPZKfo50ZoFs/XwvQdYYmJ6FyEBltgf3X7x/r1ZzARPmke8wvvAOIfQjeJeI9m+gzs1g1932bhd1TiWGQGF+2Ykg+dvoUUjJF/BAOedH3HorVkFnG1HGTxwvTrwEHMGozxVETRr38caoZzrWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eOFJj0T2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eOFJj0T2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A047C433F1;
	Thu, 21 Mar 2024 22:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711059470;
	bh=9Hcp03DIC+sUPGFA5PULCRXMQaGtZ5ph4MAGQgWRyuo=;
	h=Date:To:From:Subject:From;
	b=eOFJj0T21Yp5ywc/G5G4z+00d8+ctIek+uCI7+6FffJjFdXbhe+TcBHQNX4qxPQlG
	 hh4K+QR8jcRO2yYwXPfCbHwjdzXzCn1pvO1ZFHXAuTVAI2YhbMlsyo5C808HhvJHgj
	 3RTyoB/ozLY7MIY0lp6Gvmlb3YmpUaEez1VizmLE=
Date: Thu, 21 Mar 2024 15:17:49 -0700
To: mm-commits@vger.kernel.org,gehao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page-flags-make-__pagemovable-return-bool.patch added to mm-unstable branch
Message-Id: <20240321221750.5A047C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page-flags: make __PageMovable return bool
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page-flags-make-__pagemovable-return-bool.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page-flags-make-__pagemovable-return-bool.patch

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
From: Hao Ge <gehao@kylinos.cn>
Subject: mm/page-flags: make __PageMovable return bool
Date: Thu, 21 Mar 2024 11:22:56 +0800

Make __PageMovable() return bool like __folio_test_movable().

Link: https://lkml.kernel.org/r/20240321032256.82063-1-gehao@kylinos.cn
Signed-off-by: Hao Ge <gehao@kylinos.cn>
Cc: Hao Ge <gehao@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/page-flags.h~mm-page-flags-make-__pagemovable-return-bool
+++ a/include/linux/page-flags.h
@@ -707,7 +707,7 @@ static __always_inline bool __folio_test
 			PAGE_MAPPING_MOVABLE;
 }
 
-static __always_inline int __PageMovable(const struct page *page)
+static __always_inline bool __PageMovable(const struct page *page)
 {
 	return ((unsigned long)page->mapping & PAGE_MAPPING_FLAGS) ==
 				PAGE_MAPPING_MOVABLE;
_

Patches currently in -mm which might be from gehao@kylinos.cn are

mm-page-flags-make-__pagemovable-return-bool.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D64C2143746
	for <mm-commits@vger.kernel.org>; Mon, 10 Jun 2024 16:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718037310; cv=none; b=TfFs3sM4Xso9Xo3CDho2YIrHsa5AP9Sj3atpq66QGd27Qbn8DoWRHCy5772bLtHpw1KDTYTh17ee3xpdJACYjJY/1mm5ljCQIeLhncknhr+w71DNko5zI3ldV3LaP1ZTrNZ45wH3Hx8JASs6sliF9GCnFbUIih+OJXZmhmmOaHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718037310; c=relaxed/simple;
	bh=yA0Zubde3rEjfXIDEvk7r0N9dKc4uknpSp4Tx7You68=;
	h=Date:To:From:Subject:Message-Id; b=o7RlWXwM5D4pLU36uBiykKQR6XdaL+mdl0aLYbJ9eDgpnUnU+UdBE0BF39nawL+Z0A2m340uY5IN1PKkRK97hGn3P8wC5sbB51sCGhuVZ2GyqC66+QFpY9sRKrP31R2pyJvKNs6j0VLMGcZCFTKe64VzEqR+XJLHrcbDGjoW4cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lQ2naCDQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lQ2naCDQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54A31C2BBFC;
	Mon, 10 Jun 2024 16:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718037310;
	bh=yA0Zubde3rEjfXIDEvk7r0N9dKc4uknpSp4Tx7You68=;
	h=Date:To:From:Subject:From;
	b=lQ2naCDQfK60EfJr9WKLVsUmVbQ04PBYADpMECC6kRK5CYpxSyM/DL08Vh5YLhCeU
	 szQ5ITvvC6U3AkRF6Yj5hx72qBAsQs0Ud29g8CNR07NWdqC589YRTYQoQUohCcTBzs
	 +g00E2o2E1J3lxD/8fi/WJRGrOPpqx623+fAw0cA=
Date: Mon, 10 Jun 2024 09:35:09 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,willy@infradead.org,nphamcs@gmail.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,usamaarif642@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-do-not-start-end-writeback-for-pages-stored-in-zswap.patch added to mm-unstable branch
Message-Id: <20240610163510.54A31C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: do not start/end writeback for pages stored in zswap
has been added to the -mm mm-unstable branch.  Its filename is
     mm-do-not-start-end-writeback-for-pages-stored-in-zswap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-do-not-start-end-writeback-for-pages-stored-in-zswap.patch

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
From: Usama Arif <usamaarif642@gmail.com>
Subject: mm: do not start/end writeback for pages stored in zswap
Date: Mon, 10 Jun 2024 15:30:37 +0100

start/end writeback combination incorrectly increments NR_WRITTEN counter,
eventhough the pages aren't written to disk.  Pages successfully stored in
zswap should just unlock folio and return from writepage.

Link: https://lkml.kernel.org/r/20240610143037.812955-1-usamaarif642@gmail.com
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: kernel-team@meta.com
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/page_io.c~mm-do-not-start-end-writeback-for-pages-stored-in-zswap
+++ a/mm/page_io.c
@@ -196,9 +196,7 @@ int swap_writepage(struct page *page, st
 		return ret;
 	}
 	if (zswap_store(folio)) {
-		folio_start_writeback(folio);
 		folio_unlock(folio);
-		folio_end_writeback(folio);
 		return 0;
 	}
 	if (!mem_cgroup_zswap_writeback_enabled(folio_memcg(folio))) {
_

Patches currently in -mm which might be from usamaarif642@gmail.com are

mm-do-not-start-end-writeback-for-pages-stored-in-zswap.patch


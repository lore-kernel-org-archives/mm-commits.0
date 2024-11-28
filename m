Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9C61DFE1
	for <mm-commits@vger.kernel.org>; Thu, 28 Nov 2024 01:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732756677; cv=none; b=eYRCHOEX1eThi0yNjbbQRLl1SowqQ5OMX1afqCh2ejrzIANcRgqhJhxhh/i5zN1PrZUOqrvPw9w0TPMCJ+T91TGAphV/wy/sglY6YAaldpZ7CpYUAGK4hHa/FGerD3LfXDTHoX+SeOysqCljgw5f5YKYAoN33Oq3wBrEjjWPu8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732756677; c=relaxed/simple;
	bh=noiWzeM/qsA9cW/KRtoTC+uLVsoviZbuM420wdrKJPo=;
	h=Date:To:From:Subject:Message-Id; b=se87OP314vFvojRm+1XTs3H9b1UajKxH9nyXV3O1P9fOqunqVz2UZIlcN0ds9GiiAAfB/FfYWZeppaRgeqVE/HGzgU57l7tBBEJG6+gV0cwm5qOZ1t0eERIgbWc4y/OGZkgTxYi26wlhHld9+PdGrObvl9OpOKs/g4+M5TOZ4pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E1GVAbNs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E1GVAbNs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C757C4CECC;
	Thu, 28 Nov 2024 01:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732756676;
	bh=noiWzeM/qsA9cW/KRtoTC+uLVsoviZbuM420wdrKJPo=;
	h=Date:To:From:Subject:From;
	b=E1GVAbNsHA7NJmw3F7ylIcCgiLXwtrufqd3vbOxGaIsyKrI53dy3J6hhdrwknG2SJ
	 Wttkdwo/q8WTCmtA91M0DtEZUMPihj45V8kMIss+KxBnafN93E8KL2OD2ptavY5xYI
	 n0k4CyaoHl9j5eiQ3OiKNKTeWr7yBP2xX20Gw0/0=
Date: Wed, 27 Nov 2024 17:17:56 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,honggyu.kim@sk.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-remove-duplicate-list_empty-quota-goals-check.patch added to mm-unstable branch
Message-Id: <20241128011756.8C757C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: remove duplicate list_empty quota->goals check
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-remove-duplicate-list_empty-quota-goals-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-remove-duplicate-list_empty-quota-goals-check.patch

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
From: Honggyu Kim <honggyu.kim@sk.com>
Subject: mm/damon/core: remove duplicate list_empty quota->goals check
Daye: Mon, 25 Nov 2024 13:56:55 +0900

damos_set_effective_quota() checks quota contidions but there are some
duplicate checks for quota->goals inside.

This patch reduces one of if statement to simplify the esz calculation
logic by setting esz as ULONG_MAX by default.

Link: https://lkml.kernel.org/r/20241125184307.41746-1-sj@kernel.org
Signed-off-by: Honggyu Kim <honggyu.kim@sk.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-remove-duplicate-list_empty-quota-goals-check
+++ a/mm/damon/core.c
@@ -1542,7 +1542,7 @@ static unsigned long damos_quota_score(s
 static void damos_set_effective_quota(struct damos_quota *quota)
 {
 	unsigned long throughput;
-	unsigned long esz;
+	unsigned long esz = ULONG_MAX;
 
 	if (!quota->ms && list_empty(&quota->goals)) {
 		quota->esz = quota->sz;
@@ -1564,10 +1564,7 @@ static void damos_set_effective_quota(st
 				quota->total_charged_ns;
 		else
 			throughput = PAGE_SIZE * 1024;
-		if (!list_empty(&quota->goals))
-			esz = min(throughput * quota->ms, esz);
-		else
-			esz = throughput * quota->ms;
+		esz = min(throughput * quota->ms, esz);
 	}
 
 	if (quota->sz && quota->sz < esz)
_

Patches currently in -mm which might be from honggyu.kim@sk.com are

mm-damon-core-remove-duplicate-list_empty-quota-goals-check.patch


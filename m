Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 763FE18E029
	for <mm-commits@vger.kernel.org>; Thu, 14 Nov 2024 23:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731627072; cv=none; b=A9vd/ZP2ZTLNbh/t1gY8GCn38G/1IGW7TuafqH/WENH7TxK9wJzAJMPVVmu2ESjShBVJDmdA23OMK6V36eFRcbgjoxI3JbI6pEe+s6lt6JzynEQCD9EF3dRCoUKmB+KZnpiLapTqzsVyEUMsHVemZCwxNjwy2dkSZ6IuSPr2crY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731627072; c=relaxed/simple;
	bh=wt6zwKli5gdFTJDS9JNy0qXJfwEkAsFIL+SYmliVJac=;
	h=Date:To:From:Subject:Message-Id; b=pPWXwnW9GUjj46LH5/xs3Hs+Uf1eZy0+rpJjJzL7JtK/HiD46upuRNEa/WtUfNjmrmCKOiAIpDR4t5FHLvtbOGxpzANBccAKS6KXutr0x0v/ZlU+4a8Lo4CHWUpt0bdMiKQ19nBxjT3xW/USYygz8gbJErOiXH37G6h/m+TK28w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uou8YlPU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uou8YlPU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28195C4CECD;
	Thu, 14 Nov 2024 23:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731627072;
	bh=wt6zwKli5gdFTJDS9JNy0qXJfwEkAsFIL+SYmliVJac=;
	h=Date:To:From:Subject:From;
	b=uou8YlPU3HlgJZ1Dt7E6zkB7FQPnjqQGoaR5nD5Ww+ZSfURIjNn9gjSAzCUFrTAYR
	 rZaEHgXMEUwcLgafKOhocg7Utsp0JaOn8L+Hkg84E9NQuMZ3UyMG2SXJyJEVhYr4I8
	 74ExHuYz8PvHP9miriAWartWmt/lRUfSNIfVOPMI=
Date: Thu, 14 Nov 2024 15:31:08 -0800
To: mm-commits@vger.kernel.org,wladislav.kw@gmail.com,vishal.moola@gmail.com,sj@kernel.org,oleksandr@natalenko.name,motiejus@jakstys.lt,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-mm-fix-compile-error.patch added to mm-hotfixes-unstable branch
Message-Id: <20241114233111.28195C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/mm: fix compile error
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     tools-mm-fix-compile-error.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-mm-fix-compile-error.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

Subject: tools/mm: fix compile error
Date: Tue, 12 Nov 2024 19:16:55 +0200

Add a missing semicolon.

Link: https://lkml.kernel.org/r/20241112171655.1662670-1-motiejus@jakstys.lt
Fixes: ece5897e5a10 ("tools/mm: -Werror fixes in page-types/slabinfo")
Signed-off-by: Motiejus Jak≈`tys <motiejus@jakstys.lt>
Closes: https://github.com/NixOS/nixpkgs/issues/355369
Reviewed-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Acked-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Cc: Wladislav Wiebe <wladislav.kw@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/mm/page-types.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/mm/page-types.c~tools-mm-fix-compile-error
+++ a/tools/mm/page-types.c
@@ -420,7 +420,7 @@ static void show_page(unsigned long voff
 	if (opt_file)
 		printf("%lx\t", voffset);
 	if (opt_list_cgroup)
-		printf("@%" PRIu64 "\t", cgroup)
+		printf("@%" PRIu64 "\t", cgroup);
 	if (opt_list_mapcnt)
 		printf("%" PRIu64 "\t", mapcnt);
 
_

Patches currently in -mm which might be from motiejus@jakstys.lt are



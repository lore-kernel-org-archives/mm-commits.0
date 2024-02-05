Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DACA4879C
	for <mm-commits@vger.kernel.org>; Mon,  5 Feb 2024 23:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707175416; cv=none; b=fTrE2pr1F1CjpWbaJ0Mb40ACbPfjAdztlXF8IDtnWeLbBYQa/IXbOxachV3lqaoSiwC6ZU7AtzKrE/R2rnWOxkpwQi/+MQiSdmNG03aXrkroHp6knUSh8ifI1zhJRa552NE+PqfqCKOdeaS6SKzHB39MVjoIXG+vMx7Gs1epaEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707175416; c=relaxed/simple;
	bh=7T2FYh5gQVegnDhR4mT8wKnnPLu8OlnE4y9nGZpE01U=;
	h=Date:To:From:Subject:Message-Id; b=PfJ81Jq5zVzGyYT1SvdTygPjQAjsAiRJXTjQ2rJh4ROXB7zYAbPJTee0I/STBPP4QG3XQwvd8E6dSIa0xYu7vQuuToa3Dv9sw2VE0Kcbj/Kh3FH1E0P9XpPhMJAwAFIi8/gfTdISk8QeLnpFQZfdw29L5ptPJOWsxv688Dlhj7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=go0RQcJp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="go0RQcJp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13370C433C7;
	Mon,  5 Feb 2024 23:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707175416;
	bh=7T2FYh5gQVegnDhR4mT8wKnnPLu8OlnE4y9nGZpE01U=;
	h=Date:To:From:Subject:From;
	b=go0RQcJpLTLY4Q48/+7cX6MybtuFzubP9VZ2bK8a9O+U+ozRKvE/jxHgAFnsD+mah
	 wuw62X8D9ZS1LnZVzUOloCRCUl7RoS+4FVXA3RzS6gidG21vightCuWIOlZUPk25m2
	 HkydG+bHZ21QM5yqSxh6ULk5kV1V9HQfPakKYtEY=
Date: Mon, 05 Feb 2024 15:23:35 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,gehao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-make-too_many_isolated-return-bool.patch added to mm-unstable branch
Message-Id: <20240205232336.13370C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmscan: make too_many_isolated return bool
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-make-too_many_isolated-return-bool.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-make-too_many_isolated-return-bool.patch

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
Subject: mm/vmscan: make too_many_isolated return bool
Date: Mon, 5 Feb 2024 12:26:18 +0800

too_many_isolated() should return bool as does the similar
too_many_isolated() in mm/compaction.c.

Link: https://lkml.kernel.org/r/20240205042618.108140-1-gehao@kylinos.cn
Signed-off-by: Hao Ge <gehao@kylinos.cn>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-make-too_many_isolated-return-bool
+++ a/mm/vmscan.c
@@ -1744,17 +1744,17 @@ bool folio_isolate_lru(struct folio *fol
  * the LRU list will go small and be scanned faster than necessary, leading to
  * unnecessary swapping, thrashing and OOM.
  */
-static int too_many_isolated(struct pglist_data *pgdat, int file,
+static bool too_many_isolated(struct pglist_data *pgdat, int file,
 		struct scan_control *sc)
 {
 	unsigned long inactive, isolated;
 	bool too_many;
 
 	if (current_is_kswapd())
-		return 0;
+		return false;
 
 	if (!writeback_throttling_sane(sc))
-		return 0;
+		return false;
 
 	if (file) {
 		inactive = node_page_state(pgdat, NR_INACTIVE_FILE);
_

Patches currently in -mm which might be from gehao@kylinos.cn are

mm-vmscan-change-the-type-of-file-from-int-to-bool.patch
mm-vmscan-make-too_many_isolated-return-bool.patch


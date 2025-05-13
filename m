Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849971EEA49
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119318; cv=none; b=cIZSBeP8lTUP9TM9Y3uo48sqzDtHJng5O+inZCZLsc6+HGmonjBIHzY78tGdB9uEz+bTr4CQ7w/Vg1gKxnooih86bq0cje4VauX/YcH5MqO1mNbX5yW2tjWXbbT7PF5aLHUWP8PQTcBmIcrCBhohZTDGB1VnjE+grESd4EOiVtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119318; c=relaxed/simple;
	bh=CVKffQ/XbV7G1Y3wKpCHsGNAyk64RjQtsl0YxFJD450=;
	h=Date:To:From:Subject:Message-Id; b=XI+cqW/z62bZkl3nONHxwywa2BEG/J+3DWc5D4YSwnefe5a7XTjB6DYfQavWxHPOMxk7PKMPbkxC2TiJw1dBu9aWrLNRnqCiifXGORa4ARZTwE8/+652ZjbtDFrRohKoJX9AizbCBhreMA2zK7MO2PGXReDzxKwvOOiIPVdSb+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IM3lSmAd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IM3lSmAd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E1BFC4CEE4;
	Tue, 13 May 2025 06:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119318;
	bh=CVKffQ/XbV7G1Y3wKpCHsGNAyk64RjQtsl0YxFJD450=;
	h=Date:To:From:Subject:From;
	b=IM3lSmAdIgC2oinzmbGZSulozTyvAgvys4uoIuSsvzmFJkn6INu5kb6i33drdgyJy
	 SqPTxNfGIANltA3Ca1UxoEmMtSw+i1JSFlHjJk43btkUWE+fQl/PBDaFPa+MWBXZYX
	 QBRi/Zfxkmgtvf9HLXxQ5RapM0aoeJxyPnef8l1g=
Date: Mon, 12 May 2025 23:55:16 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,thusharms@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-fix-spelling-mistake.patch removed from -mm tree
Message-Id: <20250513065518.4E1BFC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: docs/mm/damon/design: fix spelling mistake
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-fix-spelling-mistake.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Thushara.M.S <thusharms@gmail.com>
Subject: docs/mm/damon/design: fix spelling mistake
Date: Mon May  5 02:29:12 PM PDT 2025

The word accuracy was misspelled as "accruracy".

Signed-off-by: Thushara.M.S <thusharms@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-fix-spelling-mistake
+++ a/Documentation/mm/damon/design.rst
@@ -54,7 +54,7 @@ monitoring are address-space dependent.
 DAMON consolidates these implementations in a layer called DAMON Operations
 Set, and defines the interface between it and the upper layer.  The upper layer
 is dedicated for DAMON's core logics including the mechanism for control of the
-monitoring accruracy and the overhead.
+monitoring accuracy and the overhead.
 
 Hence, DAMON can easily be extended for any address space and/or available
 hardware features by configuring the core logic to use the appropriate
_

Patches currently in -mm which might be from thusharms@gmail.com are



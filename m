Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B366E22CBF3
	for <mm-commits@vger.kernel.org>; Wed, 19 Feb 2025 23:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740006775; cv=none; b=P5hM/jpMDTh4xLUA6AhJxSl81pMANzQQs1XJmgSfnLKteeWcs3cdwBkqESxfOmRkD64mO+n4kg5aQh/N8d9/3dcH3gEo6JRpRExg+txZKayJmZpHv6o0q4/uO1R1NWiVNUN9+4FicjFE03tDDwesQhtl/ZX57ur+nFRwWSsGlmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740006775; c=relaxed/simple;
	bh=7ZmXiFKFi85muBmQmeUxmpgQv1U7MJM7smUc3I6PcmA=;
	h=Date:To:From:Subject:Message-Id; b=n83qcw4oZFKL2JPtm62aul9lXvHNqcmjl8VseybnOP6PavZFL/Co6+FAHs2CfHYXOJ52FU48W1/ySaKIdr6tvE65BYmD3Z2EHKfENch0c9kCh7AxvwL5+cJTeIkjSjGkGds25vBnXbURgmnlW3KK0RZ3+RwlLoVah6qAOsnLgPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zI/AGzEf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zI/AGzEf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D189C4CED1;
	Wed, 19 Feb 2025 23:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740006775;
	bh=7ZmXiFKFi85muBmQmeUxmpgQv1U7MJM7smUc3I6PcmA=;
	h=Date:To:From:Subject:From;
	b=zI/AGzEfvLqRwKXnBw+BgBBMIOe+o74J5g9THSR93YzBVuCuI0jiyN6KOpdLpD8Wf
	 /xgV2MbtNtGdKQvXIQILaSA3WOrKopGGvIYRVAsvVy4D4Rc05VAh0YlHvLTwOPEuRE
	 po9SNAyREX140WDB79W+9rfO8GNCwlzyX9WXnL9Y=
Date: Wed, 19 Feb 2025 15:12:54 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,colin.i.king@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mincore-improve-performance-by-adding-an-unlikely-hint.patch added to mm-unstable branch
Message-Id: <20250219231255.1D189C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mincore: improve performance by adding an unlikely hint
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mincore-improve-performance-by-adding-an-unlikely-hint.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mincore-improve-performance-by-adding-an-unlikely-hint.patch

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
From: Colin Ian King <colin.i.king@gmail.com>
Subject: mm/mincore: improve performance by adding an unlikely hint
Date: Wed, 19 Feb 2025 08:36:07 +0000

Adding an unlikely() hint on the masked start comparison error return path
improves run-time performance of the mincore system call.

Benchmarking on an i9-12900 shows an improvement of 7ns on mincore calls
on a 256KB mmap'd region where 50% of the pages we resident.  Improvement
was from ~970 ns down to 963 ns, so a small ~0.7% improvement.

Results based on running 20 tests with turbo disabled (to reduce clock
freq turbo changes), with 10 second run per test and comparing the number
of mincores calls per second.  The % standard deviation of the 20 tests
was ~0.10%, so results are reliable.

Link: https://lkml.kernel.org/r/20250219083607.5183-1-colin.i.king@gmail.com
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Cc: Matthew Wilcow <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mincore.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mincore.c~mm-mincore-improve-performance-by-adding-an-unlikely-hint
+++ a/mm/mincore.c
@@ -239,7 +239,7 @@ SYSCALL_DEFINE3(mincore, unsigned long,
 	start = untagged_addr(start);
 
 	/* Check the start address: needs to be page-aligned.. */
-	if (start & ~PAGE_MASK)
+	if (unlikely(start & ~PAGE_MASK))
 		return -EINVAL;
 
 	/* ..and we need to be passed a valid user-space range */
_

Patches currently in -mm which might be from colin.i.king@gmail.com are

mm-mincore-improve-performance-by-adding-an-unlikely-hint.patch


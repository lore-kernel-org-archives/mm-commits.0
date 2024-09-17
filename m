Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31E515886A;
	Tue, 17 Sep 2024 08:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726560586; cv=none; b=ZX6V88L7KtV8s7KQ8w0+2E2QlSYuclW0JHxs7CMh+0q27h4QzrbdWEn8ehlXIeyytpnecJGbHLHy/ZdJosSBRvCTZlRpGQVY6WnCXRYMdcrMdh81ajfxWp6TSSFvDYzwEw2rhYv+0zwvXBvWC+yLPT/+gS/fqrfx3jai/44UMWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726560586; c=relaxed/simple;
	bh=30mFcxDi1JQ9lNr32l6tdAPC0/lP7p0hMsSStL5BpWs=;
	h=Date:To:From:Subject:Message-Id; b=jNVp+syW/hxFHWt+Po/UkwZ0WH0cqk++JVfgJT9SqKrZLl07dSXqyWGArM9w7xzj6Sb68t7UKG3+tOnhaLIG3NmCYPTXF07BHKQsTmKrSa2d342Uhb2yK7tZz6MW9a+CzuqLKXUG+alhLMDZbVN1JFcL0CIR1t5HKUASpRtrfTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MolwETd/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MolwETd/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28BCAC4CEC6;
	Tue, 17 Sep 2024 08:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726560585;
	bh=30mFcxDi1JQ9lNr32l6tdAPC0/lP7p0hMsSStL5BpWs=;
	h=Date:To:From:Subject:From;
	b=MolwETd/e8F26t9OwSUzWveAbJ1g4IbtYf4jesBYcfjg1hm7kQyqXurDqkZVbEpu8
	 HCZZnGnGlQ4DQsOoScbo/dDEH1II6ad6KTlPybVy1LV+3mmFqTzfrIfuycTcy2/rwx
	 VKi6Fc4NfpsILpS6CfiurAJ5g64N5Idys6l3SQzM=
Date: Tue, 17 Sep 2024 01:09:41 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-free-secondary-algorithms-names.patch removed from -mm tree
Message-Id: <20240917080945.28BCAC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: free secondary algorithms names
has been removed from the -mm tree.  Its filename was
     zram-free-secondary-algorithms-names.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: free secondary algorithms names
Date: Wed, 11 Sep 2024 11:54:56 +0900

We need to kfree() secondary algorithms names when reset zram device that
had multi-streams, otherwise we leak memory.

[senozhatsky@chromium.org: kfree(NULL) is legal]
  Link: https://lkml.kernel.org/r/20240917013021.868769-1-senozhatsky@chromium.org
Link: https://lkml.kernel.org/r/20240911025600.3681789-1-senozhatsky@chromium.org
Fixes: 001d92735701 ("zram: add recompression algorithm sysfs knob")
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/block/zram/zram_drv.c~zram-free-secondary-algorithms-names
+++ a/drivers/block/zram/zram_drv.c
@@ -2112,6 +2112,11 @@ static void zram_destroy_comps(struct zr
 		zram->num_active_comps--;
 	}
 
+	for (prio = ZRAM_SECONDARY_COMP; prio < ZRAM_MAX_COMPS; prio++) {
+		kfree(zram->comp_algs[prio]);
+		zram->comp_algs[prio] = NULL;
+	}
+
 	zram_comp_params_reset(zram);
 }
 
_

Patches currently in -mm which might be from senozhatsky@chromium.org are



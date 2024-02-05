Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B0A4EB20
	for <mm-commits@vger.kernel.org>; Mon,  5 Feb 2024 23:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707175951; cv=none; b=a2htuGjCsYhs6gtfUqYKSWY6lwf8aqMBKqJX4EAQtrQKk+dc+Yz4FQbky2zSeTV2YtlYOF2w86DpHl1kgH4nfB8AW62A6LdiQqvQzTcryx3Ho7agOF9urF+1So1H1zKqyACysve6bi+GPBgILaNgAN2Nz32H27u9COcgAQtWj9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707175951; c=relaxed/simple;
	bh=AaN+Es/ZQNMg06fPHkxWEjo5+cXTIX1eGUyOCcoFCVs=;
	h=Date:To:From:Subject:Message-Id; b=BlekUOpvshOSYTDpzYivoi7TI3BtEYF1WuX6uxWLGs38Spcq3jmo9njkeqfoMIL1PHdwxPB81akh1ZYT2rXPK4OaYKiQvJ77j650612UPPm6dAvTxfxiQBFwLU6jAaXcL1ZPCtIAvsrlczyjxF16G5gy6ldVoWYz3c9xG7ixAFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fBz4rxH0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fBz4rxH0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F904C433C7;
	Mon,  5 Feb 2024 23:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707175950;
	bh=AaN+Es/ZQNMg06fPHkxWEjo5+cXTIX1eGUyOCcoFCVs=;
	h=Date:To:From:Subject:From;
	b=fBz4rxH011Ic7dcFTqCgtvsWIi1fW0zzLsG9uTyn2pIC8L4t1wBbwz5DqqVVlDTwN
	 T+dbHeWL73XCYt0FQgf1Z9DmFyZmpuSPCTIQJdHVKH8Y6nU/mU0/qbN85vUHd8RE53
	 B+G/Io7FiV6of4XTvhXRXyDv3PQB7p4X9wISGRpQ=
Date: Mon, 05 Feb 2024 15:32:29 -0800
To: mm-commits@vger.kernel.org,hannes@cmpxchg.org,cerasuolodomenico@gmail.com,hezhongkun.hzk@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-z3fold-remove-unneeded-spinlock-in-z3fold_alloc.patch added to mm-unstable branch
Message-Id: <20240205233230.4F904C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/z3fold: remove unneeded spinlock in z3fold_alloc
has been added to the -mm mm-unstable branch.  Its filename is
     mm-z3fold-remove-unneeded-spinlock-in-z3fold_alloc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-z3fold-remove-unneeded-spinlock-in-z3fold_alloc.patch

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
From: Zhongkun He <hezhongkun.hzk@bytedance.com>
Subject: mm/z3fold: remove unneeded spinlock in z3fold_alloc
Date: Sun, 4 Feb 2024 21:15:43 +0800

The spinlock in z3fold_alloc() is used to protect page->lru, but now it
was removed in commit e774a7bc7f0ad ("mm: zswap: remove page reclaim logic
from z3fold"), so remove the spinlock too.

Link: https://lkml.kernel.org/r/20240204131543.1469661-1-hezhongkun.hzk@bytedance.com
Signed-off-by: Zhongkun He <hezhongkun.hzk@bytedance.com>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/z3fold.c~mm-z3fold-remove-unneeded-spinlock-in-z3fold_alloc
+++ a/mm/z3fold.c
@@ -1070,9 +1070,7 @@ found:
 	add_to_unbuddied(pool, zhdr);
 
 headless:
-	spin_lock(&pool->lock);
 	*handle = encode_handle(zhdr, bud);
-	spin_unlock(&pool->lock);
 	if (bud != HEADLESS)
 		z3fold_page_unlock(zhdr);
 
_

Patches currently in -mm which might be from hezhongkun.hzk@bytedance.com are

mm-z3fold-remove-unneeded-spinlock-in-z3fold_alloc.patch


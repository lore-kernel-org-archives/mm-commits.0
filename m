Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F74156880
	for <mm-commits@vger.kernel.org>; Tue, 17 Sep 2024 07:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726558330; cv=none; b=FhP3Q6kssQLcgjKmHWO5c9bGAr8N6OTKPSFFEXhj6TxUj5lukTg9G93wBKrVz1mGrN9EYIHPCRKZMYTHeJEy5PKs4veL/+Jb+zvDTWJx3k365l0yCBIDI8LoILk5Vvqm2xw3ggn8UiWYZl5q1ISaXCqzwDhMIMHYQZiE7HXy68M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726558330; c=relaxed/simple;
	bh=Q4+M6jVgUuWCSgBBQUEKV/k8tUPROLNMOsbgcwrcxNc=;
	h=Date:To:From:Subject:Message-Id; b=OAZS+qNI6DtU8ZXuvmwjW1MTXca6g8N9qLRV8FsUPk710AX66pAjhVcOo3b2BxdaVgTbVzN59q4crYC7MTyRxibhj7K6K8HsMdZHrA36efpOczDmD7pflv2yVG91edEKFZPQF3jJoF/jkG0LIYORzXCqYkUp8WO5o61dfy9p4Zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YfiKLLHR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YfiKLLHR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CCF2C4CECE;
	Tue, 17 Sep 2024 07:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726558329;
	bh=Q4+M6jVgUuWCSgBBQUEKV/k8tUPROLNMOsbgcwrcxNc=;
	h=Date:To:From:Subject:From;
	b=YfiKLLHRP+Zhufc9Njzs4pVlHx7lpfc6agAfby+FvTb256hfmmtQD4OPcN4YkoFV0
	 ECocPVatOlntFe3r6d00tcHPvyAuMHi+r6Dn76ugnqktVudXXMvbTi5qNyyYmviSfu
	 8/1xmecUnSLP66FVpU8f25LOIztsRQvRaI4LYIqg=
Date: Tue, 17 Sep 2024 00:32:07 -0700
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-free-secondary-algorithms-names-v2.patch added to mm-unstable branch
Message-Id: <20240917073209.7CCF2C4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram-free-secondary-algorithms-names-v2
has been added to the -mm mm-unstable branch.  Its filename is
     zram-free-secondary-algorithms-names-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-free-secondary-algorithms-names-v2.patch

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
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram-free-secondary-algorithms-names-v2
Date: Tue, 17 Sep 2024 10:30:05 +0900

kfree(NULL) is legal

Link: https://lkml.kernel.org/r/20240917013021.868769-1-senozhatsky@chromium.org
Fixes: 001d92735701 ("zram: add recompression algorithm sysfs knob")
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-free-secondary-algorithms-names-v2
+++ a/drivers/block/zram/zram_drv.c
@@ -2113,8 +2113,6 @@ static void zram_destroy_comps(struct zr
 	}
 
 	for (prio = ZRAM_SECONDARY_COMP; prio < ZRAM_MAX_COMPS; prio++) {
-		if (!zram->comp_algs[prio])
-			continue;
 		kfree(zram->comp_algs[prio]);
 		zram->comp_algs[prio] = NULL;
 	}
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zsmalloc-use-unique-zsmalloc-caches-names.patch
zram-free-secondary-algorithms-names.patch
zram-free-secondary-algorithms-names-v2.patch


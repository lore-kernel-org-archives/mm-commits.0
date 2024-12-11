Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E2F70814
	for <mm-commits@vger.kernel.org>; Wed, 11 Dec 2024 00:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733878225; cv=none; b=EHia1aTDzeDe9wnX1CeEy5kjIZTEV3D+xu+8QsPk/doVKAYHv/749aNP2x2oDsu9tNq9FjoA0KKJLzu0g0jYwbAv91tWQTJxp9j2noj60BLoZxtzNUkPwklypt8DPamT4X0Nm3AO7YX+xeeT1OMeaxCw/ZYArf7I6R4xsjGLiZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733878225; c=relaxed/simple;
	bh=wgirva9lm5T80frOQ3ohC2HPEVAzArH8j4BQAE8qlJk=;
	h=Date:To:From:Subject:Message-Id; b=czp2Feymv4qZzeRaNWAKCiRq0rdubugtdO11FZ2GmRhYLv3sSC4vnTSbBBKgaCx+eD+hp8GNjc2C44FaY+Y/ZOcdmocZD6yNSh8mv31Hlk0mT7iHQIEaRVmQTIYFiyDAi1EYeqAa5R30rJdHJdRXxwHM4GLgKBgbiwafvGjjUTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vN98OCyZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vN98OCyZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EFA2C4CED6;
	Wed, 11 Dec 2024 00:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733878225;
	bh=wgirva9lm5T80frOQ3ohC2HPEVAzArH8j4BQAE8qlJk=;
	h=Date:To:From:Subject:From;
	b=vN98OCyZLyMVTzbSjDBiJD2iTLrPChtk7hfrnCN11nj84MaoN+EpueQXBpTgqbLGC
	 bGMru83CzaiEv3z205bYQQkOJAJ+pQ/jh1n1bJFOhXTSvizrTV3/kxr6yQ+nMstqNw
	 P7Zm0k5SD4Rn95yKQzIP8kcYjh6TpWVMLOQh+otQ=
Date: Tue, 10 Dec 2024 16:50:24 -0800
To: mm-commits@vger.kernel.org,minchan@kernel.org,caiqingfu@ruijie.com.cn,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-panic-when-use-ext4-over-zram-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20241211005025.0EFA2C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram-panic-when-use-ext4-over-zram-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     zram-panic-when-use-ext4-over-zram-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-panic-when-use-ext4-over-zram-fix.patch

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
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram-panic-when-use-ext4-over-zram-fix
Date: Tue, 10 Dec 2024 18:38:35 +0900

simplify zram_write_page() -ENOMEM return

Link: https://lkml.kernel.org/r/20241210093835.GN16709@google.com
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: caiqingfu <caiqingfu@ruijie.com.cn>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/zram/zram_drv.c~zram-panic-when-use-ext4-over-zram-fix
+++ a/drivers/block/zram/zram_drv.c
@@ -1668,7 +1668,7 @@ compress_again:
 
 	if (last_comp_len && (last_comp_len != comp_len)) {
 		zs_free(zram->mem_pool, handle);
-		handle = (unsigned long)ERR_PTR(-ENOMEM);
+		handle = -ENOMEM;
 	}
 	/*
 	 * handle allocation has 2 paths:
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-panic-when-use-ext4-over-zram-fix.patch
zram-cond_resched-in-writeback-loop.patch
zram-free-slot-memory-early-during-write.patch
zram-remove-entry-element-member.patch
zram-factor-out-zram_same-write.patch
zram-factor-out-zram_huge-write.patch
zram-factor-out-different-page-types-read.patch


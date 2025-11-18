Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A0A1F463E
	for <mm-commits@vger.kernel.org>; Tue, 18 Nov 2025 03:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763437434; cv=none; b=cX1/yudqls5vhwoYlSeYVqJpoWYhubx/k3SJPh8KNBcyFJ6udIGQsPUqbUofUeVYzLyS8jasCuncM51/Fkh6RUNERPPt66PaYcaLZXX+/Jce4t5ruGO5Ig1a3aYvodX+Q2iBKNOtLdL5OoW9yuPxHu4ddfUIfZ6NQDM27YO4k8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763437434; c=relaxed/simple;
	bh=q8kDAz4n8aEhqJeOps6awqt2PJ+1o+LqY7Q2tUcroYU=;
	h=Date:To:From:Subject:Message-Id; b=KM4c+q4/jQt5gio7r8B4PHdejoORbMht7mzd1/JbJuw51V5h4+84vzWCM5D30wwD8OHaXqKAUMetvmZ6ytOAAN1BxQ9gVyQaN+CGIGa3YrCoQNqy6jjsgBDpTYoKK4pHiX8kxqyJ+1yiME3RZvMHOdkthId8QcLIlwsOBCdtGX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hl3CTj+A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hl3CTj+A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D694EC19423;
	Tue, 18 Nov 2025 03:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763437434;
	bh=q8kDAz4n8aEhqJeOps6awqt2PJ+1o+LqY7Q2tUcroYU=;
	h=Date:To:From:Subject:From;
	b=hl3CTj+A+cF4DZw7YgOqdCPt42ja08rPBQlwDF1sclE4BwDdASJ7THYPpVEaFFLKD
	 4TW5mPe5rw7gZXK3DkujWbZlDzKpqt0AC8WynB7x+SrRaPGPf2ukNEh0q6b80mDpBu
	 c1lztIoFxQ5iqIquw0xc1r5d/FyOpWgh1OYWGlMg=
Date: Mon, 17 Nov 2025 19:43:52 -0800
To: mm-commits@vger.kernel.org,ywen.chen@foxmail.com,richardycc@google.com,minchan@google.com,bgeffon@google.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-introduce-writeback-bio-batching-support-fix.patch added to mm-unstable branch
Message-Id: <20251118034353.D694EC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram-introduce-writeback-bio-batching-support-fix
has been added to the -mm mm-unstable branch.  Its filename is
     zram-introduce-writeback-bio-batching-support-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-introduce-writeback-bio-batching-support-fix.patch

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
Subject: zram-introduce-writeback-bio-batching-support-fix
Date: Tue, 18 Nov 2025 11:19:23 +0900

set slot index to current post-processing slot index

Link: https://lkml.kernel.org/r/20251118021953.1794503-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Minchan Kim <minchan@google.com>
Cc: Richard Chang <richardycc@google.com>
Cc: Yuwen Chen <ywen.chen@foxmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/block/zram/zram_drv.c~zram-introduce-writeback-bio-batching-support-fix
+++ a/drivers/block/zram/zram_drv.c
@@ -990,6 +990,7 @@ static int zram_writeback_slots(struct z
 			}
 		}
 
+		index = pps->index;
 		zram_slot_lock(zram, index);
 		/*
 		 * scan_slots() sets ZRAM_PP_SLOT and relases slot lock, so
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-introduce-writeback-bio-batching-support-fix.patch
zram-add-writeback-batch-size-device-attr.patch
zram-take-write-lock-in-wb-limit-store-handlers.patch
zram-drop-wb_limit_lock.patch


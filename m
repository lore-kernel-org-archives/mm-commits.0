Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA8217D355
	for <mm-commits@vger.kernel.org>; Mon, 28 Oct 2024 22:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730153419; cv=none; b=uTVHKv8nDyp4Gu2So8LTkCgAnSa5pGlwgOGNj1jYnSg80cMLrGKnuhrE1I2TUB+3CbkPTFmD4mSwE26I5rpop6bXyOrTDK8VHBKdKkGGXu90p9RiifB9xUjkl7XK9YDl57PUN6Ht9MMvlVyY++osFrXGdx4FLlOH1qDkyE5FHls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730153419; c=relaxed/simple;
	bh=RrPNYXonPJK7yqbHnDHEkeqVZY44Xb6kvC7uIOpnmw4=;
	h=Date:To:From:Subject:Message-Id; b=pMBeAKOXfeHkcJ8BN/xJ0lqeXgJVNuYbaU8rgrCAnWbDRR8gFCU3Dc/UlFVltTYGu5GCWesAAoq8sPR9Y5udcIHy1xm8ZTyyzcr4koK0rQ/kNRT2mLrublLsP7diqEGsvfxsJ0oZ93EHbVxiRVPhXf9hKP+G+IR7E6Wx7xNNZRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ur1Ne7Af; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ur1Ne7Af"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5481AC4CEC3;
	Mon, 28 Oct 2024 22:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730153418;
	bh=RrPNYXonPJK7yqbHnDHEkeqVZY44Xb6kvC7uIOpnmw4=;
	h=Date:To:From:Subject:From;
	b=Ur1Ne7Af1EWNJSboEPYrNWrQp5XNbLzysE6aDm0xOgR4UuB6wL8qDwINUw5KKSopx
	 v15Dx6chPxXzkkqJQogoxZU9msSBohfJr/R9gn8ksGNaucaiDiH3mTIv/vuf8LfnA1
	 8ONc8pW9k1svC8lc5+fLrJ+eUJH1+FpolXEGg2aw=
Date: Mon, 28 Oct 2024 15:10:17 -0700
To: mm-commits@vger.kernel.org,minchan@kernel.org,kawasin@google.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-clear-idle-flag-after-recompression.patch added to mm-unstable branch
Message-Id: <20241028221018.5481AC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: clear IDLE flag after recompression
has been added to the -mm mm-unstable branch.  Its filename is
     zram-clear-idle-flag-after-recompression.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-clear-idle-flag-after-recompression.patch

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
Subject: zram: clear IDLE flag after recompression
Date: Mon, 28 Oct 2024 16:34:57 +0900

Patch series "zram: IDLE flag handling fixes".

zram can wrongly preserve ZRAM_IDLE flag on its entries which can result
in premature post-processing (writeback and recompression) of such
entries.


This patch (of 2):

Recompression should clear ZRAM_IDLE flag on the entires it has accessed,
because otherwise some entries, specifically those for which recompression
has failed, become immediate candidate entries for another post-processing
(e.g.  writeback).

Consider the following case:
- recompression marks entries IDLE every 4 hours and attempts
  to recompress them
- some entries are incompressible, so we keep them intact and
  hence preserve IDLE flag
- writeback marks entries IDLE every 8 hours and writebacks
  IDLE entries, however we have IDLE entries left from
  recompression, so writeback prematurely writebacks those
  entries.

Link: https://lkml.kernel.org/r/20241028073529.1383980-1-senozhatsky@chromium.org
Link: https://lkml.kernel.org/r/20241028073529.1383980-2-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reported-by: Shin Kawamura <kawasin@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/block/zram/zram_drv.c~zram-clear-idle-flag-after-recompression
+++ a/drivers/block/zram/zram_drv.c
@@ -1864,6 +1864,13 @@ static int recompress_slot(struct zram *
 	if (ret)
 		return ret;
 
+	/*
+	* We touched this entry so mark it as non-IDLE. This makes sure that
+	* we don't preserve IDLE flag and don't incorrectly pick this entry
+	* for different post-processing type (e.g. writeback).
+	*/
+	zram_clear_flag(zram, index, ZRAM_IDLE);
+
 	class_index_old = zs_lookup_class_index(zram->mem_pool, comp_len_old);
 	/*
 	 * Iterate the secondary comp algorithms list (in order of priority)
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-introduce-zram_pp_slot-flag.patch
zram-permit-only-one-post-processing-operation-at-a-time.patch
zram-rework-recompress-target-selection-strategy.patch
zram-rework-recompress-target-selection-strategy-fix.patch
zram-rework-writeback-target-selection-strategy.patch
zram-do-not-mark-idle-slots-that-cannot-be-idle.patch
zram-reshuffle-zram_free_page-flags-operations.patch
zram-remove-under_wb-and-simplify-writeback.patch
zram-do-not-open-code-comp-priority-0.patch
zram-clear-idle-flag-after-recompression.patch
zram-clear-idle-flag-in-mark_idle.patch


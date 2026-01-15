Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B0823B61E
	for <mm-commits@vger.kernel.org>; Thu, 15 Jan 2026 23:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768518515; cv=none; b=QX9j0m2Qs0R4ayMb285sBhJX4qxYpIA7vKICG8eq5n1ou136YCDaFGTs/BD6XbyGZpapiBi4Jru8buF7eVE8Cti8VKUt1Da7TvCIvLKzok7YIF4AJkAVNp1nPsTHQjgFwc9uq5s4yWD+Sgg5K3XG4VZ7bHLtF2h+iC/0E/hM8jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768518515; c=relaxed/simple;
	bh=aq1d8VLiOoZze7wx/0QWWuqT5H5agB5fHMBU85jAgEM=;
	h=Date:To:From:Subject:Message-Id; b=juPpzZIILq8EdGw2JJnlLmSRAzxyJu7wF8Mqv8WUmVTil7QuRtT+/4BOgh7KfIfHaVI+xIc4zIYBso1ASW2OtbdLbgqPsPMrE/pfihGPOZd8gHwwrVzIT6U9ShS98gOUJCe9qqt6svHjvC0PHx350QoUK/94LAe5tUBlDqO1bN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uTjhJ0jv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uTjhJ0jv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1B4DC116D0;
	Thu, 15 Jan 2026 23:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768518515;
	bh=aq1d8VLiOoZze7wx/0QWWuqT5H5agB5fHMBU85jAgEM=;
	h=Date:To:From:Subject:From;
	b=uTjhJ0jvUgAaC7X98lVWL/avVrWGMIegazc2Cz/bFvzQs9vyLcUbMZTpZK6lt7PvU
	 SAXa2JZ8RrmZDH27egX7oXBi5GjYu698/HgMz48RIZf+fPXyWjlLc6Ie+Qo9gHTPm/
	 9IsT4i2s4q11L+JnTfW/t7jlJ2UtjVKbO663jawQ=
Date: Thu, 15 Jan 2026 15:08:34 -0800
To: mm-commits@vger.kernel.org,stevensd@google.com,richardycc@google.com,minchan@google.com,clm@meta.com,bgeffon@google.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-fixup-read_block_state.patch added to mm-unstable branch
Message-Id: <20260115230834.E1B4DC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: fixup read_block_state()
has been added to the -mm mm-unstable branch.  Its filename is
     zram-fixup-read_block_state.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-fixup-read_block_state.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: fixup read_block_state()
Date: Thu, 15 Jan 2026 12:30:06 +0900

ac_time is now in seconds, do not use ktime_to_timespec64()

Link: https://lkml.kernel.org/r/20260115033031.3818977-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reported-by: Chris Mason <clm@meta.com>
Closes: https://lkml.kernel.org/r/20260114124522.1326519-1-clm@meta.com
Cc: Brian Geffon <bgeffon@google.com>
Cc: David Stevens <stevensd@google.com>
Cc: Minchan Kim <minchan@google.com>
Cc: Richard Chang <richardycc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-fixup-read_block_state
+++ a/drivers/block/zram/zram_drv.c
@@ -1589,11 +1589,9 @@ static ssize_t read_block_state(struct f
 		if (!slot_allocated(zram, index))
 			goto next;
 
-		ts = ktime_to_timespec64(zram->table[index].attr.ac_time);
 		copied = snprintf(kbuf + written, count,
-			"%12zd %12lld.%06lu %c%c%c%c%c%c\n",
-			index, (s64)ts.tv_sec,
-			ts.tv_nsec / NSEC_PER_USEC,
+			"%12zd %12u.%06lu %c%c%c%c%c%c\n",
+			index, zram->table[index].attr.ac_time, 0,
 			test_slot_flag(zram, index, ZRAM_SAME) ? 's' : '.',
 			test_slot_flag(zram, index, ZRAM_WB) ? 'w' : '.',
 			test_slot_flag(zram, index, ZRAM_HUGE) ? 'h' : '.',
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-document-writeback_batch_size.patch
zram-move-bd_stat-to-writeback-section.patch
zram-rename-zram_free_page.patch
zram-switch-to-guard-for-init_lock.patch
zram-consolidate-device-attr-declarations.patch
zram-use-u32-for-entry-ac_time-tracking.patch
zram-rename-internal-slot-api.patch
zram-rename-internal-slot-api-fix.patch
zram-trivial-fix-of-recompress_slot-coding-styles.patch
zram-fixup-read_block_state.patch
zram-drop-pp_in_progress.patch
zsmalloc-use-actual-object-size-to-detect-spans.patch
zsmalloc-introduce-sg-list-based-object-read-api.patch
zram-rename-init_lock-to-dev_lock.patch


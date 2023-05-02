Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDCF6C77B73
	for <mm-commits@archiver.kernel.org>; Tue,  2 May 2023 19:50:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbjEBTuB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 2 May 2023 15:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjEBTuA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 2 May 2023 15:50:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C944811B
        for <mm-commits@vger.kernel.org>; Tue,  2 May 2023 12:49:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 616EA6284F
        for <mm-commits@vger.kernel.org>; Tue,  2 May 2023 19:49:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A46A9C433D2;
        Tue,  2 May 2023 19:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683056997;
        bh=bpAQGhors0+m7Z8bzlcZWenUBnR+s27nOPdD4c1x/NQ=;
        h=Date:To:From:Subject:From;
        b=tYD0GLc3yJjLb0/it+EepHxxSZ36kMeU3McaFdNq4uF0zsNX8AO+Cnki5hu71DkJ2
         x489D/jrnuG9DR3Td+cnJjbB7SKn5nIiZQmSIhV5F5JzLVHi6kHe2+SdWThTGwK8ei
         26HzIQ8vJgAKu5cvixYy7hkuALqZTjuCDO9zVxeE=
Date:   Tue, 02 May 2023 12:49:56 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        ying.huang@intel.com, willy@infradead.org, viro@zeniv.linux.org.uk,
        vbabka@suse.cz, mgorman@techsingularity.net,
        hsiangkao@linux.alibaba.com, hdanton@sina.com, brauner@kernel.org,
        dianders@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + migrate_pages-avoid-blocking-for-io-in-migrate_sync_light.patch added to mm-unstable branch
Message-Id: <20230502194957.A46A9C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: migrate_pages: avoid blocking for IO in MIGRATE_SYNC_LIGHT
has been added to the -mm mm-unstable branch.  Its filename is
     migrate_pages-avoid-blocking-for-io-in-migrate_sync_light.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/migrate_pages-avoid-blocking-for-io-in-migrate_sync_light.patch

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
From: Douglas Anderson <dianders@chromium.org>
Subject: migrate_pages: avoid blocking for IO in MIGRATE_SYNC_LIGHT
Date: Fri, 28 Apr 2023 13:54:38 -0700

The MIGRATE_SYNC_LIGHT mode is intended to block for things that will
finish quickly but not for things that will take a long time.  Exactly how
long is too long is not well defined, but waits of tens of milliseconds is
likely non-ideal.

When putting a Chromebook under memory pressure (opening over 90 tabs on a
4GB machine) it was fairly easy to see delays waiting for some locks in
the kcompactd code path of > 100 ms.  While the laptop wasn't amazingly
usable in this state, it was still limping along and this state isn't
something artificial.  Sometimes we simply end up with a lot of memory
pressure.

Putting the same Chromebook under memory pressure while it was running
Android apps (though not stressing them) showed a much worse result (NOTE:
this was on a older kernel but the codepaths here are similar).  Android
apps on ChromeOS currently run from a 128K-block, zlib-compressed,
loopback-mounted squashfs disk.  If we get a page fault from something
backed by the squashfs filesystem we could end up holding a folio lock
while reading enough from disk to decompress 128K (and then decompressing
it using the somewhat slow zlib algorithms).  That reading goes through
the ext4 subsystem (because it's a loopback mount) before eventually
ending up in the block subsystem.  This extra jaunt adds extra overhead. 
Without much work I could see cases where we ended up blocked on a folio
lock for over a second.  With more extreme memory pressure I could see up
to 25 seconds.

We considered adding a timeout in the case of MIGRATE_SYNC_LIGHT for the
two locks that were seen to be slow [1] and that generated much
discussion.  After discussion, it was decided that we should avoid waiting
for the two locks during MIGRATE_SYNC_LIGHT if they were being held for
IO.  We'll continue with the unbounded wait for the more full SYNC modes.

With this change, I couldn't see any slow waits on these locks with my
previous testcases.

NOTE: The reason I stated digging into this originally isn't because some
benchmark had gone awry, but because we've received in-the-field crash
reports where we have a hung task waiting on the page lock (which is the
equivalent code path on old kernels).  While the root cause of those
crashes is likely unrelated and won't be fixed by this patch, analyzing
those crash reports did point out these very long waits seemed like
something good to fix.  With this patch we should no longer hang waiting
on these locks, but presumably the system will still be in a bad shape and
hang somewhere else.

[1] https://lore.kernel.org/r/20230421151135.v2.1.I2b71e11264c5c214bc59744b9e13e4c353bc5714@changeid

Link: https://lkml.kernel.org/r/20230428135414.v3.1.Ia86ccac02a303154a0b8bc60567e7a95d34c96d3@changeid
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   49 ++++++++++++++++++++++++++-----------------------
 1 file changed, 26 insertions(+), 23 deletions(-)

--- a/mm/migrate.c~migrate_pages-avoid-blocking-for-io-in-migrate_sync_light
+++ a/mm/migrate.c
@@ -692,37 +692,32 @@ static bool buffer_migrate_lock_buffers(
 							enum migrate_mode mode)
 {
 	struct buffer_head *bh = head;
+	struct buffer_head *failed_bh;
 
-	/* Simple case, sync compaction */
-	if (mode != MIGRATE_ASYNC) {
-		do {
-			lock_buffer(bh);
-			bh = bh->b_this_page;
-
-		} while (bh != head);
-
-		return true;
-	}
-
-	/* async case, we cannot block on lock_buffer so use trylock_buffer */
 	do {
 		if (!trylock_buffer(bh)) {
-			/*
-			 * We failed to lock the buffer and cannot stall in
-			 * async migration. Release the taken locks
-			 */
-			struct buffer_head *failed_bh = bh;
-			bh = head;
-			while (bh != failed_bh) {
-				unlock_buffer(bh);
-				bh = bh->b_this_page;
-			}
-			return false;
+			if (mode == MIGRATE_ASYNC)
+				goto unlock;
+			if (mode == MIGRATE_SYNC_LIGHT && !buffer_uptodate(bh))
+				goto unlock;
+			lock_buffer(bh);
 		}
 
 		bh = bh->b_this_page;
 	} while (bh != head);
+
 	return true;
+
+unlock:
+	/* We failed to lock the buffer and cannot stall. */
+	failed_bh = bh;
+	bh = head;
+	while (bh != failed_bh) {
+		unlock_buffer(bh);
+		bh = bh->b_this_page;
+	}
+
+	return false;
 }
 
 static int __buffer_migrate_folio(struct address_space *mapping,
@@ -1156,6 +1151,14 @@ static int migrate_folio_unmap(new_page_
 		if (current->flags & PF_MEMALLOC)
 			goto out;
 
+		/*
+		 * In "light" mode, we can wait for transient locks (eg
+		 * inserting a page into the page table), but it's not
+		 * worth waiting for I/O.
+		 */
+		if (mode == MIGRATE_SYNC_LIGHT && !folio_test_uptodate(src))
+			goto out;
+
 		folio_lock(src);
 	}
 	locked = true;
_

Patches currently in -mm which might be from dianders@chromium.org are

migrate_pages-avoid-blocking-for-io-in-migrate_sync_light.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221852DAFB4
	for <mm-commits@vger.kernel.org>; Tue, 16 Dec 2025 02:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765851609; cv=none; b=HFEhpaYZnZUEyPfazJV2w449XK6rNskz9EjCEpZWYqbWYXdFmpvpcPfUamuHeL3AzXiwSfnjdxbxgLpAkKeKtUHkmogjCyBiXw2JFBaph5w1DsEzRNrNIxfdfPPTbYD/eJj857qQmna2wqG2AmHaN7Ipk0xssYScSxY1V2LUmCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765851609; c=relaxed/simple;
	bh=+53IEsUzpAavrRJbiVhUOab2EyoUoT7QztTBDQkWZ6o=;
	h=Date:To:From:Subject:Message-Id; b=CxhCmbt/FXs3qSBddi8/BnNwW1hA5Cm0Eg3pxm9uJHcM7Cs6wlOBv8DGLMyolKPckDiLxvnkoexeT/vW07M9vrgl/EJsKGWRwtQT2n+Nr8iVhWXbDxMe7F9hVH+XisHNPy15/G/hIGS50pJXmqfIjSiS0Xt8YXFASMgF/LbMpqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hUieUilW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hUieUilW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E858CC4CEF5;
	Tue, 16 Dec 2025 02:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765851609;
	bh=+53IEsUzpAavrRJbiVhUOab2EyoUoT7QztTBDQkWZ6o=;
	h=Date:To:From:Subject:From;
	b=hUieUilWYQSb1L0NI2ikLlms6ABlsjo5NdJUygnAfHrDR7MJbr6Vuuejghu9SYqCX
	 Kmdki5jwr93HILjRtg70vHAuQNbmgDj9QNBPU2N5anPUVa3Lt0MiqZvKhWS6+413Mq
	 eMJtGLucH8Ookx/TjlPOmUq6tE8h7sKk4sBZVb60=
Date: Mon, 15 Dec 2025 18:20:08 -0800
To: mm-commits@vger.kernel.org,stevensd@google.com,richardycc@google.com,minchan@google.com,bgeffon@google.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-consolidate-device-attr-declarations.patch added to mm-new branch
Message-Id: <20251216022008.E858CC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: consolidate device-attr declarations
has been added to the -mm mm-new branch.  Its filename is
     zram-consolidate-device-attr-declarations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-consolidate-device-attr-declarations.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Subject: zram: consolidate device-attr declarations
Date: Mon, 1 Dec 2025 18:47:54 +0900

Do not spread device attributes declarations across the file, move
io_stat, mm_stat, debug_stat to a common device-attr section.

Link: https://lkml.kernel.org/r/20251201094754.4149975-8-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: David Stevens <stevensd@google.com>
Cc: Minchan Kim <minchan@google.com>
Cc: Richard Chang <richardycc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-consolidate-device-attr-declarations
+++ a/drivers/block/zram/zram_drv.c
@@ -1966,10 +1966,6 @@ static ssize_t debug_stat_show(struct de
 	return ret;
 }
 
-static DEVICE_ATTR_RO(io_stat);
-static DEVICE_ATTR_RO(mm_stat);
-static DEVICE_ATTR_RO(debug_stat);
-
 static void zram_meta_free(struct zram *zram, u64 disksize)
 {
 	size_t num_pages = disksize >> PAGE_SHIFT;
@@ -3008,6 +3004,9 @@ static const struct block_device_operati
 	.owner = THIS_MODULE
 };
 
+static DEVICE_ATTR_RO(io_stat);
+static DEVICE_ATTR_RO(mm_stat);
+static DEVICE_ATTR_RO(debug_stat);
 static DEVICE_ATTR_WO(compact);
 static DEVICE_ATTR_RW(disksize);
 static DEVICE_ATTR_RO(initstate);
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-document-writeback_batch_size.patch
zram-move-bd_stat-to-writeback-section.patch
zram-rename-zram_free_page.patch
zram-switch-to-guard-for-init_lock.patch
zram-consolidate-device-attr-declarations.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3478D1DF759
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 01:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768960191; cv=none; b=Gkkjb5ZqGjt99Bs6eQgs/w+eP/FsGu1j6io40btJgz7OHSmtWmPty3Ev+IgG0l0ZOhuLrJeAUPwm8pwsonJkJh7w/H40cmzQ7aoI3avzExrZDHjiuMoOGDCnSRclxnkCZqECvMM7Bczo7hrddTsfhlfm1Ti1jYIksC0VYkxMUAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768960191; c=relaxed/simple;
	bh=eopED7koZwDIXfXvjvUEOFkVbDpZxjrMjvOXA5orHnE=;
	h=Date:To:From:Subject:Message-Id; b=i/AbiN6K917OSnfdkcuAs7gNRY4uyAg2IgEK4vVFHfilRLghsta2JK3YoByz5tpidIuwjGXlFx8HL++4mO4ym26n60uWWBHHdbMCzpz7hUhTBDmN8Pu1uQoPWnALj+/QnS2oROD1Gc+QGBEq3AGXUqvZAJG/ilEkYrKN2ePpLgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zpdS1jRr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zpdS1jRr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF204C16AAE;
	Wed, 21 Jan 2026 01:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768960190;
	bh=eopED7koZwDIXfXvjvUEOFkVbDpZxjrMjvOXA5orHnE=;
	h=Date:To:From:Subject:From;
	b=zpdS1jRr+hLjdrvsGoIq/effkcGZTNBM1RY2xvXnHI4PR4NnPjzCZNswlJuoUNDK+
	 0ZL1/7c+IomLJRSAQlvsi28LKZt+wySl2P5+v8jbjFZuaYtUMNvOkO75TRjfY4j/t3
	 t9ie/84ev09Lr+N5g1HDCf4I7iYLrKOL+/RGJSuM=
Date: Tue, 20 Jan 2026 17:49:49 -0800
To: mm-commits@vger.kernel.org,clm@meta.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] zram-rename-internal-slot-api-fix.patch removed from -mm tree
Message-Id: <20260121014949.EF204C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: fixup mark_slot_accessed()
has been removed from the -mm tree.  Its filename was
     zram-rename-internal-slot-api-fix.patch

This patch was dropped because it was folded into zram-rename-internal-slot-api.patch

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: fixup mark_slot_accessed()
Date: Thu, 15 Jan 2026 12:19:00 +0900

mark_slot_accessed() should continue using ktime_get_boottime_seconds()

Link: https://lkml.kernel.org/r/20260115031922.3813659-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reported-by: Chris Mason <clm@meta.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/zram/zram_drv.c~zram-rename-internal-slot-api-fix
+++ a/drivers/block/zram/zram_drv.c
@@ -191,7 +191,7 @@ static void mark_slot_accessed(struct zr
 	clear_slot_flag(zram, index, ZRAM_IDLE);
 	clear_slot_flag(zram, index, ZRAM_PP_SLOT);
 #ifdef CONFIG_ZRAM_TRACK_ENTRY_ACTIME
-	zram->table[index].attr.ac_time = ktime_get_boottime();
+	zram->table[index].attr.ac_time = (u32)ktime_get_boottime_seconds();
 #endif
 }
 
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-document-writeback_batch_size.patch
zram-move-bd_stat-to-writeback-section.patch
zram-rename-zram_free_page.patch
zram-switch-to-guard-for-init_lock.patch
zram-consolidate-device-attr-declarations.patch
zram-use-u32-for-entry-ac_time-tracking.patch
zram-rename-internal-slot-api.patch
zram-trivial-fix-of-recompress_slot-coding-styles.patch
zram-fixup-read_block_state.patch
zram-drop-pp_in_progress.patch
zsmalloc-use-actual-object-size-to-detect-spans.patch
zsmalloc-introduce-sg-list-based-object-read-api.patch
zsmalloc-introduce-sg-list-based-object-read-api-fix.patch
zram-rename-init_lock-to-dev_lock.patch
zsmalloc-make-common-caches-global.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4739C3168EB
	for <mm-commits@vger.kernel.org>; Thu, 15 Jan 2026 22:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768514991; cv=none; b=E+VBneJskLt1u1MVr+ze5fb1gcHFHv+WKv/3Bv/ZBFzal4y+lZLKG5Ua6spOrOUjh1/RsCUA3fS7zCiELdla3acfTsEUmltRW+hY8wAo9SHj0b46PHT6ANm8RASutJwVBQiwFSgmwAiLAHVs8oBZmoYI9V4gFTt0caKABSwm5Fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768514991; c=relaxed/simple;
	bh=wLkRh96T3VSShF/Fv9R4DoKaDrNmmW4ZDCRaM447Ak8=;
	h=Date:To:From:Subject:Message-Id; b=qNaA1RjEoLjd1FLg7LUIkayHY4C2FxkScjhXVg7bqKU2ZmcpMY3SxmJpOJ9K//2cDiOM5KhVTPQpbaSJx90l0zjki2kYZ0vSEBCUFfuB2D52NPx0LdjEzXOZPBBaYHrt/SD81ROb5eIIgV8C4nj8cE8HMJUcEXB5msu3NgQAxYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nifdmMlY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nifdmMlY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3C1AC2BC87;
	Thu, 15 Jan 2026 22:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768514990;
	bh=wLkRh96T3VSShF/Fv9R4DoKaDrNmmW4ZDCRaM447Ak8=;
	h=Date:To:From:Subject:From;
	b=nifdmMlYXrsd4zgvvw2lsZ9gHYvVwq9XegJxoLECQobsTSUJr/hotjyjHVY/UC9oy
	 60g5xfQiwqNwrgCwhUKIzQ9v0ZwpkW2zTTmTZ6NeVwujGbiHjc1taweDzemtTcQ2K6
	 djcHw2EX8FZaBeyp7ND+KWev/F3kdxAdGhKBHjio=
Date: Thu, 15 Jan 2026 14:09:49 -0800
To: mm-commits@vger.kernel.org,clm@meta.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-rename-internal-slot-api-fix.patch added to mm-unstable branch
Message-Id: <20260115220950.C3C1AC2BC87@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: fixup mark_slot_accessed()
has been added to the -mm mm-unstable branch.  Its filename is
     zram-rename-internal-slot-api-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-rename-internal-slot-api-fix.patch

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
zram-rename-internal-slot-api-fix.patch
zram-trivial-fix-of-recompress_slot-coding-styles.patch
zram-drop-pp_in_progress.patch
zsmalloc-use-actual-object-size-to-detect-spans.patch
zsmalloc-introduce-sg-list-based-object-read-api.patch
zram-rename-init_lock-to-dev_lock.patch


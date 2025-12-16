Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D1C2E1758
	for <mm-commits@vger.kernel.org>; Tue, 16 Dec 2025 02:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765852053; cv=none; b=QMMLD6K2afRF7iqAYUl2GovWrtdwDTqkQGSuU8ptjLbOhSp9EnXQhY+pEccEvgsZtXHfKNYiezvFXptnAMdfs9/uIr2tCaCx2AXsIZp9nB/c77MV7s3ZdyefkotseApGFlwAg5KPS7cWEhV27fqSs+qSCLky5p/V213ScTEulMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765852053; c=relaxed/simple;
	bh=OCvyXiy1z/MxlXnBrZHTg5jYyIkr+3QMCt0eidjlpCg=;
	h=Date:To:From:Subject:Message-Id; b=Ud7CZi52lWqf2pXXWh6gqYscVAE6d7L6vR6C6HRerT2lFPZ/twQ6yTNOuX7vhGc0NFk+qX+nJIj7WUvfiNQKqIF1yOQeVEHrUhYr6NT3fUtWx0EZcVjJ2Pk9j1D75dtsQCu9FjplrOWBiIRpQEwBipOHHbLgzqPHEqKYTDFOc/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V/v/Nfcu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V/v/Nfcu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60ED7C4CEF5;
	Tue, 16 Dec 2025 02:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765852052;
	bh=OCvyXiy1z/MxlXnBrZHTg5jYyIkr+3QMCt0eidjlpCg=;
	h=Date:To:From:Subject:From;
	b=V/v/Nfcutx5Os/+pqySAjaM1C7j47/wlFN7b0oktjjaXSAiaGxwgnt3W6+rEnQ257
	 O72v0FYS9nU1+OGb8p1njjUTaRfPN1Yo6R5/5x+GKUjYDe36zKoREd/5+FRfUSkX2g
	 a7/q3OQf9zE5doVC08MEyRZGkOK20gwuO4uTLlEg=
Date: Mon, 15 Dec 2025 18:27:31 -0800
To: mm-commits@vger.kernel.org,stevensd@google.com,richardycc@google.com,minchan@google.com,bgeffon@google.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-trivial-fix-of-recompress_slot-coding-styles.patch added to mm-new branch
Message-Id: <20251216022732.60ED7C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: trivial fix of recompress_slot() coding styles
has been added to the -mm mm-new branch.  Its filename is
     zram-trivial-fix-of-recompress_slot-coding-styles.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-trivial-fix-of-recompress_slot-coding-styles.patch

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
Subject: zram: trivial fix of recompress_slot() coding styles
Date: Mon, 15 Dec 2025 14:47:13 +0900

A minor fixup of 80-cols breakage in recompress_slot() comment and
zs_malloc() call.

Link: https://lkml.kernel.org/r/ff3254847dbdc6fbd2e3fed53c572a261d60b7b6.1765775954.git.senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: David Stevens <stevensd@google.com>
Cc: Minchan Kim <minchan@google.com>
Cc: Richard Chang <richardycc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-trivial-fix-of-recompress_slot-coding-styles
+++ a/drivers/block/zram/zram_drv.c
@@ -2517,14 +2517,15 @@ static int recompress_slot(struct zram *
 	 * avoid direct reclaim.  Allocation error is not fatal since
 	 * we still have the old object in the mem_pool.
 	 *
-	 * XXX: technically, the node we really want here is the node that holds
-	 * the original compressed data. But that would require us to modify
-	 * zsmalloc API to return this information. For now, we will make do with
-	 * the node of the page allocated for recompression.
+	 * XXX: technically, the node we really want here is the node that
+	 * holds the original compressed data. But that would require us to
+	 * modify zsmalloc API to return this information. For now, we will
+	 * make do with the node of the page allocated for recompression.
 	 */
 	handle_new = zs_malloc(zram->mem_pool, comp_len_new,
 			       GFP_NOIO | __GFP_NOWARN |
-			       __GFP_HIGHMEM | __GFP_MOVABLE, page_to_nid(page));
+			       __GFP_HIGHMEM | __GFP_MOVABLE,
+			       page_to_nid(page));
 	if (IS_ERR_VALUE(handle_new)) {
 		zcomp_stream_put(zstrm);
 		return PTR_ERR((void *)handle_new);
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


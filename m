Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E813F36B912
	for <mm-commits@vger.kernel.org>; Sat, 29 Aug 2026 20:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788035928; cv=none; b=IN5kB7CcosRoGbAYG2xemSFbad66YkwpnntQNQw+Gx6hwxrMfRbWBrk7NqPR09tDUOKrp59hQvJ7szqwmn4GVlbxOwfcPjg22uUlpXfkVpJSoZXOIPGGMZEtNWiaKA1TFLFY+o8tY+vl0jfyHckiBqxrEM5RH2zAJhA5eRHLqHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788035928; c=relaxed/simple;
	bh=YQwtnRDOx/9bd9mSciRn7FWGETD5/Ph0fBAJjSvvbK0=;
	h=Date:To:From:Subject:Message-Id; b=c5elfWijfb+6wd/Uuj471s1QK2sRu60tL3AFenq7kAGccjFQH7vYo5XvXohPkmp826U5eM6L//fLD4v5UaNoAmV88MKUnR81lvOaytYh/M1H9zQ7NlCH+PGBMW+fS2lYxjJEMKJ9AffPPjv9YcJn4htAi8q13stIrsKFauqyyu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0ujnjMq6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0ujnjMq6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 789FF1F000E9;
	Sat, 29 Aug 2026 20:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788035926;
	bh=3FJgIXe/dJDxnn6S5tcE8CCSRK2J8opke65Vj7qImX4=;
	h=Date:To:From:Subject;
	b=0ujnjMq6kPKZyUAWnZp3nj10RPpvs83QLOXrVlTHAykTpPB/ZCMyVQWYVjZyet9cO
	 fkW/BFpkT39JMNUjl3hB4f0RHcfrNateTJJNPcgTTR+qBDf5t2ILMUMPXUNfdsZtsw
	 hKXLV393upClCKxCctFuXi7mxk5K/Uw3J+ekocO8=
Date: Sat, 29 Aug 2026 13:38:46 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,ljs@kernel.org,hannes@cmpxchg.org,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_io-rename-bio_associate_blkg_from_page.patch added to mm-new branch
Message-Id: <20260829203846.789FF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_io: rename bio_associate_blkg_from_page()
has been added to the -mm mm-new branch.  Its filename is
     mm-page_io-rename-bio_associate_blkg_from_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_io-rename-bio_associate_blkg_from_page.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Tal Zussman <tz2294@columbia.edu>
Subject: mm/page_io: rename bio_associate_blkg_from_page()
Date: Sat, 29 Aug 2026 15:09:03 -0400

This function takes a folio.  Rename it to bio_associate_blkg_from_folio()
accordingly.  While at it, convert the macro in the !CONFIG_MEMCG ||
!CONFIG_BLK_CGROUP case to a function.

Link: https://lore.kernel.org/20260829-b4-page_io-folios-v2-4-649728091117@columbia.edu
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/page_io.c~mm-page_io-rename-bio_associate_blkg_from_page
+++ a/mm/page_io.c
@@ -277,7 +277,7 @@ static bool folio_blkg_can_merge(struct
 	return can_merge;
 }
 
-static void bio_associate_blkg_from_page(struct bio *bio, struct folio *folio)
+static void bio_associate_blkg_from_folio(struct bio *bio, struct folio *folio)
 {
 	struct cgroup_subsys_state *css;
 
@@ -298,7 +298,9 @@ static bool folio_blkg_can_merge(struct
 {
 	return true;
 }
-#define bio_associate_blkg_from_page(bio, folio)		do { } while (0)
+static void bio_associate_blkg_from_folio(struct bio *bio, struct folio *folio)
+{
+}
 #endif /* CONFIG_MEMCG && CONFIG_BLK_CGROUP */
 
 static mempool_t *sio_pool;
@@ -596,7 +598,7 @@ static void swap_bdev_submit_write(struc
 			REQ_OP_WRITE | REQ_SWAP);
 	bio->bi_iter.bi_size = sio->len;
 	bio->bi_iter.bi_sector = swap_folio_sector(bio_first_folio_all(bio));
-	bio_associate_blkg_from_page(bio, bio_first_folio_all(bio));
+	bio_associate_blkg_from_folio(bio, bio_first_folio_all(bio));
 
 	if (ctx->sis->flags & SWP_SYNCHRONOUS_IO) {
 		submit_bio_wait(bio);
_

Patches currently in -mm which might be from tz2294@columbia.edu are

mm-page_io-convert-write-completion-handlers-to-folios.patch
mm-remove-pagereclaim.patch
mm-page_io-use-swap-entries-directly-in-zeromap-helpers.patch
mm-page_io-rename-bio_associate_blkg_from_page.patch
mm-page_io-refer-to-folios-in-swap_writeout-comments.patch
mm-swap-rename-__swap_writepage-to-__swap_writeout.patch


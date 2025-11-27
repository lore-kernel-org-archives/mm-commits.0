Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F206B223336
	for <mm-commits@vger.kernel.org>; Thu, 27 Nov 2025 20:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764274359; cv=none; b=PaGZboUNJrONOyWjYjvhYCiypd9Wdt1aiurL4NICrs7qL1zHNDO9rHnTv+LpOprlIuEvYkqZMpI12aVqrJeruVuqhZ1uvIruvLZJ+5p0v0MQBXflp8+LyPrb8Byrm9DHEIMdWd/5B/8muqJYSnEVnOGlw4h0kiYj6FigAZppS9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764274359; c=relaxed/simple;
	bh=y1nJTxhq8Rr0ZyXsVwmp65NUI/nOxU7XZHvTnuJSpsY=;
	h=Date:To:From:Subject:Message-Id; b=rn4EDY0x8ml7rb4dMLGSsE1lfDLXlGHEopKCh5IlYcqWPQJ9P3UxI0t1+5zcyFtV98UGnqa5sskxHiCczRinlj9sHkT/zOPYHqbTs6wmhFOCjyqjSTrovyzl5/BUTiJBWNjkdw3nhU6o8HIB0gLd9tOJrpVlkpPI/rnkPkOIuXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q9a5+udW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q9a5+udW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C322C4CEF8;
	Thu, 27 Nov 2025 20:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764274358;
	bh=y1nJTxhq8Rr0ZyXsVwmp65NUI/nOxU7XZHvTnuJSpsY=;
	h=Date:To:From:Subject:From;
	b=Q9a5+udWUqgZxaDb4KUIyaRiLDjTVJmI9J1VXP67HMI3deQOWhnfr3SEQITlg5wWO
	 jeMTKCpvHSHUOWO8s7SIB9FfsLzc07AhmhKedzGnf6PeLAfl/3Bko2Js5P+dmP8xus
	 J4a+ZcKGUoxUpHgyLijO7V/ALUlmnEoDPiNe+nC4=
Date: Thu, 27 Nov 2025 12:12:37 -0800
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,youngjun.park@lge.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swapfile-use-plist_for_each_entry-in-__folio_throttle_swaprate.patch added to mm-unstable branch
Message-Id: <20251127201238.7C322C4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swapfile: use plist_for_each_entry in __folio_throttle_swaprate
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swapfile-use-plist_for_each_entry-in-__folio_throttle_swaprate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swapfile-use-plist_for_each_entry-in-__folio_throttle_swaprate.patch

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
From: Youngjun Park <youngjun.park@lge.com>
Subject: mm/swapfile: use plist_for_each_entry in __folio_throttle_swaprate
Date: Thu, 27 Nov 2025 19:03:03 +0900

The loop breaks immediately after finding the first swap device and
never modifies the list. Replace plist_for_each_entry_safe() with
plist_for_each_entry() and remove the unused next variable.

Link: https://lkml.kernel.org/r/20251127100303.783198-3-youngjun.park@lge.com
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/swapfile.c~mm-swapfile-use-plist_for_each_entry-in-__folio_throttle_swaprate
+++ a/mm/swapfile.c
@@ -4023,7 +4023,7 @@ static bool __has_usable_swap(void)
 
 void __folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
 {
-	struct swap_info_struct *si, *next;
+	struct swap_info_struct *si;
 
 	if (!(gfp & __GFP_IO))
 		return;
@@ -4042,8 +4042,7 @@ void __folio_throttle_swaprate(struct fo
 		return;
 
 	spin_lock(&swap_avail_lock);
-	plist_for_each_entry_safe(si, next, &swap_avail_head,
-				  avail_list) {
+	plist_for_each_entry(si, &swap_avail_head, avail_list) {
 		if (si->bdev) {
 			blkcg_schedule_throttle(si->bdev->bd_disk, true);
 			break;
_

Patches currently in -mm which might be from youngjun.park@lge.com are

mm-swapfile-fix-list-iteration-when-next-node-is-removed-during-discard.patch
mm-swapfile-use-plist_for_each_entry-in-__folio_throttle_swaprate.patch


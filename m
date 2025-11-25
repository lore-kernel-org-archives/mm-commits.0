Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57EB328B6C
	for <mm-commits@vger.kernel.org>; Tue, 25 Nov 2025 16:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764089723; cv=none; b=ZsZngEXAUDisCVEZ09K6zZC6wu/S3Nm7qMfILYpTjIXGYe+cY4LQLHLL6eH1G8f4XUovVU9k5z/br2hIRxa4Jm+1uNonsV18IFBk/CWvaqZIueqwGPaoozAU843MPtkumPbyYvcH5vc5msQITl3omUEiqcEcp4QdISQzX4D7GY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764089723; c=relaxed/simple;
	bh=yztd6rkdoxcA4R64Zd4OBj8Ba4CRgp494hC6/f2E8N0=;
	h=Date:To:From:Subject:Message-Id; b=ePNLYKLW4+JsrsLNhf/vVLjo8acD7aEHWz1PUiAqdeo35W+vB65Lvv/0BD9K2pTEZ8QS4/KpJRlJx3l5KAZUlv4CxQ35LMKsR3aoQgsmzOqyHxo6BGZJFiwq0IdS7PIVsQ0yhpapO6r0MRPaiAzODsoe426qHg3KrIlkylExt1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZE/v4W7J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZE/v4W7J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DADDC4CEF1;
	Tue, 25 Nov 2025 16:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764089723;
	bh=yztd6rkdoxcA4R64Zd4OBj8Ba4CRgp494hC6/f2E8N0=;
	h=Date:To:From:Subject:From;
	b=ZE/v4W7J72Uyzv04MhUKEgYYuep0bXprPrey3nVl0UiSpByHrauQjuTjwhtmXrpy2
	 2GWKUOWaO8rguK29px4z1By/mPKZ2vQ44ub39rEO33fSYbmlvhQjRGKLDrkhqTq0ln
	 ah7e6V8IX4RWGUrHYyZsN//VdY3rFRdJxV9bYVLg=
Date: Tue, 25 Nov 2025 08:55:22 -0800
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,youngjun.park@lge.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swapfile-use-plist_for_each_entry-in-__folio_throttle_swaprate.patch added to mm-new branch
Message-Id: <20251125165523.6DADDC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swapfile: use plist_for_each_entry in __folio_throttle_swaprate
has been added to the -mm mm-new branch.  Its filename is
     mm-swapfile-use-plist_for_each_entry-in-__folio_throttle_swaprate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swapfile-use-plist_for_each_entry-in-__folio_throttle_swaprate.patch

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
From: Youngjun Park <youngjun.park@lge.com>
Subject: mm/swapfile: use plist_for_each_entry in __folio_throttle_swaprate
Date: Wed, 26 Nov 2025 01:30:27 +0900

The loop breaks immediately after finding the first swap device and never
modifies the list.  Replace plist_for_each_entry_safe() with
plist_for_each_entry() and remove the unused next variable.

Link: https://lkml.kernel.org/r/20251125163027.4165450-3-youngjun.park@lge.com
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
Cc: Baoquan He <bhe@redhat.com>
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

mm-swapfile-fix-list-iteration-in-swap_sync_discard.patch
mm-swapfile-use-plist_for_each_entry-in-__folio_throttle_swaprate.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3FF329388
	for <mm-commits@vger.kernel.org>; Tue, 25 Nov 2025 16:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764089723; cv=none; b=UTr9xipASVkxK61pT/q2d2bM7eSJIUQXjD9suHkzw4zw62Mz19bqtllp/wKq7kAOWWTGejFrLVA7NfQnhXo2Og3cdFk9B4rxF7W/dFjLpiOTGS87Wu8PTvkWcUj393TyNzIH/adcjIROJ7VLTMhQmiBOQWpW0zep4ToGbIcYoK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764089723; c=relaxed/simple;
	bh=uN9ndgyzet6QF892LabdZnzzqrYdJt+QMPsnwklvTqU=;
	h=Date:To:From:Subject:Message-Id; b=b/IB5eW8Ag7y0wZaCGJBn1NbOMsMBb+6X1qP/fgHgxRfi3NVMvutE+8QwA1UeUneEwA0Iz3i4iKbAmuER8gef1vb6nrjSjSVBTMFP/I+BfyXy+UeAVLrWErRPWaMHQmirhvfnzlqKfUUluV8uqIjb1ncwD5fTbQBizqZ7UrFpwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lp6613FT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lp6613FT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CAE5C4CEF1;
	Tue, 25 Nov 2025 16:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764089721;
	bh=uN9ndgyzet6QF892LabdZnzzqrYdJt+QMPsnwklvTqU=;
	h=Date:To:From:Subject:From;
	b=lp6613FTWJXPgv3T6JMP4voSDu3CWbByCE7xR1MizqmWSHoNszga1Sa9FCcXbGwIi
	 kUcOqzIPow49jGvF8cJcdv6Kk/iQsZHCeoc2whe/0NYYXGFziA/FuvcCvjoSfgBigx
	 DW36xD5BZb4XSkuseWOF6uGFXVRs+l568T+Ept1Y=
Date: Tue, 25 Nov 2025 08:55:20 -0800
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,youngjun.park@lge.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swapfile-fix-list-iteration-in-swap_sync_discard.patch added to mm-new branch
Message-Id: <20251125165521.3CAE5C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swapfile: fix list iteration in swap_sync_discard
has been added to the -mm mm-new branch.  Its filename is
     mm-swapfile-fix-list-iteration-in-swap_sync_discard.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swapfile-fix-list-iteration-in-swap_sync_discard.patch

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
Subject: mm/swapfile: fix list iteration in swap_sync_discard
Date: Wed, 26 Nov 2025 01:30:26 +0900

Patch series "mm/swapfile: fix and cleanup swap list iterations".

This series addresses an issue in swap_sync_discard() where list
iteration can fail when devices are removed, and includes a cleanup
for __folio_throttle_swaprate().

The issue was identified during discussion at:
https://lore.kernel.org/linux-mm/aR53i1G45XAqCzBd@yjaykim-PowerEdge-T330/


This patch (of 2):

swap_sync_discard() has an issue where if the next device becomes full and
is removed from the plist during iteration, the operation fails even when
other swap devices with pending discard entries remain available.

Fix by checking plist_node_empty(&next->list) and restarting iteration
when the next node is removed during discard operations.

Additionally, switch from swap_avail_lock/swap_avail_head to swap_lock/
swap_active_head.  This means the iteration is only affected by swapoff
operations rather than frequent availability changes, reducing exceptional
condition checks and lock contention.

Link: https://lkml.kernel.org/r/20251125163027.4165450-1-youngjun.park@lge.com
Link: https://lkml.kernel.org/r/20251125163027.4165450-2-youngjun.park@lge.com
Fixes: 686ea517f471 ("mm, swap: do not perform synchronous discard during allocation")
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
Suggested-by: Kairui Song <kasong@tencent.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

--- a/mm/swapfile.c~mm-swapfile-fix-list-iteration-in-swap_sync_discard
+++ a/mm/swapfile.c
@@ -1387,21 +1387,25 @@ static bool swap_sync_discard(void)
 	bool ret = false;
 	struct swap_info_struct *si, *next;
 
-	spin_lock(&swap_avail_lock);
-	plist_for_each_entry_safe(si, next, &swap_avail_head, avail_list) {
-		spin_unlock(&swap_avail_lock);
+	spin_lock(&swap_lock);
+start_over:
+	plist_for_each_entry_safe(si, next, &swap_active_head, list) {
+		spin_unlock(&swap_lock);
 		if (get_swap_device_info(si)) {
 			if (si->flags & SWP_PAGE_DISCARD)
 				ret = swap_do_scheduled_discard(si);
 			put_swap_device(si);
 		}
 		if (ret)
-			return true;
-		spin_lock(&swap_avail_lock);
+			return ret;
+
+		spin_lock(&swap_lock);
+		if (plist_node_empty(&next->list))
+			goto start_over;
 	}
-	spin_unlock(&swap_avail_lock);
+	spin_unlock(&swap_lock);
 
-	return false;
+	return ret;
 }
 
 /**
_

Patches currently in -mm which might be from youngjun.park@lge.com are

mm-swapfile-fix-list-iteration-in-swap_sync_discard.patch
mm-swapfile-use-plist_for_each_entry-in-__folio_throttle_swaprate.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD343223336
	for <mm-commits@vger.kernel.org>; Thu, 27 Nov 2025 20:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764274356; cv=none; b=aU1eFsvpPYsJ++vUhQB0ekz7LIzHA7xupbck+QlQSNLhXNm5WcBs4IdkXcWhaXIeR8JHgtUP1vMTPpCj8LtR++p5Xq127drkBobxor9FlApfTwVjIHFqhJ23OPpvYATLDRCwUSyqJ3yyHCxbwNjZ3AlCeeQ8igXAEEX6m2JRJGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764274356; c=relaxed/simple;
	bh=o45kFhZEB2AsYlZ0UZw5Ub/aOoTnSW01ovnwys2doT4=;
	h=Date:To:From:Subject:Message-Id; b=C3GT0w+WTdxDNWYRhZjsIVrUggKb9VZycvsJsq5KaWptzlpPHaoiMloYDUvjdpWsvV+ZRIdAi3j1MovkM1WKA87UDAivz9LjjNMbw0895XJ/AK2U/kTOk8C5ITpLvXVyVNe88mdaAuvX0vttfWeueom+lacAMvYUTG6d0tziBwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UOyG3tVE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UOyG3tVE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67AEBC4CEF8;
	Thu, 27 Nov 2025 20:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764274356;
	bh=o45kFhZEB2AsYlZ0UZw5Ub/aOoTnSW01ovnwys2doT4=;
	h=Date:To:From:Subject:From;
	b=UOyG3tVE8KOpJsFH/CC3CKROHEO9PbTZFyJARZIJ7v7k/BA+Kbmj1PLHwbb0P5mQS
	 RSdzff5Z8gHwxWg8YJoRIak0WIl/hizMNLLsrBSv4uecxcTojhJsW+78Wkpv5hFHyx
	 WObYPSXXwmdYnwx6YY/S66xAUuHpm4k2eh7gBcso=
Date: Thu, 27 Nov 2025 12:12:35 -0800
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,youngjun.park@lge.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swapfile-fix-list-iteration-when-next-node-is-removed-during-discard.patch added to mm-unstable branch
Message-Id: <20251127201236.67AEBC4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swapfile: fix list iteration when next node is removed during discard
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swapfile-fix-list-iteration-when-next-node-is-removed-during-discard.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swapfile-fix-list-iteration-when-next-node-is-removed-during-discard.patch

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
Subject: mm/swapfile: fix list iteration when next node is removed during discard
Date: Thu, 27 Nov 2025 19:03:02 +0900

Patch series "mm/swapfile: fix and cleanup swap list iterations", v2.

This series fixes a potential list iteration issue in swap_sync_discard()
when devices are removed, and includes a cleanup for
__folio_throttle_swaprate().


This patch (of 2):

When the next node is removed from the plist (e.g.  by swapoff),
plist_del() makes the node point to itself, causing the iteration to loop
on the same entry indefinitely.

Add a plist_node_empty() check to detect this case and restart iteration,
allowing swap_sync_discard() to continue processing remaining swap devices
that still have pending discard entries.

Additionally, switch from swap_avail_lock/swap_avail_head to
swap_lock/swap_active_head so that iteration is only affected by swapoff
operations rather than frequent availability changes, reducing exceptional
condition checks and lock contention.

Link: https://lkml.kernel.org/r/20251127100303.783198-1-youngjun.park@lge.com
Link: https://lkml.kernel.org/r/20251127100303.783198-2-youngjun.park@lge.com
Fixes: 686ea517f471 ("mm, swap: do not perform synchronous discard during allocation")
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
Suggested-by: Kairui Song <kasong@tencent.com>
Acked-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/mm/swapfile.c~mm-swapfile-fix-list-iteration-when-next-node-is-removed-during-discard
+++ a/mm/swapfile.c
@@ -1387,9 +1387,10 @@ static bool swap_sync_discard(void)
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
@@ -1397,9 +1398,12 @@ static bool swap_sync_discard(void)
 		}
 		if (ret)
 			return true;
-		spin_lock(&swap_avail_lock);
+
+		spin_lock(&swap_lock);
+		if (plist_node_empty(&next->list))
+			goto start_over;
 	}
-	spin_unlock(&swap_avail_lock);
+	spin_unlock(&swap_lock);
 
 	return false;
 }
_

Patches currently in -mm which might be from youngjun.park@lge.com are

mm-swapfile-fix-list-iteration-when-next-node-is-removed-during-discard.patch
mm-swapfile-use-plist_for_each_entry-in-__folio_throttle_swaprate.patch


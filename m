Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5885918859B;
	Wed,  1 Apr 2026 03:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775015041; cv=none; b=e6qe6ZP99W4ibreTkWyFQZx6mkqUNxdNs53pJZBJm7oQoTcgDAYQ6E5waJwSX2YiI5SqjZtnxO7b7agykNly9KKqlQsIaycS+/zp7p/8PMW7XE9CjzazExjrGg3++c3+xT1/pcc+r0xHY4LYvuIxPS6KKksIzHVRnWiB34HYgso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775015041; c=relaxed/simple;
	bh=HH/vs+xzBvjntZvKsFO+7SOrFoTpA4mWzSXF3XHhhuw=;
	h=Date:To:From:Subject:Message-Id; b=Hj3romof2fiX5PXhtLYLDqaKdZXPR22W7vvwJp1UH2j9hycxRZXJu5YDwVEOWDW2Fy96ERfMSpHDZmsH6UvJtTUpeTf2t91xXy0Mp9TSRcKNV0F+CZyVDuti1sv+j4j6SeooucO9+PIL6idiKDjGoTUHGtDTh1rfXFz/oQo4D2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UcbuBH9b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UcbuBH9b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C43C6C4CEF7;
	Wed,  1 Apr 2026 03:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775015040;
	bh=HH/vs+xzBvjntZvKsFO+7SOrFoTpA4mWzSXF3XHhhuw=;
	h=Date:To:From:Subject:From;
	b=UcbuBH9bzRFIzh2zfZrUajhNm8oL5kaZxQ+M22MkaGryW1u5HXBTmVRiajtFMWtmK
	 HceTnUIlufiWexdy5zV6bA5GxDGvqXlK9nOV/PrxRzROwDzRkiKwnPQ+SjNxQ99VDv
	 rmdRyhGTfiQ+YO+0ptMbIfOXV2LmqaVUIGDGb364=
Date: Tue, 31 Mar 2026 20:44:00 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,joshua.hahnjy@gmail.com,gourry@gourry.net,donettom@linux.ibm.com,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,liuyun01@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-fix-memory-leaks-in-weighted_interleave_auto_store.patch added to mm-unstable branch
Message-Id: <20260401034400.C43C6C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mempolicy: fix memory leaks in weighted_interleave_auto_store()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mempolicy-fix-memory-leaks-in-weighted_interleave_auto_store.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mempolicy-fix-memory-leaks-in-weighted_interleave_auto_store.patch

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
From: Jackie Liu <liuyun01@kylinos.cn>
Subject: mm/mempolicy: fix memory leaks in weighted_interleave_auto_store()
Date: Wed, 1 Apr 2026 08:57:02 +0800

weighted_interleave_auto_store() fetches old_wi_state inside the if
(!input) block only.  This causes two memory leaks:

1. When a user writes "false" and the current mode is already manual,
   the function returns early without freeing the freshly allocated
   new_wi_state.

2. When a user writes "true", old_wi_state stays NULL because the
   fetch is skipped entirely. The old state is then overwritten by
   rcu_assign_pointer() but never freed, since the cleanup path is
   gated on old_wi_state being non-NULL. A user can trigger this
   repeatedly by writing "1" in a loop.

Fix both leaks by moving the old_wi_state fetch before the input check,
making it unconditional.  This also allows a unified early return for both
"true" and "false" when the requested mode matches the current mode.

Link: https://lkml.kernel.org/r/20260401005702.7096-1-liu.yun@linux.dev
Link: https://sashiko.dev/#/patchset/20260331100740.84906-1-liu.yun@linux.dev
Fixes: e341f9c3c841 ("mm/mempolicy: Weighted Interleave Auto-tuning")
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: <stable@vger.kernel.org> # v6.16+
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-fix-memory-leaks-in-weighted_interleave_auto_store
+++ a/mm/mempolicy.c
@@ -3700,18 +3700,19 @@ static ssize_t weighted_interleave_auto_
 		new_wi_state->iw_table[i] = 1;
 
 	mutex_lock(&wi_state_lock);
-	if (!input) {
-		old_wi_state = rcu_dereference_protected(wi_state,
-					lockdep_is_held(&wi_state_lock));
-		if (!old_wi_state)
-			goto update_wi_state;
-		if (input == old_wi_state->mode_auto) {
-			mutex_unlock(&wi_state_lock);
-			return count;
-		}
+	old_wi_state = rcu_dereference_protected(wi_state,
+				lockdep_is_held(&wi_state_lock));
+
+	if (old_wi_state && input == old_wi_state->mode_auto) {
+		mutex_unlock(&wi_state_lock);
+		kfree(new_wi_state);
+		return count;
+	}
 
-		memcpy(new_wi_state->iw_table, old_wi_state->iw_table,
-					       nr_node_ids * sizeof(u8));
+	if (!input) {
+		if (old_wi_state)
+			memcpy(new_wi_state->iw_table, old_wi_state->iw_table,
+						       nr_node_ids * sizeof(u8));
 		goto update_wi_state;
 	}
 
_

Patches currently in -mm which might be from liuyun01@kylinos.cn are

mm-damon-stat-fix-memory-leak-on-damon_start-failure-in-damon_stat_start.patch
mm-mempolicy-fix-memory-leaks-in-weighted_interleave_auto_store.patch


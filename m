Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F24728F4
	for <mm-commits@vger.kernel.org>; Sun, 23 Feb 2025 01:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740275131; cv=none; b=P2peIMvcnAvfkXzHpGCYEipCdBkwAQycNzzirrlr0HtRsgr0QSER5hUDJAQt0DPkQvW0lDRiFGyLttuFb5YMBasspp9mUX+hLP4ZpjxnBajGI4ktBmSlC6aXlWtPDvitCfI6bRzApxJB7YEUUeOe8MRUHvmE55s4dpwZPPD4p1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740275131; c=relaxed/simple;
	bh=rIf+3xmACH09n8xhcxAYMPwDWNN9NhCctc44Z+7gDCg=;
	h=Date:To:From:Subject:Message-Id; b=VisXhZSJNQcreNmCN7L9f1uWPDAwiLutwzTbn6/gWRhQO+Xi3Jtg9Sxrui7Ic/7G5bDZq9cgaiAdKHq4wcjdr11enMUDgDz69pThRlFuQ1HOLiZIrgyEvuKJGI5+bySJ1p+GTqhVu5p4DF9/BCBRqKaYtlOODqnZkYoM82jL0Eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=B3uEiXMq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B3uEiXMq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1979C4CED1;
	Sun, 23 Feb 2025 01:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740275131;
	bh=rIf+3xmACH09n8xhcxAYMPwDWNN9NhCctc44Z+7gDCg=;
	h=Date:To:From:Subject:From;
	b=B3uEiXMqn607kWgQspFsDEGnvxXOHCpLRpE4RYPqc6XLTLVx0fj3+Tnm6UYIvXSRe
	 ck2mCUSdyhdAyOAS6VOGytTAwgP/h/zHB3k0pfI4VS3h+WC5WSB8uG6Urj88HuGXeR
	 hV3a85IdsEtASETOSKzTz1fI57T2FzoyzSzRGChE=
Date: Sat, 22 Feb 2025 17:45:30 -0800
To: mm-commits@vger.kernel.org,ryncsn@gmail.com,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-correct-comment-in-swap_usage_sub.patch added to mm-unstable branch
Message-Id: <20250223014530.E1979C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: correct comment in swap_usage_sub()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-correct-comment-in-swap_usage_sub.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-correct-comment-in-swap_usage_sub.patch

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
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm, swap: correct comment in swap_usage_sub()
Date: Sun, 23 Feb 2025 00:08:49 +0800

We will add si back to plist in swap_usage_sub(), just correct the wrong
comment which says we will remove si from plist in swap_usage_sub().

Link: https://lkml.kernel.org/r/20250222160850.505274-6-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Kairui Song <ryncsn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swapfile.c~mm-swap-correct-comment-in-swap_usage_sub
+++ a/mm/swapfile.c
@@ -1098,7 +1098,7 @@ static void swap_usage_sub(struct swap_i
 
 	/*
 	 * If device is not full, and SWAP_USAGE_OFFLIST_BIT is set,
-	 * remove it from the plist.
+	 * add it to the plist.
 	 */
 	if (unlikely(val & SWAP_USAGE_OFFLIST_BIT))
 		add_to_avail_list(si, false);
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are

mm-swap-avoid-losting-cluster-in-swap_reclaim_full_clusters.patch
mm-swap-use-correct-step-in-loop-to-wait-all-clusters-in-wait_for_allocation.patch
mm-swap-avoid-bug_on-in-relocate_cluster.patch
mm-swap-remove-setting-swap_map_bad-for-discard-cluster.patch
mm-swap-correct-comment-in-swap_usage_sub.patch
mm-swap-remove-stale-comment-of-swap_reclaim_full_clusters.patch


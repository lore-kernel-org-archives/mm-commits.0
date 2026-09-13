Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3DB395266
	for <mm-commits@vger.kernel.org>; Sun, 13 Sep 2026 07:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789285945; cv=none; b=kLrUzeXghbQ+fvSV/8T11Rp1V9ghjn4CUTwHz2f3srUvou0SeYdydu5NB38Uusw0bOtH2wJsYCVtGzMqdSKnkefnF7BgB9Y28e+CN/nsIKb0idAp6vgBV+XdSo5viObUyqwXsZaBWuIvp9CFOf/hfVlXsN6yy+BdT6Ve2KeQMWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789285945; c=relaxed/simple;
	bh=GlPpYRrZtiYpfChOLa8V6PlgMFs4OYnVlnzIGq/sXM8=;
	h=Date:To:From:Subject:Message-Id; b=Q4VW7K4YX2H+FS8PQO+jAeYkaiU3xko4yTtgR0p3kP7qXz8onAOi/nhZZWKn7sGNmaKGsIpOGYprd13zPpts7HTblkk+OXDOITfjzu7uCLNkmWCw3RZzq93Nb0QZwO7VQHq21YSW9JFL7roePuGSyySHQ+xn9kpVJ+VOzhvD+7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ADCf6iXl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ADCf6iXl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 433811F000FF;
	Sun, 13 Sep 2026 07:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789285943;
	bh=O/hQhUeul00gbCal4AJrfBOm/wcEYqWyFeopw1EXU9Q=;
	h=Date:To:From:Subject;
	b=ADCf6iXlmqFnOLhaizPCjpZkXWvVXLsjjTkVWt/vasNrN1m59nP5Cr474SpKjoCgh
	 4f8dqy1DMTbaZqBk8p0o82q0IukdkeRjDM6RFcHjNR4CXXsAyhFfw2BumSJmL6dQym
	 ouRZyAwADqUFrfAFhXYatu2PznncEYjwkE/TAiEo=
Date: Sun, 13 Sep 2026 00:52:22 -0700
To: mm-commits@vger.kernel.org,nphamcs@gmail.com,kasong@tencent.com,hannes@cmpxchg.org,chrisl@kernel.org,chengming.zhou@linux.dev,hebaoquan@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-return-enoent-when-the-swap-device-is-gone.patch added to mm-new branch
Message-Id: <20260913075223.433811F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: return -ENOENT when the swap device is gone
has been added to the -mm mm-new branch.  Its filename is
     mm-zswap-return-enoent-when-the-swap-device-is-gone.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-return-enoent-when-the-swap-device-is-gone.patch

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
From: Baoquan He <hebaoquan@kylinos.cn>
Subject: mm: zswap: return -ENOENT when the swap device is gone
Date: Sun, 13 Sep 2026 14:30:31 +0800

zswap_writeback_entry() returns -EEXIST when get_swap_device() finds no
device.  -EEXIST is the shrinker's "page already in swap cache" signal,
which makes zswap_shrinker_scan() stop shrinking entirely.  A NULL
get_swap_device() instead means the device is being swapped off, so the
entry is simply stale.

Return -ENOENT so the shrinker skips the stale entry and keeps scanning.
Independent of xswap; affects all swap devices.

Link: https://lore.kernel.org/20260913063031.1689420-1-hebaoquan@kylinos.cn
Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
---

 mm/zswap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/zswap.c~mm-zswap-return-enoent-when-the-swap-device-is-gone
+++ a/mm/zswap.c
@@ -1016,7 +1016,7 @@ static int zswap_writeback_entry(struct
 	/* try to allocate swap cache folio */
 	si = get_swap_device(swpentry);
 	if (IS_ERR_OR_NULL(si))
-		return -EEXIST;
+		return -ENOENT;
 
 	mpol = get_task_policy(current);
 	folio = swap_cache_alloc_folio(swpentry, GFP_KERNEL, BIT(0), NULL, mpol,
_

Patches currently in -mm which might be from hebaoquan@kylinos.cn are

mm-zswap-return-enoent-when-the-swap-device-is-gone.patch


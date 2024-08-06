Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3683C18D62B
	for <mm-commits@vger.kernel.org>; Tue,  6 Aug 2024 19:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722973493; cv=none; b=hxMcnmnLWGI/uX6qKAVeycI1UTiOh//Yre6yCpodZW1y2AkkTaVfAxzJ+ze5rPvsOWtYcN4Smq8GMkeAs99Mua8bkVFmw45P12xKweZiw7q4pgLnB55WmaEeIjcsRm6UzDN4zHBFfotjUXheJhVDJ7DedQhRjbc3CgZE2ORSpoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722973493; c=relaxed/simple;
	bh=Su4oiLj4IH1NStl5sFoWvzoqYhJ8ZdXv4LV6nYh3Plo=;
	h=Date:To:From:Subject:Message-Id; b=e4Pe41jdQxOJLuGwTeUU8Sn+tFc69ADkb5gOVUJq7nLoYeMff88zzoUvDK3A4AuOysQBhzzscATjAFB59y1bCMns3dSzwFZvkYGVBBWJKVuIwZ6JV6gn1TzFGwPAcbJ8GNmJGGhj2gzPZcyfG2VHpbU31/PVedXTYtaZ9WokA5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Jpst2YAg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Jpst2YAg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97C2FC32786;
	Tue,  6 Aug 2024 19:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722973492;
	bh=Su4oiLj4IH1NStl5sFoWvzoqYhJ8ZdXv4LV6nYh3Plo=;
	h=Date:To:From:Subject:From;
	b=Jpst2YAg+2Ktm+A7yT+5WOJ4jMX9mujTTnrZTUKvju7+DK2VcVSpbzGwu3JtEaAJ/
	 Xa7Ln1r7M/a5pfLL5Aw9ixhxx7Rs0aANTNA8aNoaBO1VqASme1LxyBeSOhJlUkQImB
	 Hocssu81Vo0sQtrJQShDIExJfIUOVtkhAzzij8Os=
Date: Tue, 06 Aug 2024 12:44:52 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,shakeel.butt@linux.dev,hannes@cmpxchg.org,flintglass@gmail.com,chengming.zhou@linux.dev,nphamcs@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zswap-track-swapins-from-disk-more-accurately-fix.patch added to mm-unstable branch
Message-Id: <20240806194452.97C2FC32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zswap: track swapins from disk more accurately (fix)
has been added to the -mm mm-unstable branch.  Its filename is
     zswap-track-swapins-from-disk-more-accurately-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zswap-track-swapins-from-disk-more-accurately-fix.patch

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
From: Nhat Pham <nphamcs@gmail.com>
Subject: zswap: track swapins from disk more accurately (fix)
Date: Mon, 5 Aug 2024 17:45:18 -0700

Squeeze a comment into a single line.

Link: https://lkml.kernel.org/r/20240806004518.3183562-1-nphamcs@gmail.com
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Takero Funaki <flintglass@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/page_io.c~zswap-track-swapins-from-disk-more-accurately-fix
+++ a/mm/page_io.c
@@ -524,9 +524,7 @@ void swap_read_folio(struct folio *folio
 		goto finish;
 	}
 
-	/*
-	 * We have to read the page from slower devices. Increase zswap protection.
-	 */
+	/* We have to read from slower devices. Increase zswap protection. */
 	zswap_folio_swapin(folio);
 
 	if (data_race(sis->flags & SWP_FS_OPS)) {
_

Patches currently in -mm which might be from nphamcs@gmail.com are

zswap-implement-a-second-chance-algorithm-for-dynamic-zswap-shrinker.patch
zswap-implement-a-second-chance-algorithm-for-dynamic-zswap-shrinker-fix.patch
zswap-track-swapins-from-disk-more-accurately.patch
zswap-track-swapins-from-disk-more-accurately-fix.patch


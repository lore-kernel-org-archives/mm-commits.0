Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD87318D
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560115; cv=none; b=shgb3+8U7D7rYLtrWG9NPumpagbjZIOVswtxlaP7GTbj2YbZU34eDxqcp4ohZcnVIk2c7XBMsOFonxa3llOVx2cvo8G1Oj0BR1ZhZkcEPbHw5+gB1PvamfYLwXx4Rv1AEvbSXkJZwODciB1uQf/1OtUaoblcVeG7XY3zsJmeoHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560115; c=relaxed/simple;
	bh=zrvjKYETrIJLdTiqVb9UdZudfizmJ4c1CaQvVNh5XsU=;
	h=Date:To:From:Subject:Message-Id; b=LkyW9r6lLnrcGgOtCCqcorVAff6APhUxbFyKRy+7xI+iT+OCdS/Vs17owxR2yimz5RPEefn+F/xpo/CHuTZBh13Isacfuhh7Sqy6+ZCZuX8c2pQn7cz42xa3ZUBJZ6EdnxRWikSwMv+2md9ToXWQtt0NoExwSVHV24T7EzCWK/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nz1Far8T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nz1Far8T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1300C43390;
	Thu, 22 Feb 2024 00:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560115;
	bh=zrvjKYETrIJLdTiqVb9UdZudfizmJ4c1CaQvVNh5XsU=;
	h=Date:To:From:Subject:From;
	b=nz1Far8TNQmqy7VPrOuzHxx/JhjGc5nZkz3GrCgXkpqqpIIs/xLkY6NuDBLrchG0M
	 Qg7RW7uKkYBnh41VGTjhnwpoAEPuac4b2Yr78HAKjd3mhZbwf9J9ImmH+LjmfJXbDy
	 l1jyumHvNZpRGlO1ABQsD8WKLHgR7kwoqcH8qXuU=
Date: Wed, 21 Feb 2024 16:01:55 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-warn-when-referencing-a-dead-entry.patch removed from -mm tree
Message-Id: <20240222000155.A1300C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: warn when referencing a dead entry
has been removed from the -mm tree.  Its filename was
     mm-zswap-warn-when-referencing-a-dead-entry.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: zswap: warn when referencing a dead entry
Date: Mon, 29 Jan 2024 20:36:40 -0500

Put a standard sanity check on zswap_entry_get() for UAF scenario.

Link: https://lkml.kernel.org/r/20240130014208.565554-5-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Chengming Zhou <zhouchengming@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/zswap.c~mm-zswap-warn-when-referencing-a-dead-entry
+++ a/mm/zswap.c
@@ -541,6 +541,7 @@ static void zswap_entry_free(struct zswa
 /* caller must hold the tree lock */
 static void zswap_entry_get(struct zswap_entry *entry)
 {
+	WARN_ON_ONCE(!entry->refcount);
 	entry->refcount++;
 }
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are



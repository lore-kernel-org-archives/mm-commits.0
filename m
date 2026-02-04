Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A8152367B5
	for <mm-commits@vger.kernel.org>; Wed,  4 Feb 2026 19:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770231814; cv=none; b=CMvOppghqcyMbESn5bKpWhY1ljh8A+cfkhllSuTLb8TznzCodwH38LffOIlbHzupqVhLTHvVazTxgrJ5SoP+OlXVTxjbAWbibn0rBuRKjNcZ88Se1YqSxVlBHr6QvakNX1AoW6e4wTeo32U4WEiF+LZCX72/uluJrAwE73I1Lfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770231814; c=relaxed/simple;
	bh=vgpcMo0N3PPWXs/XeIZssEQldc2oWMQ7MLPhK6FM4m4=;
	h=Date:To:From:Subject:Message-Id; b=GIPWI7XtV/K+fUKO3nyve0kOIFZrbScdC8xARVPkai4MCmvP29koX6m+bnRpAFdfOC1b3erw1bGZkKNa+ma1S97Jo67eHXYVZ2G2dlZWln3CmvgMz/psLAuz4Qeo2LfoxwfPGJAHhEdyLDLZhn9jpAbSnAjwP8Xoyr0ycPqZgMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0lAgHUIa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0lAgHUIa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED9D7C4CEF7;
	Wed,  4 Feb 2026 19:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770231814;
	bh=vgpcMo0N3PPWXs/XeIZssEQldc2oWMQ7MLPhK6FM4m4=;
	h=Date:To:From:Subject:From;
	b=0lAgHUIa2+ps+qtEHaKQrlylyNN8VOdCafcTM5IL9zOhF5jQKaY3QUcgVIcsolJ4k
	 VfC16qVxn6CUJpzolHKaIouMc2ttesR1jUl8gpF4CTD6GY57mtATLJJYFBr401vqGr
	 FRPgLI27a7+23tpkKK4t56FvGNf1qDoSlKC4vvyU=
Date: Wed, 04 Feb 2026 11:03:33 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,sj@kernel.org,nphamcs@gmail.com,david@kernel.org,chandna.sahil@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-use-%pe-to-print-error-pointers.patch added to mm-unstable branch
Message-Id: <20260204190333.ED9D7C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmscan: use %pe to print error pointers
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-use-%pe-to-print-error-pointers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-use-%pe-to-print-error-pointers.patch

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
From: Sahil Chandna <chandna.sahil@gmail.com>
Subject: mm/vmscan: use %pe to print error pointers
Date: Thu, 5 Feb 2026 00:24:07 +0530

Use the %pe printk format specifier to report error pointers directly
instead of printing PTR_ERR() as a long value.  This improves clarity,
produces more readable error messages.

This instance was flagged by the Coccinelle script
(misc/ptr_err_to_pe.cocci) as an opportunity to adopt %pe.

Found by: make coccicheck MODE=report M=mm/
No functional change intended

Link: https://lkml.kernel.org/r/80a6643657a60e75ddf48b4869b3e7fdc101f855.1770230135.git.chandna.sahil@gmail.com
Signed-off-by: Sahil Chandna <chandna.sahil@gmail.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-use-%pe-to-print-error-pointers
+++ a/mm/vmscan.c
@@ -7479,8 +7479,8 @@ void __meminit kswapd_run(int nid)
 		pgdat->kswapd = kthread_create_on_node(kswapd, pgdat, nid, "kswapd%d", nid);
 		if (IS_ERR(pgdat->kswapd)) {
 			/* failure at boot is fatal */
-			pr_err("Failed to start kswapd on node %d，ret=%ld\n",
-				   nid, PTR_ERR(pgdat->kswapd));
+			pr_err("Failed to start kswapd on node %d, ret=%pe\n",
+				   nid, pgdat->kswapd);
 			BUG_ON(system_state < SYSTEM_RUNNING);
 			pgdat->kswapd = NULL;
 		} else {
_

Patches currently in -mm which might be from chandna.sahil@gmail.com are

mm-vmscan-use-%pe-to-print-error-pointers.patch
mm-zswap-use-%pe-to-print-error-pointers.patch


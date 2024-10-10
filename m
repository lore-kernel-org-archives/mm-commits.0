Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E3F18DF9E
	for <mm-commits@vger.kernel.org>; Thu, 10 Oct 2024 21:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728594356; cv=none; b=FtYgVjDDdKnYgHDm+1YoeROUppvK1xQV52E9Qu2zttzs71GZrCDeim4/r7SNnNGJXscfo4eaeC3TUxXcYmM2/sywyhZrcvB/RBgSTixRVTrx40dyGN8AbM+vMVMFquNOkBUdAOGStfYn44Yr7yQjxVrOWudsD8+LtH7ITBgLVNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728594356; c=relaxed/simple;
	bh=KtBCVSCYHL7O4SHjwkf/g1bDOWwo/n4MiU+foEeD2Y0=;
	h=Date:To:From:Subject:Message-Id; b=afHjCJwl3EKbww9NoozY+SC72XHBgIA5lBIdk7q7495/+GO+hYNcamu/bkeZ+S2YGuEhqD7z7EVukenyNVGOE7WS75wrE0l6NUlEek3kl+MHYDBE5VJdNXj5LklO5ic5HR3SriMmr4SBQko22YFBm7zqzpNFZ4jYvDKfhrEg6NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wawZ1XCx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wawZ1XCx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36FABC4CECC;
	Thu, 10 Oct 2024 21:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728594356;
	bh=KtBCVSCYHL7O4SHjwkf/g1bDOWwo/n4MiU+foEeD2Y0=;
	h=Date:To:From:Subject:From;
	b=wawZ1XCx7fVzT7sHVt4rtp0h3cA3ihYfyaxH7mb83OG0w75R0LuDzed5nHp76REim
	 +QiPVLAA7NYYAB9k7EkABEt690QJ8J5zHiT0Eyv2lYxU+0YgglgnBWLcqVk38h2dBU
	 7Woc/703aKoH29mgZhHzxZejgCyRczrSYbfMNOBw=
Date: Thu, 10 Oct 2024 14:05:54 -0700
To: mm-commits@vger.kernel.org,alexjlzheng@tencent.com,mengensun@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-pcp-high_min-high_max-to-proc-zoneinfo.patch added to mm-unstable branch
Message-Id: <20241010210556.36FABC4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add pcp high_min high_max to proc zoneinfo
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-pcp-high_min-high_max-to-proc-zoneinfo.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-pcp-high_min-high_max-to-proc-zoneinfo.patch

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
From: MengEn Sun <mengensun@tencent.com>
Subject: mm: add pcp high_min high_max to proc zoneinfo
Date: Thu, 10 Oct 2024 20:09:36 +0800

When we do not set percpu_pagelist_high_fraction the kernel will compute
the pcp high_min/max by itself, which makes it hard to determine the
current high_min/max values.

So output the pcp high_min/max values to /proc/zoneinfo.

Link: https://lkml.kernel.org/r/20241010120935.656619-1-mengensun@tencent.com
Signed-off-by: MengEn Sun <mengensun@tencent.com>
Reviewed-by: Jinliang Zheng <alexjlzheng@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/mm/vmstat.c~mm-add-pcp-high_min-high_max-to-proc-zoneinfo
+++ a/mm/vmstat.c
@@ -1791,13 +1791,17 @@ static void zoneinfo_show_print(struct s
 		pcp = per_cpu_ptr(zone->per_cpu_pageset, i);
 		seq_printf(m,
 			   "\n    cpu: %i"
-			   "\n              count: %i"
-			   "\n              high:  %i"
-			   "\n              batch: %i",
+			   "\n              count:    %i"
+			   "\n              high:     %i"
+			   "\n              batch:    %i"
+			   "\n              high_min: %i"
+			   "\n              high_max: %i",
 			   i,
 			   pcp->count,
 			   pcp->high,
-			   pcp->batch);
+			   pcp->batch,
+			   pcp->high_min,
+			   pcp->high_max);
 #ifdef CONFIG_SMP
 		pzstats = per_cpu_ptr(zone->per_cpu_zonestats, i);
 		seq_printf(m, "\n  vm stats threshold: %d",
_

Patches currently in -mm which might be from mengensun@tencent.com are

mm-add-pcp-high_min-high_max-to-proc-zoneinfo.patch


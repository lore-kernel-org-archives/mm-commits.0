Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93ADD14E2ED
	for <mm-commits@vger.kernel.org>; Wed, 25 Sep 2024 20:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727297497; cv=none; b=JBSxmtoSRjlpiDLmSLYNsOJ+aw8CF/3CgdbT6E3FckFf1yBnRF+Dmzmz0faS6vkmcZYbYPAfP3TPIXM4bOuQzcgdsybuZX0Z0H+BLslfA1wBqszfdaOZoAUjH5Qk7uVrxm62vXoaUT+p5ib0MiyPFlH5B+GhVtN0jYNTVq0feD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727297497; c=relaxed/simple;
	bh=I50y6mm21rfOUIKGWcIzE/7OrHTNFyKYo/y5IRsitIc=;
	h=Date:To:From:Subject:Message-Id; b=IiWAvS4IcGLYAfPfI2WHxQAgPFmGMSTf78Yvq7Mcbw+KU678XZtD06v5u1CEnctouOw+OyXAJKkjl7gXRQTu0NaOXOBTlV8XZ2QE0gwHe87TFDbFMveY4awe1jZZt2lESjHqDyRMeUhGsi/IAbPu4ikTANNMTBqZarrAA6erhLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jNFsOjxD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jNFsOjxD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2FEEC4CEC3;
	Wed, 25 Sep 2024 20:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727297497;
	bh=I50y6mm21rfOUIKGWcIzE/7OrHTNFyKYo/y5IRsitIc=;
	h=Date:To:From:Subject:From;
	b=jNFsOjxDQY7QiV5JGcsH0x4RoZszDnjsozyCKniafCW/jmC5Q4mQDyseJ3gY6cjTY
	 01N2eL+8tLB8FHvLMMa6+9aMTAdLkc7q6YZM5Y9yPPdfBKsl/DbIKjrIdFa9dOZB7E
	 xv/sPA6woYWVTSw5MGoYGUUlolJUpen5Be9mLrCA=
Date: Wed, 25 Sep 2024 13:51:36 -0700
To: mm-commits@vger.kernel.org,justinjiang@vivo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-shrink-nrunqueued_dirty-counter-issue.patch added to mm-unstable branch
Message-Id: <20240925205136.F2FEEC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix shrink nr.unqueued_dirty counter issue
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fix-shrink-nrunqueued_dirty-counter-issue.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-shrink-nrunqueued_dirty-counter-issue.patch

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
From: Zhiguo Jiang <justinjiang@vivo.com>
Subject: mm: fix shrink nr.unqueued_dirty counter issue
Date: Fri, 12 Jan 2024 09:23:52 +0800

It is needed to ensure sc->nr.unqueued_dirty > 0, which can avoid setting
PGDAT_DIRTY flag when sc->nr.unqueued_dirty and sc->nr.file_taken are both
zero.

Link: https://lkml.kernel.org/r/20240112012353.1387-1-justinjiang@vivo.com
Signed-off-by: Zhiguo Jiang <justinjiang@vivo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-fix-shrink-nrunqueued_dirty-counter-issue
+++ a/mm/vmscan.c
@@ -5984,7 +5984,8 @@ again:
 			set_bit(PGDAT_WRITEBACK, &pgdat->flags);
 
 		/* Allow kswapd to start writing pages during reclaim.*/
-		if (sc->nr.unqueued_dirty == sc->nr.file_taken)
+		if (sc->nr.unqueued_dirty &&
+			sc->nr.unqueued_dirty == sc->nr.file_taken)
 			set_bit(PGDAT_DIRTY, &pgdat->flags);
 
 		/*
_

Patches currently in -mm which might be from justinjiang@vivo.com are

mm-fix-shrink-nrunqueued_dirty-counter-issue.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8458B1D52D
	for <mm-commits@vger.kernel.org>; Tue, 16 Jan 2024 21:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705441547; cv=none; b=KQWkXzQmBvsEdR2gC1PGYIEeVKCiOVb0ZvWiG6niU6HRRWhMG2GnBz0EP8m++CEwdiGYVwXXuEOQwCsul5Y+0h4suxjXHsyXSRHimAFeFM6yiEQw80OQ5Wil4cGvee+VwXCOEe29xEPuhhT52OsRiUyBzYJJmZr12ysRWQSryBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705441547; c=relaxed/simple;
	bh=KtJ/0rCDjobbCH4aMimvbQy5VngluNo+vLq8dDfcups=;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id; b=oC7o+0EaLUCnlA/WFXSPlECQwgnwFLZy85bIQOegSQ/VrGH8XWS9WGb5r9/iMJ7yUxvAwR7rzePz1GbURmu5Z975lLkLpiTUrjiY2zEWSTCOnA/ibq042ThlzMBXnicy0MmumYG4yD/cS3e5izeSoemupW/gwC7yLiSOKDCQWmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yNqfnH4s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yNqfnH4s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A494CC433C7;
	Tue, 16 Jan 2024 21:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705441547;
	bh=KtJ/0rCDjobbCH4aMimvbQy5VngluNo+vLq8dDfcups=;
	h=Date:To:From:Subject:From;
	b=yNqfnH4sOANG0KF1ZhOPM9pmdmVl9mXWpFB2QH9PZpbx1H4YL6yP7igsmb4WqOONR
	 oJm3lt8BJPHBHtGx0v7BVCk0eYHshLG+PhHp8Y9vOxAzyeV28egbwUS8ZG5I7zgxEc
	 49uS/6Mvp3B7Suyr4CC2Y5z4caimoKoUQRAPlHVk=
Date: Tue, 16 Jan 2024 13:45:44 -0800
To: mm-commits@vger.kernel.org,vitaly.wool@konsulko.com,sjenning@redhat.com,nphamcs@gmail.com,ddstreet@ieee.org,chrisl@kernel.org,debug.penguin32@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-improve-with-alloc_workqueue-call.patch added to mm-unstable branch
Message-Id: <20240116214546.A494CC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zswap: improve with alloc_workqueue() call
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-improve-with-alloc_workqueue-call.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-improve-with-alloc_workqueue-call.patch

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
From: Ronald Monthero <debug.penguin32@gmail.com>
Subject: mm/zswap: improve with alloc_workqueue() call
Date: Tue, 16 Jan 2024 23:31:45 +1000

The core-api create_workqueue is deprecated, this patch replaces the
create_workqueue with alloc_workqueue.  The previous implementation
workqueue of zswap was a bounded workqueue, this patch uses
alloc_workqueue() to create an unbounded workqueue.  The WQ_UNBOUND
attribute is desirable making the workqueue not localized to a specific
cpu so that the scheduler is free to exercise improvisations in any
demanding scenarios for offloading cpu time slices for workqueues.  For
example if any other workqueues of the same primary cpu had to be served
which are WQ_HIGHPRI and WQ_CPU_INTENSIVE.  Also Unbound workqueue happens
to be more efficient in a system during memory pressure scenarios in
comparison to a bounded workqueue.

shrink_wq = alloc_workqueue("zswap-shrink",
                     WQ_UNBOUND|WQ_MEM_RECLAIM, 1);

Overall the change suggested in this patch should be seamless and does not
alter the existing behavior, other than the improvisation to be an
unbounded workqueue.

Link: https://lkml.kernel.org/r/20240116133145.12454-1-debug.penguin32@gmail.com
Signed-off-by: Ronald Monthero <debug.penguin32@gmail.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/zswap.c~mm-zswap-improve-with-alloc_workqueue-call
+++ a/mm/zswap.c
@@ -1884,7 +1884,8 @@ static int zswap_setup(void)
 		zswap_enabled = false;
 	}
 
-	shrink_wq = create_workqueue("zswap-shrink");
+	shrink_wq = alloc_workqueue("zswap-shrink",
+			WQ_UNBOUND|WQ_MEM_RECLAIM, 1);
 	if (!shrink_wq)
 		goto fallback_fail;
 
_

Patches currently in -mm which might be from debug.penguin32@gmail.com are

mm-zswap-improve-with-alloc_workqueue-call.patch


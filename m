Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 421531361
	for <mm-commits@vger.kernel.org>; Thu,  9 May 2024 00:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715214140; cv=none; b=EVdfJbW0+n2vkanJDOSySOdxMwxxlb6LLEeEuQXXSwsv+RV5rkas/OqQzNmTjlW29ZtGCT1zMprTnl3U9Qe4B3Z1SBAIbdsyx1ey+CvKrzbUpHd3RIG5xneCsdWewMo+xNn6UY8ummeXsYGJpESXtg/jfKPcPQWTl3yb0c7Mq1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715214140; c=relaxed/simple;
	bh=PKgTAfJGCjK6+NgMP2cyqos8WHnZNU3Ki+WFYGrp/Bk=;
	h=Date:To:From:Subject:Message-Id; b=Rv9I98/lLOHi/YtKGRXjPQ5on5Z1M7bpeuFVRcSh6ItMZDUrDqwARljXfoRftr4J0rxP5Vi64LBaopTJbPKay4k9qpshbC/xtfWvTVUW7sVuqf7LlAPV3CU/DAPEyhbXOC+Gow+ANsGvOTGN8uv8LilHJyMKIWIlMw9nA5cbKj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tF/+P9BY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tF/+P9BY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2C93C113CC;
	Thu,  9 May 2024 00:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715214139;
	bh=PKgTAfJGCjK6+NgMP2cyqos8WHnZNU3Ki+WFYGrp/Bk=;
	h=Date:To:From:Subject:From;
	b=tF/+P9BY0ZVflkdlKXn4OR9gVCilZgKBzKIkLTbHd8hODLPGmBnLMIpIkxEM1YUsP
	 c9uu8SCaN30OK3PNs/5rwejACHhfoaR09Gka83eD7n/048ry72DThxiVAdi1K3kz4d
	 h+B8MZ0P47f4DhSx63tbhQo4/ro65O6QxqhEt76g=
Date: Wed, 08 May 2024 17:22:18 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-convert-bug_on-in-nilfs_finish_roll_forward-to-warn_on.patch added to mm-nonmm-unstable branch
Message-Id: <20240509002219.B2C93C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: convert BUG_ON() in nilfs_finish_roll_forward() to WARN_ON()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-convert-bug_on-in-nilfs_finish_roll_forward-to-warn_on.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-convert-bug_on-in-nilfs_finish_roll_forward-to-warn_on.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: convert BUG_ON() in nilfs_finish_roll_forward() to WARN_ON()
Date: Thu, 9 May 2024 07:14:29 +0900

The BUG_ON check performed on the return value of __getblk() in
nilfs_finish_roll_forward() assumes that a buffer that has been
successfully read once is retrieved with the same parameters and does not
fail (__getblk() does not return an error due to memory allocation
failure).  Also, nilfs_finish_roll_forward() is called at most once during
mount.

Taking these into consideration, rewrite the check to use WARN_ON() to
avoid using BUG_ON().

Link: https://lkml.kernel.org/r/20240508221429.7559-1-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/recovery.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/nilfs2/recovery.c~nilfs2-convert-bug_on-in-nilfs_finish_roll_forward-to-warn_on
+++ a/fs/nilfs2/recovery.c
@@ -699,7 +699,9 @@ static void nilfs_finish_roll_forward(st
 		return;
 
 	bh = __getblk(nilfs->ns_bdev, ri->ri_lsegs_start, nilfs->ns_blocksize);
-	BUG_ON(!bh);
+	if (WARN_ON(!bh))
+		return;  /* should never happen */
+
 	memset(bh->b_data, 0, bh->b_size);
 	set_buffer_dirty(bh);
 	err = sync_dirty_buffer(bh);
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-convert-bug_on-in-nilfs_finish_roll_forward-to-warn_on.patch


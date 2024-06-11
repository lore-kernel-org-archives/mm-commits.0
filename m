Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B053A8E4
	for <mm-commits@vger.kernel.org>; Tue, 11 Jun 2024 21:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718142818; cv=none; b=FeXqSb1nJypEHS1Ho4+EOLVXPo++nWx+jelyXL5BeFfwyabH7sMpFS2uYtarQbREs474NumyVlk6ca6xGlEa2P/NQ7r0/xJp4ADgmrcQ6TI+ywtWo66bBIQczmv/5OIhqe+XlS8CbPrUo2ELXJhEamAUDux1JW1dg7aFwblyueI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718142818; c=relaxed/simple;
	bh=DVYB/4ZtM3kzHBno4H21NYDfiDF/oEQMKhWEx+a4WfY=;
	h=Date:To:From:Subject:Message-Id; b=RQyKZEiOxej/Za062VOqXQE/X/ysxXPZYRWThPhcjUTkTUSV/yjGiVEyB4JDzfC56DDlfZyjT+VMRxhwbJ3pvhbHF1dKFvGcGLNILl+FiwGmJRatvHB2OuQkr7AhvxyMq04hFXfWv/ZkRtHWvyjw10q18i/Vkg0Z4O2lIpDZPdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K7mGjcu4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K7mGjcu4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C75BC2BD10;
	Tue, 11 Jun 2024 21:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718142818;
	bh=DVYB/4ZtM3kzHBno4H21NYDfiDF/oEQMKhWEx+a4WfY=;
	h=Date:To:From:Subject:From;
	b=K7mGjcu4SxlNcRc17a3BzePJDF6CpMAnApmS6xJdbO6TMJqVKCAo6woiCXoj+XQUQ
	 8gNcn0Aly0uclXQXrvtgSNyXZa9tIU0GzcZmDVKOtOFTm47JSM1AMoKgyyfaDdQGIn
	 eonb5Zm4x5bObQUJid3GJQy+FO1tfziiElxDtLPE=
Date: Tue, 11 Jun 2024 14:53:37 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tj@kernel.org,shikemeng@huaweicloud.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + writeback-factor-out-balance_wb_limits-to-remove-repeated-code-v3-fix.patch added to mm-unstable branch
Message-Id: <20240611215338.2C75BC2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: writeback-factor-out-balance_wb_limits-to-remove-repeated-code-v3-fix
has been added to the -mm mm-unstable branch.  Its filename is
     writeback-factor-out-balance_wb_limits-to-remove-repeated-code-v3-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/writeback-factor-out-balance_wb_limits-to-remove-repeated-code-v3-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: writeback-factor-out-balance_wb_limits-to-remove-repeated-code-v3-fix
Date: Tue Jun 11 02:50:38 PM PDT 2024

s/fileds/fields/ in comment

Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page-writeback.c~writeback-factor-out-balance_wb_limits-to-remove-repeated-code-v3-fix
+++ a/mm/page-writeback.c
@@ -1784,8 +1784,8 @@ static inline void wb_dirty_exceeded(str
 }
 
 /*
- * The limits fileds dirty_exceeded and pos_ratio won't be updated if wb is
- * in freerun state. Please don't use these invalid fileds in freerun case.
+ * The limits fields dirty_exceeded and pos_ratio won't be updated if wb is
+ * in freerun state. Please don't use these invalid fields in freerun case.
  */
 static void balance_wb_limits(struct dirty_throttle_control *dtc,
 			      bool strictlimit)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

writeback-factor-out-balance_wb_limits-to-remove-repeated-code-v3-fix.patch
mm-allow-reuse-of-the-lower-16-bit-of-the-page-type-with-an-actual-type-fix.patch


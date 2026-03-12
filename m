Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28BF6286A4
	for <mm-commits@vger.kernel.org>; Thu, 12 Mar 2026 23:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773356975; cv=none; b=fRnQ2mbd0MuVW2J8IeY5YrJ2ZhgzE26etxOTf4jI+JwhY7rXlxnlkzIQ1cZFnUGv/W65ssZkWr8XYWdbaYxhnwU2jNzKfLWkIPnFqofgjEtpw0g4tjlFdQTzZuZ0YgGYIT0WYcom+YCb+jbXHl4fC8kv2Kcnxk8Om3ntwMtOdyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773356975; c=relaxed/simple;
	bh=9zdL7YOcN9VSIu7p80rwdcDJ4+X3cH42YwOiFSE/nbw=;
	h=Date:To:From:Subject:Message-Id; b=sb0ZAKCNYvP+nCsTY6qHXVd4uJ0eZ1GfRPX2zDmO1Uf2LPuw7p9xH76KdhGGaV5U1dBxD0wfixd+vZtkAEJTFpZv4FNbjhdYuZ5ablHtGCHqI/ai8NS/oNs/WAX3nGBCdDP25nT5jktrZKMa9sewvFpgT7/PY6XL2V6IY9Rq8j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AXitPeKl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AXitPeKl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B12A7C4CEF7;
	Thu, 12 Mar 2026 23:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773356974;
	bh=9zdL7YOcN9VSIu7p80rwdcDJ4+X3cH42YwOiFSE/nbw=;
	h=Date:To:From:Subject:From;
	b=AXitPeKlphfRF1CC570x9kOaUuKU6jaZr4LmHx9SVmINGaSv4t9hKi8wxkNeLv/oA
	 T4yU5Epri/CQscioBwAooVUMAmYTRllLT9VS6vSXzXaXAXlvWVwXiYJUWHO8O3sV66
	 BUdDUFKSr61vrCni2uJYnUMZaCbaPx1eioOehXT4=
Date: Thu, 12 Mar 2026 16:09:34 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,kuba@kernel.org,horms@kernel.org,hisamshar@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + credits-simplify-the-end-of-file-alphabetical-order-comment.patch added to mm-nonmm-unstable branch
Message-Id: <20260312230934.B12A7C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: CREDITS: simplify the end-of-file alphabetical order comment
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     credits-simplify-the-end-of-file-alphabetical-order-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/credits-simplify-the-end-of-file-alphabetical-order-comment.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Hisam Mehboob <hisamshar@gmail.com>
Subject: CREDITS: simplify the end-of-file alphabetical order comment
Date: Thu, 12 Mar 2026 06:17:42 +0500

The existing comment references specific individuals by name which becomes
outdated as new entries are added.  Simplify it to state the alphabetical
ordering rule clearly without depending on who happens to be the last
entry.

Link: https://lkml.kernel.org/r/20260312011741.846664-2-hisamshar@gmail.com
Signed-off-by: Hisam Mehboob <hisamshar@gmail.com>
Suggested-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jakub Kacinski <kuba@kernel.org>
Cc: Simon Horman <horms@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 CREDITS |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/CREDITS~credits-simplify-the-end-of-file-alphabetical-order-comment
+++ a/CREDITS
@@ -4560,8 +4560,5 @@ D: MD driver
 D: EISA/sysfs subsystem
 S: France
 
-# Don't add your name here, unless you really _are_ after Marc
-# alphabetically. Leonard used to be very proud of being the
-# last entry, and he'll get positively pissed if he can't even
-# be second-to-last.  (and this file really _is_ supposed to be
-# in alphabetic order)
+# Don't add your name here unless you really are last alphabetically.
+# (This file is supposed to be kept in alphabetical order by last name.)
_

Patches currently in -mm which might be from hisamshar@gmail.com are

credits-simplify-the-end-of-file-alphabetical-order-comment.patch


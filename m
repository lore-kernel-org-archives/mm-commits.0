Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2832E3387
	for <mm-commits@vger.kernel.org>; Thu,  3 Apr 2025 04:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743654095; cv=none; b=LxpCSEQb9y/T+ksR7x/aXI81OtUF8NOgXpwSwK1n0ou2yK8Ojr7Cf143tSdMPeMKmohNxLME3ihxQH1yOhykYfGHwwsrts1hXmIdEIiOyuz7r8bmfb6YcsNwxlhyn5nfSkW5ReGzuPYKQKr18TixGDwGMyDlJlZQQJERGG+EIrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743654095; c=relaxed/simple;
	bh=fyWMdLYfVvXf7ItTLjaPJh8CRoGH2fsa2WcPtN2OLKk=;
	h=Date:To:From:Subject:Message-Id; b=LZOtMKYytQid7DjU6d0gFxZYiPso3PFTn/s+aliv3hmE6pn3cIBs63EKfl+PnCrdDxqXS/hzMk0RC7sJLKo8+5SrZIEfuLf8amdGMGKlJdeoS8bN8sUqUGMMXZk4xhRdw4/qS+HSPmH86ElORAN6CQ4M1S9zn6idIIUKd+2Hq4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zcrlEbkH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zcrlEbkH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A966C4CEE3;
	Thu,  3 Apr 2025 04:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743654094;
	bh=fyWMdLYfVvXf7ItTLjaPJh8CRoGH2fsa2WcPtN2OLKk=;
	h=Date:To:From:Subject:From;
	b=zcrlEbkHRmrAHZcTIw2nC7GqWYvN2oyk/8T9LhNNW5flw7MVveP/oyxMQeuPIFtX1
	 EbqG+m3LBPE63GumKeEtj10ABnaRDaYfBJNNgVD1ZGIWsbBTdX5qqk5XEw1UcC9koI
	 iKkm6xCW2z/TurwvkUx1CpHwKYdec/Wq8uGc2NUU=
Date: Wed, 02 Apr 2025 21:21:33 -0700
To: mm-commits@vger.kernel.org,pfalcato@suse.de,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,ignacio@iencinas.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-annotate-data-race-in-update_hiwater_rss.patch added to mm-new branch
Message-Id: <20250403042134.6A966C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: annotate data race in update_hiwater_rss
has been added to the -mm mm-new branch.  Its filename is
     mm-annotate-data-race-in-update_hiwater_rss.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-annotate-data-race-in-update_hiwater_rss.patch

This patch will later appear in the mm-new branch at
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
From: Ignacio Encinas <ignacio@iencinas.com>
Subject: mm: annotate data race in update_hiwater_rss
Date: Mon, 31 Mar 2025 21:57:05 +0200

mm_struct.hiwater_rss can be accessed concurrently without proper
synchronization as reported by KCSAN.

This data race is benign as it only affects accounting information.
Annotate it with data_race() to make KCSAN happy.

Link: https://lkml.kernel.org/r/20250331-mm-maxrss-data-race-v2-1-cf958e6205bf@iencinas.com
Signed-off-by: Ignacio Encinas <ignacio@iencinas.com>
Reported-by: syzbot+419c4b42acc36c420ad3@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/67e3390c.050a0220.1ec46.0001.GAE@google.com/
Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Pedro Falcato <pfalcato@suse.de>
Cc: Liam Howlett <liam.howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/mm.h~mm-annotate-data-race-in-update_hiwater_rss
+++ a/include/linux/mm.h
@@ -12,6 +12,7 @@
 #include <linux/rbtree.h>
 #include <linux/atomic.h>
 #include <linux/debug_locks.h>
+#include <linux/compiler.h>
 #include <linux/mm_types.h>
 #include <linux/mmap_lock.h>
 #include <linux/range.h>
@@ -2777,7 +2778,7 @@ static inline void update_hiwater_rss(st
 {
 	unsigned long _rss = get_mm_rss(mm);
 
-	if ((mm)->hiwater_rss < _rss)
+	if (data_race(mm->hiwater_rss) < _rss)
 		(mm)->hiwater_rss = _rss;
 }
 
_

Patches currently in -mm which might be from ignacio@iencinas.com are

mm-annotate-data-race-in-update_hiwater_rss.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED1C12C470
	for <mm-commits@vger.kernel.org>; Thu,  5 Dec 2024 04:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733372367; cv=none; b=O8KlguR0pW9TExFCQZfubVVx0GTTsT3YzgJvoIR2HWDkkg6ZBRbHtoNPQ5tiG8N00UOHDcAuygIGqSaD4MYgWAn5/8ejgUlV0yb7H5VAvKf8ZZg/LNBZj3fl6nXcvSkNymq/zLqSXZaySukDujCvbnrCasU0yAfO8A9n/jno5MY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733372367; c=relaxed/simple;
	bh=3EQLJ1vs5ZGcnt468CF0QG4hFdCZeue5Ch9mt3TcTK8=;
	h=Date:To:From:Subject:Message-Id; b=lW3cq5/XjQsuto8gzi39+AmTiqI0MIgupNX03xWfQ1uAWjxc5v+3KC/kKjcSQaAjMNMu9vCiai6/cny8juG5oyj6/VXiGUZw2ci/JdEjyVO+/xsbMVEnXGMfwhJmTov7hi+KyZe2yWYG/WvkuL2st4IiolNXC+HtIjOji/4BVbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OtzPQMw3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OtzPQMw3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6495BC4CED6;
	Thu,  5 Dec 2024 04:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733372366;
	bh=3EQLJ1vs5ZGcnt468CF0QG4hFdCZeue5Ch9mt3TcTK8=;
	h=Date:To:From:Subject:From;
	b=OtzPQMw3BeczIyBwhMIFgif/nVrUjpdwEdI2J0NXmt7xMaTcOCpediTGXuJyqXeMc
	 NV35fYZnUQgJZWXcK/f9VjaULVBwuwo3jFL+8br0Y3Jr9oRPlmxCgXRyA7CwyGDk+d
	 /cccze7KGohStQdo3d+NtsQ+3SSJwnQ6jBmNXyyU=
Date: Wed, 04 Dec 2024 20:19:25 -0800
To: mm-commits@vger.kernel.org,thomas.orgis@uni-hamburg.de,zhangjiao2@cmss.chinamobile.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-accounting-procacct-fix-minor-errors.patch added to mm-nonmm-unstable branch
Message-Id: <20241205041926.6495BC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/accounting/procacct: Fix minor errors
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     tools-accounting-procacct-fix-minor-errors.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-accounting-procacct-fix-minor-errors.patch

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
From: zhang jiao <zhangjiao2@cmss.chinamobile.com>
Subject: tools/accounting/procacct: Fix minor errors
Date: Tue, 3 Dec 2024 10:05:50 +0800

The logfile option was documented but not working.  Add it and optimized
the while loop.

Link: https://lkml.kernel.org/r/20241203020550.3145-1-zhangjiao2@cmss.chinamobile.com
Signed-off-by: zhang jiao <zhangjiao2@cmss.chinamobile.com>
Reviewed-by: Dr. Thomas Orgis <thomas.orgis@uni-hamburg.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/accounting/procacct.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/tools/accounting/procacct.c~tools-accounting-procacct-fix-minor-errors
+++ a/tools/accounting/procacct.c
@@ -274,12 +274,11 @@ int main(int argc, char *argv[])
 	int maskset = 0;
 	char *logfile = NULL;
 	int cfd = 0;
-	int forking = 0;
 
 	struct msgtemplate msg;
 
-	while (!forking) {
-		c = getopt(argc, argv, "m:vr:");
+	while (1) {
+		c = getopt(argc, argv, "m:vr:w:");
 		if (c < 0)
 			break;
 
_

Patches currently in -mm which might be from zhangjiao2@cmss.chinamobile.com are

tools-accounting-procacct-fix-minor-errors.patch


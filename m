Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 358181448F6
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719293159; cv=none; b=frxUoplCKU7IdNmHT+o/JaGa5CtvwcEJUItyy4xITTzKZ2mepCzeGIRxWfNtU+nnOJ3ql/PFi4nSrihwzrCd9c1td+1rSHPzZMA/50dWw1g5WxUl+yI2bR9crLqX9gl7ZaZ+f8tYLQRK59KGUQtPDJDmBgjoLQTcF/gmSg0XUyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719293159; c=relaxed/simple;
	bh=eh9pgIuD0elGz79vVQYPBkwfYC4lXhlXYNtqP+mEnj8=;
	h=Date:To:From:Subject:Message-Id; b=u95avXqR/DjY208FmrWxONJKw+T2cgphAmL7KbePdJLpE95fQDbIMZ9mrjZQ4L0t9R9zPu77fG75PdGD2YKjcRe/gV/pshlLjzkRdSK1f3DB2WVGapLiikwCrAzBSculw8hLzp/CFOn33o1XQkyi93MLNYK6JlVOLxlW2XR5etY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dd3qlgyU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dd3qlgyU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4B9FC32782;
	Tue, 25 Jun 2024 05:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719293158;
	bh=eh9pgIuD0elGz79vVQYPBkwfYC4lXhlXYNtqP+mEnj8=;
	h=Date:To:From:Subject:From;
	b=dd3qlgyUK1pim1JZe1XdA3sVnJVnkQfBu0e8WfddtNx9NEVntWBlLvuTjZTd2+f+B
	 bhaw3jIr6xEFAyg1Mc5djIr93xH4WncLkGvEEapLSKBfJBLCaSCKsaWhlyFAImd3gT
	 vN9Tln0MRJJU0ovn4EHmf9IaXmbx376bgTpYxA00=
Date: Mon, 24 Jun 2024 22:25:58 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,peterz@infradead.org,namhyung@kernel.org,msakai@redhat.com,mingo@redhat.com,mark.rutland@arm.com,kent.overstreet@linux.dev,jserv@ccns.ncku.edu.tw,jolsa@kernel.org,irogers@google.com,colyli@suse.de,bfoster@redhat.com,bagasdotme@gmail.com,alexander.shishkin@linux.intel.com,adrian.hunter@intel.com,acme@kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] bcache-fix-typo.patch removed from -mm tree
Message-Id: <20240625052558.D4B9FC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: bcache: fix typo
has been removed from the -mm tree.  Its filename was
     bcache-fix-typo.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: bcache: fix typo
Date: Fri, 24 May 2024 23:29:44 +0800

Replace 'utiility' with 'utility'.

Link: https://lkml.kernel.org/r/20240524152958.919343-3-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Brian Foster <bfoster@redhat.com>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: Coly Li <colyli@suse.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Sakai <msakai@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/bcache/util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/bcache/util.c~bcache-fix-typo
+++ a/drivers/md/bcache/util.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * random utiility code, for bcache but in theory not specific to bcache
+ * random utility code, for bcache but in theory not specific to bcache
  *
  * Copyright 2010, 2011 Kent Overstreet <kent.overstreet@gmail.com>
  * Copyright 2012 Google, Inc.
_

Patches currently in -mm which might be from visitorckw@gmail.com are



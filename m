Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3830E1448D4
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719293160; cv=none; b=t1BCi0nME2Syxf1ogksQU1v2f+RY1oy7+1I/rdlgJBjpBVDbhbwm/l2eRSids9F/OqxrV377gkhcLTB3im6I4nzeNtqvmyDx0yXZsbe5b8GRTiD0GU+d3wdVgiR09EX/+YYmdXkFXQHC8VmHsR1jJb7vz5okA0eTxx3ylB1ohFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719293160; c=relaxed/simple;
	bh=ZDXb8IXTIsxHDqEEDulV06AQYYr5pn9Zmc8R0VaNdTA=;
	h=Date:To:From:Subject:Message-Id; b=SMY2r1ZJzmVxaqI8TG6nush31gBcnWw+m7OuhLJwvNOYOXec6/amHghBXZlHb0mw+U8WmSSD+cLoqsSYXpOt5KO0ISXCQcD+qg25KYqO/4P3Ue7y+Z0W4me0iGq8gPkIlUtsRIiM2yko86UtafNCV0G5BM14Q+mI7jzZQnC508c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0hQnKwSQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0hQnKwSQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C3C3C32782;
	Tue, 25 Jun 2024 05:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719293160;
	bh=ZDXb8IXTIsxHDqEEDulV06AQYYr5pn9Zmc8R0VaNdTA=;
	h=Date:To:From:Subject:From;
	b=0hQnKwSQc551z3z2FJngncjH4Q8/5GWhB1wJSNqK6w5rLF1QbhucZ3gAGih7PFGl4
	 8ZaG60J6raj4KwxLWotWsiAgAJMu8pTw/bsdWEUdZ75I+WgSrYLTDhtZdwV0EBhXEs
	 DzIYz82SuGRooKwZJTXW0UtPZPci8laKwyh9ujP8=
Date: Mon, 24 Jun 2024 22:25:59 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,peterz@infradead.org,namhyung@kernel.org,msakai@redhat.com,mingo@redhat.com,mark.rutland@arm.com,kent.overstreet@linux.dev,jserv@ccns.ncku.edu.tw,jolsa@kernel.org,irogers@google.com,colyli@suse.de,bfoster@redhat.com,bagasdotme@gmail.com,alexander.shishkin@linux.intel.com,adrian.hunter@intel.com,acme@kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] bcachefs-fix-typo.patch removed from -mm tree
Message-Id: <20240625052600.0C3C3C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: bcachefs: fix typo
has been removed from the -mm tree.  Its filename was
     bcachefs-fix-typo.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: bcachefs: fix typo
Date: Fri, 24 May 2024 23:29:45 +0800

Replace 'utiility' with 'utility'.

Link: https://lkml.kernel.org/r/20240524152958.919343-4-visitorckw@gmail.com
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

 fs/bcachefs/util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/bcachefs/util.c~bcachefs-fix-typo
+++ a/fs/bcachefs/util.c
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



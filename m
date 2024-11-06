Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9EBD16FF45
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730855634; cv=none; b=nn6Gn0cl8pX8sGoQHMADxrMIrCI8dPSQIZsw/y+Gw16DT7hO8g8xx1M8ynF9gACghfui9+ISzFYvHcYE5g2Vtx9eLFpk7Y/KYIOL48IU8Vb59sXtuorwDu+tnQ6/Acq9Y+G7SyR8X1yeC3Japj0vljSohJUZvmiW7G3vGJXCbRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730855634; c=relaxed/simple;
	bh=1ulXHwdDZXOXS3nBT2azy3lu12PI4k4pw84j6ub4T+4=;
	h=Date:To:From:Subject:Message-Id; b=fFi4PP/yfW17Xmkn8weRg/3+rYY3Zart+wZ5CEzoObMtSg/HdyDvT+bLjKZZBrEyunpTbioLeJl6PBgyHFowygxBMRcHcaO1e6VaNTHXEp/EOBIwlz/WEacAQC6pcMVOsMh5i0HnBlVRQJONcepWhb1w3kSIp2Yqk5gTi9GsB2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aR9HZPcy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aR9HZPcy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72667C4CECF;
	Wed,  6 Nov 2024 01:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730855634;
	bh=1ulXHwdDZXOXS3nBT2azy3lu12PI4k4pw84j6ub4T+4=;
	h=Date:To:From:Subject:From;
	b=aR9HZPcyof2aChtW+66INrngyqSQPDgSBqRCHLcrr+9iHeMLWWasqpkZzBIHB5XWF
	 wbLkiN2+3Xia4N/lV5aLiCp22lxstH6yNIUlJH0LovyJD31O1g8oH+h+7jy8dVIT6p
	 B8F6LOsNHtjSMZs5roQLShLD5LWhQQM+JclK1QLY=
Date: Tue, 05 Nov 2024 17:13:53 -0800
To: mm-commits@vger.kernel.org,peterz@infradead.org,namhyung@kernel.org,mingo@redhat.com,mark.rutland@arm.com,kan.liang@linux.intel.com,jserv@ccns.ncku.edu.tw,jolsa@kernel.org,irogers@google.com,adrian.hunter@intel.com,acme@kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] tools-lib-list_sort-remove-unnecessary-header-includes.patch removed from -mm tree
Message-Id: <20241106011354.72667C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/lib/list_sort: remove unnecessary header includes
has been removed from the -mm tree.  Its filename was
     tools-lib-list_sort-remove-unnecessary-header-includes.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: tools/lib/list_sort: remove unnecessary header includes
Date: Sat, 12 Oct 2024 12:28:27 +0800

Since lib/list_sort.c no longer requires ARRAY_SIZE() and memset(), the
includes for kernel.h, bug.h, and string.h have been removed.  Similarly,
tools/lib/list_sort.c also does not need to include these headers, so they
have been removed as well.

Link: https://lkml.kernel.org/r/20241012042828.471614-3-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: "Liang, Kan" <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/lib/list_sort.c |    2 --
 1 file changed, 2 deletions(-)

--- a/tools/lib/list_sort.c~tools-lib-list_sort-remove-unnecessary-header-includes
+++ a/tools/lib/list_sort.c
@@ -1,8 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
-#include <linux/kernel.h>
 #include <linux/compiler.h>
 #include <linux/export.h>
-#include <linux/string.h>
 #include <linux/list_sort.h>
 #include <linux/list.h>
 
_

Patches currently in -mm which might be from visitorckw@gmail.com are



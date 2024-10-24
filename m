Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678A656446
	for <mm-commits@vger.kernel.org>; Thu, 24 Oct 2024 02:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729736266; cv=none; b=rQVwo8bhJMLFzkbHXOQrl+pPPinevXzUpm6gM0XUvyvmuiDcp08U9gyiYam4H8JxrtDks8WdAXDAf+bJEJ3t4DY5BN0QEjy8htkzGeWC60fLGiTjERi772LnLH02/2HNiPoWrcUBz3pew7GFc4hjAgzAz3Im6TBC8baVPMQkuQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729736266; c=relaxed/simple;
	bh=yBJaGiZFDqaAshPxg//4dBIexfa1agYIhthcgwBGR3o=;
	h=Date:To:From:Subject:Message-Id; b=F+jSnCNlMxWil6xJM9UyQCZF1cPNH+n8/WQwXIDbXBsZWqyZh0O7LVJ8TKQOTjv2YqI4IGkt0OPyR8q5BQpyOQWQiy7KIMQkHWSk8L9Ur5tv2X6txkQFZLlnc6lCMAh28RxHPm5qdtcnU5W0YsWc8TolRWf+SviYaKmj0VvvJvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W/dnIgmS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W/dnIgmS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD91FC4CEC6;
	Thu, 24 Oct 2024 02:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729736265;
	bh=yBJaGiZFDqaAshPxg//4dBIexfa1agYIhthcgwBGR3o=;
	h=Date:To:From:Subject:From;
	b=W/dnIgmSI633IJLCOcoXNczL46kXMnxH19oX8C0Zo22NnYeywDiJsOmBlBiJoF0cN
	 OVBCN8Cv+qym4JUbBWEwhDRSBhayHUl+0e0UnmXtEpQyUfJFQVDpUQ0LOChPcc1KMW
	 3hKIZLoQjf8PQ2kVMT4+6uR2sEbZeFPm9beIVYM4=
Date: Wed, 23 Oct 2024 19:17:45 -0700
To: mm-commits@vger.kernel.org,peterz@infradead.org,namhyung@kernel.org,mingo@redhat.com,mark.rutland@arm.com,kan.liang@linux.intel.com,jserv@ccns.ncku.edu.tw,jolsa@kernel.org,irogers@google.com,adrian.hunter@intel.com,acme@kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-list_sort-remove-unnecessary-header-includes.patch added to mm-nonmm-unstable branch
Message-Id: <20241024021745.BD91FC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/list_sort: remove unnecessary header includes
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-list_sort-remove-unnecessary-header-includes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-list_sort-remove-unnecessary-header-includes.patch

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
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: lib/list_sort: remove unnecessary header includes
Date: Sat, 12 Oct 2024 12:28:26 +0800

Patch series "Remove unnecessary header includes from
{tools/}lib/list_sort.c".

Remove outdated and unnecessary header includes from lib/list_sort.c and
tools/lib/list_sort.c.  Additionally, update the hunk exceptions checked
by check_headers.sh to reflect these changes.


This patch (of 3):

After commit 043b3f7b6388 ("lib/list_sort: simplify and remove
MAX_LIST_LENGTH_BITS"), list_sort.c no longer uses ARRAY_SIZE() (which
required kernel.h and bug.h for BUILD_BUG_ON_ZERO via __must_be_array) or
memset() (which required string.h).  As these headers are no longer
needed, removes them.

There are no changes to the generated code, as confirmed by 'objdump -d'. 
Additionally, 'wc -l' shows that the size of lib/.list_sort.o.cmd is
reduced from 259 lines to 101 lines.

Link: https://lkml.kernel.org/r/20241012042828.471614-1-visitorckw@gmail.com
Link: https://lkml.kernel.org/r/20241012042828.471614-2-visitorckw@gmail.com
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

 lib/list_sort.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/lib/list_sort.c~lib-list_sort-remove-unnecessary-header-includes
+++ a/lib/list_sort.c
@@ -1,9 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
-#include <linux/kernel.h>
-#include <linux/bug.h>
 #include <linux/compiler.h>
 #include <linux/export.h>
-#include <linux/string.h>
 #include <linux/list_sort.h>
 #include <linux/list.h>
 
_

Patches currently in -mm which might be from visitorckw@gmail.com are

lib-kconfigdebug-move-int_pow-test-option-to-runtime-testing-section.patch
lib-makefile-make-union-find-compilation-conditional-on-config_cpusets.patch
lib-list_sort-remove-unnecessary-header-includes.patch
tools-lib-list_sort-remove-unnecessary-header-includes.patch
perf-tools-update-expected-diff-for-lib-list_sortc.patch


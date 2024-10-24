Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CFCB56446
	for <mm-commits@vger.kernel.org>; Thu, 24 Oct 2024 02:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729736270; cv=none; b=jaXfOi85/8jTIkGV8V868z5Wz4zXptdwk2CV5eQh/JxfAtv7ggW0ERa9hiTfQ6Ne4ObGS8PvfAnPJ0F7hPgvLXWvgJCgpqu1bOUJ0ks5ZAcRYr/FCT8PSenuY1sRmHwREPOXy/4WEpUmWp7+uSLonBXf+lwFvyBqWQ9cb3YXwvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729736270; c=relaxed/simple;
	bh=PBc6g0Y/Xk9z0JTD0M4EOGTmRS9SbZkTpRrNFSpFAao=;
	h=Date:To:From:Subject:Message-Id; b=beRtZQ1vp4Sh9o5sTD3NCG6dMYwD1YtjFoD1VdVDGYBwMY+BeO/L3WsSNVCRqBrygLjXlXj8VkEnJC/r9xBvBiWGe1T8x+wDw6EvafyPzEAb2m9eOu4d4prdO8nd9lW88rvpxgO2GPJRJQOeNWNXgx6WLo/DEtCiygHtcRosOfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YEjh2F54; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YEjh2F54"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93DF1C4CEC6;
	Thu, 24 Oct 2024 02:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729736269;
	bh=PBc6g0Y/Xk9z0JTD0M4EOGTmRS9SbZkTpRrNFSpFAao=;
	h=Date:To:From:Subject:From;
	b=YEjh2F54CGKQXycXr8ZTUEui0jklCAdcVKmo57FKkg5GIcE87zeeNoJZBravEpPvK
	 It+1QMSrPbXtJM0evx7uOpQq99WLLz3GXviM+QtURBaH8y+8gLcwqSd200ydesNhQH
	 KxIUOeHOV30vxmjSUuYk/OWILTofAkibUcdEJS30=
Date: Wed, 23 Oct 2024 19:17:49 -0700
To: mm-commits@vger.kernel.org,peterz@infradead.org,namhyung@kernel.org,mingo@redhat.com,mark.rutland@arm.com,kan.liang@linux.intel.com,jserv@ccns.ncku.edu.tw,jolsa@kernel.org,irogers@google.com,adrian.hunter@intel.com,acme@kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + perf-tools-update-expected-diff-for-lib-list_sortc.patch added to mm-nonmm-unstable branch
Message-Id: <20241024021749.93DF1C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: perf tools: update expected diff for lib/list_sort.c
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     perf-tools-update-expected-diff-for-lib-list_sortc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/perf-tools-update-expected-diff-for-lib-list_sortc.patch

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
Subject: perf tools: update expected diff for lib/list_sort.c
Date: Sat, 12 Oct 2024 12:28:28 +0800

Since there are no longer any header include differences between
lib/list_sort.c and tools/lib/list_sort.c, update the expected diff in
check-header_ignore_hunks accordingly.

Link: https://lkml.kernel.org/r/20241012042828.471614-4-visitorckw@gmail.com
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

 tools/perf/check-header_ignore_hunks/lib/list_sort.c |   11 +---------
 1 file changed, 2 insertions(+), 9 deletions(-)

--- a/tools/perf/check-header_ignore_hunks/lib/list_sort.c~perf-tools-update-expected-diff-for-lib-list_sortc
+++ a/tools/perf/check-header_ignore_hunks/lib/list_sort.c
@@ -1,11 +1,4 @@
-@@ -1,5 +1,6 @@
- // SPDX-License-Identifier: GPL-2.0
- #include <linux/kernel.h>
-+#include <linux/bug.h>
- #include <linux/compiler.h>
- #include <linux/export.h>
- #include <linux/string.h>
-@@ -52,6 +53,7 @@
+@@ -50,6 +50,7 @@
  			struct list_head *a, struct list_head *b)
  {
  	struct list_head *tail = head;
@@ -13,7 +6,7 @@
  
  	for (;;) {
  		/* if equal, take 'a' -- important for sort stability */
-@@ -77,6 +79,15 @@
+@@ -75,6 +76,15 @@
  	/* Finish linking remainder of list b on to tail */
  	tail->next = b;
  	do {
_

Patches currently in -mm which might be from visitorckw@gmail.com are

lib-kconfigdebug-move-int_pow-test-option-to-runtime-testing-section.patch
lib-makefile-make-union-find-compilation-conditional-on-config_cpusets.patch
lib-list_sort-remove-unnecessary-header-includes.patch
tools-lib-list_sort-remove-unnecessary-header-includes.patch
perf-tools-update-expected-diff-for-lib-list_sortc.patch


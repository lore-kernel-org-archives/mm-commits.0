Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D793416FF45
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730855635; cv=none; b=Guypp8lmZ0Y2jk/WrlyRrldZnJQ1nsFWr5qaMi1NUM3VmJakmrMmdVqv61OKNhS7YS68HkgB8R8FPGpNwg5T7AkzDY0oG1gn54r+IOualNAHVh1rcN1Qe0a8FSs4G34p6VHQZFvDLkBqjVvO6H2gvgV4G2UcqMWIT1WsFwgMGBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730855635; c=relaxed/simple;
	bh=9x9R0XmKjXRRcK7jaCztaCllb7yylBB9z3vGxbsELtU=;
	h=Date:To:From:Subject:Message-Id; b=lgDJC78wKjxoOblc7sELEJ0z1axVPqetRajw+dWTid+4VGOgXHsOmssAJZomeLrKK40uOnsCr3K7Nk4Y6v7yXuvv2CcHr5Fy4Kz+s0PZrxleT4Aa4z8LID2jmLl7UrKpuIG7k3gGeukisLeLAvHSaneyy/SITaJkim0gK8PtMQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qKWdbgUA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qKWdbgUA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1DBFC4CECF;
	Wed,  6 Nov 2024 01:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730855635;
	bh=9x9R0XmKjXRRcK7jaCztaCllb7yylBB9z3vGxbsELtU=;
	h=Date:To:From:Subject:From;
	b=qKWdbgUAxMS2usIjbKgf15Wv6JJC1RaKKxF0qPJoxij+/wH5hEs1I93gq0WXYx+pT
	 iJ8H9Kq5PnsLMVFxroJHZTsPidQGZRvl8r4OARruykcVGmjHp/lNXBqH0Gjv3QSnaJ
	 ParUt95JJPiTFqOCdv+nHGG+yrVXAcHdIu1krq/8=
Date: Tue, 05 Nov 2024 17:13:55 -0800
To: mm-commits@vger.kernel.org,peterz@infradead.org,namhyung@kernel.org,mingo@redhat.com,mark.rutland@arm.com,kan.liang@linux.intel.com,jserv@ccns.ncku.edu.tw,jolsa@kernel.org,irogers@google.com,adrian.hunter@intel.com,acme@kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] perf-tools-update-expected-diff-for-lib-list_sortc.patch removed from -mm tree
Message-Id: <20241106011355.A1DBFC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: perf tools: update expected diff for lib/list_sort.c
has been removed from the -mm tree.  Its filename was
     perf-tools-update-expected-diff-for-lib-list_sortc.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



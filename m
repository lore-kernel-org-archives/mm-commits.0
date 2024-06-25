Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D054F33C0
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719293195; cv=none; b=dWjIjCp8//WpX5+5YcFwpqgSUA6P1EE6oL/ysn23nZC8IYByN3CWjU23rM23e3EB711LnTJwc6+Tp4XwEXTReFVf04F7GdbX3xtAdDm9aWj2lqd1Syiey3VLy2YVA6wk3ym8mbjDYQ0dSy7EkHU64NGi47APo7lh37I1x3OdKlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719293195; c=relaxed/simple;
	bh=thWOUerBAMkx+hm4eFAXQst0qq58viO1hNjmXN6Wn6o=;
	h=Date:To:From:Subject:Message-Id; b=JRCQSLPhZMVZwOBRHLu1Jn68BhJlhPB5dxHcilhac0C/m7iw60rzgwfWkCCkMh3FqEts4/yOIJu70UtWtasp/kJsi+hTiCgYYCdGz9XaOA9LczwAzHF1yLSkrQwJgRNPFkJ1Vtoej0iuxG6AqVRxTUM3qZ46wyXsgdh/vZ8e4QM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ovp49fYv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ovp49fYv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CE9AC32782;
	Tue, 25 Jun 2024 05:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719293195;
	bh=thWOUerBAMkx+hm4eFAXQst0qq58viO1hNjmXN6Wn6o=;
	h=Date:To:From:Subject:From;
	b=ovp49fYvwo5SVRPlUjQzkx6WoMs7rNWmsqcvwm599SFRSI9F9VvbOxBIhtqhCbiQc
	 5dFDO017qtyjlR0n2MrrjSgRZS4Lpru2VmNz3qGCffl0WBfuo9GAVgCMwCjHBdxeFI
	 DkqK/PF6I5pedmqg5M4DVtmMa5Bf7GX7K6h0yPSo=
Date: Mon, 24 Jun 2024 22:26:35 -0700
To: mm-commits@vger.kernel.org,peterz@infradead.org,namhyung@kernel.org,mingo@redhat.com,mark.rutland@arm.com,kan.liang@linux.intel.com,jserv@ccns.ncku.edu.tw,jolsa@kernel.org,irogers@google.com,alexander.shishkin@linux.intel.com,adrian.hunter@intel.com,acme@kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] tools-lib-list_sort-remove-redundant-code-for-cond_resched-handling.patch removed from -mm tree
Message-Id: <20240625052635.9CE9AC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/lib/list_sort: remove redundant code for cond_resched handling
has been removed from the -mm tree.  Its filename was
     tools-lib-list_sort-remove-redundant-code-for-cond_resched-handling.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: tools/lib/list_sort: remove redundant code for cond_resched handling
Date: Sun, 26 May 2024 07:02:06 +0800

Since cond_resched() is not called in userspace, remove the redundant code
in userspace's list_sort() implementation.  This change eliminates the
unused 'count' variable and the associated logic for invoking cmp()
periodically, which was intended to trigger cond_resched() in kernel
space.

The removed code includes:
- Declaration and increment of the 'count' variable.
- Conditional invocation of cmp() based on 'count'.

This cleanup simplifies merge_final(), avoids unnecessary overhead, and
has no impact on the functionality of list_sort() in userspace.

Link: https://lkml.kernel.org/r/20240525230206.1077536-1-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/lib/list_sort.c |   10 ----------
 1 file changed, 10 deletions(-)

--- a/tools/lib/list_sort.c~tools-lib-list_sort-remove-redundant-code-for-cond_resched-handling
+++ a/tools/lib/list_sort.c
@@ -52,7 +52,6 @@ static void merge_final(void *priv, list
 			struct list_head *a, struct list_head *b)
 {
 	struct list_head *tail = head;
-	u8 count = 0;
 
 	for (;;) {
 		/* if equal, take 'a' -- important for sort stability */
@@ -78,15 +77,6 @@ static void merge_final(void *priv, list
 	/* Finish linking remainder of list b on to tail */
 	tail->next = b;
 	do {
-		/*
-		 * If the merge is highly unbalanced (e.g. the input is
-		 * already sorted), this loop may run many iterations.
-		 * Continue callbacks to the client even though no
-		 * element comparison is needed, so the client's cmp()
-		 * routine can invoke cond_resched() periodically.
-		 */
-		if (unlikely(!++count))
-			cmp(priv, b, b);
 		b->prev = tail;
 		tail = b;
 		b = b->next;
_

Patches currently in -mm which might be from visitorckw@gmail.com are



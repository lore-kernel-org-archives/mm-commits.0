Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C8F175A80
	for <mm-commits@vger.kernel.org>; Sat, 21 Mar 2026 01:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774056070; cv=none; b=qAbrE1QuPo+g05cPxLKgNkKkkr322BHpkyuUrVZ0nn4M30CrK1SOBrvHFGox7ZAiZlWcXIl12x52WnhBBONyzhrOEpQF1DLSauEhjnqWpeuX8lNGmaZ+bDKkDt0/MPpHBXnzfq1daU+woyTZeYSYDaqmCCAglbjdpgy8O0G0kNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774056070; c=relaxed/simple;
	bh=1lDzkCM5Itduz7P39EsmKflLzc9fF3SIFdpMJeCSEK0=;
	h=Date:To:From:Subject:Message-Id; b=L5DoZgRvqC4IMoQ5gl09UBNuP1Mgi4MBuIfzaPFxG4VSw98Oszr7WPWtUjX/Cta02kzOYC2FqorTbp0OKpE/88Ka5NteBRUOFeQzfLO/9/laAbfmtFsfgrNMajYOlSAMNibQYBf+liTUnLn58JbGcrwz77Zqnql+PLZ9B/Wes1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h8GlIj5q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h8GlIj5q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F39EC4CEF7;
	Sat, 21 Mar 2026 01:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774056070;
	bh=1lDzkCM5Itduz7P39EsmKflLzc9fF3SIFdpMJeCSEK0=;
	h=Date:To:From:Subject:From;
	b=h8GlIj5qLBhJU5qzu0LgpavhULx1/9Q5+62HvqizhBoUPlEQIHhChrtHrZEzBjDYz
	 WSs0PdsrCfN6iSzHq7hFVurUyV2Omf7ynfUbMeA7zGFGO3pjPzJoKXWI5DCZDgDxwX
	 azgZJM/uMBFSB/ri813cU2p22fy8d7rKk7h8i/GM=
Date: Fri, 20 Mar 2026 18:21:09 -0700
To: mm-commits@vger.kernel.org,richard@nod.at,marscheng@google.com,jserv@ccns.ncku.edu.tw,hch@infradead.org,eleanor15x@gmail.com,chengzhihao1@huawei.com,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ubifs-remove-unnecessary-cond_resched-from-list_sort-compare.patch added to mm-nonmm-unstable branch
Message-Id: <20260321012110.2F39EC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ubifs: remove unnecessary cond_resched() from list_sort() compare
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ubifs-remove-unnecessary-cond_resched-from-list_sort-compare.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ubifs-remove-unnecessary-cond_resched-from-list_sort-compare.patch

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
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: ubifs: remove unnecessary cond_resched() from list_sort() compare
Date: Fri, 20 Mar 2026 18:09:37 +0000

Patch series "lib/list_sort: Clean up list_sort() scheduling workarounds",
v3.

Historically, list_sort() included a hack in merge_final() that
periodically invoked dummy cmp(priv, b, b) calls when merging highly
unbalanced lists.  This allowed the caller to invoke cond_resched() within
their comparison callbacks to avoid soft lockups.  

However, an audit of the kernel tree shows that fs/ubifs/ has been the
sole user of this mechanism.  For all other generic list_sort() users,
this results in wasted function calls and unnecessary overhead in a tight
loop.

Recent discussions and code inspection confirmed that the lists being
sorted in UBIFS are bounded in size (a few thousand elements at most), and
the comparison functions are extremely lightweight.  Therefore, UBIFS does
not actually need to rely on this mechanism.


This patch (of 2):

Historically, UBIFS embedded cond_resched() calls inside its list_sort()
comparison callbacks (data_nodes_cmp, nondata_nodes_cmp, and
replay_entries_cmp) to prevent soft lockups when sorting long lists.

However, further inspection by Richard Weinberger reveals that these
compare functions are extremely lightweight and do not perform any
blocking MTD I/O. Furthermore, the lists being sorted are strictly
bounded in size:
- In the GC case, the list contains at most the number of nodes that
  fit into a single LEB.
- In the replay case, the list spans across a few LEBs from the UBIFS
  journal, amounting to at most a few thousand elements.

Since the compare functions are called a few thousand times at most, the
overhead of frequent scheduling points is unjustified.  Removing the
cond_resched() calls simplifies the comparison logic and reduces
unnecessary context switch checks during the sort.

Link: https://lkml.kernel.org/r/20260320180938.1827148-1-visitorckw@gmail.com
Link: https://lkml.kernel.org/r/20260320180938.1827148-2-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Mars Cheng <marscheng@google.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Yu-Chun Lin <eleanor15x@gmail.com>
Cc: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ubifs/gc.c     |    2 --
 fs/ubifs/replay.c |    1 -
 2 files changed, 3 deletions(-)

--- a/fs/ubifs/gc.c~ubifs-remove-unnecessary-cond_resched-from-list_sort-compare
+++ a/fs/ubifs/gc.c
@@ -109,7 +109,6 @@ static int data_nodes_cmp(void *priv, co
 	struct ubifs_info *c = priv;
 	struct ubifs_scan_node *sa, *sb;
 
-	cond_resched();
 	if (a == b)
 		return 0;
 
@@ -153,7 +152,6 @@ static int nondata_nodes_cmp(void *priv,
 	struct ubifs_info *c = priv;
 	struct ubifs_scan_node *sa, *sb;
 
-	cond_resched();
 	if (a == b)
 		return 0;
 
--- a/fs/ubifs/replay.c~ubifs-remove-unnecessary-cond_resched-from-list_sort-compare
+++ a/fs/ubifs/replay.c
@@ -305,7 +305,6 @@ static int replay_entries_cmp(void *priv
 	struct ubifs_info *c = priv;
 	struct replay_entry *ra, *rb;
 
-	cond_resched();
 	if (a == b)
 		return 0;
 
_

Patches currently in -mm which might be from visitorckw@gmail.com are

ubifs-remove-unnecessary-cond_resched-from-list_sort-compare.patch
lib-list_sort-remove-dummy-cmp-calls-to-speed-up-merge_final.patch


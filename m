Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C9912B97
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560218; cv=none; b=BjP41pAvRSLUDeeammBLOa5JBifAl5WSt8y6VYiu8wjdWeFIMxyvQF7GSa9cTtnzI2cgHC+h8o14qAXwW/Qc3BXu5a1lhzUG2f7JEUwyk6xtx+xjhnXFd1nCI0iaXkcVWA/1v6MJuOTR894SnI8pbf+DquZqwBH6HCsXHFFQkz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560218; c=relaxed/simple;
	bh=nYR8W6efj3wMr6JD8dwTuV444CsaJXr1OROv1xrE7Gc=;
	h=Date:To:From:Subject:Message-Id; b=UaU7nAw4eeXmxJE6FYUFxhR8D290QhMiLkb10us5jIO4Qqbq0jnO5TvbYmnU3F/iAtYbEm92pUq0nPMQU+sM0rZiRPD0/cF4gaP9XCBxhDr8dVkzi04ZnRJzTRBk4vEU5SL1Vb5O7Ema5zkRw34NAalgXG3s1odYez70lwnzTQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d0rM15Do; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d0rM15Do"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BE50C433C7;
	Thu, 22 Feb 2024 00:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560218;
	bh=nYR8W6efj3wMr6JD8dwTuV444CsaJXr1OROv1xrE7Gc=;
	h=Date:To:From:Subject:From;
	b=d0rM15Do723LyCy9oo/jQJzI6TQSfCpWLQBMHlBunrZQFYXPlVEbHz8kEOKDv4ZOm
	 mhMOcM5tu33kHgFiWmibFdowk03NG2YBb1/Tf06QFN8jG1peSt1sp9pIYOC8hzJLqr
	 ZCT39pOgaVz/raCDd47vFmEjfYMagq67SUx6LzSo=
Date: Wed, 21 Feb 2024 16:03:37 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,donettom@linux.vnet.ibm.com,aneesh.kumar@linux.ibm.com,kinseyho@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mglru-drop-unused-parameter.patch removed from -mm tree
Message-Id: <20240222000338.0BE50C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mglru: drop unused parameter
has been removed from the -mm tree.  Its filename was
     mm-mglru-drop-unused-parameter.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kinsey Ho <kinseyho@google.com>
Subject: mm/mglru: drop unused parameter
Date: Wed, 14 Feb 2024 06:05:34 +0000

Patch series "mm/mglru: code cleanup and refactoring"

This provides MGLRU code cleanup and refactoring for better readability.


This patch (of 5):

struct scan_control *sc is currently passed into try_to_inc_max_seq() and
run_aging().  This parameter is not used.

Drop the unused parameter struct scan_control *sc. No functional change.

Link: https://lkml.kernel.org/r/20240214060538.3524462-1-kinseyho@google.com
Link: https://lkml.kernel.org/r/20240214060538.3524462-2-kinseyho@google.com
Signed-off-by: Kinsey Ho <kinseyho@google.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Donet Tom <donettom@linux.vnet.ibm.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/vmscan.c~mm-mglru-drop-unused-parameter
+++ a/mm/vmscan.c
@@ -3816,7 +3816,7 @@ unlock:
 }
 
 static bool try_to_inc_max_seq(struct lruvec *lruvec, unsigned long max_seq,
-			       struct scan_control *sc, bool can_swap, bool force_scan)
+			       bool can_swap, bool force_scan)
 {
 	bool success;
 	struct lru_gen_mm_walk *walk;
@@ -4672,7 +4672,7 @@ static long get_nr_to_scan(struct lruvec
 		return nr_to_scan;
 
 	/* skip this lruvec as it's low on cold folios */
-	return try_to_inc_max_seq(lruvec, max_seq, sc, can_swap, false) ? -1 : 0;
+	return try_to_inc_max_seq(lruvec, max_seq, can_swap, false) ? -1 : 0;
 }
 
 static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
@@ -5332,7 +5332,7 @@ static const struct seq_operations lru_g
 	.show = lru_gen_seq_show,
 };
 
-static int run_aging(struct lruvec *lruvec, unsigned long seq, struct scan_control *sc,
+static int run_aging(struct lruvec *lruvec, unsigned long seq,
 		     bool can_swap, bool force_scan)
 {
 	DEFINE_MAX_SEQ(lruvec);
@@ -5347,7 +5347,7 @@ static int run_aging(struct lruvec *lruv
 	if (!force_scan && min_seq[!can_swap] + MAX_NR_GENS - 1 <= max_seq)
 		return -ERANGE;
 
-	try_to_inc_max_seq(lruvec, max_seq, sc, can_swap, force_scan);
+	try_to_inc_max_seq(lruvec, max_seq, can_swap, force_scan);
 
 	return 0;
 }
@@ -5415,7 +5415,7 @@ static int run_cmd(char cmd, int memcg_i
 
 	switch (cmd) {
 	case '+':
-		err = run_aging(lruvec, seq, sc, swappiness, opt);
+		err = run_aging(lruvec, seq, swappiness, opt);
 		break;
 	case '-':
 		err = run_eviction(lruvec, seq, sc, swappiness, opt);
_

Patches currently in -mm which might be from kinseyho@google.com are



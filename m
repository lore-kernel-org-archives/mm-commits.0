Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 756B75C5FA
	for <mm-commits@vger.kernel.org>; Wed, 14 Feb 2024 15:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707923573; cv=none; b=ep4Dq/8rAsxFVsUKaMtvLE1Si4eEs7H4fqXjzrw8zdwEbyCkYw7PPDfu8K+maK3agEnrkPYFh4BTFJvl19X8zV9vTl0zCXGTuAQvNMbJAE7b0ANxcszFQzPV0f4dNf9u42srZcSw4h0gZiVjcrJyiAquxkr4PQQPC4KLYbW0fRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707923573; c=relaxed/simple;
	bh=QeutVwFPTVL/0K0YhVgp1Ow6gyjabP3tIwJ+JrPZ7KA=;
	h=Date:To:From:Subject:Message-Id; b=mP6ROlylxMUc4aQpT37f/t+RMxuGWYwitWNVPCucmbsG5WfRgs37w60S0Tv6ERFp9Y2vftn0ajZX7KwbXEYGSOoJ2mqv+tanzJLkskzaWl9r7L4Xgqnr4/hAEjyAeTXPWWy5uEarRK9wObzdPFobHjYIs3lYDdTnro1yRZGU/Ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K61fibJO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K61fibJO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3199C433F1;
	Wed, 14 Feb 2024 15:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707923572;
	bh=QeutVwFPTVL/0K0YhVgp1Ow6gyjabP3tIwJ+JrPZ7KA=;
	h=Date:To:From:Subject:From;
	b=K61fibJOdimE2f/GOd4GInKSI7SL9ii8fLsdgFDz4pNHwTt1hf1JitVu1IPbw23oE
	 6WkjwyIeBiZbrAKY1cOxe8G3opMeor9FtfVlPrm05mvN6ND1b+WFSzlDRPWaPCV1uR
	 DItLjKHxgZZwD0ueYSs9OM25TSGRFZwtyU5N31kc=
Date: Wed, 14 Feb 2024 07:12:51 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,donettom@linux.vnet.ibm.com,aneesh.kumar@linux.ibm.com,kinseyho@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-drop-unused-parameter.patch added to mm-unstable branch
Message-Id: <20240214151252.C3199C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mglru: drop unused parameter
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mglru-drop-unused-parameter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-drop-unused-parameter.patch

This patch will later appear in the mm-unstable branch at
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
@@ -3817,7 +3817,7 @@ unlock:
 }
 
 static bool try_to_inc_max_seq(struct lruvec *lruvec, unsigned long max_seq,
-			       struct scan_control *sc, bool can_swap, bool force_scan)
+			       bool can_swap, bool force_scan)
 {
 	bool success;
 	struct lru_gen_mm_walk *walk;
@@ -4673,7 +4673,7 @@ static long get_nr_to_scan(struct lruvec
 		return nr_to_scan;
 
 	/* skip this lruvec as it's low on cold folios */
-	return try_to_inc_max_seq(lruvec, max_seq, sc, can_swap, false) ? -1 : 0;
+	return try_to_inc_max_seq(lruvec, max_seq, can_swap, false) ? -1 : 0;
 }
 
 static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
@@ -5333,7 +5333,7 @@ static const struct seq_operations lru_g
 	.show = lru_gen_seq_show,
 };
 
-static int run_aging(struct lruvec *lruvec, unsigned long seq, struct scan_control *sc,
+static int run_aging(struct lruvec *lruvec, unsigned long seq,
 		     bool can_swap, bool force_scan)
 {
 	DEFINE_MAX_SEQ(lruvec);
@@ -5348,7 +5348,7 @@ static int run_aging(struct lruvec *lruv
 	if (!force_scan && min_seq[!can_swap] + MAX_NR_GENS - 1 <= max_seq)
 		return -ERANGE;
 
-	try_to_inc_max_seq(lruvec, max_seq, sc, can_swap, force_scan);
+	try_to_inc_max_seq(lruvec, max_seq, can_swap, force_scan);
 
 	return 0;
 }
@@ -5416,7 +5416,7 @@ static int run_cmd(char cmd, int memcg_i
 
 	switch (cmd) {
 	case '+':
-		err = run_aging(lruvec, seq, sc, swappiness, opt);
+		err = run_aging(lruvec, seq, swappiness, opt);
 		break;
 	case '-':
 		err = run_eviction(lruvec, seq, sc, swappiness, opt);
_

Patches currently in -mm which might be from kinseyho@google.com are

mm-mglru-drop-unused-parameter.patch
mm-mglru-improve-should_run_aging.patch
mm-mglru-improve-reset_mm_stats.patch
mm-mglru-improve-struct-lru_gen_mm_walk.patch
mm-mglru-improve-swappiness-handling.patch


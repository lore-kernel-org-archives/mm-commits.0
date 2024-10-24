Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3935815E5B5;
	Thu, 24 Oct 2024 03:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729740390; cv=none; b=aJ+tzmyzdsIgomlvBLS4fySKsrK5BJGf//yeRoIGAqDdzJTB89PMdTza6kh5T84iyFoji1m4zh/kDMXBM2wxUWwQuvR++2A6xU9Wbx1xBUlfavSXVJ5NBNtzKiPpE+5eYd9msa1CwJ01bef8Buvp218hwSU6ClxJH2nLDexKRw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729740390; c=relaxed/simple;
	bh=sA7lsaxO2lYk5WCgaBlue5KkdPVvvonLjE89Ugp2G0g=;
	h=Date:To:From:Subject:Message-Id; b=FVQI1qPcs2nKr5usUHFrz6Dre5laVjtXfTgw5tXupKo8K05dsWz+aAG8zhlTYgf3gfD7Awcm6pNUDF9/H+kekPTa0gB4Fh09dpWRFLlGXt/Pw0CG/KbLyrQAqaY3Hdrsbdm8G5CR9ERHZNCjtrj7pDqKg4S2fu0b+ILNGWV0O3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i7BukLEO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i7BukLEO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A14BBC4CEC7;
	Thu, 24 Oct 2024 03:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729740389;
	bh=sA7lsaxO2lYk5WCgaBlue5KkdPVvvonLjE89Ugp2G0g=;
	h=Date:To:From:Subject:From;
	b=i7BukLEOj4UnKMxjwHswSF/KJltCr/7S1zqGVb2f2JD5lsbrSWKnAaHKEyR/+UQ5e
	 xygGpSUGpdUmKm7ZdChkOl+CdzQux2U99SFmdJdmtdk+DYKWLJrY7FSdvMKhUo4hwh
	 O5F0lbYC4GyoZZ4gfsaxfAGhEwcpChmj2WDcKWa4=
Date: Wed, 23 Oct 2024 20:26:29 -0700
To: mm-commits@vger.kernel.org,weixugc@google.com,stevensd@google.com,stable@vger.kernel.org,seanjc@google.com,rientjes@google.com,pbonzini@redhat.com,oliver.upton@linux.dev,jthoughton@google.com,dmatlack@google.com,axelrasmussen@google.com,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-multi-gen-lru-remove-mm_leaf_old-and-mm_nonleaf_total-stats.patch added to mm-hotfixes-unstable branch
Message-Id: <20241024032629.A14BBC4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: multi-gen LRU: remove MM_LEAF_OLD and MM_NONLEAF_TOTAL stats
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-multi-gen-lru-remove-mm_leaf_old-and-mm_nonleaf_total-stats.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-multi-gen-lru-remove-mm_leaf_old-and-mm_nonleaf_total-stats.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Yu Zhao <yuzhao@google.com>
Subject: mm: multi-gen LRU: remove MM_LEAF_OLD and MM_NONLEAF_TOTAL stats
Date: Sat, 19 Oct 2024 01:29:38 +0000

Patch series "mm: multi-gen LRU: Have secondary MMUs participate in
MM_WALK".

Today, the MM_WALK capability causes MGLRU to clear the young bit from
PMDs and PTEs during the page table walk before eviction, but MGLRU does
not call the clear_young() MMU notifier in this case.  By not calling this
notifier, the MM walk takes less time/CPU, but it causes pages that are
accessed mostly through KVM / secondary MMUs to appear younger than they
should be.

We do call the clear_young() notifier today, but only when attempting to
evict the page, so we end up clearing young/accessed information less
frequently for secondary MMUs than for mm PTEs, and therefore they appear
younger and are less likely to be evicted.  Therefore, memory that is
*not* being accessed mostly by KVM will be evicted *more* frequently,
worsening performance.

ChromeOS observed a tab-open latency regression when enabling MGLRU with a
setup that involved running a VM:

		Tab-open latency histogram (ms)
Version		p50	mean	p95	p99	max
base		1315	1198	2347	3454	10319
mglru		2559	1311	7399	12060	43758
fix		1119	926	2470	4211	6947

This series replaces the final non-selftest patchs from this series[1],
which introduced a similar change (and a new MMU notifier) with KVM
optimizations.  I'll send a separate series (to Sean and Paolo) for the
KVM optimizations.

This series also makes proactive reclaim with MGLRU possible for KVM
memory.  I have verified that this functions correctly with the selftest
from [1], but given that that test is a KVM selftest, I'll send it with
the rest of the KVM optimizations later.  Andrew, let me know if you'd
like to take the test now anyway.

[1]: https://lore.kernel.org/linux-mm/20240926013506.860253-18-jthoughton@google.com/


This patch (of 2):

The removed stats, MM_LEAF_OLD and MM_NONLEAF_TOTAL, are not very helpful
and become more complicated to properly compute when adding
test/clear_young() notifiers in MGLRU's mm walk.

Link: https://lkml.kernel.org/r/20241019012940.3656292-1-jthoughton@google.com
Link: https://lkml.kernel.org/r/20241019012940.3656292-2-jthoughton@google.com
Fixes: bd74fdaea146 ("mm: multi-gen LRU: support page table walks")
Signed-off-by: Yu Zhao <yuzhao@google.com>
Signed-off-by: James Houghton <jthoughton@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Matlack <dmatlack@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: David Stevens <stevensd@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 --
 mm/vmscan.c            |   14 +++++---------
 2 files changed, 5 insertions(+), 11 deletions(-)

--- a/include/linux/mmzone.h~mm-multi-gen-lru-remove-mm_leaf_old-and-mm_nonleaf_total-stats
+++ a/include/linux/mmzone.h
@@ -458,9 +458,7 @@ struct lru_gen_folio {
 
 enum {
 	MM_LEAF_TOTAL,		/* total leaf entries */
-	MM_LEAF_OLD,		/* old leaf entries */
 	MM_LEAF_YOUNG,		/* young leaf entries */
-	MM_NONLEAF_TOTAL,	/* total non-leaf entries */
 	MM_NONLEAF_FOUND,	/* non-leaf entries found in Bloom filters */
 	MM_NONLEAF_ADDED,	/* non-leaf entries added to Bloom filters */
 	NR_MM_STATS
--- a/mm/vmscan.c~mm-multi-gen-lru-remove-mm_leaf_old-and-mm_nonleaf_total-stats
+++ a/mm/vmscan.c
@@ -3399,7 +3399,6 @@ restart:
 			continue;
 
 		if (!pte_young(ptent)) {
-			walk->mm_stats[MM_LEAF_OLD]++;
 			continue;
 		}
 
@@ -3552,7 +3551,6 @@ restart:
 			walk->mm_stats[MM_LEAF_TOTAL]++;
 
 			if (!pmd_young(val)) {
-				walk->mm_stats[MM_LEAF_OLD]++;
 				continue;
 			}
 
@@ -3564,8 +3562,6 @@ restart:
 			continue;
 		}
 
-		walk->mm_stats[MM_NONLEAF_TOTAL]++;
-
 		if (!walk->force_scan && should_clear_pmd_young()) {
 			if (!pmd_young(val))
 				continue;
@@ -5254,11 +5250,11 @@ static void lru_gen_seq_show_full(struct
 	for (tier = 0; tier < MAX_NR_TIERS; tier++) {
 		seq_printf(m, "            %10d", tier);
 		for (type = 0; type < ANON_AND_FILE; type++) {
-			const char *s = "   ";
+			const char *s = "xxx";
 			unsigned long n[3] = {};
 
 			if (seq == max_seq) {
-				s = "RT ";
+				s = "RTx";
 				n[0] = READ_ONCE(lrugen->avg_refaulted[type][tier]);
 				n[1] = READ_ONCE(lrugen->avg_total[type][tier]);
 			} else if (seq == min_seq[type] || NR_HIST_GENS > 1) {
@@ -5280,14 +5276,14 @@ static void lru_gen_seq_show_full(struct
 
 	seq_puts(m, "                      ");
 	for (i = 0; i < NR_MM_STATS; i++) {
-		const char *s = "      ";
+		const char *s = "xxxx";
 		unsigned long n = 0;
 
 		if (seq == max_seq && NR_HIST_GENS == 1) {
-			s = "LOYNFA";
+			s = "TYFA";
 			n = READ_ONCE(mm_state->stats[hist][i]);
 		} else if (seq != max_seq && NR_HIST_GENS > 1) {
-			s = "loynfa";
+			s = "tyfa";
 			n = READ_ONCE(mm_state->stats[hist][i]);
 		}
 
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-allow-set-clear-page_type-again.patch
mm-multi-gen-lru-remove-mm_leaf_old-and-mm_nonleaf_total-stats.patch
mm-multi-gen-lru-use-pteppmdp_clear_young_notify.patch


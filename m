Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB7633C063E;
	Tue,  2 Jun 2026 22:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439165; cv=none; b=XhBCioqR7Bdkc7xnz8HbQS1FFhaxVku6dZehTG89q76B+ARHP//G4cRcjFnlIlCidNZjDP5q4y9qGxdFGir2TNdS4v6rpZjcE0InuqYFym0eIqBrxAFa7mTeVzJEtrNjW+zK01KlYKANOds5VnC+k+4yZPHbmfvct+0Ba2W+/b8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439165; c=relaxed/simple;
	bh=5t4H7ayqqik64uHSbW31pbJ5HFYbrRQhC4GqjB3b7YY=;
	h=Date:To:From:Subject:Message-Id; b=uLHa3svfjqkA18DeWIMf+uehh1jG+lieM+VrqbMcPE3tkBZXMpMBtxBnTt7wqMeQ/BDVIr6dpfTi2FcY3h1wlMbLctWWWzmwdIUEbPlMPCPtPsIGpDPPTbDjnjBYyVNe5Oh1B43esLJzZXSPS2gEgZN4VMWIegkzCm1rGrTyq6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tXWshOCE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tXWshOCE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B01281F00898;
	Tue,  2 Jun 2026 22:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439164;
	bh=lSDzwR5+BNmUKJo5yTADATYzm70OOZtOcTd7nHkgndg=;
	h=Date:To:From:Subject;
	b=tXWshOCE7nDj7Vs2lJdJtuc5oJZ/wxpr0riBX6DKMxqVM0pn8S3AX22YWBT+ZbDyX
	 SDu7TED9r+1i9Eq1WbgY2JuCoxnIKDE1WoaKblP2TRjA+1UsrF4cMdFnOYHMWkTaEW
	 +wLnXLl/lqzax4ZbPNkjl+2IBVRhEA910zwVAwTk=
Date: Tue, 02 Jun 2026 15:26:04 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-trace-esz-at-first-setup.patch removed from -mm tree
Message-Id: <20260602222604.B01281F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: trace esz at first setup
has been removed from the -mm tree.  Its filename was
     mm-damon-core-trace-esz-at-first-setup.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: trace esz at first setup
Date: Wed, 20 May 2026 08:03:10 -0700

DAMON traces effective size quota from the second update, only if a change
has been made by the update.  Tracing only changed updates was an
intentional decision to avoid unnecessary same value tracing.  Always
skipping the first value is just an unintended mistake.

The mistake makes the tracepoint based investigation incomplete, because
the first effective size quota is never traced.  It is not a big issue
when the 'consist' quota tuner is used, because it keeps changing the
quota in the usual setup.

However, when the 'temporal' tuner is used, the quota value is not changed
before the goal achievement status is completely changed.  For example, if
the DAMOS scheme is started with an under-achieved goal, the quota is set
to the maximum value, and kept the same value until the goal is achieved. 
Because DAMON skips the first value, the user cannot know what effective
quota the current scheme is using.  Only after the goal is achieved, the
effective quota is changed to zero, and traced.

Unconditionally trace the initial quota value to fix this problem.

Note that the 'temporal' quota tuner was introduced by commit af738a6a00c1
("mm/damon/core: introduce DAMOS_QUOTA_GOAL_TUNER_TEMPORAL"), which was
added to 7.1-rc1.  But even with the 'consist' quota tuner, the tracing is
unintentionally incomplete.  Hence this commit marks the introduction of
the trace event as the broken commit.

Link: https://lore.kernel.org/20260520150311.80925-1-sj@kernel.org
Fixes: a86d695193bf ("mm/damon: add trace event for effective size quota")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.17.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-trace-esz-at-first-setup
+++ a/mm/damon/core.c
@@ -2899,6 +2899,8 @@ static void damos_adjust_quota(struct da
 	if (!quota->total_charged_sz && !quota->charged_from) {
 		quota->charged_from = jiffies;
 		damos_set_effective_quota(c, s);
+		if (trace_damos_esz_enabled())
+			damos_trace_esz(c, s, quota);
 	}
 
 	/* New charge window starts */
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-reclaim-handle-ctx-allocation-failure.patch
mm-damonn-lru_sort-handle-ctx-allocation-failure.patch
maintainers-add-testing-abi-documents-for-mm.patch


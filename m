Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31A51E7C1C
	for <mm-commits@vger.kernel.org>; Sat,  2 Aug 2025 18:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754160839; cv=none; b=RG/JANMm/aUUZBLJQUVHUSucjUbKUiCDAW8AkBoVVA7Co3VonZELw9KEefF9wSlAXNpz91ifJ2cHOyk4/uAiXnB0PNRGWqDpWYSKmUgCDmPPiMeDFJCG/uHwLVBFAMGDqWDqavRX4Kh9QzZ8KOZvfus8oLTXoB3e/XNQCJ2UPts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754160839; c=relaxed/simple;
	bh=k/t9Y43xetFxq7cxzhkxwjS1xzTanD1QZfx47wPMg08=;
	h=Date:To:From:Subject:Message-Id; b=q2jNVHSIz/xAKOhc3WHd5OOYbx4T3M1wtw6TnSTdnRHi4TjqcZjXLxyctHU0awe0DO1VMvNw/6booZMo1KGZwqfaq9OHlWluVpvEl+Ko3Y5jyUrHzdHz0bBo1y4yxaVsT8jjV+RlkAUEttVHIaRbQ3C0+8kSekXaTZOYMHCcdCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mVcFcvEm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mVcFcvEm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B507C4CEEF;
	Sat,  2 Aug 2025 18:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754160839;
	bh=k/t9Y43xetFxq7cxzhkxwjS1xzTanD1QZfx47wPMg08=;
	h=Date:To:From:Subject:From;
	b=mVcFcvEmOks5vr3iSaEx6Ti14LA3DqvlGHVKG2FYCM2fofnTKLYmIKw0aVIn2dtvu
	 ThGV0TKlXKUs91LdV0oGrPyCWFRcjHokws7oPiSJNynvQUYVc45x3uM9FJzJ58pUw5
	 wgDga87kKSuJYKaEGjyGvxlCHVZn1hQkXugbNdHk=
Date: Sat, 02 Aug 2025 11:53:58 -0700
To: mm-commits@vger.kernel.org,vschneid@redhat.com,vincent.guittot@linaro.org,vbabka@suse.cz,surenb@google.com,sj@kernel.org,rppt@kernel.org,rostedt@goodmis.org,peterz@infradead.org,mingo@redhat.com,mhocko@suse.com,mgorman@suse.de,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kees@kernel.org,juri.lelli@redhat.com,dietmar.eggemann@arm.com,david@redhat.com,bsegall@google.com,liuqiye2025@163.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-process-info-to-bad-rss-counter-warning.patch removed from -mm tree
Message-Id: <20250802185359.2B507C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add process info to bad rss-counter warning
has been removed from the -mm tree.  Its filename was
     mm-add-process-info-to-bad-rss-counter-warning.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Xuanye Liu <liuqiye2025@163.com>
Subject: mm: add process info to bad rss-counter warning
Date: Wed, 23 Jul 2025 18:09:00 +0800

Enhance the debugging information in check_mm() by including the process
name and PID when reporting bad rss-counter states.  This helps identify
which process is associated with the memory accounting issue.

Link: https://lkml.kernel.org/r/20250723100901.1909683-1-liuqiye2025@163.com
Signed-off-by: Xuanye Liu <liuqiye2025@163.com>
Acked-by: SeongJae Park <sj@kernel.org>
Cc: Ben Segall <bsegall@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mel Gorman <mgorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/kernel/fork.c~mm-add-process-info-to-bad-rss-counter-warning
+++ a/kernel/fork.c
@@ -585,9 +585,12 @@ static void check_mm(struct mm_struct *m
 	for (i = 0; i < NR_MM_COUNTERS; i++) {
 		long x = percpu_counter_sum(&mm->rss_stat[i]);
 
-		if (unlikely(x))
-			pr_alert("BUG: Bad rss-counter state mm:%p type:%s val:%ld\n",
-				 mm, resident_page_types[i], x);
+		if (unlikely(x)) {
+			pr_alert("BUG: Bad rss-counter state mm:%p type:%s val:%ld Comm:%s Pid:%d\n",
+				 mm, resident_page_types[i], x,
+				 current->comm,
+				 task_pid_nr(current));
+		}
 	}
 
 	if (mm_pgtables_bytes(mm))
_

Patches currently in -mm which might be from liuqiye2025@163.com are



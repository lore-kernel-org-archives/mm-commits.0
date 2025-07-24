Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A1229A5
	for <mm-commits@vger.kernel.org>; Thu, 24 Jul 2025 00:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753316952; cv=none; b=ga0yaR7/oGvqKXOsx3Qo3xeOjR0jPkPgpvhE1eE1eovZemDABEIu0Svh2pNV/P7Z8K0HichYjYNJp0IHo/Yscf08q0dLh8GW2OyV/spcy03f756nX+Hl8OWicLTtAvnXCFxDQCslaycRzz7+HfTtGl4yE2UrQrCbX2B4iSE+Xz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753316952; c=relaxed/simple;
	bh=uyJgeRsp8XAkRZtJFDaWHPO+49yebPNceOFGbrS4lpI=;
	h=Date:To:From:Subject:Message-Id; b=mb94K0wFvzHT7hTmhPCjYmQJ4T+MLZBg8eZP3W7K2HA7KowaVXNq/iIQrp43i4kYxnZ68fTJ8zMICn5zBnMBqCSnXlCLLsAI83l0YZyPvA26qwBBClU3FJix8HRJC4p7Zklkc1/OrtSxr7YFKHF/Hef+bcURk+sTfilOJNdBfS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ijcnYHCg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ijcnYHCg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD61C4CEE7;
	Thu, 24 Jul 2025 00:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753316951;
	bh=uyJgeRsp8XAkRZtJFDaWHPO+49yebPNceOFGbrS4lpI=;
	h=Date:To:From:Subject:From;
	b=ijcnYHCgPpzB6cY2sdsI3ydFqUoURN3QY6Zk4dhS4F5Sx4dq7Mr8P+mxclLdcnazh
	 8Xa9HXJE+SNfNqNn2EIhrWiXQMU0VYxm5FDixLsbEMIJvg7Dd9MZHQOGYN0t6SEkVm
	 A14LK3JHuthuuboEwv5BeS3bf4TxV+NZMns6qXVE=
Date: Wed, 23 Jul 2025 17:29:10 -0700
To: mm-commits@vger.kernel.org,vschneid@redhat.com,vincent.guittot@linaro.org,vbabka@suse.cz,surenb@google.com,sj@kernel.org,rppt@kernel.org,rostedt@goodmis.org,peterz@infradead.org,mingo@redhat.com,mhocko@suse.com,mgorman@suse.de,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kees@kernel.org,juri.lelli@redhat.com,dietmar.eggemann@arm.com,david@redhat.com,bsegall@google.com,liuqiye2025@163.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-process-info-to-bad-rss-counter-warning.patch added to mm-unstable branch
Message-Id: <20250724002911.7BD61C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add process info to bad rss-counter warning
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-process-info-to-bad-rss-counter-warning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-process-info-to-bad-rss-counter-warning.patch

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

mm-add-process-info-to-bad-rss-counter-warning.patch


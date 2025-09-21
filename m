Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77DE28EA72
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489803; cv=none; b=kDcxccJELY3n0JGC3+w9M/218+WY8FHdEEIR4j4DyCyCVvFQlpA2DD1d4RclS8SbhgKFDU1YYxn5REYGwX5QF3wUpdgmQq381PFCcJwTWy4I4LsoZdgTT8ihDiNoEW9aoDJt2+pmVqNRzzHTMz/1giwhvMB0av7vHsm2SIxASws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489803; c=relaxed/simple;
	bh=Ea5UwFR1F3PNZj+4/mKXXaVkvX+LXkkP9/2VMP1Ipgg=;
	h=Date:To:From:Subject:Message-Id; b=IKEwKU37Rzzfa1euv1zeu/G6MoU9x28rKyeYmmNwoDqvjYWkASwVhOQ54QiNQIvjr3q884QHZExAgm0pSNtFpWHxPTYBOwhHi+4sxrSBAHMSOeIYsPlmI44F/P/fieK2thnJ+PmlZ+2gBAqfuVe/5/kO1WJT9lxZv6J4vI8BHV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1I38lT3Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1I38lT3Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19C1CC116B1;
	Sun, 21 Sep 2025 21:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489803;
	bh=Ea5UwFR1F3PNZj+4/mKXXaVkvX+LXkkP9/2VMP1Ipgg=;
	h=Date:To:From:Subject:From;
	b=1I38lT3ZxHZxEu6z5TW3hDuUryQPXmeqFbFs/354rtNw7XgbFh2LNCxvkqJ1tQjW/
	 dEHZkbIcjGrTK9NHfU9MjEL68eVShVA4BQFYEw32LIxL5OQdarEqbOEEp26UCc1QNa
	 YYDMqh14Ett5765eVw1zZktppVfqXw63TzWyuzcE=
Date: Sun, 21 Sep 2025 14:23:22 -0700
To: mm-commits@vger.kernel.org,vschneid@redhat.com,vincent.guittot@linaro.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,rostedt@goodmis.org,peterz@infradead.org,mingo@redhat.com,mhocko@suse.com,mgorman@suse.de,lorenzo.stoakes@oracle.com,linus.walleij@linaro.org,Liam.Howlett@oracle.com,kees@kernel.org,juri.lelli@redhat.com,dietmar.eggemann@arm.com,david@redhat.com,bsegall@google.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] task_stackh-clean-up-stack_not_used-implementation.patch removed from -mm tree
Message-Id: <20250921212323.19C1CC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: task_stack.h: clean-up stack_not_used() implementation
has been removed from the -mm tree.  Its filename was
     task_stackh-clean-up-stack_not_used-implementation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: task_stack.h: clean-up stack_not_used() implementation
Date: Fri, 29 Aug 2025 13:44:41 +0200

Inside the small stack_not_used() function there are several ifdefs for
stack growing-up vs.  regular versions.  Instead just implement this
function two times, one for growing-up and another regular.

Add comments like /* !CONFIG_DEBUG_STACK_USAGE */ to clarify what the
ifdefs are doing.

[linus.walleij@linaro.org: rebased, function moved elsewhere in the kernel]
Link: https://lkml.kernel.org/r/20250829-fork-cleanups-for-dynstack-v1-2-3bbaadce1f00@linaro.org
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Link: https://lore.kernel.org/20240311164638.2015063-13-pasha.tatashin@soleen.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Ben Segall <bsegall@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Kees Cook <kees@kernel.org>
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

 kernel/exit.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

--- a/kernel/exit.c~task_stackh-clean-up-stack_not_used-implementation
+++ a/kernel/exit.c
@@ -780,24 +780,29 @@ static void exit_notify(struct task_stru
 }
 
 #ifdef CONFIG_DEBUG_STACK_USAGE
+#ifdef CONFIG_STACK_GROWSUP
 unsigned long stack_not_used(struct task_struct *p)
 {
 	unsigned long *n = end_of_stack(p);
 
 	do {	/* Skip over canary */
-# ifdef CONFIG_STACK_GROWSUP
 		n--;
-# else
-		n++;
-# endif
 	} while (!*n);
 
-# ifdef CONFIG_STACK_GROWSUP
 	return (unsigned long)end_of_stack(p) - (unsigned long)n;
-# else
+}
+#else /* !CONFIG_STACK_GROWSUP */
+unsigned long stack_not_used(struct task_struct *p)
+{
+	unsigned long *n = end_of_stack(p);
+
+	do {	/* Skip over canary */
+		n++;
+	} while (!*n);
+
 	return (unsigned long)n - (unsigned long)end_of_stack(p);
-# endif
 }
+#endif /* CONFIG_STACK_GROWSUP */
 
 /* Count the maximum pages reached in kernel stacks */
 static inline void kstack_histogram(unsigned long used_stack)
@@ -856,9 +861,9 @@ static void check_stack_usage(void)
 	}
 	spin_unlock(&low_water_lock);
 }
-#else
+#else /* !CONFIG_DEBUG_STACK_USAGE */
 static inline void check_stack_usage(void) {}
-#endif
+#endif /* CONFIG_DEBUG_STACK_USAGE */
 
 static void synchronize_group_exit(struct task_struct *tsk, long code)
 {
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are



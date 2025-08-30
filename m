Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E3922B8B6
	for <mm-commits@vger.kernel.org>; Sat, 30 Aug 2025 03:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756525115; cv=none; b=qK/yUHGHvAh9negH0fTNWQ4clWo1kimXkeL+iRzSLW81jtbI3h1uYrI8g3p8nHvza1/pwaMu7O2Uu2zOuKKO8/m6m1VBINrh0YYhxMnjMfKuomt0DOsn4B8GuJC72muhqV7/pXGDL+6p9qGHL0cRHctVIipYreB7t63CAnbgbnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756525115; c=relaxed/simple;
	bh=TLKOhbHBFlWaijbIGvepw5GNxqmhmuFIen1YmaNpsOc=;
	h=Date:To:From:Subject:Message-Id; b=Z10f9TkCBoTyXPnSl8aMBCfqYaJg/TeHVXpzH37pyrwAEALmPC1YEHZ1QRFjXntoTOxEXXl5g5bdY0kuKPTs6patKh9OD/LhZSZ+5FS7Ae+IpliT4xxRXxCneIN0sTEsZwMD+k13HVgCSPM/IN2kidQc5mYUYwNIpcHCQQf9gzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fR6hXV9t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fR6hXV9t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA5F9C4CEF0;
	Sat, 30 Aug 2025 03:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756525115;
	bh=TLKOhbHBFlWaijbIGvepw5GNxqmhmuFIen1YmaNpsOc=;
	h=Date:To:From:Subject:From;
	b=fR6hXV9tp1/VhmZUSzXw+fMtFw5rJAz5fCuDoWYdyLfZxLf/Cdg7B8amW5M5b5ZZk
	 xF7iolVZwHvdnqiXfYMgTzCkZcc/qFhI0MALTMVM+i6vzZRHHtyXRKzZ9UlwNdu2SG
	 oQBCer8K9ks3f0TpgaFLJQY6ZBjqjQtk3A6hIcv4=
Date: Fri, 29 Aug 2025 20:38:34 -0700
To: mm-commits@vger.kernel.org,vschneid@redhat.com,vincent.guittot@linaro.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,rostedt@goodmis.org,peterz@infradead.org,mingo@redhat.com,mhocko@suse.com,mgorman@suse.de,lorenzo.stoakes@oracle.com,linus.walleij@linaro.org,Liam.Howlett@oracle.com,kees@kernel.org,juri.lelli@redhat.com,dietmar.eggemann@arm.com,david@redhat.com,bsegall@google.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + task_stackh-clean-up-stack_not_used-implementation.patch added to mm-new branch
Message-Id: <20250830033834.EA5F9C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: task_stack.h: clean-up stack_not_used() implementation
has been added to the -mm mm-new branch.  Its filename is
     task_stackh-clean-up-stack_not_used-implementation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/task_stackh-clean-up-stack_not_used-implementation.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Cc: Ben Segall <bsegall@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Kees Cook <kees@kernel.org>
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

fork-check-charging-success-before-zeroing-stack.patch
task_stackh-clean-up-stack_not_used-implementation.patch


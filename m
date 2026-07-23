Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 486073793D3
	for <mm-commits@vger.kernel.org>; Thu, 23 Jul 2026 23:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784848753; cv=none; b=EQtQrhIN4Ca9jaijH9rEDa1mywwk2Je88tJnVevOX7sszfAfOQztJF7U46CQc8wd9wstqhhIGrdnPuGM2B40ocjz8k2K3X/4DRpj9wAKt/fiomL5vqZGI8kiYzeusYxXEjnz/43I9IT0gBjs7MrgF8vNGLX9koU0vvdRjGvA/uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784848753; c=relaxed/simple;
	bh=oldxU3lQ6EIAjO6fhL0D0NlrYnBv/oy8ECC8XS6MWBQ=;
	h=Date:To:From:Subject:Message-Id; b=H/d47OLIMJPDojdM37UazvxAJMe1/L8wxbiwlo/8HrBpmn+8YDyMx0I5nah8e2q+KcJ5CFNcXtfh58J/wFkl2NiyQbyemYpGaDbQxWSrIvujim/4TVhMQNaB+EC5Z9kCCuca0UViWc6+LgsiZdMVybRKWBDeq0+G2QS6t7NBDIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Be/xiDBO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Be/xiDBO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC5011F000E9;
	Thu, 23 Jul 2026 23:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784848751;
	bh=bOWMqdTIugTzwY0Ps/UCurbyYRgflQCMne/GIkACkmU=;
	h=Date:To:From:Subject;
	b=Be/xiDBObs+kpavFNC11M4wgXzlVJYBTxG2BbTcB47ObISjmHCz3yW3exl55PZVdF
	 Lu5DSjIbNRde9zjBuXagQAsAsG6yu5SdJXx0UjqrqTs9H1IOI1Q5N0AIwlOMT6qv5J
	 IQiaW9v1/9OON9Nne3LVQscNgcutqwSOmvUF+bqk=
Date: Thu, 23 Jul 2026 16:19:11 -0700
To: mm-commits@vger.kernel.org,peterz@infradead.org,mark.rutland@arm.com,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + stacktrace-header-repair-kernel-doc-comments.patch added to mm-nonmm-unstable branch
Message-Id: <20260723231911.CC5011F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: stacktrace: header: repair kernel-doc comments
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     stacktrace-header-repair-kernel-doc-comments.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/stacktrace-header-repair-kernel-doc-comments.patch

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
From: Randy Dunlap <rdunlap@infradead.org>
Subject: stacktrace: header: repair kernel-doc comments
Date: Thu, 23 Jul 2026 09:18:31 -0700

- use the "typedef" keyword when describing a typedef
- add a Returns: section

to prevent these kernel-doc warnings:

Warning: include/linux/stacktrace.h:20 function parameter
 'stack_trace_consume_fn' not described in 'bool'
Warning: include/linux/stacktrace.h:20 expecting prototype for
 stack_trace_consume_fn(). Prototype was for bool() instead
Warning: include/linux/stacktrace.h:58 No description found for
 return value of 'arch_stack_walk_reliable'

Link: https://lore.kernel.org/20260723161831.138237-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/stacktrace.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/stacktrace.h~stacktrace-header-repair-kernel-doc-comments
+++ a/include/linux/stacktrace.h
@@ -11,7 +11,7 @@ struct pt_regs;
 #ifdef CONFIG_ARCH_STACKWALK
 
 /**
- * stack_trace_consume_fn - Callback for arch_stack_walk()
+ * typedef stack_trace_consume_fn - Callback for arch_stack_walk()
  * @cookie:	Caller supplied pointer handed back by arch_stack_walk()
  * @addr:	The stack entry address to consume
  *
@@ -48,9 +48,9 @@ void arch_stack_walk(stack_trace_consume
  *			@consume_entry
  * @task:		Pointer to a task struct, can be NULL
  *
- * This function returns an error if it detects any unreliable
+ * Returns: a negative error code if it detects any unreliable
  * features of the stack. Otherwise it guarantees that the stack
- * trace is reliable.
+ * trace is reliable and returns %0.
  *
  * If the task is not 'current', the caller *must* ensure the task is
  * inactive and its stack is pinned.
_

Patches currently in -mm which might be from rdunlap@infradead.org are

mm-migrate-use-migrate_info-field-instead-of-private-fix.patch
mm-page_owner-document-page_owner-filter-fix.patch
radix-tree-add-correct-some-kernel-doc.patch
delaytop-sort-by-max-delay-to-highlight-top-latency-processes-fix.patch
rbtree-fixup-kernel-doc-names.patch
llist-use-correct-function-parameter-name.patch
stacktrace-header-repair-kernel-doc-comments.patch


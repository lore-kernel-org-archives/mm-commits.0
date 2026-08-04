Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6746B4252BE
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 04:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816360; cv=none; b=PZX/ze5F9dBGm1aFUU24fIZW+l2qZ8D54JQuqVDwyJ9BPFyccVZRjLY8qh8BkTQ4CIBsLG26rdoE50ppjDhC1d6KglarBQAjPzcFbuo3laq7oVUbUxe/thfxhrDLe3p/4PYCXSjByKFgfKT/4+4TaJ0wYzVO7AJb+TkdX6pZaRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816360; c=relaxed/simple;
	bh=skh01dzc9hRisJVNQwljFMECrTXGgyC2pD/LwKmQoiM=;
	h=Date:To:From:Subject:Message-Id; b=dpI7KN8kPDa6GZ6X2E+yyKf5ScEPWMQo5U3Z6oGH0fo1qDnAeAHVjsilMklxw7MJfLOZlvnWBaIu0XVKaNXN1XgTmAE7IMQ8HNV1qXcxITd5/VY7DjQGCv5aWcOEwmt03FvhjSg394lkC/YxwHSpy1fWScMRF/T1KYvMXlZ4O4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=suTYqefK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="suTYqefK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B9FB1F00A3A;
	Tue,  4 Aug 2026 04:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785816359;
	bh=ZyiQ+zzo9ZUeILyuJP93NAdLy9jA/c96NlgMhESHUcA=;
	h=Date:To:From:Subject;
	b=suTYqefK20DTMTq9+tjZVowq8hyOJZf1XkESQ0RN/WpVcaBXoztkoPwW08gIrQR7E
	 6bUvHOfxckBr9mIsUAbF4EkZvQuNBlfzrZo+SU8HVZqKf5w9FKX1QfZFMiOfVkduo7
	 PkgIW3QOOwtXzl2D4BB6mOa3r2rmP8Px126R7k4g=
Date: Mon, 03 Aug 2026 21:05:58 -0700
To: mm-commits@vger.kernel.org,peterz@infradead.org,mark.rutland@arm.com,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] stacktrace-header-repair-kernel-doc-comments.patch removed from -mm tree
Message-Id: <20260804040559.3B9FB1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: stacktrace: header: repair kernel-doc comments
has been removed from the -mm tree.  Its filename was
     stacktrace-header-repair-kernel-doc-comments.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



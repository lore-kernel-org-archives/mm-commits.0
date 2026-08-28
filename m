Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A93D23C3C1C
	for <mm-commits@vger.kernel.org>; Fri, 28 Aug 2026 05:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787896073; cv=none; b=kJyJOMdmekNLEuIB4tgEvOpaS8GVb4ytTmaBpSHDS8KHIhDjyyAQzDZEtiqKhKh+/rPVuBM+WEoET5FhjTpL/ZOMPliBKoJLq0y/P4TfgN63j+EtC0AEnWWG+ETQd/M0dzLfRk10t3gvOSZ7+Dqu+hXpXUQLym84yCQJ/Zz8wDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787896073; c=relaxed/simple;
	bh=FxjouAJORIRTpd39+jarsOIPTtzIiBRxlxSogqf/NPA=;
	h=Date:To:From:Subject:Message-Id; b=WhUqERqrNAtLEMaK7L0fvfb/IeGYuokF1gXl10doV0M9aHxMDLqMrby6bJgcGsARcAYvcHJQVjOkgN1jAwGJ9dIEiZtTFl245WYpAPNYiohk/WUKvWec2reMJ7WVYxKv8QUtV7jb5qa3D+TRvqk+bE+lJOwQA/Thg2fKcyhnBN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cR0MKnFB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cR0MKnFB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 401471F000E9;
	Fri, 28 Aug 2026 05:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787896072;
	bh=OvLcwTIqy73DzkXTC/j8NuFnShb4A9Te8q20N/5h1S0=;
	h=Date:To:From:Subject;
	b=cR0MKnFB7D+Id5jIIBVSX/5R6iHyRmhZLjNZhSqRthV5k3GpRnFnBYmAQYvR/Tdp3
	 tU+hKWNw6gsqKM5dVEPOlv9ktb6owHBBhCrnCGbkcYZrBnPArYrbUnjmBzRBP9/5Pu
	 z0L8QvJ1QREPQjhp1fU2F1JL0I3yAMUY9qWlHU68=
Date: Thu, 27 Aug 2026 22:47:51 -0700
To: mm-commits@vger.kernel.org,visitorckw@gmail.com,pmladek@suse.com,pasha.tatashin@soleen.com,kees@kernel.org,gustavoars@kernel.org,dmantipov@yandex.ru,david@davidgow.net,brendan.higgins@linux.dev,morbo@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + stacktrace-add-__counted_by_ptr-attribute-to-struct-stack_trace.patch added to mm-nonmm-unstable branch
Message-Id: <20260828054752.401471F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: stacktrace: add __counted_by_ptr attribute to struct stack_trace
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     stacktrace-add-__counted_by_ptr-attribute-to-struct-stack_trace.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/stacktrace-add-__counted_by_ptr-attribute-to-struct-stack_trace.patch

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
From: Bill Wendling <morbo@google.com>
Subject: stacktrace: add __counted_by_ptr attribute to struct stack_trace
Date: Sun, 23 Aug 2026 12:35:32 +0000

For hardening and catching out-of-bounds accesses to the 'entries' pointer
field in 'struct stack_trace', associate it with its count field
'max_entries' using the __counted_by_ptr attribute.

An analysis of the codebase reveals that 'struct stack_trace' is
instantiated and initialized across several entry points in
'kernel/stacktrace.c'.  In each execution path, 'trace.entries' is
assigned a buffer of size 'size', and 'trace.max_entries' is assigned
'size' concurrently within the structure's initializer block.  The pointer
is not accessed before the count is set.

Because 'trace.entries' is always assigned at the same time as
'trace.max_entries' during initialization and is never reallocated or
accessed beforehand, there are no uninitialized access windows.  The
'max_entries' field accurately holds the exact element count of the buffer
allocated for the 'entries' pointer, ensuring that compiler fortification
and KASAN bounds checks using __counted_by_ptr do not trigger
false-positive bounds checks or runtime panics.

Link: https://lore.kernel.org/20260823123549.1120133-2-morbo@google.com
Signed-off-by: Bill Wendling <morbo@google.com>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <david@davidgow.net>
Cc: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Kees Cook <kees@kernel.org>
Cc: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Petr Mladek <pmladek@suse.com>
Assisted-by: Gemini Next
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/stacktrace.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/stacktrace.h~stacktrace-add-__counted_by_ptr-attribute-to-struct-stack_trace
+++ a/include/linux/stacktrace.h
@@ -81,7 +81,7 @@ unsigned int filter_irq_stacks(unsigned
 /* Internal interfaces. Do not use in generic code */
 struct stack_trace {
 	unsigned int nr_entries, max_entries;
-	unsigned long *entries;
+	unsigned long *entries __counted_by_ptr(max_entries);
 	unsigned int skip;	/* input argument: How many entries to skip */
 };
 
_

Patches currently in -mm which might be from morbo@google.com are

stacktrace-add-__counted_by_ptr-attribute-to-struct-stack_trace.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C5FD30D40E
	for <mm-commits@vger.kernel.org>; Fri, 28 Aug 2026 05:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787896117; cv=none; b=RqkHGZJnZKINDtqxPOEh6FDnPCh+47hpVlodvKNEYs385zi7J4EtArACv2V5tACV/TUppIEpwS1kMAyc9R+eMLLRE86qy86oZ6gMfMFqbOAnzEpt1FBoDwyLIBGvYLzu3Dm8bjgnv4+xjTO/aaTfpJx2ZnuhGutoNNWyta8u7x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787896117; c=relaxed/simple;
	bh=Oh48viknUAlzrOYizIWBhiMkl9tMIhnnCwN29G13hQM=;
	h=Date:To:From:Subject:Message-Id; b=Qj0HuAo9fp4cCxBHhGr0D2Y0THxQyh1h8RJmWyRr19Wpa1gtdqLvi8HBuXvSLnL419sMqYfPHTL2ELDaEXvM4In4KlLXck5s6lAW5OUnX5DuNyMFead/LKn5feUbhOXPiofu56HcOvpddYUneEDivqM8OI3A/yFNC+zwciEz4WU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KWLZ78Z3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KWLZ78Z3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04BBD1F000E9;
	Fri, 28 Aug 2026 05:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787896116;
	bh=qWUvLvui8ci7WNd73bt16qUi918PAZKUdAevWX6xWm8=;
	h=Date:To:From:Subject;
	b=KWLZ78Z3mugd1rrTGzGWQUIiXANCTsDe/aIRqvBGJyTII3evxj5lvUEuZ9hv/HAUx
	 DVc+SM5n3TrvTBJqcjW/pD0oPwo1mwbgtJvSUHg3QdpKXjLNTaU+I02APsztPF2Kzd
	 bTneX8JjPOgfB3Iz93SD7npWcrvEJt4JOFdn2B8U=
Date: Thu, 27 Aug 2026 22:48:35 -0700
To: mm-commits@vger.kernel.org,visitorckw@gmail.com,pmladek@suse.com,pasha.tatashin@soleen.com,kees@kernel.org,gustavoars@kernel.org,dmantipov@yandex.ru,david@davidgow.net,brendan.higgins@linux.dev,morbo@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] stacktrace-add-__counted_by_ptr-attribute-to-struct-stack_trace.patch removed from -mm tree
Message-Id: <20260828054836.04BBD1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: stacktrace: add __counted_by_ptr attribute to struct stack_trace
has been removed from the -mm tree.  Its filename was
     stacktrace-add-__counted_by_ptr-attribute-to-struct-stack_trace.patch

This patch was dropped because an updated version will be issued

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



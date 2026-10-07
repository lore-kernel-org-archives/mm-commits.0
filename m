Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955E03546E6
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 02:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338684; cv=none; b=F+SDyaIUaD7ppeKXQCXF4he+yPg7Izq7HQFUeINBdAAOExfbal0tvzOsCsZ2R3pP2WkquiB2PbS3nmO1CJHJQliM9p99Tb6qkd4EalJDYsJByt77n7L3zf7d7PMoenzZbOuXl66/8SPdZEu4yI9+9j676vOuOr+ujdsSkCleF30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338684; c=relaxed/simple;
	bh=bPl5kVY5ux1foumIHr5B/h4rW0L5tkUGD8k6eZXSkL8=;
	h=Date:To:From:Subject:Message-Id; b=raCptBdlxOBbuFGktbM2RNvQQ1Q80YqdtWPdDGoiIOqM59D6Ryrc2VPyHhEPdqjbnJMpC7WP+gJvNzY0zF4smmhKL8Qkd5x0GOKyanJkjtBfAEizJ0p54QmNR9B+h+95cBH9KMywwLak4Wybex4nY3FTo2UOz7Wmv18Fv7jBjhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EXG+xHUe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EXG+xHUe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D3131F0089C;
	Wed,  7 Oct 2026 02:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338683;
	bh=YjMvg8jgYBAZqBrr1XnJUk8QGZ+HotqFuV7wswjkPnU=;
	h=Date:To:From:Subject;
	b=EXG+xHUerJwCpYV2F9jz3n8TphomLPgl/TOzl23jLlziYewqLiyjYlitEBcG/kF3K
	 Iol72FqC7MQP5nt5cBzijs8X9sDItfqsATd8vlCTo8t/GzyyCUbwTUzjI8YIekCbGS
	 EYvcQj/Fq6i9+f3EhAFgbRog853bsAc3o8DZbT/o=
Date: Tue, 06 Oct 2026 19:04:43 -0700
To: mm-commits@vger.kernel.org,pmladek@suse.com,brads@mainlining.org,akpm@linux-foundation.org,feng.tang@linux.alibaba.com
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] panic-remove-the-unneeded-panic_print_get.patch removed from -mm tree
Message-Id: <20261007020443.6D3131F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: panic: remove the unneeded panic_print_get()
has been removed from the -mm tree.  Its filename was
     panic-remove-the-unneeded-panic_print_get.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Feng Tang <feng.tang@linux.alibaba.com>
Subject: panic: remove the unneeded panic_print_get()
Date: Wed, 2 Sep 2026 19:48:51 +0800

panic_print_get() was introduced in commit 2683df6539cb ("panic: add
note that 'panic_print' parameter is deprecated") to print out warning
message of the deprecation of 'panic_print' on read access.

Since commit 90f3c123247e ("panic: only warn about deprecated panic_print
on write access"), panic_print_get() wrapper is not needed anymore for
read access, so remove it and use param_get_ulong() instead.

Link: https://lore.kernel.org/20260902114851.77062-1-feng.tang@linux.alibaba.com
Signed-off-by: Feng Tang <feng.tang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Petr Mladek <pmladek@suse.com>
---

 kernel/panic.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/kernel/panic.c~panic-remove-the-unneeded-panic_print_get
+++ a/kernel/panic.c
@@ -1216,14 +1216,9 @@ static int panic_print_set(const char *v
 	return  param_set_ulong(val, kp);
 }
 
-static int panic_print_get(char *val, const struct kernel_param *kp)
-{
-	return  param_get_ulong(val, kp);
-}
-
 static const struct kernel_param_ops panic_print_ops = {
 	.set	= panic_print_set,
-	.get	= panic_print_get,
+	.get	= param_get_ulong,
 };
 __core_param_cb(panic_print, &panic_print_ops, &panic_print, 0644);
 
_

Patches currently in -mm which might be from feng.tang@linux.alibaba.com are



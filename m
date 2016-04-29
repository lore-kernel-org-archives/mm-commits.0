From: akpm@linux-foundation.org
Subject: [merged]
 lib-stackdepotc-allow-the-stack-trace-hash-to-be-zero.patch removed from
 -mm tree
Date: Fri, 29 Apr 2016 15:05:52 -0700
Message-ID: <5723dac0.JVIekI2x63hJshrj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45467 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109AbcD2WFx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2016 18:05:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glider@google.com, aryabinin@virtuozzo.com, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/stackdepot.c: allow the stack trace hash to be zero
has been removed from the -mm tree.  Its filename was
     lib-stackdepotc-allow-the-stack-trace-hash-to-be-zero.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: lib/stackdepot.c: allow the stack trace hash to be zero

Do not bail out from depot_save_stack() if the stack trace has zero hash. 
Initially depot_save_stack() silently dropped stack traces with zero
hashes, however there's actually no point in reserving this zero value.

Reported-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Alexander Potapenko <glider@google.com>
Acked-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackdepot.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN lib/stackdepot.c~lib-stackdepotc-allow-the-stack-trace-hash-to-be-zero lib/stackdepot.c
--- a/lib/stackdepot.c~lib-stackdepotc-allow-the-stack-trace-hash-to-be-zero
+++ a/lib/stackdepot.c
@@ -210,10 +210,6 @@ depot_stack_handle_t depot_save_stack(st
 		goto fast_exit;
 
 	hash = hash_stack(trace->entries, trace->nr_entries);
-	/* Bad luck, we won't store this stack. */
-	if (hash == 0)
-		goto exit;

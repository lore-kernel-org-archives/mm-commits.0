From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 079/127] lib/percpu-refcount.c: use a more common
 logging style
Date: Thu, 04 Jun 2020 16:50:20 -0700
Message-ID: <20200604235020.mayuBW-Cd%akpm@linux-foundation.org>
References: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725943AbgFDXuV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 19:50:21 -0400
In-Reply-To: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, christophe.jaillet@wanadoo.fr, joe@perches.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Joe Perches <joe@perches.com>
Subject: lib/percpu-refcount.c: use a more common logging style

Remove the trailing newline from the used-once pr_fmt and add it to the
single use of pr_<level> in this code to use a more common logging style.

Miscellanea:

o Use %lu in the pr_debug format and remove the unnecessary cast

Link: http://lkml.kernel.org/r/47372467902a047c03b0fd29aab56e0c38d3f848.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/percpu-refcount.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/lib/percpu-refcount.c~percpu_ref-use-a-more-common-logging-style
+++ a/lib/percpu-refcount.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-#define pr_fmt(fmt) "%s: " fmt "\n", __func__
+#define pr_fmt(fmt) "%s: " fmt, __func__
 
 #include <linux/kernel.h>
 #include <linux/sched.h>
@@ -141,8 +141,8 @@ static void percpu_ref_switch_to_atomic_
 	for_each_possible_cpu(cpu)
 		count += *per_cpu_ptr(percpu_count, cpu);
 
-	pr_debug("global %ld percpu %ld",
-		 atomic_long_read(&ref->count), (long)count);
+	pr_debug("global %lu percpu %lu\n",
+		 atomic_long_read(&ref->count), count);
 
 	/*
 	 * It's crucial that we sum the percpu counters _before_ adding the sum
_

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764B31CEEB2
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 16:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747846612; cv=none; b=C7E0TCHfqDzkADB4XzQk9Ha2mhbg7bRoMXnowyxUY9I9/r/Vgsi8yxPWgt6WlTdF8wJljKxkQZgJqSLvZUh3zfWlXf03u+PBZkaBiT976dDB8uskcGz21KBiz0vmpTTLI5CueI+uYuoFfLriWvufmeH055VTz7zVzIgfooP0Kno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747846612; c=relaxed/simple;
	bh=oDaloNm3QL/TWV1eKcCn8lyPnUhgsjBlKf0cnHn/dQ4=;
	h=Date:To:From:Subject:Message-Id; b=kh9EPJYYwcwD8u0wb+OplbsannVaNV0kBiQoShqvqyl5+9YggTBoR+FEVgXgfSER0SUr6ZyY9nf5dsIDn5FebcZMBbTPa0N6XgwPGEVrZjkFtmMQIUU00iT5SQnxj38spIv6wsmlz8busWxzmAEWSiMoNdc87pRegy3r1iTDSes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SZBi6VJA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SZBi6VJA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D078EC4CEE4;
	Wed, 21 May 2025 16:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747846611;
	bh=oDaloNm3QL/TWV1eKcCn8lyPnUhgsjBlKf0cnHn/dQ4=;
	h=Date:To:From:Subject:From;
	b=SZBi6VJAGCEPceFmh8Ir+i9oH1S+Tato94vRPn00wWqXvdChzEYjBKla88mbJLRmc
	 rcCqhKzaM2CApzxgdzg8NY/ZXWRk60EypOXqgsi41YdDNGha07X59Yd/2LJ74rO+rO
	 mkIvyGr/IvO9wUDhzAwyydaYABydEudbjBEmIa7k=
Date: Wed, 21 May 2025 09:56:51 -0700
To: mm-commits@vger.kernel.org,kent.overstreet@linux.dev,iii@linux.ibm.com,elver@google.com,dvyukov@google.com,bvanassche@acm.org,glider@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kmsan-rework-kmsan_in_runtime-handling-in-kmsan_report.patch removed from -mm tree
Message-Id: <20250521165651.D078EC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kmsan: rework kmsan_in_runtime() handling in kmsan_report()
has been removed from the -mm tree.  Its filename was
     kmsan-rework-kmsan_in_runtime-handling-in-kmsan_report.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: kmsan: rework kmsan_in_runtime() handling in kmsan_report()
Date: Wed, 7 May 2025 18:00:12 +0200

kmsan_report() calls used to require entering/leaving the runtime around
them.  To simplify the things, drop this requirement and move calls to
kmsan_enter_runtime()/kmsan_leave_runtime() into kmsan_report().

Link: https://lkml.kernel.org/r/20250507160012.3311104-5-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmsan/core.c            |    8 --------
 mm/kmsan/instrumentation.c |    4 ----
 mm/kmsan/report.c          |    6 +++---
 3 files changed, 3 insertions(+), 15 deletions(-)

--- a/mm/kmsan/core.c~kmsan-rework-kmsan_in_runtime-handling-in-kmsan_report
+++ a/mm/kmsan/core.c
@@ -274,11 +274,9 @@ void kmsan_internal_check_memory(void *a
 			 * bytes before, report them.
 			 */
 			if (cur_origin) {
-				kmsan_enter_runtime();
 				kmsan_report(cur_origin, addr, size,
 					     cur_off_start, pos - 1, user_addr,
 					     reason);
-				kmsan_leave_runtime();
 			}
 			cur_origin = 0;
 			cur_off_start = -1;
@@ -292,11 +290,9 @@ void kmsan_internal_check_memory(void *a
 				 * poisoned bytes before, report them.
 				 */
 				if (cur_origin) {
-					kmsan_enter_runtime();
 					kmsan_report(cur_origin, addr, size,
 						     cur_off_start, pos + i - 1,
 						     user_addr, reason);
-					kmsan_leave_runtime();
 				}
 				cur_origin = 0;
 				cur_off_start = -1;
@@ -312,11 +308,9 @@ void kmsan_internal_check_memory(void *a
 			 */
 			if (cur_origin != new_origin) {
 				if (cur_origin) {
-					kmsan_enter_runtime();
 					kmsan_report(cur_origin, addr, size,
 						     cur_off_start, pos + i - 1,
 						     user_addr, reason);
-					kmsan_leave_runtime();
 				}
 				cur_origin = new_origin;
 				cur_off_start = pos + i;
@@ -326,10 +320,8 @@ void kmsan_internal_check_memory(void *a
 	}
 	KMSAN_WARN_ON(pos != size);
 	if (cur_origin) {
-		kmsan_enter_runtime();
 		kmsan_report(cur_origin, addr, size, cur_off_start, pos - 1,
 			     user_addr, reason);
-		kmsan_leave_runtime();
 	}
 }
 
--- a/mm/kmsan/instrumentation.c~kmsan-rework-kmsan_in_runtime-handling-in-kmsan_report
+++ a/mm/kmsan/instrumentation.c
@@ -312,13 +312,9 @@ EXPORT_SYMBOL(__msan_unpoison_alloca);
 void __msan_warning(u32 origin);
 void __msan_warning(u32 origin)
 {
-	if (!kmsan_enabled || kmsan_in_runtime())
-		return;
-	kmsan_enter_runtime();
 	kmsan_report(origin, /*address*/ NULL, /*size*/ 0,
 		     /*off_first*/ 0, /*off_last*/ 0, /*user_addr*/ NULL,
 		     REASON_ANY);
-	kmsan_leave_runtime();
 }
 EXPORT_SYMBOL(__msan_warning);
 
--- a/mm/kmsan/report.c~kmsan-rework-kmsan_in_runtime-handling-in-kmsan_report
+++ a/mm/kmsan/report.c
@@ -157,14 +157,14 @@ void kmsan_report(depot_stack_handle_t o
 	unsigned long ua_flags;
 	bool is_uaf;
 
-	if (!kmsan_enabled)
+	if (!kmsan_enabled || kmsan_in_runtime())
 		return;
 	if (current->kmsan_ctx.depth)
 		return;
 	if (!origin)
 		return;
 
-	kmsan_disable_current();
+	kmsan_enter_runtime();
 	ua_flags = user_access_save();
 	raw_spin_lock(&kmsan_report_lock);
 	pr_err("=====================================================\n");
@@ -217,5 +217,5 @@ void kmsan_report(depot_stack_handle_t o
 	if (panic_on_kmsan)
 		panic("kmsan.panic set ...\n");
 	user_access_restore(ua_flags);
-	kmsan_enable_current();
+	kmsan_leave_runtime();
 }
_

Patches currently in -mm which might be from glider@google.com are



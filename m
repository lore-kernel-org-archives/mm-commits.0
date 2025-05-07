Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF2122F17B
	for <mm-commits@vger.kernel.org>; Wed,  7 May 2025 21:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746654230; cv=none; b=le6WrHWXSO+Yz55BcHbtAwg5xnbXQZ9Lv+0BLIIPWxAzaV7MBDN9sij5G06/YO/qFrW3I2euwlC+Et+dwlbN57N/PWb13wOmfTXE1K85QppMofjXSO48OKaWsHJAWNmb5vR65YVxBBfoYGYKVuiWxO74Eq0SCRKFlVZGM4BDrAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746654230; c=relaxed/simple;
	bh=YwcGGHnyP2rhoSfYOJtOKx5k3CVk+68U2+nvvTjrbaw=;
	h=Date:To:From:Subject:Message-Id; b=Yrzq0Qph/IH5q0e6GPpoAPaRLflO1UUzSZmFrLAbcTdSbksbYbdJTbyGcXmIs3ZqkMPTScN9JZ3JrfAbKZUWOW5L9g+iYHGqjwb5BKg/ki1CjqG+gBtUD6uJjED1KNEPzbZb+jcDtvdow03SfAesiW0pMIE8tRY7yTcRpUrIqg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qTa/e1IN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qTa/e1IN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 084AEC4CEE2;
	Wed,  7 May 2025 21:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746654230;
	bh=YwcGGHnyP2rhoSfYOJtOKx5k3CVk+68U2+nvvTjrbaw=;
	h=Date:To:From:Subject:From;
	b=qTa/e1IN+b+0WA6Uymv8RzHIPp6cqKEJB1f0YdvLWxxngXbMjl2lVt0nnZXYCByEy
	 4S2lSMjdRI06DBcvInzBP6/cYvP0LYtaX6gOIE3pb93n5Pjfhf+eKviVCWoeiVaEJI
	 YcINTN4ZnTSCCu8a6+qR3z+vPVa+sXBmgcjxQCUo=
Date: Wed, 07 May 2025 14:43:48 -0700
To: mm-commits@vger.kernel.org,kent.overstreet@linux.dev,iii@linux.ibm.com,elver@google.com,dvyukov@google.com,bvanassche@acm.org,glider@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kmsan-rework-kmsan_in_runtime-handling-in-kmsan_report.patch added to mm-new branch
Message-Id: <20250507214350.084AEC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kmsan: rework kmsan_in_runtime() handling in kmsan_report()
has been added to the -mm mm-new branch.  Its filename is
     kmsan-rework-kmsan_in_runtime-handling-in-kmsan_report.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kmsan-rework-kmsan_in_runtime-handling-in-kmsan_report.patch

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

kmsan-apply-clang-format-to-files-mm-kmsan.patch
kmsan-fix-usage-of-kmsan_enter_runtime-in-kmsan_vmap_pages_range_noflush.patch
kmsan-drop-the-declaration-of-kmsan_save_stack.patch
kmsan-enter-the-runtime-around-kmsan_internal_memmove_metadata-call.patch
kmsan-rework-kmsan_in_runtime-handling-in-kmsan_report.patch


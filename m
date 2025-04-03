Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E557219E4
	for <mm-commits@vger.kernel.org>; Thu,  3 Apr 2025 21:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743715171; cv=none; b=do9F5aYkc1kEBmYPch+XkSlob+b7YiLDiH+tiLwMX0RFi4TG8OLNIpJnW1dX51A6n0DXZUdK7urOXOPf62GtywPDD6G4k56tjrByNsC992Fpf7OHht0ESYrwedT+50RODg/TWv1avxSRiuQJuvwm9d1IIRiBbepIVm9kcD7xXN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743715171; c=relaxed/simple;
	bh=535mi0JFWPcqXLDrkY908RHzVc56HMFCpMhpo86giVI=;
	h=Date:To:From:Subject:Message-Id; b=lWglz2Ak6x6O/ulLQXCcHXyF3EHY9tSGCCBEwMXgA3Od82TAaNL0tkatG7Lu2KopApMbatmUZ5R5fcSyxsYabK10owSvpjvyY54e/LxCoJPTkLMEbdVz+FDBYLompcQ+6Mp6blXgUhzKvgV/z9gUHMTgNtkAjeOpeXHD+V/i6AY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=w8OXQiIv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="w8OXQiIv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C32CAC4CEE3;
	Thu,  3 Apr 2025 21:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743715170;
	bh=535mi0JFWPcqXLDrkY908RHzVc56HMFCpMhpo86giVI=;
	h=Date:To:From:Subject:From;
	b=w8OXQiIv+raNWXHPQS87pUbdRIEyDjCkati9KeHrETAr2jzaQ/LaGpLE+uEEwxXdm
	 Xq/+BRGv7F4K/aiMUTiqSksEiAWSUbS7wueBsdxAokJKEYoYGfIM43ESjm2mLguWNC
	 lCCI/oOZ1NVqchsqD2xIOwOpim+pco30ZE944Buw=
Date: Thu, 03 Apr 2025 14:19:29 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,oleg@redhat.com,mingo@kernel.org,mhocko@kernel.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,glider@google.com,brauner@kernel.org,andrii@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + exit-move-and-extend-sched_process_exit-tracepoint-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20250403211930.C32CAC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: exit: document sched_process_exit and sched_process_template relation
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     exit-move-and-extend-sched_process_exit-tracepoint-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/exit-move-and-extend-sched_process_exit-tracepoint-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Andrii Nakryiko <andrii@kernel.org>
Subject: exit: document sched_process_exit and sched_process_template relation
Date: Thu, 3 Apr 2025 10:41:20 -0700

Add an explicit note pointing out that sched_process_exit tracepoint is,
conceptually, related to sched_process_template and should be kept in sync
(though, on the best effort basis).

Link: https://lkml.kernel.org/r/20250403174120.4087794-1-andrii@kernel.org
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Suggested-by: Ingo Molnar <mingo@kernel.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/sched.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/include/trace/events/sched.h~exit-move-and-extend-sched_process_exit-tracepoint-fix
+++ a/include/trace/events/sched.h
@@ -326,7 +326,11 @@ DEFINE_EVENT(sched_process_template, sch
 	     TP_ARGS(p));
 
 /*
- * Tracepoint for a task exiting:
+ * Tracepoint for a task exiting.
+ * Note, it's a superset of sched_process_template and should be kept
+ * compatible as much as possible. sched_process_exits has an extra
+ * `group_dead` argument, so sched_process_template can't be used,
+ * unfortunately, just like sched_migrate_task above.
  */
 TRACE_EVENT(sched_process_exit,
 
_

Patches currently in -mm which might be from andrii@kernel.org are

exit-move-and-extend-sched_process_exit-tracepoint.patch
exit-move-and-extend-sched_process_exit-tracepoint-fix.patch


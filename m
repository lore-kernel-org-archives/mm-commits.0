Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8CF25F794
	for <mm-commits@vger.kernel.org>; Tue,  4 Mar 2025 20:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741121147; cv=none; b=rETsIT6m9mwpfzeXMBAypJPvU0JhdxqDMFUoA3CvX7XLxx3sDuBuLHngjxHTCqbUkil8EWGos1MvvhdWeqqCaUz3fEJ61S6xFeT1BLfrkK/Vr40Pnj1x4Y+Ca9zRo5Sq2/HssI5fAShg0oGUvqNu0btWsV0YMcZ+jigh2KQUeho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741121147; c=relaxed/simple;
	bh=3Z9xPCOwBg/cXc2DhxlAoSzNZ4TlfhYjt9s16qolSjk=;
	h=Date:To:From:Subject:Message-Id; b=qa7uY1Ptkw5LnfBcGz8EyU/e3yF2fE3D8dFw3ziWezSc1jLZMDuVjac1o24GtcQntZEy83RdUGwpFMeEbuadkWsenM8NW34sDgQZP3iHwz8tploCDVnIJ5xMq7zv3Fmx5Q6BOeja9j3/pxAxH4SvcVlPL9fs6fIrObfXnEOZ1Fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WWkQ858P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WWkQ858P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 110F6C4CEE5;
	Tue,  4 Mar 2025 20:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741121147;
	bh=3Z9xPCOwBg/cXc2DhxlAoSzNZ4TlfhYjt9s16qolSjk=;
	h=Date:To:From:Subject:From;
	b=WWkQ858PfBmBrko3pQBA02eWXCI/SeJhgzZA/9/utSpZ+zCvIjL6cYfIu4n6K9A3V
	 UKfZjy64ElnlztonE/6k5pFtISmy5EYiBFSdmJXholZtlIs14Jr1zUWHh9GE2druz0
	 kln4fGcwWfztGamsoddLg6VI00KMy0g8LtVugqJY=
Date: Tue, 04 Mar 2025 12:45:46 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,tj@kernel.org,rostedt@goodmis.org,mhiramat@kernel.org,jack@suse.cz,brauner@kernel.org,ast@kernel.org,yizhou.tang@shopee.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + writeback-rename-variables-in-trace_balance_dirty_pages.patch added to mm-unstable branch
Message-Id: <20250304204547.110F6C4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: writeback: rename variables in trace_balance_dirty_pages()
has been added to the -mm mm-unstable branch.  Its filename is
     writeback-rename-variables-in-trace_balance_dirty_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/writeback-rename-variables-in-trace_balance_dirty_pages.patch

This patch will later appear in the mm-unstable branch at
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
From: Tang Yizhou <yizhou.tang@shopee.com>
Subject: writeback: rename variables in trace_balance_dirty_pages()
Date: Tue, 4 Mar 2025 19:03:17 +0800

Rename bdi_setpoint and bdi_dirty in the tracepoint to wb_setpoint and
wb_dirty, respectively. These changes were omitted by Tejun in the cgroup
writeback patchset.

Link: https://lkml.kernel.org/r/20250304110318.159567-3-yizhou.tang@shopee.com
Signed-off-by: Tang Yizhou <yizhou.tang@shopee.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/writeback.h |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/include/trace/events/writeback.h~writeback-rename-variables-in-trace_balance_dirty_pages
+++ a/include/trace/events/writeback.h
@@ -646,8 +646,8 @@ TRACE_EVENT(balance_dirty_pages,
 		__field(unsigned long,	limit)
 		__field(unsigned long,	setpoint)
 		__field(unsigned long,	dirty)
-		__field(unsigned long,	bdi_setpoint)
-		__field(unsigned long,	bdi_dirty)
+		__field(unsigned long,	wb_setpoint)
+		__field(unsigned long,	wb_dirty)
 		__field(unsigned long,	dirty_ratelimit)
 		__field(unsigned long,	task_ratelimit)
 		__field(unsigned int,	dirtied)
@@ -667,9 +667,9 @@ TRACE_EVENT(balance_dirty_pages,
 		__entry->setpoint	= (global_wb_domain.dirty_limit +
 						freerun) / 2;
 		__entry->dirty		= dtc->dirty;
-		__entry->bdi_setpoint	= __entry->setpoint *
+		__entry->wb_setpoint	= __entry->setpoint *
 						dtc->wb_thresh / (dtc->thresh + 1);
-		__entry->bdi_dirty	= dtc->wb_dirty;
+		__entry->wb_dirty	= dtc->wb_dirty;
 		__entry->dirty_ratelimit = KBps(dirty_ratelimit);
 		__entry->task_ratelimit	= KBps(task_ratelimit);
 		__entry->dirtied	= dirtied;
@@ -685,7 +685,7 @@ TRACE_EVENT(balance_dirty_pages,
 
 	TP_printk("bdi %s: "
 		  "limit=%lu setpoint=%lu dirty=%lu "
-		  "bdi_setpoint=%lu bdi_dirty=%lu "
+		  "wb_setpoint=%lu wb_dirty=%lu "
 		  "dirty_ratelimit=%lu task_ratelimit=%lu "
 		  "dirtied=%u dirtied_pause=%u "
 		  "paused=%lu pause=%ld period=%lu think=%ld cgroup_ino=%lu",
@@ -693,8 +693,8 @@ TRACE_EVENT(balance_dirty_pages,
 		  __entry->limit,
 		  __entry->setpoint,
 		  __entry->dirty,
-		  __entry->bdi_setpoint,
-		  __entry->bdi_dirty,
+		  __entry->wb_setpoint,
+		  __entry->wb_dirty,
 		  __entry->dirty_ratelimit,
 		  __entry->task_ratelimit,
 		  __entry->dirtied,
_

Patches currently in -mm which might be from yizhou.tang@shopee.com are

writeback-let-trace_balance_dirty_pages-take-struct-dtc-as-parameter.patch
writeback-rename-variables-in-trace_balance_dirty_pages.patch
writeback-fix-calculations-in-trace_balance_dirty_pages-for-cgwb.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582928634E
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188534; cv=none; b=b6S/netu+5PGroxRMrPmnY9Wjlnw51CIAlooujkjWIZP0C1CCOwewDIiTD5H+443uyJtulbHAtnHL0cIUR2qdcV+s/cyaOLqXAtAP+oZ1TQv2DMLbMN3SUlbzyKOz8GqE+vr8F/whAwg6JFAxwgEB8EKfhIgyYgpoMPTH7MJO94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188534; c=relaxed/simple;
	bh=LE5tN5XCWEvdQb4YkTwd+QqrF3Glc58BlqLbSRg6RWY=;
	h=Date:To:From:Subject:Message-Id; b=n6JiFm41Ooku1SiuxOynSjPuKLnlR/2BUEKof4YIqGO9gXh3f0QGMWKhISzE8m1EviAVARIwPC/Chn8mYGJpjpSLInOxeUcWJSUaFfpDlFWblcOBfj423fo+PsrL8JFGiGHkjfEy9sVPqpzqU2Huso7ktSZGKF/cexDlsoWtmDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pL1uP0U4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pL1uP0U4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BBD1C4CEEC;
	Mon, 17 Mar 2025 05:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188534;
	bh=LE5tN5XCWEvdQb4YkTwd+QqrF3Glc58BlqLbSRg6RWY=;
	h=Date:To:From:Subject:From;
	b=pL1uP0U4o4hJsxP/jJHk/oHFSFxqvPOcDapX5ddfHstHxWUnBr6b26D3GJneGw+CK
	 GZKYfOrfSuoTEGdQRqlzoyL0GpuVgLzil0dM6dqgvNq/ImFdypwP2Em8ief2VukTiE
	 xRlovgBTl3COvgJLmYG9SDRpEss9pWlfSeNKff8o=
Date: Sun, 16 Mar 2025 22:15:33 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tj@kernel.org,rostedt@goodmis.org,mhiramat@kernel.org,jack@suse.cz,brauner@kernel.org,ast@kernel.org,yizhou.tang@shopee.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] writeback-rename-variables-in-trace_balance_dirty_pages.patch removed from -mm tree
Message-Id: <20250317051534.2BBD1C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: writeback: rename variables in trace_balance_dirty_pages()
has been removed from the -mm tree.  Its filename was
     writeback-rename-variables-in-trace_balance_dirty_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



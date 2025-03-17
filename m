Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37E508634E
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188533; cv=none; b=MkxpW0+9MqNeq7ehZyDeaGxr2v2DFE/uqzK/LZSj3F0SbB1yKC9y+C5JATR1GjN/L3GS5MdeqlZtmYwEC/jb3j9tEM5uI2aNXHsAyhP19SyujbD1OuTZbzEYPvfjHiPqd2GXuTbiXzFQWL1ki++2SYy/jgBy7zoYL3aGjgWKQ8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188533; c=relaxed/simple;
	bh=i/Ohmu4yiZpdcfA/kebqrmH1V5fMp7HOkl6GetHcZ3g=;
	h=Date:To:From:Subject:Message-Id; b=aJCeJ3fjeNI7H14xlaXQQ/VQvaIxDrjzX3d+6lSInczgn0c6IgD1vHhmfs6mPGATfk7Oq5GOY9DVWR+FwwUf6ADUoeRQKNqwZQriEtezE3e5P6d1Vk0taTxv8ZVgCtQzKV1vbVdWOUCCZRpa336cmaMgK3/vgBEoeflGHaPDL3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k2BprWFe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k2BprWFe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0872CC4CEEC;
	Mon, 17 Mar 2025 05:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188533;
	bh=i/Ohmu4yiZpdcfA/kebqrmH1V5fMp7HOkl6GetHcZ3g=;
	h=Date:To:From:Subject:From;
	b=k2BprWFewgkrW04hGXgo+k/+Uh0FcxYGugJcbDM9h3LwvarXAz5zg9TTDAp0nAkc7
	 36GEPxEGeE9UO6/JhoKW1tDJF0kBmrzXARNFYf+9pV3Oao3v78zJxgHd6d1v0k4HNO
	 GeVdcBIROKFzV1/+vIFgRSCRp59/8BhZL5UI93pc=
Date: Sun, 16 Mar 2025 22:15:32 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tj@kernel.org,rostedt@goodmis.org,mhiramat@kernel.org,jack@suse.cz,brauner@kernel.org,ast@kernel.org,yizhou.tang@shopee.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] writeback-let-trace_balance_dirty_pages-take-struct-dtc-as-parameter.patch removed from -mm tree
Message-Id: <20250317051533.0872CC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: writeback: let trace_balance_dirty_pages() take struct dtc as parameter
has been removed from the -mm tree.  Its filename was
     writeback-let-trace_balance_dirty_pages-take-struct-dtc-as-parameter.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tang Yizhou <yizhou.tang@shopee.com>
Subject: writeback: let trace_balance_dirty_pages() take struct dtc as parameter
Date: Tue, 4 Mar 2025 19:03:16 +0800

Patch series "Fix calculations in trace_balance_dirty_pages() for cgwb", v2.

In my experiment, I found that the output of trace_balance_dirty_pages()
in the cgroup writeback scenario was strange because
trace_balance_dirty_pages() always uses global_wb_domain.dirty_limit for
related calculations instead of the dirty_limit of the corresponding
memcg's wb_domain.

The basic idea of the fix is to store the hard dirty limit value computed
in wb_position_ratio() into struct dirty_throttle_control and use it for
calculations in trace_balance_dirty_pages().


This patch (of 3):

Currently, trace_balance_dirty_pages() already has 12 parameters.  In the
patch #3, I initially attempted to introduce an additional parameter. 
However, in include/linux/trace_events.h, bpf_trace_run12() only supports
up to 12 parameters and bpf_trace_run13() does not exist.

To reduce the number of parameters in trace_balance_dirty_pages(), we can
make it accept a pointer to struct dirty_throttle_control as a parameter. 
To achieve this, we need to move the definition of struct
dirty_throttle_control from mm/page-writeback.c to
include/linux/writeback.h.

Link: https://lkml.kernel.org/r/20250304110318.159567-1-yizhou.tang@shopee.com
Link: https://lkml.kernel.org/r/20250304110318.159567-2-yizhou.tang@shopee.com
Signed-off-by: Tang Yizhou <yizhou.tang@shopee.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jan Kara <jack@suse.cz>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Tang Yizhou <yizhou.tang@shopee.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/writeback.h        |   23 +++++++++++++++++++
 include/trace/events/writeback.h |   16 ++++---------
 mm/page-writeback.c              |   35 +----------------------------
 3 files changed, 31 insertions(+), 43 deletions(-)

--- a/include/linux/writeback.h~writeback-let-trace_balance_dirty_pages-take-struct-dtc-as-parameter
+++ a/include/linux/writeback.h
@@ -313,6 +313,29 @@ static inline void cgroup_writeback_umou
 /*
  * mm/page-writeback.c
  */
+/* consolidated parameters for balance_dirty_pages() and its subroutines */
+struct dirty_throttle_control {
+#ifdef CONFIG_CGROUP_WRITEBACK
+	struct wb_domain	*dom;
+	struct dirty_throttle_control *gdtc;	/* only set in memcg dtc's */
+#endif
+	struct bdi_writeback	*wb;
+	struct fprop_local_percpu *wb_completions;
+
+	unsigned long		avail;		/* dirtyable */
+	unsigned long		dirty;		/* file_dirty + write + nfs */
+	unsigned long		thresh;		/* dirty threshold */
+	unsigned long		bg_thresh;	/* dirty background threshold */
+
+	unsigned long		wb_dirty;	/* per-wb counterparts */
+	unsigned long		wb_thresh;
+	unsigned long		wb_bg_thresh;
+
+	unsigned long		pos_ratio;
+	bool			freerun;
+	bool			dirty_exceeded;
+};
+
 void laptop_io_completion(struct backing_dev_info *info);
 void laptop_sync_completion(void);
 void laptop_mode_timer_fn(struct timer_list *t);
--- a/include/trace/events/writeback.h~writeback-let-trace_balance_dirty_pages-take-struct-dtc-as-parameter
+++ a/include/trace/events/writeback.h
@@ -629,11 +629,7 @@ TRACE_EVENT(bdi_dirty_ratelimit,
 TRACE_EVENT(balance_dirty_pages,
 
 	TP_PROTO(struct bdi_writeback *wb,
-		 unsigned long thresh,
-		 unsigned long bg_thresh,
-		 unsigned long dirty,
-		 unsigned long bdi_thresh,
-		 unsigned long bdi_dirty,
+		 struct dirty_throttle_control *dtc,
 		 unsigned long dirty_ratelimit,
 		 unsigned long task_ratelimit,
 		 unsigned long dirtied,
@@ -641,7 +637,7 @@ TRACE_EVENT(balance_dirty_pages,
 		 long pause,
 		 unsigned long start_time),
 
-	TP_ARGS(wb, thresh, bg_thresh, dirty, bdi_thresh, bdi_dirty,
+	TP_ARGS(wb, dtc,
 		dirty_ratelimit, task_ratelimit,
 		dirtied, period, pause, start_time),
 
@@ -664,16 +660,16 @@ TRACE_EVENT(balance_dirty_pages,
 	),
 
 	TP_fast_assign(
-		unsigned long freerun = (thresh + bg_thresh) / 2;
+		unsigned long freerun = (dtc->thresh + dtc->bg_thresh) / 2;
 		strscpy_pad(__entry->bdi, bdi_dev_name(wb->bdi), 32);
 
 		__entry->limit		= global_wb_domain.dirty_limit;
 		__entry->setpoint	= (global_wb_domain.dirty_limit +
 						freerun) / 2;
-		__entry->dirty		= dirty;
+		__entry->dirty		= dtc->dirty;
 		__entry->bdi_setpoint	= __entry->setpoint *
-						bdi_thresh / (thresh + 1);
-		__entry->bdi_dirty	= bdi_dirty;
+						dtc->wb_thresh / (dtc->thresh + 1);
+		__entry->bdi_dirty	= dtc->wb_dirty;
 		__entry->dirty_ratelimit = KBps(dirty_ratelimit);
 		__entry->task_ratelimit	= KBps(task_ratelimit);
 		__entry->dirtied	= dirtied;
--- a/mm/page-writeback.c~writeback-let-trace_balance_dirty_pages-take-struct-dtc-as-parameter
+++ a/mm/page-writeback.c
@@ -120,29 +120,6 @@ EXPORT_SYMBOL(laptop_mode);
 
 struct wb_domain global_wb_domain;
 
-/* consolidated parameters for balance_dirty_pages() and its subroutines */
-struct dirty_throttle_control {
-#ifdef CONFIG_CGROUP_WRITEBACK
-	struct wb_domain	*dom;
-	struct dirty_throttle_control *gdtc;	/* only set in memcg dtc's */
-#endif
-	struct bdi_writeback	*wb;
-	struct fprop_local_percpu *wb_completions;
-
-	unsigned long		avail;		/* dirtyable */
-	unsigned long		dirty;		/* file_dirty + write + nfs */
-	unsigned long		thresh;		/* dirty threshold */
-	unsigned long		bg_thresh;	/* dirty background threshold */
-
-	unsigned long		wb_dirty;	/* per-wb counterparts */
-	unsigned long		wb_thresh;
-	unsigned long		wb_bg_thresh;
-
-	unsigned long		pos_ratio;
-	bool			freerun;
-	bool			dirty_exceeded;
-};
-
 /*
  * Length of period for aging writeout fractions of bdis. This is an
  * arbitrarily chosen number. The longer the period, the slower fractions will
@@ -1962,11 +1939,7 @@ free_running:
 		 */
 		if (pause < min_pause) {
 			trace_balance_dirty_pages(wb,
-						  sdtc->thresh,
-						  sdtc->bg_thresh,
-						  sdtc->dirty,
-						  sdtc->wb_thresh,
-						  sdtc->wb_dirty,
+						  sdtc,
 						  dirty_ratelimit,
 						  task_ratelimit,
 						  pages_dirtied,
@@ -1991,11 +1964,7 @@ free_running:
 
 pause:
 		trace_balance_dirty_pages(wb,
-					  sdtc->thresh,
-					  sdtc->bg_thresh,
-					  sdtc->dirty,
-					  sdtc->wb_thresh,
-					  sdtc->wb_dirty,
+					  sdtc,
 					  dirty_ratelimit,
 					  task_ratelimit,
 					  pages_dirtied,
_

Patches currently in -mm which might be from yizhou.tang@shopee.com are



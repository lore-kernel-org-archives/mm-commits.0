Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D7D0259C83
	for <mm-commits@vger.kernel.org>; Tue,  4 Mar 2025 20:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741121149; cv=none; b=VIbBn/fPTWj356fkmBf5bzNnhBVPhn+PKtxZ2Ennrf3FQ3Jvg+WkdC09YbVJmV6yzPoYFGnnUmFYJdske3mdPrIKPnl6mP3PyL0HURue4264n0Y7yUN6BuECwlxf51ieQmNGlaEm2KucQaOZa7qMkqXwldO29bvsN533NEKssq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741121149; c=relaxed/simple;
	bh=eltBOcfLlK7rv66MMwZdv0Au7Kh2dGex2day/xsX1FU=;
	h=Date:To:From:Subject:Message-Id; b=Q9pzlDtt0qvYhx35ftmHG+w89I5kIwIF2C3Ziou8asmsVbcECxtd+f/JHFZVfggJSWz5kGUu/vjUAjMzFYitTyv7afKXiQ6y7rl0rW4w+Isv9pANFTfMdK5aOynB7+zksXBU0OO4F/VNtk+aYspElCy7opzeIfNGwhnOUAeQR7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Kq7OSGK9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Kq7OSGK9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E1ACC4CEE5;
	Tue,  4 Mar 2025 20:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741121149;
	bh=eltBOcfLlK7rv66MMwZdv0Au7Kh2dGex2day/xsX1FU=;
	h=Date:To:From:Subject:From;
	b=Kq7OSGK9nOgTnTUQehQXiOfc4KzHBINfjPiWMOU93uNTIuhqhLTT6Je7yjz+cSiPe
	 OfQLeb55QvfVzfenMYRhjniKkzWUd8M+1m4R0owxcPNzpjDajUga8zaqslKmriUpVl
	 Y+JVFNz71S4DJEUScfhpvN8FdiH5EoHU1wDRMBTo=
Date: Tue, 04 Mar 2025 12:45:48 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,tj@kernel.org,rostedt@goodmis.org,mhiramat@kernel.org,jack@suse.cz,brauner@kernel.org,ast@kernel.org,yizhou.tang@shopee.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + writeback-fix-calculations-in-trace_balance_dirty_pages-for-cgwb.patch added to mm-unstable branch
Message-Id: <20250304204549.2E1ACC4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: writeback: fix calculations in trace_balance_dirty_pages() for cgwb
has been added to the -mm mm-unstable branch.  Its filename is
     writeback-fix-calculations-in-trace_balance_dirty_pages-for-cgwb.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/writeback-fix-calculations-in-trace_balance_dirty_pages-for-cgwb.patch

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
Subject: writeback: fix calculations in trace_balance_dirty_pages() for cgwb
Date: Tue, 4 Mar 2025 19:03:18 +0800

In the commit dcc25ae76eb7 ("writeback: move global_dirty_limit into
wb_domain") of the cgroup writeback backpressure propagation patchset,
Tejun made some adaptations to trace_balance_dirty_pages() for cgroup
writeback.  However, this adaptation was incomplete and Tejun missed
further adaptation in the subsequent patches.

In the cgroup writeback scenario, if sdtc in balance_dirty_pages() is
assigned to mdtc, then upon entering trace_balance_dirty_pages(),
__entry->limit should be assigned based on the dirty_limit of the
corresponding memcg's wb_domain, rather than global_wb_domain.

To address this issue and simplify the implementation, introduce a 'limit'
field in struct dirty_throttle_control to store the hard_limit value
computed in wb_position_ratio() by calling hard_dirty_limit().  This field
will then be used in trace_balance_dirty_pages() to assign the value to
__entry->limit.

Link: https://lkml.kernel.org/r/20250304110318.159567-4-yizhou.tang@shopee.com
Fixes: dcc25ae76eb7 ("writeback: move global_dirty_limit into wb_domain")
Signed-off-by: Tang Yizhou <yizhou.tang@shopee.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/writeback.h        |    1 +
 include/trace/events/writeback.h |    5 ++---
 mm/page-writeback.c              |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/writeback.h~writeback-fix-calculations-in-trace_balance_dirty_pages-for-cgwb
+++ a/include/linux/writeback.h
@@ -326,6 +326,7 @@ struct dirty_throttle_control {
 	unsigned long		dirty;		/* file_dirty + write + nfs */
 	unsigned long		thresh;		/* dirty threshold */
 	unsigned long		bg_thresh;	/* dirty background threshold */
+	unsigned long		limit;		/* hard dirty limit */
 
 	unsigned long		wb_dirty;	/* per-wb counterparts */
 	unsigned long		wb_thresh;
--- a/include/trace/events/writeback.h~writeback-fix-calculations-in-trace_balance_dirty_pages-for-cgwb
+++ a/include/trace/events/writeback.h
@@ -663,9 +663,8 @@ TRACE_EVENT(balance_dirty_pages,
 		unsigned long freerun = (dtc->thresh + dtc->bg_thresh) / 2;
 		strscpy_pad(__entry->bdi, bdi_dev_name(wb->bdi), 32);
 
-		__entry->limit		= global_wb_domain.dirty_limit;
-		__entry->setpoint	= (global_wb_domain.dirty_limit +
-						freerun) / 2;
+		__entry->limit		= dtc->limit;
+		__entry->setpoint	= (dtc->limit + freerun) / 2;
 		__entry->dirty		= dtc->dirty;
 		__entry->wb_setpoint	= __entry->setpoint *
 						dtc->wb_thresh / (dtc->thresh + 1);
--- a/mm/page-writeback.c~writeback-fix-calculations-in-trace_balance_dirty_pages-for-cgwb
+++ a/mm/page-writeback.c
@@ -1072,7 +1072,7 @@ static void wb_position_ratio(struct dir
 	struct bdi_writeback *wb = dtc->wb;
 	unsigned long write_bw = READ_ONCE(wb->avg_write_bandwidth);
 	unsigned long freerun = dirty_freerun_ceiling(dtc->thresh, dtc->bg_thresh);
-	unsigned long limit = hard_dirty_limit(dtc_dom(dtc), dtc->thresh);
+	unsigned long limit = dtc->limit = hard_dirty_limit(dtc_dom(dtc), dtc->thresh);
 	unsigned long wb_thresh = dtc->wb_thresh;
 	unsigned long x_intercept;
 	unsigned long setpoint;		/* dirty pages' target balance point */
_

Patches currently in -mm which might be from yizhou.tang@shopee.com are

writeback-let-trace_balance_dirty_pages-take-struct-dtc-as-parameter.patch
writeback-rename-variables-in-trace_balance_dirty_pages.patch
writeback-fix-calculations-in-trace_balance_dirty_pages-for-cgwb.patch


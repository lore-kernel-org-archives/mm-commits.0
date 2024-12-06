Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0B8192B8F;
	Fri,  6 Dec 2024 03:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733457339; cv=none; b=F6C0EDotE9E2T/rFwMAP3OPINi1O3r2IYmope92IZeMUE7YsxHrtLyIixoEJ98lfsg3H6iIHt77Zqfk5oREKPvnXRum160VasXRKksQOXfigBjnN+O8RoNXG1RzpVKhdWy1804nBTd30f73AXSnPquQzzg980CK1KgzsaqBJbA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733457339; c=relaxed/simple;
	bh=FMSGMD8N1Uk7WjEHapfQALYYGsXw6Dj+/sEVHHRNLiA=;
	h=Date:To:From:Subject:Message-Id; b=X3odDcgTjKVGZcxkvwy1NT5wPRAkiz7KiJGf2aIEG/xh2347vVT+L+yAWP6lnDmIlROZ/3phET7ohLeWQyDR5DnRb1j8mhVW8zZYBmwb+1/vKyGfCOGZU3TriulkpzYU5DemXzbvqtZnYziqYRfCLizeV4soPs4yb142YDGsTJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eb9PpnAQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eb9PpnAQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48D86C4CED1;
	Fri,  6 Dec 2024 03:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733457339;
	bh=FMSGMD8N1Uk7WjEHapfQALYYGsXw6Dj+/sEVHHRNLiA=;
	h=Date:To:From:Subject:From;
	b=eb9PpnAQFbKrTfg/BMtpS1K6i3Pt3iLliKsYpX7sXXP7EJU7LfllfhwaTMN40RIIS
	 MRJVObK92WI/aOmW5WIl3gZxf9HuWvOrOaBrwJKPPMTOiLniu31VHHx+OzHszsPB/T
	 3HdDr+igTcPQaOdEK6MtIc5di+zIuV6BpNYPgTws=
Date: Thu, 05 Dec 2024 19:55:38 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,rostedt@goodmis.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,akinobu.mita@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-fix-order-of-arguments-in-damos_before_apply-tracepoint.patch removed from -mm tree
Message-Id: <20241206035539.48D86C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: fix order of arguments in damos_before_apply tracepoint
has been removed from the -mm tree.  Its filename was
     mm-damon-fix-order-of-arguments-in-damos_before_apply-tracepoint.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: mm/damon: fix order of arguments in damos_before_apply tracepoint
Date: Fri, 15 Nov 2024 10:20:23 -0800

Since the order of the scheme_idx and target_idx arguments in TP_ARGS is
reversed, they are stored in the trace record in reverse.

Link: https://lkml.kernel.org/r/20241115182023.43118-1-sj@kernel.org
Link: https://patch.msgid.link/20241112154828.40307-1-akinobu.mita@gmail.com
Fixes: c603c630b509 ("mm/damon/core: add a tracepoint for damos apply target regions")
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/damon.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/trace/events/damon.h~mm-damon-fix-order-of-arguments-in-damos_before_apply-tracepoint
+++ a/include/trace/events/damon.h
@@ -15,7 +15,7 @@ TRACE_EVENT_CONDITION(damos_before_apply
 		unsigned int target_idx, struct damon_region *r,
 		unsigned int nr_regions, bool do_trace),
 
-	TP_ARGS(context_idx, target_idx, scheme_idx, r, nr_regions, do_trace),
+	TP_ARGS(context_idx, scheme_idx, target_idx, r, nr_regions, do_trace),
 
 	TP_CONDITION(do_trace),
 
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are



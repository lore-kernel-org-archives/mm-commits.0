Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 386D938F929;
	Sun, 26 Apr 2026 20:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777233771; cv=none; b=lnk//XjXMHUNErWb/OE/FfdlzDtXSvB3fgID1Mis/tp6OYuzO4JOOzdJRXUoiCNhUxsMfFaovUjU330hTQM9hBfVS0dbatPm6B0ZpRF+ioOg4Ssx2DpyQmkPIJLVizGTDqJB5XT7HHCE0PeVM5SQentyx2dedkcfZ0Ry0cNi1P8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777233771; c=relaxed/simple;
	bh=bxlyRdvIDp5E3p9LtmZkNrJObZr+A7yxjdnHKgbgr+s=;
	h=Date:To:From:Subject:Message-Id; b=h0xBOCjyoLnGRjrOv0afcIFcSUEnchqwqTsk1HsDFeeKfXeQ8/C18xg35QyjXAl9wVLtSS5zkkLnLnQt7qBle3QWxM7JP/Aoy6VBzxpuyMVAxWjsx1ZBv/eo7r6kZtDxcM6yBq1BHflCcB0wc3YX3KucbYcU6k6/CRoi50guebk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=m3stEKmN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m3stEKmN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE164C2BCAF;
	Sun, 26 Apr 2026 20:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777233770;
	bh=bxlyRdvIDp5E3p9LtmZkNrJObZr+A7yxjdnHKgbgr+s=;
	h=Date:To:From:Subject:From;
	b=m3stEKmNZDXJEsVRRO9grqOL8FWONVV5H9oY5Yc4qFZQzmMK+eKKf1TzOCjlqvLlh
	 npYll/jWoMv/drRM50jr3PPJthLXCmWoAGnFrjGoJFsci+TVGoGzJgd7a90Zmcn25M
	 FLyKkSB23SivFYrtFaPHab+H5o5MJp1VuzWodfuo=
Date: Sun, 26 Apr 2026 13:02:50 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,rostedt@goodmis.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-fix-damos_stat-tracepoint-format-for-sz_applied.patch added to mm-hotfixes-unstable branch
Message-Id: <20260426200250.BE164C2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon: fix damos_stat tracepoint format for sz_applied
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-fix-damos_stat-tracepoint-format-for-sz_applied.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-fix-damos_stat-tracepoint-format-for-sz_applied.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon: fix damos_stat tracepoint format for sz_applied
Date: Sun, 26 Apr 2026 12:31:17 -0700

The print format is wrongly marking sz_applied as sz_tried.  Fix it.

Link: https://lore.kernel.org/20260426193119.88095-1-sj@kernel.org
Fixes: 804c26b961da ("mm/damon/core: add trace point for damos stat per apply interval")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: <stable@vger.kernel.org> # 7.0.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/damon.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/trace/events/damon.h~mm-damon-fix-damos_stat-tracepoint-format-for-sz_applied
+++ a/include/trace/events/damon.h
@@ -41,7 +41,7 @@ TRACE_EVENT(damos_stat_after_apply_inter
 	),
 
 	TP_printk("ctx_idx=%u scheme_idx=%u nr_tried=%lu sz_tried=%lu "
-			"nr_applied=%lu sz_tried=%lu sz_ops_filter_passed=%lu "
+			"nr_applied=%lu sz_applied=%lu sz_ops_filter_passed=%lu "
 			"qt_exceeds=%lu nr_snapshots=%lu",
 			__entry->context_idx, __entry->scheme_idx,
 			__entry->nr_tried, __entry->sz_tried,
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-protect-memcg_path-kfree-with-damon_sysfs_lock.patch
mm-damon-sysfs-schemes-protect-path-kfree-with-damon_sysfs_lock.patch
mm-damon-reclaim-detect-and-use-fresh-enabled-and-kdamond_pid-values.patch
mm-damon-lru_sort-detect-and-use-fresh-enabled-and-kdamond_pid-values.patch
mm-damon-stat-detect-and-use-fresh-enabled-value.patch
mm-damon-sysfs-schemes-call-missing-mem_cgroup_iter_break.patch
mm-damon-fix-damos_stat-tracepoint-format-for-sz_applied.patch
docs-mm-damon-maintainer-profile-add-ai-review-usage-guideline.patch


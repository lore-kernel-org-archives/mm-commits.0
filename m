Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACC3C20330;
	Sat, 30 Nov 2024 04:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732939967; cv=none; b=P09xJBVVjvw+xvp5HlGpdSD/uK99MYMTrXlvfUz0DZ6hVP8/kxYPOrBd0qp0SK+7iCLTOGRNJeeKz4iEQW09eLoScW8s5BZvUTnTbwU6zcUKI7O2ywNObEU0cIVjlixsuh1Y0JMXnDezcr7I0MR1CRuQM5TMTyqapGdtErqHpcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732939967; c=relaxed/simple;
	bh=ZdR8He5KkFZynUOunl5hS1ewYxv7g1Gn1/jzgOXQ6OM=;
	h=Date:To:From:Subject:Message-Id; b=IC3tKyvdBpkkTs4RfX2hTrm7IHzhviubh/juWm6b+BIR1m+u6OwYUEPfHevAMGDJSecWDI7Tby8CWeQYRuDAQik28aStdAwe+bxkMNQqomI5T65z30LFII+Qc05/bTv+X1OpwPUXG/wk1QZQmx+4EIpWelq8xuHWOTgZ/+k74Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QaGROKIU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QaGROKIU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AA5AC4CECC;
	Sat, 30 Nov 2024 04:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732939967;
	bh=ZdR8He5KkFZynUOunl5hS1ewYxv7g1Gn1/jzgOXQ6OM=;
	h=Date:To:From:Subject:From;
	b=QaGROKIU3Xbo2+PtItRJz4t+3ZdFDTFmKzhDqq0QI/h5ljNovU7ktZNxJMq8JGsJo
	 Ov9Ox1LFU3h29mlmNIdEoFrTpyoigsdmEOdwt0kisfUEVB7QRA46gmYupKE/RWHNKP
	 0P4dEjSYy+F93kkzaRypZvX2J+F6QzFTHGyI9IuY=
Date: Fri, 29 Nov 2024 20:12:46 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,rostedt@goodmis.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,akinobu.mita@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-fix-order-of-arguments-in-damos_before_apply-tracepoint.patch added to mm-hotfixes-unstable branch
Message-Id: <20241130041247.6AA5AC4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon: fix order of arguments in damos_before_apply tracepoint
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-fix-order-of-arguments-in-damos_before_apply-tracepoint.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-fix-order-of-arguments-in-damos_before_apply-tracepoint.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

mm-damon-fix-order-of-arguments-in-damos_before_apply-tracepoint.patch


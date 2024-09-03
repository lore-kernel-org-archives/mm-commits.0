Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9998241C65
	for <mm-commits@vger.kernel.org>; Tue,  3 Sep 2024 20:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725395131; cv=none; b=g5UILStSenjiIYde+Tf5q1Ujm9FV2ElXS0jQWYp/PXBbWiTUZe0DKPgSlcPtNZtTAp+cd6YspK05M/YylR69WR9kZ0aaYmU7qSSb61VhpHC//EZ9VqIzcUIHtm2Nzl1cy1Pgxr2xIjlnhD5Q20Q3IG20yg0690XyEiE9a3e1Iy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725395131; c=relaxed/simple;
	bh=qtdiHg5Ti4wD2BDqmT1oS7cS6qCmdvjGLnynBLpoMm8=;
	h=Date:To:From:Subject:Message-Id; b=sF0GsK5hGy14cVGSNMkpUbuncIc0960bm76/QXQ/3F0IX/dcppz20bJiMf0uTYdrPp6UNRdrtULyGrH4o/tACP/Y+K6SRneMoDoxYU7bwFnY4ai1BVs7hVP+La8Xc0wIuWGCszbCYxFKcDLshs3N2/nWBFHuX4pwGZbH87qtVOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TfeuXUpd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TfeuXUpd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 060CFC4CEC4;
	Tue,  3 Sep 2024 20:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725395130;
	bh=qtdiHg5Ti4wD2BDqmT1oS7cS6qCmdvjGLnynBLpoMm8=;
	h=Date:To:From:Subject:From;
	b=TfeuXUpdlZynaDp02plozg89VsI7BQ1yBPLpm71Q4HK3XVFpciFj6hmiIb2C5L7Il
	 Yv5XZc6vsQpb8De1Cd/g8WS45MckUnzUy85riKPt1EyJhSixLTI9Wnx83ewfzLWAoK
	 MVjn11pHbKG4dDsLsOAOducm9jS/9RG33Vimhu2E=
Date: Tue, 03 Sep 2024 13:25:29 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,uekawa@chromium.org,rostedt@goodmis.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,takayas@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + filemap-fix-the-last_index-of-mm_filemap_get_pages.patch added to mm-unstable branch
Message-Id: <20240903202530.060CFC4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: filemap: fix the last_index of mm_filemap_get_pages
has been added to the -mm mm-unstable branch.  Its filename is
     filemap-fix-the-last_index-of-mm_filemap_get_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/filemap-fix-the-last_index-of-mm_filemap_get_pages.patch

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
From: Takaya Saeki <takayas@chromium.org>
Subject: filemap: fix the last_index of mm_filemap_get_pages
Date: Tue, 3 Sep 2024 10:21:00 +0000

In commit b6273b55d885 ("filemap: add trace events for get_pages,
map_pages, and fault"), mm_filemap_get_pages was added to trace page cache
access.  However, it tracks an extra page beyond the end of the accessed
range.  This patch fixes it by replacing last_index with last_index - 1.

Link: https://lkml.kernel.org/r/20240903102100.70405-1-takayas@chromium.org
Fixes: b6273b55d885 ("filemap: add trace events for get_pages, map_pages, and fault")
Signed-off-by: Takaya Saeki <takayas@chromium.org>
Cc: Junichi Uekawa <uekawa@chromium.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/filemap.c~filemap-fix-the-last_index-of-mm_filemap_get_pages
+++ a/mm/filemap.c
@@ -2571,7 +2571,7 @@ retry:
 			goto err;
 	}
 
-	trace_mm_filemap_get_pages(mapping, index, last_index);
+	trace_mm_filemap_get_pages(mapping, index, last_index - 1);
 	return 0;
 err:
 	if (err < 0)
_

Patches currently in -mm which might be from takayas@chromium.org are

filemap-fix-the-last_index-of-mm_filemap_get_pages.patch


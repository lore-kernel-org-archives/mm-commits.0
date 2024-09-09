Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 950AD18E05F
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925292; cv=none; b=bOsCVhqFofRIJuisJM5qW7q+Gbl78nFVrRGQ/ekuHI6F+vvz5IfcBQllm/CTiIbxzqSE8611/Zi59zyz3/G3RBPrE4ap3ANWcoac0o2cVAJpSyzzvWj/z7VGai/VUiZ9fdICebHwqeCYbD34VRt3KW8PDBn/mk0l8GTsqyIVDEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925292; c=relaxed/simple;
	bh=S5wvPttdn6KT9qwuPpsuAq9jA6RDDDwz5E2TQhRl6sg=;
	h=Date:To:From:Subject:Message-Id; b=bJ/8ytzMy/rrXJ/0OHEIhGFycddidcbTjOpgcv+jEfN6FiWEl6YPT7GaM/RLDxFpSK1wxQaJcgV36UOCVpffh+ACcnU4iaOdu0TP2J7OXE32uns1CxhsqbuYOOgi5QfVK10UKphaVqmDndcGiIyf7KcWdQBP8p2iAdTvnId2J2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nt4n0HCq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nt4n0HCq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AEEFC4CEC5;
	Mon,  9 Sep 2024 23:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925292;
	bh=S5wvPttdn6KT9qwuPpsuAq9jA6RDDDwz5E2TQhRl6sg=;
	h=Date:To:From:Subject:From;
	b=nt4n0HCq8D3qjXdDc55ZdxSsDjXlFyXda45mZk+hrKUJ5BPp/7ed9Fej56263s1+X
	 mGUpAT2KXc4pWA04glCU36jfI76bqBFilDrzY4DPrGLY4hLXWkL8ZAnDqgXFh5Qupn
	 t42oZCTYwFUjs5JLJcnXuNOg0zUxT6fZ5Pi9X7wo=
Date: Mon, 09 Sep 2024 16:41:31 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,uekawa@chromium.org,rostedt@goodmis.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,takayas@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] filemap-fix-the-last_index-of-mm_filemap_get_pages.patch removed from -mm tree
Message-Id: <20240909234132.6AEEFC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: filemap: fix the last_index of mm_filemap_get_pages
has been removed from the -mm tree.  Its filename was
     filemap-fix-the-last_index-of-mm_filemap_get_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -2567,7 +2567,7 @@ retry:
 			goto err;
 	}
 
-	trace_mm_filemap_get_pages(mapping, index, last_index);
+	trace_mm_filemap_get_pages(mapping, index, last_index - 1);
 	return 0;
 err:
 	if (err < 0)
_

Patches currently in -mm which might be from takayas@chromium.org are



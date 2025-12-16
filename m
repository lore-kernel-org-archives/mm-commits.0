Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03EF1D90DD;
	Tue, 16 Dec 2025 03:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765855823; cv=none; b=fiMK7jsf8AyaD05iVxG2ltsisIz9dkFaQom71OPXL+q9cWjzAO2p1daxrX6eB5asw4Id7XyW/qgAOnqRTlgv17AC86vwRm3UM5xe9CgJ7FqL1XZ6r+9HuiJMkPLDBXTVpr/qgFX30ZcV6sLN4d+MWbjhYj6EGtI0vV18yowWTYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765855823; c=relaxed/simple;
	bh=ts4UgXQUSRB3DlY0oEK5TQ0Z3lJWVO3ZAGbqjy4/MbE=;
	h=Date:To:From:Subject:Message-Id; b=LIRxqB/Yted+Y5UUFOGSfecDVwX1lFkjup3kH0DY2gXT10NLmPP8qrPcOJ8cHb6IwevUao11DOi1EZhuLlmPKNWHhbux5XA+ch2F6MbchjUpnIjlh+hWvVOhZhL1RdBV9a/x3yhVMXvmJpCqqM8dZGlIJoXWfMSrYQbSCuTAUnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ya/maR3V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ya/maR3V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EBDDC4CEF5;
	Tue, 16 Dec 2025 03:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765855823;
	bh=ts4UgXQUSRB3DlY0oEK5TQ0Z3lJWVO3ZAGbqjy4/MbE=;
	h=Date:To:From:Subject:From;
	b=ya/maR3V692N7ExXT9pmPp/qxHajrq+8m3BWfhWvAqmKUz+4EJsD3NG6xxCcnvxQV
	 wmxlFvK4l4GMi+q1WYhklyDr4DFaZp/OPMKdxk6kRZzsWUvj7Bx/y/zeyxkBP6jMJs
	 YdEsuFk5MQXl2sc3KfoCWtc3YgMNBIX058115PS4=
Date: Mon, 15 Dec 2025 19:30:22 -0800
To: mm-commits@vger.kernel.org,zhaochongxi2019@email.szu.edu.cn,stable@vger.kernel.org,kaushlendra.kumar@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-mm-page_owner_sort-fix-timestamp-comparison-for-stable-sorting.patch added to mm-hotfixes-unstable branch
Message-Id: <20251216033023.3EBDDC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/mm/page_owner_sort: fix timestamp comparison for stable sorting
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     tools-mm-page_owner_sort-fix-timestamp-comparison-for-stable-sorting.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-mm-page_owner_sort-fix-timestamp-comparison-for-stable-sorting.patch

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
From: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Subject: tools/mm/page_owner_sort: fix timestamp comparison for stable sorting
Date: Tue, 9 Dec 2025 10:15:52 +0530

The ternary operator in compare_ts() returns 1 when timestamps are equal,
causing unstable sorting behavior. Replace with explicit three-way
comparison that returns 0 for equal timestamps, ensuring stable qsort
ordering and consistent output.

Link: https://lkml.kernel.org/r/20251209044552.3396468-1-kaushlendra.kumar@intel.com
Fixes: 8f9c447e2e2b ("tools/vm/page_owner_sort.c: support sorting pid and time")
Signed-off-by: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Cc: Chongxi Zhao <zhaochongxi2019@email.szu.edu.cn>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/mm/page_owner_sort.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/tools/mm/page_owner_sort.c~tools-mm-page_owner_sort-fix-timestamp-comparison-for-stable-sorting
+++ a/tools/mm/page_owner_sort.c
@@ -181,7 +181,11 @@ static int compare_ts(const void *p1, co
 {
 	const struct block_list *l1 = p1, *l2 = p2;
 
-	return l1->ts_nsec < l2->ts_nsec ? -1 : 1;
+	if (l1->ts_nsec < l2->ts_nsec)
+		return -1;
+	if (l1->ts_nsec > l2->ts_nsec)
+		return 1;
+	return 0;
 }
 
 static int compare_cull_condition(const void *p1, const void *p2)
_

Patches currently in -mm which might be from kaushlendra.kumar@intel.com are

tools-mm-page_owner_sort-fix-timestamp-comparison-for-stable-sorting.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B099E1F03C5
	for <mm-commits@vger.kernel.org>; Tue,  2 Dec 2025 16:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764693582; cv=none; b=d66RxWP4rfJuJ1LFi7NNVyl12UwSXSwXvZ82PDIth/1q68OdEPb0MZ7eP/1L7ixyz7vaRepF3wNxp4lwwBTbTddy9+nYPUTNrqS9iQWRT7ZihIvmXGyGAnTdCRyptNk7uHKPYa6XPwA0xz+ZTi3iakag3H84/6mvCzv+YfrP79E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764693582; c=relaxed/simple;
	bh=yHIWSLgqLzC7tbxQTQVa4ayK5c/BEDGDfDzz1F0SH00=;
	h=Date:To:From:Subject:Message-Id; b=duUQnZ3X9xXOiZYLg4LRVdf7aKFk8T4cvuGMoqCmlIOU11OBbyUJSP+xciMNuSulCWsbW+WygpG/+llANx8b0Y9Wdon2GfZdtsu2Ljjk70EjvEfueF3AHhG63ZIsZWcnx4Roj87XccdikmET+CtuGHdNaE504YMFAntt8xNUPlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NzAS0Mgt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NzAS0Mgt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31F25C4CEF1;
	Tue,  2 Dec 2025 16:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764693582;
	bh=yHIWSLgqLzC7tbxQTQVa4ayK5c/BEDGDfDzz1F0SH00=;
	h=Date:To:From:Subject:From;
	b=NzAS0Mgt8IA0OJ5b3UjoJ4iIaz+cDGZspdCeh1+4dVbeOyaggUSPtSQD5XaYnygbF
	 /xoPwLqoJPMFCaWrQd7exzzKCDT9hP0KIJlJcaU6Ku+u+LcqSN3jvejRDwsf/vriJS
	 N+WcfJtpjL2hp0C5D6bNe0QCeT7uytKzTvPph/m0=
Date: Tue, 02 Dec 2025 08:39:41 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,lienze@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-fix-memory-leak-of-repeat-mode-damon_call_control-objects.patch added to mm-new branch
Message-Id: <20251202163942.31F25C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: fix memory leak of repeat mode damon_call_control objects
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-fix-memory-leak-of-repeat-mode-damon_call_control-objects.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-fix-memory-leak-of-repeat-mode-damon_call_control-objects.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Enze Li <lienze@kylinos.cn>
Subject: mm/damon/core: fix memory leak of repeat mode damon_call_control objects
Date: Tue, 2 Dec 2025 16:23:40 +0800

A memory leak exists in the handling of repeat mode damon_call_control
objects by kdamond_call().  While damon_call() correctly allows multiple
repeat mode objects (with ->repeat set to true) to be added to the
per-context list, kdamond_call() incorrectly processes them.

The function moves all repeat mode objects from the context's list to a
temporary list (repeat_controls).  However, it only moves the first object
back to the context's list for future calls, leaving the remaining objects
on the temporary list where they are abandoned and leaked.

This patch fixes the leak by ensuring all repeat mode objects are properly
re-added to the context's list.

Note that the leak is not in the real world, and therefore no user is
impacted.  It is only potential for imaginaray damon_call() use cases that
do not exist in the tree for now.  In more detail, the leak happens only
when the multiple repeat mode objects are assumed to be deallocated by
kdamond_call() (damon_call_control->dealloc_on_cancel is set).  There is
no such damon_call() use cases at the moment.

Link: https://lkml.kernel.org/r/20251202082340.34178-1-lienze@kylinos.cn
Fixes: 43df7676e550 ("mm/damon/core: introduce repeat mode damon_call()")
Signed-off-by: Enze Li <lienze@kylinos.cn>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-fix-memory-leak-of-repeat-mode-damon_call_control-objects
+++ a/mm/damon/core.c
@@ -2573,13 +2573,19 @@ static void kdamond_call(struct damon_ct
 			list_add(&control->list, &repeat_controls);
 		}
 	}
-	control = list_first_entry_or_null(&repeat_controls,
-			struct damon_call_control, list);
-	if (!control || cancel)
-		return;
-	mutex_lock(&ctx->call_controls_lock);
-	list_add_tail(&control->list, &ctx->call_controls);
-	mutex_unlock(&ctx->call_controls_lock);
+	while (true) {
+		control = list_first_entry_or_null(&repeat_controls,
+				struct damon_call_control, list);
+		if (!control)
+			break;
+		/* Unlink from the repeate_controls list. */
+		list_del(&control->list);
+		if (cancel)
+			continue;
+		mutex_lock(&ctx->call_controls_lock);
+		list_add(&control->list, &ctx->call_controls);
+		mutex_unlock(&ctx->call_controls_lock);
+	}
 }
 
 /* Returns negative error code if it's not activated but should return */
_

Patches currently in -mm which might be from lienze@kylinos.cn are

mm-damon-core-fix-memory-leak-of-repeat-mode-damon_call_control-objects.patch


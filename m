Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE25A2836A6;
	Mon, 29 Jun 2026 04:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782708561; cv=none; b=tfAPGf9qUKVOqqPzmnl2cNHgaqjrqUOKUVRQnsHWsfJxT+zqLBN41FvsebgHvHMHZRUrA7GReIqGY/fdxygnufcLQGSe09WHIXaJOKubOxZbuDzChnQUTpvIWoGxpYFq7OTt3J4v5uEuiqLG9Mje9CtLB06XLR3lsM8h7cQg2ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782708561; c=relaxed/simple;
	bh=vaqLj5uI1qEAhd0ySf3UNsZn75kzED+Agu4lS3sGEH8=;
	h=Date:To:From:Subject:Message-Id; b=kmJuq+zvPuw8lHOcXAZ82synvgnXPzugPW/j2eFbwr5qALePaIBttHomcqo0QfQHeFgoK5MrbiMtWTuhW2J6etw7JQKYHARI3E6y+UDThPdaoEdxQMpEKVcNBuAAehndko8AdZcQcGZ2Cz3tWtfVwUStEIxK+wf876ojGIHdHD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FEVA3eV8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FEVA3eV8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61D131F000E9;
	Mon, 29 Jun 2026 04:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782708559;
	bh=/Hx3iATGxyzXMoThrkAom6wVZkCh+fcN2/vTNVc0Iv8=;
	h=Date:To:From:Subject;
	b=FEVA3eV8ND43wNoz0XnlS6OZvBdPQoBVPbhL5hqIxfxn1ZCBnrpBlW9R8pt/epQ5b
	 h8DofuMg+XAqcwCYex/o/MhBe16R2RqxKpdAUKf662Ir9CHsUOPq4eQ8P02yFUbY0t
	 JvgeztmAbyzEFf8JJld2XnTA+o/HsSUtoi+Ow+sA=
Date: Sun, 28 Jun 2026 21:49:18 -0700
To: mm-commits@vger.kernel.org,zenghui.yu@linux.dev,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + samples-damon-mtier-handle-damon_start-failure.patch added to mm-new branch
Message-Id: <20260629044919.61D131F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: samples/damon/mtier: handle damon_start() failure
has been added to the -mm mm-new branch.  Its filename is
     samples-damon-mtier-handle-damon_start-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/samples-damon-mtier-handle-damon_start-failure.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: SJ Park <sj@kernel.org>
Subject: samples/damon/mtier: handle damon_start() failure
Date: Sun, 28 Jun 2026 14:54:42 -0700

damon_sample_mtier_start() callers assume it will clean up resources when
it fails.  And the function does the cleanup for context buildup failures.
However, it is not doing the cleanup for damon_start() failure.

As a result, when damon_start() fails, it could leak the memory for DAMON
context.  Also, if damon_start() fails for only the second context, the
first context will indefinitely run, and avoid starting other DAMON
contexts since it is running in the exclusive mode.  Stop possibly started
DAMON context and free the contexts in case of the failure to fix the
issues.

Note that the issue can reliably be reproduced because the module calls
damon_start() in the exclusive mode.  For example,

    $ sudo damo start
    $ echo Y | sudo tee /sys/module/damon_sample_mtier/parameters/enabled
    $ sudo cat /proc/allocinfo | grep damon_new_ctx

Because the first command is running another DAMON instance, the second
command fails the damon_start() call because the new DAMON instance cannot
exclusively run.  And without this fix, by repeating the second and the
third commands above, we can show the memory consumption is only
increasing due to the leaks.  It requires the sudo permission though.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260628215447.96166-4-sj@kernel.org
Link: https://lore.kernel.org/20260608112455.274231F00893@smtp.kernel.org [1]
Fixes: 82a08bde3cf7 ("samples/damon: implement a DAMON module for memory tiering")
Signed-off-by: SJ Park <sj@kernel.org>
Reviewed-by: Zenghui Yu <zenghui.yu@linux.dev>
Cc: <stable@vger.kernel.org> # 6.16.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/damon/mtier.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/samples/damon/mtier.c~samples-damon-mtier-handle-damon_start-failure
+++ a/samples/damon/mtier.c
@@ -174,6 +174,7 @@ free_out:
 static int damon_sample_mtier_start(void)
 {
 	struct damon_ctx *ctx;
+	int err;
 
 	ctx = damon_sample_mtier_build_ctx(true);
 	if (!ctx)
@@ -185,7 +186,15 @@ static int damon_sample_mtier_start(void
 		return -ENOMEM;
 	}
 	ctxs[1] = ctx;
-	return damon_start(ctxs, 2, true);
+	err = damon_start(ctxs, 2, true);
+	if (!err)
+		return 0;
+
+	if (damon_is_running(ctxs[0]))
+		damon_stop(ctxs, 1);
+	damon_destroy_ctx(ctxs[0]);
+	damon_destroy_ctx(ctxs[1]);
+	return err;
 }
 
 static void damon_sample_mtier_stop(void)
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-fix-dir-put-orders-in-access_pattern_add_dirs.patch
mm-damon-sysfs-schemes-put-stats-for-scheme_add_dirs-internal-error.patch
mm-damon-ops-common-handle-extreme-intervals-in-damon_hot_score.patch
maintainers-s-seongjae-sj.patch
samples-damon-wsse-handle-damon_start-failure.patch
samples-damon-prcl-handle-damon_start-failure.patch
samples-damon-mtier-handle-damon_start-failure.patch
samples-damon-mtier-handle-damon_stop-failure.patch
samples-damon-wsse-stop-and-free-damon-ctx-when-damon_call-fails.patch
samples-damon-prcl-stop-and-free-damon-ctx-when-damon_call-fails.patch


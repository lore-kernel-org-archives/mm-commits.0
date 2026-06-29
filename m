Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC1731DF25C;
	Mon, 29 Jun 2026 04:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782708559; cv=none; b=HqTWCtUpOD0+Ry4GfFRsP7l/IFGbzlnKArm2VkT6G3ghfjxmQ0RD1qJDqwJOsrZcR2H62cVo+seRAsi59F5eATogTt1B+cUogSabKFZiLBXne2NbPVHEB/hn/xFXAZbA5gMhm1Ew8SXgaE4jA8+UQXVfFcziTfGqKPuJYp+BoM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782708559; c=relaxed/simple;
	bh=BxxYm59B12d/6HST7or3RbTL7ddieRv6KIS6EPrOkaw=;
	h=Date:To:From:Subject:Message-Id; b=htbfQ7QaCq4eJ6qY+OHL0ah9eAANKHJkZ6NkvhjyLj9zW4enRDGHlg80EQeln+te3q2vEHR5fbXPBNjEJXoGFAd0v97NDOEGhvIZ8HMuc2St5CNHX47BaFyQEy9F8f5KF+Jn5Elz5sfnaJrRdt/y5xe9Idfo3lYZ+hTZIsKPqD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=veQ441DW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="veQ441DW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63CB81F000E9;
	Mon, 29 Jun 2026 04:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782708557;
	bh=YC1S6Ag8kE668aA9hBNpGE0hGaB1We/NqyUhzNzZpjY=;
	h=Date:To:From:Subject;
	b=veQ441DWjV2HctqyL6HmGiqGxrrIFidVrim+H1jvQW/cOgAOYtlxj4vm4IFnj5iF4
	 u6kucibPXAdKcdfIyqNuIuJpGEDVvnYe0kkgDVacj5XtCSd9stu8VRTqsTwyFV6HF3
	 CH6EyR7XfVh0jH9h+MrIwn+nKEsSw8hrgc76ubeE=
Date: Sun, 28 Jun 2026 21:49:17 -0700
To: mm-commits@vger.kernel.org,zenghui.yu@linux.dev,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + samples-damon-prcl-handle-damon_start-failure.patch added to mm-new branch
Message-Id: <20260629044917.63CB81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: samples/damon/prcl: handle damon_start() failure
has been added to the -mm mm-new branch.  Its filename is
     samples-damon-prcl-handle-damon_start-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/samples-damon-prcl-handle-damon_start-failure.patch

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
Subject: samples/damon/prcl: handle damon_start() failure
Date: Sun, 28 Jun 2026 14:54:41 -0700

damon_sample_prcl_start() callers assume it will clean up resources when
it fails.  And the function does the cleanup for context buildup failures.
However, it is not doing the cleanup for damon_start() failure.  As a
result, when damon_start() fails, it leaks the memory for DAMON context. 
Free the context in case of the failure to fix the issues.

Note that the issue can reliably be reproduced because the module calls
damon_start() in the exclusive mode.  For example,

    $ sudo damo start
    $ echo $$ | sudo tee /sys/module/damon_sample_prcl/parameters/target_pid
    $ echo Y | sudo tee /sys/module/damon_sample_prcl/parameters/enabled
    $ sudo cat /proc/allocinfo | grep damon_new_ctx

Because the first command is running another DAMON instance, the third
command fails the damon_start() call because the new DAMON instance cannot
exclusively run.  And without this fix, by repeating the third and the
fourth commands above, we can show the memory consumption is only
increasing due to the leaks.  It requires the sudo permission though.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260628215447.96166-3-sj@kernel.org
Link: https://lore.kernel.org/20260609145814.70163-1-sj@kernel.org [1]
Fixes: 2aca254620a8 ("samples/damon: introduce a skeleton of a smaple DAMON module for proactive reclamation")
Signed-off-by: SJ Park <sj@kernel.org>
Reviewed-by: Zenghui Yu <zenghui.yu@linux.dev>
Cc: <stable@vger.kernel.org> # 6.14.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/damon/prcl.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/samples/damon/prcl.c~samples-damon-prcl-handle-damon_start-failure
+++ a/samples/damon/prcl.c
@@ -106,8 +106,10 @@ static int damon_sample_prcl_start(void)
 	damon_set_schemes(ctx, &scheme, 1);
 
 	err = damon_start(&ctx, 1, true);
-	if (err)
+	if (err) {
+		damon_destroy_ctx(ctx);
 		return err;
+	}
 
 	repeat_call_control.data = ctx;
 	return damon_call(ctx, &repeat_call_control);
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


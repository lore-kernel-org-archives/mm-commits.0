Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8322B21CC51;
	Sun, 13 Jul 2025 23:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752450115; cv=none; b=jOru0fC4kR2jmm2vUncsB8MubVwM0I+kEaDDFfILYwomYPtxRal+5GbuPlj5cOQl3U11U+DL5dDPmgVQ9uciSLY4/1q8jTHLYA48YJ6yCJlBrylfxCC9l8JZQm21HNr3xVpwmCCmxUc4fFbKe4yNWEb4nfkCUxpvpC6z6MgMess=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752450115; c=relaxed/simple;
	bh=MvrV+IDBdZGaPgZv9ofy8GlkqpB96yS67eQZboZz1TY=;
	h=Date:To:From:Subject:Message-Id; b=W/CdINBEpifuyKMxZLSoDyQcnSekjtg/FxGIIa2vq57Er+ekCgI+DX5rhvrhYzKNrZdiUO6hE3vXhtSfSWQjkNWHz5Bzh8BayxXBY5bF/S2PH24F3bOzHah4xQAdyOWjAdWPPTqpZ0dQiLzhEC4g6cw+xbrl7xWqt9Gs0fEiV/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yNJ3In8o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yNJ3In8o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 509C6C4CEE3;
	Sun, 13 Jul 2025 23:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752450115;
	bh=MvrV+IDBdZGaPgZv9ofy8GlkqpB96yS67eQZboZz1TY=;
	h=Date:To:From:Subject:From;
	b=yNJ3In8oYpy8yXzQJppn51K0CLp3L02+GyjxSez3Ww87yg6MW3Evqgy7O0W35Guc2
	 cMRbeXBDV49oSzpf1aCLVRIFt8LMIA+7Wmo08UBlQJ8LcGTXRqpizb1PeGp70z+kp2
	 mDziDs+ghvgtRJRqBb0YrCXmW3/3y5KS7xzmoTGU=
Date: Sun, 13 Jul 2025 16:41:54 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] samples-damon-wsse-fix-boot-time-enable-handling.patch removed from -mm tree
Message-Id: <20250713234155.509C6C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: samples/damon/wsse: fix boot time enable handling
has been removed from the -mm tree.  Its filename was
     samples-damon-wsse-fix-boot-time-enable-handling.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: samples/damon/wsse: fix boot time enable handling
Date: Sun, 6 Jul 2025 12:32:02 -0700

Patch series "mm/damon: fix misc bugs in DAMON modules".

From manual code review, I found below bugs in DAMON modules.

DAMON sample modules crash if those are enabled at boot time, via kernel
command line.  A similar issue was found and fixed on DAMON non-sample
modules in the past, but we didn't check that for sample modules.

DAMON non-sample modules are not setting 'enabled' parameters accordingly
when real enabling is failed.  Honggyu found and fixed[1] this type of
bugs in DAMON sample modules, and my inspection was motivated by the great
work.  Kudos to Honggyu.

Finally, DAMON_RECLIAM is mistakenly losing scheme internal status due to
misuse of damon_commit_ctx().  DAMON_LRU_SORT has a similar misuse, but
fortunately it is not causing real status loss.

Fix the bugs.  Since these are similar patterns of bugs that were found in
the past, it would be better to add tests or refactor the code, in future.


This patch (of 6):

If 'enable' parameter of the 'wsse' DAMON sample module is set at boot
time via the kernel command line, memory allocation is tried before the
slab is initialized.  As a result kernel NULL pointer dereference BUG can
happen.  Fix it by checking the initialization status.

Link: https://lkml.kernel.org/r/20250706193207.39810-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20250706193207.39810-2-sj@kernel.org
Link: https://lore.kernel.org/20250702000205.1921-1-honggyu.kim@sk.com [1]
Fixes: b757c6cfc696 ("samples/damon/wsse: start and stop DAMON as the user requests")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/damon/wsse.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/samples/damon/wsse.c~samples-damon-wsse-fix-boot-time-enable-handling
+++ a/samples/damon/wsse.c
@@ -89,6 +89,8 @@ static void damon_sample_wsse_stop(void)
 		put_pid(target_pidp);
 }
 
+static bool init_called;
+
 static int damon_sample_wsse_enable_store(
 		const char *val, const struct kernel_param *kp)
 {
@@ -114,7 +116,15 @@ static int damon_sample_wsse_enable_stor
 
 static int __init damon_sample_wsse_init(void)
 {
-	return 0;
+	int err = 0;
+
+	init_called = true;
+	if (enable) {
+		err = damon_sample_wsse_start();
+		if (err)
+			enable = false;
+	}
+	return err;
 }
 
 module_init(damon_sample_wsse_init);
_

Patches currently in -mm which might be from sj@kernel.org are

samples-damon-wsse-rename-to-have-damon_sample_-prefix.patch
samples-damon-prcl-rename-to-have-damon_sample_-prefix.patch
samples-damon-mtier-rename-to-have-damon_sample_-prefix.patch
mm-damon-sysfs-use-damon-core-api-damon_is_running.patch
mm-damon-sysfs-dont-hold-kdamond_lock-in-before_terminate.patch
docs-mm-damon-maintainer-profile-update-for-mm-new-tree.patch
mm-damon-add-struct-damos_migrate_dests.patch
mm-damon-core-add-damos-migrate_dests-field.patch
mm-damon-sysfs-schemes-implement-damos-action-destinations-directory.patch
mm-damon-sysfs-schemes-set-damos-migrate_dests.patch
docs-abi-damon-document-schemes-dests-directory.patch
docs-admin-guide-mm-damon-usage-document-dests-directory.patch
mm-damon-accept-parallel-damon_call-requests.patch
mm-damon-core-introduce-repeat-mode-damon_call.patch
mm-damon-stat-use-damon_call-repeat-mode-instead-of-damon_callback.patch
mm-damon-reclaim-use-damon_call-repeat-mode-instead-of-damon_callback.patch
mm-damon-lru_sort-use-damon_call-repeat-mode-instead-of-damon_callback.patch
samples-damon-prcl-use-damon_call-repeat-mode-instead-of-damon_callback.patch
samples-damon-wsse-use-damon_call-repeat-mode-instead-of-damon_callback.patch
mm-damon-core-do-not-call-opscleanup-when-destroying-targets.patch
mm-damon-core-add-cleanup_target-ops-callback.patch
mm-damon-vaddr-put-pid-in-cleanup_target.patch
mm-damon-sysfs-remove-damon_sysfs_destroy_targets.patch
mm-damon-core-destroy-targets-when-kdamond_fn-finish.patch
mm-damon-sysfs-remove-damon_sysfs_before_terminate.patch
mm-damon-core-remove-damon_callback.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9367D20F070
	for <mm-commits@vger.kernel.org>; Sun, 13 Jul 2025 23:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752449660; cv=none; b=PagDjXwmorz6mDQX5cQIPGUpmOvSVpZeUZNcuLum4nhRoBZiKyu+32V+WBSHQJPxRULjqDG1EUT/zCBS91K6yUqUjz1yXs6F3Pa0IwbeDlUGpPCtYn1Vw1UthHT8582SYmI9Rz9XIDNiyOtoYlKxLcjLYIz946+MSVDBqJobEP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752449660; c=relaxed/simple;
	bh=Sc+jqa/8CfQSv/RV7LWgFVSxuo5QgtAivyePA/McC+E=;
	h=Date:To:From:Subject:Message-Id; b=CksaOv0KVQAextbBiMUJiX5UQu7kx7bjGJYG9VMya1gcMD3fo25fhoKdXE72jfkKVXn0nkZurpo+xL8I24xFn6lX7jx39uGE1Sa4I4YiPWRTo4ka5Spon5SkSSumfPWK3DwVHO7ruQQXFRTGbodMvYj5W5B3HCHzA09PonjWej4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pzfiIJsW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pzfiIJsW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 097BEC4CEE3;
	Sun, 13 Jul 2025 23:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752449660;
	bh=Sc+jqa/8CfQSv/RV7LWgFVSxuo5QgtAivyePA/McC+E=;
	h=Date:To:From:Subject:From;
	b=pzfiIJsWZaB4rykblqlVVjRq2ZgNzkkOWMj+CkPEYdW5v9kbFw5o5Gdw/xKvVZpsL
	 xmYMQJSH0i62C1m9viRWCktdQvJEuv/aeHqvuNujhF1YatrWnikg/9HJDeK+8o/D/3
	 rk4t763E1csgFjfXgd6c4cbIDl+/a/OYCPkIiNKw=
Date: Sun, 13 Jul 2025 16:34:19 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lkp@intel.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-damon-add-trace-event-for-effective-size-quota-fix.patch removed from -mm tree
Message-Id: <20250713233420.097BEC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: initialize sidx in damos_trace_esz()
has been removed from the -mm tree.  Its filename was
     mm-damon-add-trace-event-for-effective-size-quota-fix.patch

This patch was dropped because it was folded into mm-damon-add-trace-event-for-effective-size-quota.patch

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: initialize sidx in damos_trace_esz()
Date: Sat, 5 Jul 2025 10:20:03 -0700

Commit ae4dc5a31d0f ("mm/damon: add trace event for effective size
quota") introduced damos_trac_esz(), which uses sidx variable without
initialization.  Initialize before using it.

Link: https://lkml.kernel.org/r/20250705172003.52324-1-sj@kernel.org
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202507051517.bs3jd8RW-lkp@intel.com/
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/core.c~mm-damon-add-trace-event-for-effective-size-quota-fix
+++ a/mm/damon/core.c
@@ -2014,7 +2014,7 @@ static void damos_set_effective_quota(st
 static void damos_trace_esz(struct damon_ctx *c, struct damos *s,
 		struct damos_quota *quota)
 {
-	unsigned int cidx = 0, sidx;
+	unsigned int cidx = 0, sidx = 0;
 	struct damos *siter;
 
 	damon_for_each_scheme(siter, c) {
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-add-drgn-script-for-extracting-damon-status.patch
selftests-damon-_damon_sysfs-set-kdamondpid-in-start.patch
selftests-damon-add-python-and-drgn-based-damon-sysfs-test.patch
selftests-damon-sysfspy-test-monitoring-attribute-parameters.patch
selftests-damon-sysfspy-test-adaptive-targets-parameter.patch
selftests-damon-sysfspy-test-damos-schemes-parameters-setup.patch
mm-damon-add-trace-event-for-auto-tuned-monitoring-intervals.patch
mm-damon-add-trace-event-for-effective-size-quota.patch
mm-damon-add-trace-event-for-effective-size-quota-fix-2.patch
samples-damon-wsse-fix-boot-time-enable-handling.patch
samples-damon-prcl-fix-boot-time-enable-crash.patch
samples-damon-mtier-support-boot-time-enable-setup.patch
mm-damon-reclaim-reset-enabled-when-damon-start-failed.patch
mm-damon-lru_sort-reset-enabled-when-damon-start-failed.patch
mm-damon-reclaim-use-parameter-context-correctly.patch
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


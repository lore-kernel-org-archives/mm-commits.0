Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8DF20F076
	for <mm-commits@vger.kernel.org>; Sun, 13 Jul 2025 23:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752449661; cv=none; b=dPAb0iDpWj4Hs5MS6nIfShQ+FmL4VJg7nqZAVtWcO2SKNlS5pM0v2XeSAty2I/M9UmDkSr2jNNpQ9+xxpdNuivqG5L3QwHdZmIoOhjq+M98EIKOjDu2sxv7XNmFYBlvC4oHnvaNojpN5EWiQmnasMT05MpItPobACpfjU/E5m5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752449661; c=relaxed/simple;
	bh=IfmLmSfKt40X55MzfyAlr/uFWZno/CMb25OStZ+ZfnQ=;
	h=Date:To:From:Subject:Message-Id; b=YR9NDG/rptnlmauhysseNk1Y7Mn/Z+4X1JB5zUFEeJrAN9fUHilJ+jUhjZ/qmin9Bz3i6tL0TidXmgDYrXGzyt4Bgzr+8U3Jm+KTLBojw7d1/LL2T97muOcdLM5F2CL/l3QNe5KzTYaYczBs9FScuKuRUHmVgGTLTqMegltMYPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wZ0PiQaZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wZ0PiQaZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4485BC4CEE3;
	Sun, 13 Jul 2025 23:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752449661;
	bh=IfmLmSfKt40X55MzfyAlr/uFWZno/CMb25OStZ+ZfnQ=;
	h=Date:To:From:Subject:From;
	b=wZ0PiQaZZBrcrDwWF6Gd8z2gMrf6A+Bm4XODC/5Ki11HCeAIEBxKJdFQB2r6FQzyk
	 itJ6+ZoiZzA2dn8ANDJOqrKL0qYcJftB20Xr/8Qy8Z9576Y4vSobFhNxNg1wvau0xf
	 R3Vz/pgtem6qHRhRwJAM4QrHjg5xmh5jCBzcechg=
Date: Sun, 13 Jul 2025 16:34:20 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lkp@intel.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-damon-add-trace-event-for-effective-size-quota-fix-2.patch removed from -mm tree
Message-Id: <20250713233421.4485BC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: make damos_esz unconditional trace event
has been removed from the -mm tree.  Its filename was
     mm-damon-add-trace-event-for-effective-size-quota-fix-2.patch

This patch was dropped because it was folded into mm-damon-add-trace-event-for-effective-size-quota.patch

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon: make damos_esz unconditional trace event
Date: Wed, 9 Jul 2025 11:22:39 -0700

It has no reason to be conditional.  Make it unconditional trace event.

Link: https://lkml.kernel.org/r/20250709182843.35812-1-sj@kernel.org
Closes: https://lore.kernel.org/20250709122123.779c874f@batman.local.home
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: Steven Rostedt <rostedt@goodmis.org>
Cc: kernel test robot <lkp@intel.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/damon.h |    8 +++-----
 mm/damon/core.c              |    2 +-
 2 files changed, 4 insertions(+), 6 deletions(-)

--- a/include/trace/events/damon.h~mm-damon-add-trace-event-for-effective-size-quota-fix-2
+++ a/include/trace/events/damon.h
@@ -9,14 +9,12 @@
 #include <linux/types.h>
 #include <linux/tracepoint.h>
 
-TRACE_EVENT_CONDITION(damos_esz,
+TRACE_EVENT(damos_esz,
 
 	TP_PROTO(unsigned int context_idx, unsigned int scheme_idx,
-		unsigned long esz, bool do_trace),
+		unsigned long esz),
 
-	TP_ARGS(context_idx, scheme_idx, esz, do_trace),
-
-	TP_CONDITION(do_trace),
+	TP_ARGS(context_idx, scheme_idx, esz),
 
 	TP_STRUCT__entry(
 		__field(unsigned int, context_idx)
--- a/mm/damon/core.c~mm-damon-add-trace-event-for-effective-size-quota-fix-2
+++ a/mm/damon/core.c
@@ -2022,7 +2022,7 @@ static void damos_trace_esz(struct damon
 			break;
 		sidx++;
 	}
-	trace_damos_esz(cidx, sidx, quota->esz, true);
+	trace_damos_esz(cidx, sidx, quota->esz);
 }
 
 static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
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


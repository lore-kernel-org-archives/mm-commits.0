Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A870F1FF1C4
	for <mm-commits@vger.kernel.org>; Wed,  9 Jul 2025 22:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752101782; cv=none; b=oKQKthwXGGxcVIeZbyaOXmQBQfRye9mO65KrICtEWnYLdFif2qw3uA3w4Mth9/lv7lVIskQ9EERDimRKcOp8vcDeBdRIj0yaibXoQlGHSIk/kzNlOCw9uSfaJ3UCefSTx4EMOfpyjmvFHHVu2YTxVgwx6W1xrO4MqBzfaEZ1YMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752101782; c=relaxed/simple;
	bh=Ufkm+Ru7lUEtC6hlxmawUOv3hcwPNF6AmMVTrOGr4Ow=;
	h=Date:To:From:Subject:Message-Id; b=e/7HYVP8QnmNFBfo8Gg+JZGR4qvIwK0KE1gK33wzFcYmBSsO+IunE7OW4Kl+AoQk38dWXy45nzAXJlHoFVjFZaIF8mTXZVTMt7W28uOByHFWN+Yw3VG1L1mYYdSo+2jIve5176MwUzL784y/3Jvo4GJO3DVAvs8o+puiTL2jbjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AsBbtY6c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AsBbtY6c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08680C4CEEF;
	Wed,  9 Jul 2025 22:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752101782;
	bh=Ufkm+Ru7lUEtC6hlxmawUOv3hcwPNF6AmMVTrOGr4Ow=;
	h=Date:To:From:Subject:From;
	b=AsBbtY6csVYhpY9KvADHjC6W1p8lc3j5cKBH4UIC5no2GV1Fcm7lushmdARH6IoEA
	 EHXRP3wJaNxwUUJg9xCUPXQdpHNzVECJfowv/JaldfkD/pYXi/hG2Ml/4+6M+6+Xhu
	 vpHWV9rDk3knv8jmqHXX2WqY7mEBM5zksfzK/7ow=
Date: Wed, 09 Jul 2025 15:56:20 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lkp@intel.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-add-trace-event-for-effective-size-quota-fix-2.patch added to mm-unstable branch
Message-Id: <20250709225622.08680C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon: make damos_esz unconditional trace event
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-add-trace-event-for-effective-size-quota-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-add-trace-event-for-effective-size-quota-fix-2.patch

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

mm-damon-core-handle-damon_call_control-as-normal-under-kdmond-deactivation.patch
mm-damon-introduce-damon_stat-module.patch
mm-damon-introduce-damon_stat-module-fix.patch
mm-damon-introduce-damon_stat-module-fix-2.patch
mm-damon-stat-calculate-and-expose-estimated-memory-bandwidth.patch
mm-damon-stat-calculate-and-expose-idle-time-percentiles.patch
docs-admin-guide-mm-damon-add-damon_stat-usage-document.patch
mm-damon-paddr-use-alloc_migartion_target-with-no-migration-fallback-nodemask.patch
revert-mm-rename-alloc_demote_folio-to-alloc_migrate_folio.patch
revert-mm-make-alloc_demote_folio-externally-invokable-for-migration.patch
selftets-damon-add-a-test-for-memcg_path-leak.patch
mm-damon-sysfs-schemes-decouple-from-damos_quota_goal_metric.patch
mm-damon-sysfs-schemes-decouple-from-damos_action.patch
mm-damon-sysfs-schemes-decouple-from-damos_wmark_metric.patch
mm-damon-sysfs-schemes-decouple-from-damos_filter_type.patch
mm-damon-sysfs-decouple-from-damon_ops_id.patch
selftests-damon-add-drgn-script-for-extracting-damon-status.patch
selftests-damon-_damon_sysfs-set-kdamondpid-in-start.patch
selftests-damon-add-python-and-drgn-based-damon-sysfs-test.patch
selftests-damon-sysfspy-test-monitoring-attribute-parameters.patch
selftests-damon-sysfspy-test-adaptive-targets-parameter.patch
selftests-damon-sysfspy-test-damos-schemes-parameters-setup.patch
mm-damon-add-trace-event-for-auto-tuned-monitoring-intervals.patch
mm-damon-add-trace-event-for-effective-size-quota.patch
mm-damon-add-trace-event-for-effective-size-quota-fix.patch
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


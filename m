Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB3C1A2541
	for <mm-commits@vger.kernel.org>; Thu, 17 Jul 2025 23:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752793947; cv=none; b=mPWygtZwbUSBbKeoEY9QYorUdFsisfYyZFarvh9xYjIQnyAYh9fIAMnTzlWTd3uidZZo4RpHf3W/DN5tJ48RNPgsuhQ2O61HMSRBzFCTh1un1XjbnI+C+rgkHmfHFaJYK3rq5fGhk5wWb6mOPS+77+D03f8LYm9z2g1T/0rxMgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752793947; c=relaxed/simple;
	bh=2AvIngWSA//h0ux6Xh4T9SrRjiu3r8uiL5679Bt8CTs=;
	h=Date:To:From:Subject:Message-Id; b=fAbh6jMjyeHcgSyKBAec3P4KGlLyKc9xb6N+LNLx3YYBwkWLi5pZEqTi+yRbUSGCpeeM2DGAfOMRt12SCJNwMSZCkHYytsTtqvo62dQwRQPTTypbPnci9tUCZeirmgTscLYCj45EmsFBoi2nKS0MvKzjQlSeN3j1fVdGhe4I+nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M1gXWRhg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M1gXWRhg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44A2EC4CEE3;
	Thu, 17 Jul 2025 23:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752793947;
	bh=2AvIngWSA//h0ux6Xh4T9SrRjiu3r8uiL5679Bt8CTs=;
	h=Date:To:From:Subject:From;
	b=M1gXWRhgdJfxAlfCfGCTDmUBR1rBFSmIHpW5LYlR3h4rz5y/Uz8fofyD6mTuNz72O
	 PmSjt2wGx9dJeq2XC6ZHVdTnyT8PBcVmCKMLYUbj9c6GuGuwWnOhxnl9mCdoTFhCmb
	 TmD77r7JGGia3tq+Jw825clEG0otLB709TImYgT4=
Date: Thu, 17 Jul 2025 16:12:26 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-implement-refresh_ms-file-under-kdamond-directory.patch added to mm-new branch
Message-Id: <20250717231227.44A2EC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs: implement refresh_ms file under kdamond directory
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-sysfs-implement-refresh_ms-file-under-kdamond-directory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-implement-refresh_ms-file-under-kdamond-directory.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs: implement refresh_ms file under kdamond directory
Date: Wed, 16 Jul 2025 22:54:45 -0700

Patch series "mm/damon/sysfs: support periodic and automated stats
update".

DAMON sysfs interface provides files for reading DAMON internal status
including auto-tuned monitoring intervals, DAMOS stats, DAMOS action
applied regions, and auto-tuned DAMOS effective quota.  Among those,
auto-tuned monitoring intervals, DAMOS stats and auto-tuned DAMOS
effective quota are essential for common DAMON/S use cases.

The content of the files are not automatically updated, though.  Users
should manually request updates of the contents by writing a special
command to 'state' file of each kdamond directory.  This interface is good
for minimizing overhead, but causes the below problems.

First, the usage is cumbersome.  This is arguably not a big problem, since
the user-space tool (damo) can do this instead of the user.

Second, it can be too slow.  The update request is not directly handled by
the sysfs interface but kdamond thread.  And kdamond threads wake up only
once per the sampling interval.  Hence if sampling interval is not short,
each update request could take too long time.  The recommended sampling
interval setup is asking DAMON to automatically tune it, within a range
between 5 milliseconds and 10 seconds.  On production systems it is not
very rare to have a few seconds sampling interval as a result of the
auto-tuning, so this can disturb observing DAMON internal status.

Finally, parallel update requests can conflict with each other.  When
parallel update requests are received, DAMON sysfs interface simply
returns -EBUSY to one of the requests.  DAMON user-space tool is hence
implementing its own backoff mechanism, but this can make the operation
even slower.

Introduce a new sysfs file, namely refresh_ms, for asking DAMON sysfs
interface to repeat the update of the above mentioned essential contents
with a user-specified time delay.  If non-zero value is written to the
file, DAMON sysfs interface does the updates for essential DAMON internal
status including auto-tuned monitoring intervals, DAMOS stats, and
auto-tuned DAMOS quotas using the user-written value as the time delay. 
In other words, it is similar to periodically writing
'update_schemes_stats', 'update_schemes_effective_quotas', and
'update_tuned_intervals' keywords to the 'state' file.  If zero is written
to the file, the automatic refresh is disabled.


This patch (of 4):

Implement a new DAMON sysfs file named 'refresh_ms' under each kdamond
directory.  The file will be used as a control knob of automatic refresh
of a few DAMON internal status files.  This commit implements only minimum
file operations, though.  The automatic refresh feature will be
implemented by the following commit.

Link: https://lkml.kernel.org/r/20250717055448.56976-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20250717055448.56976-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-implement-refresh_ms-file-under-kdamond-directory
+++ a/mm/damon/sysfs.c
@@ -1155,6 +1155,7 @@ struct damon_sysfs_kdamond {
 	struct kobject kobj;
 	struct damon_sysfs_contexts *contexts;
 	struct damon_ctx *damon_ctx;
+	unsigned int refresh_ms;
 };
 
 static struct damon_sysfs_kdamond *damon_sysfs_kdamond_alloc(void)
@@ -1690,6 +1691,30 @@ out:
 	return sysfs_emit(buf, "%d\n", pid);
 }
 
+static ssize_t refresh_ms_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_kdamond *kdamond = container_of(kobj,
+			struct damon_sysfs_kdamond, kobj);
+
+	return sysfs_emit(buf, "%u\n", kdamond->refresh_ms);
+}
+
+static ssize_t refresh_ms_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_kdamond *kdamond = container_of(kobj,
+			struct damon_sysfs_kdamond, kobj);
+	unsigned int nr;
+	int err = kstrtouint(buf, 0, &nr);
+
+	if (err)
+		return err;
+
+	kdamond->refresh_ms = nr;
+	return count;
+}
+
 static void damon_sysfs_kdamond_release(struct kobject *kobj)
 {
 	struct damon_sysfs_kdamond *kdamond = container_of(kobj,
@@ -1706,9 +1731,13 @@ static struct kobj_attribute damon_sysfs
 static struct kobj_attribute damon_sysfs_kdamond_pid_attr =
 		__ATTR_RO_MODE(pid, 0400);
 
+static struct kobj_attribute damon_sysfs_kdamond_refresh_ms_attr =
+		__ATTR_RW_MODE(refresh_ms, 0600);
+
 static struct attribute *damon_sysfs_kdamond_attrs[] = {
 	&damon_sysfs_kdamond_state_attr.attr,
 	&damon_sysfs_kdamond_pid_attr.attr,
+	&damon_sysfs_kdamond_refresh_ms_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_kdamond);
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
mm-damon-core-add-cleanup_target-ops-callback-fix.patch
mm-damon-core-add-cleanup_target-ops-callback-fix-2.patch
mm-damon-vaddr-put-pid-in-cleanup_target.patch
mm-damon-sysfs-remove-damon_sysfs_destroy_targets.patch
mm-damon-core-destroy-targets-when-kdamond_fn-finish.patch
mm-damon-sysfs-remove-damon_sysfs_before_terminate.patch
mm-damon-core-remove-damon_callback.patch
mm-damon-sysfs-implement-refresh_ms-file-under-kdamond-directory.patch
mm-damon-sysfs-implement-refresh_ms-file-internal-work.patch
docs-admin-guide-mm-damon-usage-document-refresh_ms-file.patch
docs-abi-damon-update-for-refresh_ms.patch


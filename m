Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37FAA214232
	for <mm-commits@vger.kernel.org>; Fri, 25 Jul 2025 02:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753409687; cv=none; b=SfiTiXd2zoR6Hab+GWIJJ+mpxtUX5W24b6LqhkWCSM/vWK80L0n72cqx/R3X/1Wcfrj99MhFMoPQmApYfEibaRDSF5hU+wuifVhvfll0gDePOf5ioG14NhmJ9aEKESaop6MRbQQMWsJvWIVHshywFKjtXFuFadIfAVnmdIYuZR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753409687; c=relaxed/simple;
	bh=bmStH3SOQrReigu/ys+ZTro/XHr2Z14KVNxNJzAVB9o=;
	h=Date:To:From:Subject:Message-Id; b=EUaZ65Q54Qm7vUQ3iAyNuFtVf3upeOBYf1nNh2uJ7wkY7oZk2XLbNm0Ro5XQWUcoXskXDBJlIZz4lCFzO5t6u4SFmmjIuwwb+zLuvWV2AnEyL/SXHdxl9oM0btBiQ9D5wbiNm2NrvUkFP5S1Hwb/h9fOliH34vYhmY/MG5o6dyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Wijri+9l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Wijri+9l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AE3BC4CEED;
	Fri, 25 Jul 2025 02:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753409687;
	bh=bmStH3SOQrReigu/ys+ZTro/XHr2Z14KVNxNJzAVB9o=;
	h=Date:To:From:Subject:From;
	b=Wijri+9l08PpCRmZIFQGRmo6eOVtpPJa8BeDI5NW2cXmv1vVS9wV/7ItIpTDxlYzm
	 2vwGEk1EJRoFSvz8Z/WXQLNPhjGxglRInI3ydmJEKWMgU4Eo7hODyTZI0kbv20dh5O
	 GlJjaLDEVrHVHda3pCo5exiWqBloqniMTDyeY/U0=
Date: Thu, 24 Jul 2025 19:14:46 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-implement-refresh_ms-file-under-kdamond-directory.patch removed from -mm tree
Message-Id: <20250725021447.0AE3BC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs: implement refresh_ms file under kdamond directory
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-implement-refresh_ms-file-under-kdamond-directory.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

selftests-damon-sysfspy-stop-damon-for-dumping-failures.patch
selftests-damon-_damon_sysfs-support-damos-watermarks-setup.patch
selftests-damon-_damon_sysfs-support-damos-filters-setup.patch
selftests-damon-_damon_sysfs-support-monitoring-intervals-goal-setup.patch
selftests-damon-_damon_sysfs-support-damos-quota-weights-setup.patch
selftests-damon-_damon_sysfs-support-damos-quota-goal-nid-setup.patch
selftests-damon-_damon_sysfs-support-damos-action-dests-setup.patch
selftests-damon-_damon_sysfs-support-damos-target_nid-setup.patch
selftests-damon-_damon_sysfs-use-232-1-as-max-nr_accesses-and-age.patch
selftests-damon-drgn_dump_damon_status-dump-damos-migrate_dests.patch
selftests-damon-drgn_dump_damon_status-dump-ctx-opsid.patch
selftests-damon-drgn_dump_damon_status-dump-damos-filters.patch
selftests-damon-sysfspy-generalize-damos-watermarks-commit-assertion.patch
selftests-damon-sysfspy-generalize-damosquota-commit-assertion.patch
selftests-damon-sysfspy-test-quota-goal-commitment.patch
selftests-damon-sysfspy-test-damos-destinations-commitment.patch
selftests-damon-sysfspy-generalize-damos-scheme-commit-assertion.patch
selftests-damon-sysfspy-test-damos-filters-commitment.patch
selftests-damon-sysfspy-generalize-damos-schemes-commit-assertion.patch
selftests-damon-sysfspy-generalize-monitoring-attributes-commit-assertion.patch
selftests-damon-sysfspy-generalize-damon-context-commit-assertion.patch
selftests-damon-sysfspy-test-non-default-parameters-runtime-commit.patch
selftests-damon-sysfspy-test-runtime-reduction-of-damon-parameters.patch


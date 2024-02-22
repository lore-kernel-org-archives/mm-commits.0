Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42C8A15A8
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560135; cv=none; b=TxtNkFsteQ0mVGDWvgvNS/yeG9EynF7nC0AmazLH+8ERKHjmXMju9dItM3Iw9n0MFFpYtw+asm6iXSiYhmcP4vUKbjlDdzlp+o+yZVxxCLwnyFAa045AESZMYnyy2ETgZCNKqhWy+9SY+VEcAlLce/RerGss3ULCKKFe0QHe3RY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560135; c=relaxed/simple;
	bh=vJx+sBr6QFfthg675UABg3jQYD2Q+y/XxyH/I+F9NsM=;
	h=Date:To:From:Subject:Message-Id; b=KkmWaPHjVk9801hX56lkpIZQfK4niPb98lIObyPRVjVX+51Pn8d9r79xAAjxiMpg40EnSUF8pMkdAZYHJD42C0mhm5DGRckuLr3kE8a2HwZAODBp+LBZ6vWHWrD9Aatj1ICbBV79YY6JLRIXqHF44jV8+gPZhU5H/vajPHAUlkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hSm29IvH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hSm29IvH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C7FC433C7;
	Thu, 22 Feb 2024 00:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560134;
	bh=vJx+sBr6QFfthg675UABg3jQYD2Q+y/XxyH/I+F9NsM=;
	h=Date:To:From:Subject:From;
	b=hSm29IvH480KUfQTtUFEz4QwVfpNpyvaxSeB4rIpQxUyiE4UsFPFQKzWTMovYe3qC
	 2gU2RfCAoQU+AKIAfMT0iHyB+YLJ/5TerXKnQbKF3PpjUqp1peGe743UBAWqb4/ipr
	 FK8aNWoyyOtYKZK3i820S8raZ8AjDUoAMt4MKm0M=
Date: Wed, 21 Feb 2024 16:02:14 -0800
To: mm-commits@vger.kernel.org,siyanteng@loongson.cn,shuah@kernel.org,corbet@lwn.net,alexs@kernel.org,2023002089@link.tyut.edu.cn,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftets-damon-prepare-for-monitor_on-file-renaming.patch removed from -mm tree
Message-Id: <20240222000214.D6C7FC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftets/damon: prepare for monitor_on file renaming
has been removed from the -mm tree.  Its filename was
     selftets-damon-prepare-for-monitor_on-file-renaming.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftets/damon: prepare for monitor_on file renaming
Date: Mon, 29 Jan 2024 17:35:45 -0800

Following change will rename 'monitor_on' DAMON debugfs file to
'monitor_on_DEPRECATED', to make the deprecation unignorable in runtime. 
Since it could make DAMON selftests fail and disturb future bisects,
update DAMON selftests to support the change.

Link: https://lkml.kernel.org/r/20240130013549.89538-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Alex Shi <alexs@kernel.org>
Cc: Hu Haowen <2023002089@link.tyut.edu.cn>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Yanteng Si <siyanteng@loongson.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/_chk_dependency.sh       |   11 +++++++--
 tools/testing/selftests/damon/_debugfs_common.sh       |    7 +++++
 tools/testing/selftests/damon/debugfs_empty_targets.sh |   12 ++++++++--
 3 files changed, 26 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/damon/_chk_dependency.sh~selftets-damon-prepare-for-monitor_on-file-renaming
+++ a/tools/testing/selftests/damon/_chk_dependency.sh
@@ -18,7 +18,14 @@ then
 	exit $ksft_skip
 fi
 
-for f in attrs target_ids monitor_on
+if [ -f "$DBGFS/monitor_on_DEPRECATED" ]
+then
+	monitor_on_file="monitor_on_DEPRECATED"
+else
+	monitor_on_file="monitor_on"
+fi
+
+for f in attrs target_ids "$monitor_on_file"
 do
 	if [ ! -f "$DBGFS/$f" ]
 	then
@@ -28,7 +35,7 @@ do
 done
 
 permission_error="Operation not permitted"
-for f in attrs target_ids monitor_on
+for f in attrs target_ids "$monitor_on_file"
 do
 	status=$( cat "$DBGFS/$f" 2>&1 )
 	if [ "${status#*$permission_error}" != "$status" ]; then
--- a/tools/testing/selftests/damon/_debugfs_common.sh~selftets-damon-prepare-for-monitor_on-file-renaming
+++ a/tools/testing/selftests/damon/_debugfs_common.sh
@@ -45,6 +45,13 @@ test_content() {
 source ./_chk_dependency.sh
 
 damon_onoff="$DBGFS/monitor_on"
+if [ -f "$DBGFS/monitor_on_DEPRECATED" ]
+then
+	damon_onoff="$DBGFS/monitor_on_DEPRECATED"
+else
+	damon_onoff="$DBGFS/monitor_on"
+fi
+
 if [ $(cat "$damon_onoff") = "on" ]
 then
 	echo "monitoring is on"
--- a/tools/testing/selftests/damon/debugfs_empty_targets.sh~selftets-damon-prepare-for-monitor_on-file-renaming
+++ a/tools/testing/selftests/damon/debugfs_empty_targets.sh
@@ -8,6 +8,14 @@ source _debugfs_common.sh
 
 orig_target_ids=$(cat "$DBGFS/target_ids")
 echo "" > "$DBGFS/target_ids"
-orig_monitor_on=$(cat "$DBGFS/monitor_on")
-test_write_fail "$DBGFS/monitor_on" "on" "orig_monitor_on" "empty target ids"
+
+if [ -f "$DBGFS/monitor_on_DEPRECATED" ]
+then
+	monitor_on_file="$DBGFS/monitor_on_DEPRECATED"
+else
+	monitor_on_file="$DBGFS/monitor_on"
+fi
+
+orig_monitor_on=$(cat "$monitor_on_file")
+test_write_fail "$monitor_on_file" "on" "orig_monitor_on" "empty target ids"
 echo "$orig_target_ids" > "$DBGFS/target_ids"
_

Patches currently in -mm which might be from sj@kernel.org are

docs-mm-damon-maintainer-profile-fix-reference-links-for-mm-stable-tree.patch
docs-mm-damon-move-the-list-of-damos-actions-to-design-doc.patch
docs-mm-damon-move-damon-operation-sets-list-from-the-usage-to-the-design-document.patch
docs-mm-damon-move-damon-operation-sets-list-from-the-usage-to-the-design-document-fix.patch
docs-mm-damon-move-monitoring-target-regions-setup-detail-from-the-usage-to-the-design-document.patch
docs-admin-guide-mm-damon-usage-fix-wrong-quotas-diabling-condition.patch
mm-damon-core-set-damos_quota-esz-as-public-field-and-document.patch
mm-damon-sysfs-schemes-implement-quota-effective_bytes-file.patch
mm-damon-sysfs-implement-a-kdamond-command-for-updating-schemes-effective-quotas.patch
docs-abi-damon-document-effective_bytes-sysfs-file.patch
docs-admin-guide-mm-damon-usage-document-effective_bytes-file.patch
mm-damon-move-comments-and-fields-for-damos-quota-prioritization-to-the-end.patch
mm-damon-core-split-out-quota-goal-related-fields-to-a-struct.patch
mm-damon-core-add-multiple-goals-per-damos_quota-and-helpers-for-those.patch
mm-damon-sysfs-use-only-quota-goals.patch
mm-damon-core-remove-goal-field-of-damos_quota.patch
mm-damon-core-let-goal-specified-with-only-target-and-current-values.patch
mm-damon-core-support-multiple-metrics-for-quota-goal.patch
mm-damon-core-implement-psi-metric-damos-quota-goal.patch
mm-damon-sysfs-schemes-support-psi-based-quota-auto-tune.patch
docs-mm-damon-design-document-quota-goal-self-tuning.patch
docs-abi-damon-document-quota-goal-metric-file.patch
docs-admin-guide-mm-damon-usage-document-quota-goal-metric-file.patch
docs-admin-guide-mm-damon-usage-document-quota-goal-metric-file-fix.patch
mm-damon-reclaim-implement-user-feedback-driven-quota-auto-tuning.patch
mm-damon-reclaim-implement-memory-psi-driven-quota-self-tuning.patch
docs-admin-guide-mm-damon-reclaim-document-auto-tuning-parameters.patch


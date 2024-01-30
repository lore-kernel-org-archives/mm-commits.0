Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFAF751C5D
	for <mm-commits@vger.kernel.org>; Tue, 30 Jan 2024 06:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706597165; cv=none; b=bE+W6hvjwE5cHglzfpADj9HRu8E++89/JY/xrTegZjukCaMgx3Ysi4F7DcicZgFrBCZvC23Jc2cfc08R6F+qY7hYHJ2RLiI/Sw7N3QuvS0b9qzfF1HanpB3ZfgAgBLdRMT4Ts+5DDSJo0dt3R+e6klRcu9QERovPqqWZD+B28rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706597165; c=relaxed/simple;
	bh=WxX9Z+5elXc1Cj14CO6LmrDemawnhEMAyT8AKuA+9as=;
	h=Date:To:From:Subject:Message-Id; b=iIKijmrgsReimraCvJbXCFNer5vCHC5UYDwS+dsoCVeV6qBrtZj5kZLqfaZIZVy+cEJLeA4Gi52tAOGbRl0WRp0KfkLOisnifgp1maOFSAH8B2swLeBts1GCASM75DbpiNeyoH/I/88ZkBFA3WlqO0lb+uaDwZ+PJQrvIMHkLnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pdt0703E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pdt0703E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A0A5C433C7;
	Tue, 30 Jan 2024 06:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706597164;
	bh=WxX9Z+5elXc1Cj14CO6LmrDemawnhEMAyT8AKuA+9as=;
	h=Date:To:From:Subject:From;
	b=pdt0703ETQ+MeUptqvnl3mjH/ilGxwAFt58IFM6lZXMBLmpl2Tlur3Ys8VbVew+Gf
	 95eecpFmjiZH54A2kzGdfrorGMcjQEQ1bUpqT0ZIvmqs3IA8Z5ndzwP84I8+d7+GXa
	 DNi6itjCYLkWqT3G8WVtocnKPAlgQ0fOphONFEeo=
Date: Mon, 29 Jan 2024 22:45:51 -0800
To: mm-commits@vger.kernel.org,siyanteng@loongson.cn,shuah@kernel.org,corbet@lwn.net,alexs@kernel.org,2023002089@link.tyut.edu.cn,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftets-damon-prepare-for-monitor_on-file-renaming.patch added to mm-unstable branch
Message-Id: <20240130064603.4A0A5C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftets/damon: prepare for monitor_on file renaming
has been added to the -mm mm-unstable branch.  Its filename is
     selftets-damon-prepare-for-monitor_on-file-renaming.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftets-damon-prepare-for-monitor_on-file-renaming.patch

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

docs-admin-guide-mm-damon-usage-use-sysfs-interface-for-tracepoints-example.patch
mm-damon-rename-config_damon_dbgfs-to-damon_dbgfs_deprecated.patch
mm-damon-dbgfs-implement-deprecation-notice-file.patch
mm-damon-dbgfs-make-debugfs-interface-deprecation-message-a-macro.patch
docs-admin-guide-mm-damon-usage-document-deprecated-file-of-damon-debugfs-interface.patch
selftets-damon-prepare-for-monitor_on-file-renaming.patch
mm-damon-dbgfs-rename-monitor_on-file-to-monitor_on_deprecated.patch
docs-admin-guide-mm-damon-usage-update-for-monitor_on-renaming.patch
docs-translations-damon-usage-update-for-monitor_on-renaming.patch


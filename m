Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CCCF11717
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560211; cv=none; b=fAvKCWQ+838DP9RWXpa5JwnS+2U76JfQvsmbkWDL3RxcrB/UjdGwTBT7+RI40Fjj/kGcrtwwIHBf1prIRDoe706vrg+C60dg1P9N9KrBzyIiPrMbuNVS/a8nLRoFp2p+r5EcHB5oydKVfn7+jb/pq+h81fx+TnY91i790JpdBQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560211; c=relaxed/simple;
	bh=qCYFHWr2nSk3j+MFGdnlGZbi3wr3qABQvDId8gQzHrQ=;
	h=Date:To:From:Subject:Message-Id; b=aVX7g3TzdF3zuKChnNwNL7JTlUOewAQGMyQkoNhD1krWjMbKeKkIiBJs2HsRyL720lra8Tf8V7OfFSGr8VoKFulakuJm5H4FRHedwYLidKIoPnAK6KQnvepRf32gr9btmY5gBJnXiGLzs3RqpqaCzx401AgKlz2luqmJ+W7wLVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VkLAEQKi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VkLAEQKi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D53F1C433C7;
	Thu, 22 Feb 2024 00:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560210;
	bh=qCYFHWr2nSk3j+MFGdnlGZbi3wr3qABQvDId8gQzHrQ=;
	h=Date:To:From:Subject:From;
	b=VkLAEQKiSWuImELPkl0M3AtK1gZ8vkcS9OJi1Kx1chTWzQlhtfID+rtvmbVD854ME
	 dGwu5rfiJgZXucMVN/UYSI4dF3sZFaCXdXcE6O7ubO2dmmBt2bsoxOIlluZalGUMzo
	 zZj9xjm8hoqo3nFw4eRkrZmp7nntgp1kpo3kSL/s=
Date: Wed, 21 Feb 2024 16:03:30 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-_chk_dependency-get-debugfs-mount-point-from-proc-mounts.patch removed from -mm tree
Message-Id: <20240222000330.D53F1C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/_chk_dependency: get debugfs mount point from /proc/mounts
has been removed from the -mm tree.  Its filename was
     selftests-damon-_chk_dependency-get-debugfs-mount-point-from-proc-mounts.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/_chk_dependency: get debugfs mount point from /proc/mounts
Date: Wed, 7 Feb 2024 12:31:34 -0800

DAMON debugfs selftests dependency checker assumes debugfs would be
mounted at /sys/kernel/debug.  That would be ok for many cases, but some
systems might mounted the file system on some different places.  Parse the
real mount point using /proc/mounts file.

Link: https://lkml.kernel.org/r/20240207203134.69976-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/_chk_dependency.sh |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/damon/_chk_dependency.sh~selftests-damon-_chk_dependency-get-debugfs-mount-point-from-proc-mounts
+++ a/tools/testing/selftests/damon/_chk_dependency.sh
@@ -4,7 +4,14 @@
 # Kselftest framework requirement - SKIP code is 4.
 ksft_skip=4
 
-DBGFS=/sys/kernel/debug/damon
+DBGFS=$(grep debugfs /proc/mounts --max-count 1 | awk '{print $2}')
+if [ "$DBGFS" = "" ]
+then
+	echo "debugfs not mounted"
+	exit $ksft_skip
+fi
+
+DBGFS+="/damon"
 
 if [ $EUID -ne 0 ];
 then
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


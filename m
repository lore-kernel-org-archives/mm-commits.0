Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1042063F0
	for <mm-commits@vger.kernel.org>; Fri, 25 Jul 2025 02:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753409690; cv=none; b=h3brGQxzKNdrFfuXV9WRfr+sSW4/JcqBzAUu8fXVC1X3Llo0Age49Ie5D0Itt1bhAhROv4p+ZASisRFDKzh58ifur/Aqye2cGthNnteHaNhO9ttaS3nRwft+CA2+MwxlE0cwUvQA1RkjudQxMzqVyPI+8bsXtH3LwEpT9Q79BYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753409690; c=relaxed/simple;
	bh=0o4MbOZjoZuhWKtS/DmMFmTtSRQrN+LcaJWXIwi23/o=;
	h=Date:To:From:Subject:Message-Id; b=gWdn1SdNB38TgI/LWq+hZwdPH/FiAw0LCy4BPhg1O7JqfZ0i1FGr9HQcqBwz+OhpJR2E4aegaHklao+sPSp2F/CwOAK6bATu6BFPw0ANAzGdlqc1H7YtLEgb2w3s/EvylX85G5/PZSASTPaIm6whuBI1jq9hz4ANnbF/fOD9UWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RLUV8TP9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RLUV8TP9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E438C4CEED;
	Fri, 25 Jul 2025 02:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753409690;
	bh=0o4MbOZjoZuhWKtS/DmMFmTtSRQrN+LcaJWXIwi23/o=;
	h=Date:To:From:Subject:From;
	b=RLUV8TP9nJZMhKbE5df59xvIqARXZ668deqQjka6Eem2+AKzIVum5FTTvVGXVFt/j
	 xzfCZEnEzW/g0AFXzkW/J6yd+NQR+fgOtHDc5ddls4KsdbgVPITBG3UrFFDCiSlR6M
	 xWGrUP9T7t+b1zgC0jwbLbGKk+9XColeUrNnoYRg=
Date: Thu, 24 Jul 2025 19:14:49 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-abi-damon-update-for-refresh_ms.patch removed from -mm tree
Message-Id: <20250725021450.3E438C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/ABI/damon: update for refresh_ms
has been removed from the -mm tree.  Its filename was
     docs-abi-damon-update-for-refresh_ms.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/ABI/damon: update for refresh_ms
Date: Wed, 16 Jul 2025 22:54:48 -0700

Document the new DAMON sysfs file, refresh_ms, on the ABI document.

Link: https://lkml.kernel.org/r/20250717055448.56976-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-damon |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon~docs-abi-damon-update-for-refresh_ms
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -44,6 +44,13 @@ Contact:	SeongJae Park <sj@kernel.org>
 Description:	Reading this file returns the pid of the kdamond if it is
 		running.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/refresh_ms
+Date:		Jul 2025
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing a value to this file sets the time interval for
+		automatic DAMON status file contents update.  Writing '0'
+		disables the update.  Reading this file returns the value.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/nr_contexts
 Date:		Mar 2022
 Contact:	SeongJae Park <sj@kernel.org>
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


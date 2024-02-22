Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF884685
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560130; cv=none; b=iy4nwzw+ISIf6w/S1G4GshMcz5PmXd4O+NKE+X45V8l0K1XfWac4D/GKk/ELJ8GlJOVJH/XGFcAljTh04C95dMSlb3NGMFyHn9vlTSmOu5ivmQrCouREDyqlg1tG6V8aPV5SoqTYODwY92hK+rPLJhj0GxPPoMRSq9i59avwtU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560130; c=relaxed/simple;
	bh=gVgg5PJQQPyIN6IT1qNEMAT34+a0RVF9So0/u+G5uYY=;
	h=Date:To:From:Subject:Message-Id; b=KoU/8gwy6/Zxm8wmX6Uecvxrr0+eu4w8uejjAhF86kcuAkpiE2wPRXnkwrA1bu/49EshKPzKVvGgsQkEB9utYR6qfLmwTtmOilYVv5gyEYyBWNs8KZPCi3Od2jhYHS4/riNhSEIml/sY6onTaXBx4dJm/RMfo8BuruSF9wBLUyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rTbc0QFC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rTbc0QFC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64551C43390;
	Thu, 22 Feb 2024 00:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560130;
	bh=gVgg5PJQQPyIN6IT1qNEMAT34+a0RVF9So0/u+G5uYY=;
	h=Date:To:From:Subject:From;
	b=rTbc0QFCr2Gi2342KQzjB/gGGtV/OI82evujgvVQM1jJeFumDds/G1wQncGTNsOn+
	 IRteScc5lSoDFjmAhcOfjJPU/R1WOXr7J6yhx6dEn8sLe4tDYcu7SW1QB+WEeTZlLZ
	 VbAyG363e48T+nvNVly3rISgBiOSrVBejBOhb1q8=
Date: Wed, 21 Feb 2024 16:02:09 -0800
To: mm-commits@vger.kernel.org,siyanteng@loongson.cn,shuah@kernel.org,corbet@lwn.net,alexs@kernel.org,2023002089@link.tyut.edu.cn,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-usage-use-sysfs-interface-for-tracepoints-example.patch removed from -mm tree
Message-Id: <20240222000210.64551C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/usage: use sysfs interface for tracepoints example
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-use-sysfs-interface-for-tracepoints-example.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/usage: use sysfs interface for tracepoints example
Date: Mon, 29 Jan 2024 17:35:40 -0800

Patch series "mm/damon: make DAMON debugfs interface deprecation
unignorable".

DAMON debugfs interface is deprecated in February 2023, by commit
5445fcbc4cda ("Docs/admin-guide/mm/damon/usage: add DAMON debugfs
interface deprecation notice").  Make the fact unable to be easily ignored
by removing an example usage from the document (patch 1), renaming the
config (patch 2), adding a deprecation notice file to the debugfs
directory (patches 3-5), and renaming the debugfs file that essnetial to
be used for real use of DAMON (patches 6-9).


This patch (of 9):

DAMON tracepoints example on the DAMON usage document is using DAMON
debugfs interface, which is deprecated.  Use its alternative, DAMON sysfs
interface.

Link: https://lkml.kernel.org/r/20240130013549.89538-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20240130013549.89538-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Alex Shi <alexs@kernel.org>
Cc: Hu Haowen <2023002089@link.tyut.edu.cn>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Yanteng Si <siyanteng@loongson.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-use-sysfs-interface-for-tracepoints-example
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -579,11 +579,11 @@ monitoring results recording.
 While the monitoring is turned on, you could record the tracepoint events and
 show results using tracepoint supporting tools like ``perf``.  For example::
 
-    # echo on > monitor_on
+    # echo on > kdamonds/0/state
     # perf record -e damon:damon_aggregated &
     # sleep 5
     # kill 9 $(pidof perf)
-    # echo off > monitor_on
+    # echo off > kdamonds/0/state
     # perf script
     kdamond.0 46568 [027] 79357.842179: damon:damon_aggregated: target_id=0 nr_regions=11 122509119488-135708762112: 0 864
     [...]
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


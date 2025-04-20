Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E321C7014
	for <mm-commits@vger.kernel.org>; Sun, 20 Apr 2025 20:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745180737; cv=none; b=FEQ5y27oHbw9suAxVuiHXHjE1u8pP/0pYSMSb0aNAl4ONre/vem6u1Eh1/cQPnDcir3zdKGJ3RjjaG2xg4IcqCfdARUHuaiQoXGsSYhNg4C1pf7uoRFZ4wpxCymlmDOWLEgp1PG3TAy2Zq6vbsUKOzqzdlj9ieXUSjS0/30XVQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745180737; c=relaxed/simple;
	bh=pDBK3rG4iYQ5A53+dxNKSq/NOyLzhoMJJH13HbHmHOQ=;
	h=Date:To:From:Subject:Message-Id; b=bJ1oebS35apXFnuQr0KHAHOyUDDqZvbjW8MRCxddryAHZm822HTT/BgKkNqzAP8OtqomSjpeJ0mY8+YdRbQ0BDVZUAOhJf2nyXhP8KxgdexlZCb5eLcRardJ5Rhq3Fh00pR3txUZ9euN2SGC/ZlAE1uhdwyKkKIZtmIuAV3UCJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cS8Azpwk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cS8Azpwk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5210C4CEE2;
	Sun, 20 Apr 2025 20:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745180736;
	bh=pDBK3rG4iYQ5A53+dxNKSq/NOyLzhoMJJH13HbHmHOQ=;
	h=Date:To:From:Subject:From;
	b=cS8Azpwkx5ECT4ujOSvmWkYdG3zUyA2QfGaRyihZfH272DxfKOjpezp7VrgAkWfph
	 7h0hJzDITkrkWn1cpJxXS7RkCDG6Itaf5Pi5R2r/tTY0nuqdddYDxpQSKKi1BWlCe2
	 GxYi4dmgMrYtbtZRkIjFupueQ9T0RYm55WnjQZQc=
Date: Sun, 20 Apr 2025 13:25:36 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-design-document-node_mem_usedfree_bp.patch added to mm-unstable branch
Message-Id: <20250420202536.B5210C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/mm/damon/design: document node_mem_{used,free}_bp
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-design-document-node_mem_usedfree_bp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-document-node_mem_usedfree_bp.patch

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
Subject: Docs/mm/damon/design: document node_mem_{used,free}_bp
Date: Sun, 20 Apr 2025 12:40:27 -0700

Add description of DAMOS quota goal metrics for NUMA node utilization on
the DAMON deesign document.

Link: https://lkml.kernel.org/r/20250420194030.75838-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-document-node_mem_usedfree_bp
+++ a/Documentation/mm/damon/design.rst
@@ -550,10 +550,10 @@ aggressiveness (the quota) of the corres
 is under achieving the goal, DAMOS automatically increases the quota.  If DAMOS
 is over achieving the goal, it decreases the quota.
 
-The goal can be specified with three parameters, namely ``target_metric``,
-``target_value``, and ``current_value``.  The auto-tuning mechanism tries to
-make ``current_value`` of ``target_metric`` be same to ``target_value``.
-Currently, two ``target_metric`` are provided.
+The goal can be specified with four parameters, namely ``target_metric``,
+``target_value``, ``current_value`` and ``nid``.  The auto-tuning mechanism
+tries to make ``current_value`` of ``target_metric`` be same to
+``target_value``.
 
 - ``user_input``: User-provided value.  Users could use any metric that they
   has interest in for the value.  Use space main workload's latency or
@@ -565,6 +565,11 @@ Currently, two ``target_metric`` are pro
   in microseconds that measured from last quota reset to next quota reset.
   DAMOS does the measurement on its own, so only ``target_value`` need to be
   set by users at the initial time.  In other words, DAMOS does self-feedback.
+- ``node_mem_used_bp``: Specific NUMA node's used memory ratio in bp (1/10,000).
+- ``node_mem_free_bp``: Specific NUMA node's free memory ratio in bp (1/10,000).
+
+``nid`` is optionally required for only ``node_mem_used_bp`` and
+``node_mem_free_bp`` to point the specific NUMA node.
 
 To know how user-space can set the tuning goal metric, the target value, and/or
 the current value via :ref:`DAMON sysfs interface <sysfs_interface>`, refer to
_

Patches currently in -mm which might be from sj@kernel.org are

mm-madvise-define-and-use-madvise_behavior-struct-for-madvise_do_behavior.patch
mm-madvise-batch-tlb-flushes-for-madv_free.patch
mm-memory-split-non-tlb-flushing-part-from-zap_page_range_single.patch
mm-madvise-batch-tlb-flushes-for-madv_dontneed.patch
mm-damon-core-introduce-damos-quota-goal-metrics-for-memory-node-utilization.patch
mm-damon-sysfs-schemes-implement-file-for-quota-goal-nid-parameter.patch
mm-damon-sysfs-schemes-connect-damos_quota_goal-nid-with-core-layer.patch
docs-mm-damon-design-document-node_mem_usedfree_bp.patch
docs-admin-guide-mm-damon-usage-document-nid-file.patch
docs-abi-damon-document-nid-file.patch
samples-damon-implement-a-damon-module-for-memory-tiering.patch


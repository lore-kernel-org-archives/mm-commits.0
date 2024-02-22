Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314F97E1
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560134; cv=none; b=lROI8fQY8GcbRhJo2Pp3Hj9o51gxpcniCrRr2JCJjHzXDpOM6AgeHOzFRn0MHSQghCNiRNtAV6tQup3tauhqDvYuJ1pjDKOsargSEsXpMjfS8qSL/OGUdjwSq6nw4uC1FoqjApqZpt0ew2iIAoHhcZbYiSH90q1AYztHc69GKaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560134; c=relaxed/simple;
	bh=LyNpFEDN59ED4m2Cdqni+O07xYwHYjS64Mupg8IfiTU=;
	h=Date:To:From:Subject:Message-Id; b=Q0oq/Ykr6RB1Ug4Ay9c64GLKcGddbb8TMZ3xZbWCVKGWD4sarAzQcB0V3U23uCZG59pc8T+y+vWiIB44EPh+cO2YUIkMPKirEgBF/zsVmtPtNLj/KxQFe/26isMqswN2NAZh6Qbm7p+mgZMx+DfKKTVUYYmLelC8Ui7sTYH0Y2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JkGAMcfh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JkGAMcfh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06ADDC433F1;
	Thu, 22 Feb 2024 00:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560134;
	bh=LyNpFEDN59ED4m2Cdqni+O07xYwHYjS64Mupg8IfiTU=;
	h=Date:To:From:Subject:From;
	b=JkGAMcfhZ5M+Ci2tKitxSwmMyb9JgMZlZsAydo7WQGfRJTxZsAhQu810h9UOTNDgc
	 OhLceIbxr2ssO6fsXKEirDsBFt4N8S/jNGrX8hLw8ggvySbJ9CKHeg+7KELmeqGfv/
	 YmNOFdmuLWMHMDAXzbAwIV0VrNO5/NoJ0Sfggpyw=
Date: Wed, 21 Feb 2024 16:02:13 -0800
To: mm-commits@vger.kernel.org,siyanteng@loongson.cn,shuah@kernel.org,corbet@lwn.net,alexs@kernel.org,2023002089@link.tyut.edu.cn,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-usage-document-deprecated-file-of-damon-debugfs-interface.patch removed from -mm tree
Message-Id: <20240222000214.06ADDC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/usage: document 'DEPRECATED' file of DAMON debugfs interface
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-document-deprecated-file-of-damon-debugfs-interface.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/usage: document 'DEPRECATED' file of DAMON debugfs interface
Date: Mon, 29 Jan 2024 17:35:44 -0800

Document the newly added DAMON debugfs interface deprecation notice file
on the usage document.

Link: https://lkml.kernel.org/r/20240130013549.89538-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Alex Shi <alexs@kernel.org>
Cc: Hu Haowen <2023002089@link.tyut.edu.cn>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Yanteng Si <siyanteng@loongson.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-document-deprecated-file-of-damon-debugfs-interface
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -628,9 +628,16 @@ debugfs Interface (DEPRECATED!)
   move, please report your usecase to damon@lists.linux.dev and
   linux-mm@kvack.org.
 
-DAMON exports eight files, ``attrs``, ``target_ids``, ``init_regions``,
-``schemes``, ``monitor_on``, ``kdamond_pid``, ``mk_contexts`` and
-``rm_contexts`` under its debugfs directory, ``<debugfs>/damon/``.
+DAMON exports nine files, ``DEPRECATED``, ``attrs``, ``target_ids``,
+``init_regions``, ``schemes``, ``monitor_on``, ``kdamond_pid``, ``mk_contexts``
+and ``rm_contexts`` under its debugfs directory, ``<debugfs>/damon/``.
+
+
+``DEPRECATED`` is a read-only file for the DAMON debugfs interface deprecation
+notice.  Reading it returns the deprecation notice, as below::
+
+    # cat DEPRECATED
+    DAMON debugfs interface is deprecated, so users should move to DAMON_SYSFS. If you cannot, please report your usecase to damon@lists.linux.dev and linux-mm@kvack.org.
 
 
 Attributes
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


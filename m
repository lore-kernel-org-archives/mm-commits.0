Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 259A11448E0
	for <mm-commits@vger.kernel.org>; Sat,  4 Jan 2025 02:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735958725; cv=none; b=jG8teupJPbCD5/axA3CY0J7BQvn3EehIc7V7d8JT45aKXOdclSn+zX8JmgIm9ZaGSIOqaXChk3GTybPyjZpQeGxsP4mgjXNPjEMYMjeby4ykfL5xObqwlzY5OuB3i5QNFlKgDQni3U/4QfXRy1q3foiKNW51PXDPJ4LEc9CPlo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735958725; c=relaxed/simple;
	bh=Iy92RNJ5jg5ROhlDZRYej/Ay/wIC55jUP/B2AsYR82U=;
	h=Date:To:From:Subject:Message-Id; b=lLoyg9m9qh6mVw6aU9sFabspvAJIppMUVCJYp+Q7bjZJsLtt5uucdoovBnu/lQWrzdOy2A8Bnt6kOVJ+2Jchc3La7NsvboJVptNbEgQhHVIDAZ6KOBlvztyBrjg3AszE6dqtRU4tTvRj3582x33vOIV5N4R3tg5gLDq85TG1z/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DwkiemTO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DwkiemTO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 913E4C4CED6;
	Sat,  4 Jan 2025 02:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735958724;
	bh=Iy92RNJ5jg5ROhlDZRYej/Ay/wIC55jUP/B2AsYR82U=;
	h=Date:To:From:Subject:From;
	b=DwkiemTOJ0bdC90wvYQaRMmwsZQEv5B5AaLY//KXSnZeKXNZ3W24aLbUZo0khr/Qz
	 6cpt87+MCS821eosxxTe5QrGEMNBpH19j7+U8ZckTPlSdClzZKvepHEC+M7/jm2ciF
	 oBNR5f0/nINCNj89pUfI2SV2SJ/xl+ynjjO3QwNs=
Date: Fri, 03 Jan 2025 18:45:24 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-design-document-damos-regions-walking.patch added to mm-unstable branch
Message-Id: <20250104024524.913E4C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/mm/damon/design: document DAMOS regions walking
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-design-document-damos-regions-walking.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-document-damos-regions-walking.patch

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
Subject: Docs/mm/damon/design: document DAMOS regions walking
Date: Fri, 3 Jan 2025 09:43:58 -0800

DAMOS' regions walking is a feature for efficiently retrieving monitoring
results or DAMOS-internal behavior.  It can be useful for multiple
purposes including investigations and tuning.  Add a section for it on the
design document.

Link: https://lkml.kernel.org/r/20250103174400.54890-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-document-damos-regions-walking
+++ a/Documentation/mm/damon/design.rst
@@ -540,6 +540,17 @@ To know how user-space can set the water
 documentation.
 
 
+Regions Walking
+~~~~~~~~~~~~~~~
+
+DAMOS feature allowing users access each region that a DAMOS action has just
+applied.  Using this feature, DAMON :ref:`API <damon_design_api>` allows users
+access full properties of the regions including the access monitoring results.
+:ref:`DAMON sysfs interface <sysfs_interface>` also allows users read the data
+via special :ref:`files <sysfs_schemes_tried_regions>`.
+
+.. _damon_design_api:
+
 Application Programming Interface
 ---------------------------------
 
_

Patches currently in -mm which might be from sj@kernel.org are

samples-add-a-skeleton-of-a-sample-damon-module-for-working-set-size-estimation.patch
samples-damon-wsse-start-and-stop-damon-as-the-user-requests.patch
samples-damon-wsse-implement-working-set-size-estimation-and-logging.patch
samples-damon-introduce-a-skeleton-of-a-smaple-damon-module-for-proactive-reclamation.patch
samples-damon-prcl-implement-schemes-setup.patch
replace-free-hugepage-folios-after-migration-fix-2.patch
docs-admin-guide-mm-damon-usage-remove-damon-debugfs-interface-documentation.patch
docs-mm-damon-design-update-for-removal-of-damon-debugfs-interface.patch
selftests-damon-config-remove-configs-for-damon-debugfs-interface-selftests.patch
selftests-damon-remove-tests-for-damon-debugfs-interface.patch
kunit-configs-remove-configs-for-damon-debugfs-interface-tests.patch
mm-damon-remove-damon-debugfs-interface-kunit-tests.patch
mm-damon-remove-damon-debugfs-interface.patch
mm-damon-sysfs-schemes-remove-unnecessary-schemes-existence-check-in-damon_sysfs_schemes_clear_regions.patch
mm-damon-sysfs-handle-clear_schemes_tried_regions-from-damon-sysfs-context.patch
mm-damon-core-introduce-damon_call.patch
mm-damon-sysfs-use-damon_call-for-update_schemes_stats.patch
mm-damon-sysfs-use-damon_call-for-commit_schemes_quota_goals.patch
mm-damon-sysfs-use-damon_call-for-update_schemes_effective_quotas.patch
mm-damon-core-implement-damos_walk.patch
docs-mm-damon-design-document-damos-regions-walking.patch
mm-damon-sysfs-use-damos_walk-for-update_schemes_tried_bytesregions.patch
mm-damon-sysfs-remove-unused-code-for-schemes-tried-regions-update.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13251D689
	for <mm-commits@vger.kernel.org>; Sun, 18 Feb 2024 21:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708290778; cv=none; b=la3GR1lEsBXm2QEdi6pDfLDbWcxTSemEW1y4doXfKBFAhdOya0yNLRYyJjK94ptMqlmqEXzYwMT7YWEHDawOWttEK1XEtirygwvjAk0KmrYDthjZC+gM3WJkSJnUo2SLdJrWtghVY1sm8X1ubv2FdT660AgDI+uUe0l0S8uc/mQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708290778; c=relaxed/simple;
	bh=yWeP0ptw1O3BqVRiXbQqBsdxfGdckiXpP8rFw39eMTM=;
	h=Date:To:From:Subject:Message-Id; b=IhOfEUhEWGNCSsGHtvTu8gAlsV292T8p7PKvmkU8ktIq6DMrchRj87JHm5mFrAKJRTRzK/3URGYEMWc4Z6tmnSqXrXE1Ue1TdLM9e4k+ybr9EurCtpw+j4CIDQDzR89Z0AavAiIgjR2GZ50RXSbmfFoADEOxqv0GBkQDCULh/vU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uYypJ9hs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uYypJ9hs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17DE4C433F1;
	Sun, 18 Feb 2024 21:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708290778;
	bh=yWeP0ptw1O3BqVRiXbQqBsdxfGdckiXpP8rFw39eMTM=;
	h=Date:To:From:Subject:From;
	b=uYypJ9hsvee2kYrwZWmEsQ5M9FzPEvmAnhyrZQUBfbwyproukJHWWcdDv5XvyR7er
	 061OY/zAsst2ioz/DwAhORWwnxiWHW1iCDG0l+u2i7qTRg2+eEAEhkLgE05H9/6OqX
	 5eOYo9lIFyeVZ90zRXC4tz1Mq/UsTXwlq5/J91D0=
Date: Sun, 18 Feb 2024 13:12:56 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-maintainer-profile-fix-reference-links-for-mm-stable-tree.patch added to mm-unstable branch
Message-Id: <20240218211258.17DE4C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/mm/damon/maintainer-profile: fix reference links for mm-[un]stable tree
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-maintainer-profile-fix-reference-links-for-mm-stable-tree.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-maintainer-profile-fix-reference-links-for-mm-stable-tree.patch

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
Subject: Docs/mm/damon/maintainer-profile: fix reference links for mm-[un]stable tree
Date: Fri, 16 Feb 2024 16:58:38 -0800

Patch series "Docs/mm/damon: misc readability improvements".

Fix trivial mistakes and improve layout of information on different
documents for DAMON.


This patch (of 5):

A couple of sentences on maintainer-profile.rst are having reference links
for mm-unstable and mm-stable trees with wrong rst markup.  Fix those.

Link: https://lkml.kernel.org/r/20240217005842.87348-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20240217005842.87348-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/maintainer-profile.rst |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/Documentation/mm/damon/maintainer-profile.rst~docs-mm-damon-maintainer-profile-fix-reference-links-for-mm-stable-tree
+++ a/Documentation/mm/damon/maintainer-profile.rst
@@ -21,8 +21,8 @@ be queued in mm-stable [3]_ , and finall
 memory management subsystem maintainer.
 
 Note again the patches for review should be made against the mm-unstable
-tree[1] whenever possible.  damon/next is only for preview of others' works in
-progress.
+tree [1]_ whenever possible.  damon/next is only for preview of others' works
+in progress.
 
 Submit checklist addendum
 -------------------------
@@ -41,8 +41,8 @@ Further doing below and putting the resu
 Key cycle dates
 ---------------
 
-Patches can be sent anytime.  Key cycle dates of the mm-unstable[1] and
-mm-stable[3] trees depend on the memory management subsystem maintainer.
+Patches can be sent anytime.  Key cycle dates of the mm-unstable [1]_ and
+mm-stable [3]_ trees depend on the memory management subsystem maintainer.
 
 Review cadence
 --------------
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-check-apply-interval-in-damon_do_apply_schemes.patch
mm-damon-sysfs-schemes-handle-schemes-sysfs-dir-removal-before-commit_schemes_quota_goals.patch
docs-admin-guide-mm-damon-usage-use-sysfs-interface-for-tracepoints-example.patch
mm-damon-rename-config_damon_dbgfs-to-damon_dbgfs_deprecated.patch
mm-damon-dbgfs-implement-deprecation-notice-file.patch
mm-damon-dbgfs-make-debugfs-interface-deprecation-message-a-macro.patch
docs-admin-guide-mm-damon-usage-document-deprecated-file-of-damon-debugfs-interface.patch
selftets-damon-prepare-for-monitor_on-file-renaming.patch
mm-damon-dbgfs-rename-monitor_on-file-to-monitor_on_deprecated.patch
docs-admin-guide-mm-damon-usage-update-for-monitor_on-renaming.patch
docs-translations-damon-usage-update-for-monitor_on-renaming.patch
mm-damon-sysfs-handle-state-file-inputs-for-every-sampling-interval-if-possible.patch
selftests-damon-_damon_sysfs-support-damos-quota.patch
selftests-damon-_damon_sysfs-support-damos-stats.patch
selftests-damon-_damon_sysfs-support-damos-apply-interval.patch
selftests-damon-add-a-test-for-damos-quota.patch
selftests-damon-add-a-test-for-damos-apply-intervals.patch
selftests-damon-add-a-test-for-a-race-between-target_ids_read-and-dbgfs_before_terminate.patch
selftests-damon-add-a-test-for-the-pid-leak-of-dbgfs_target_ids_write.patch
selftests-damon-_chk_dependency-get-debugfs-mount-point-from-proc-mounts.patch
docs-mm-damon-maintainer-profile-fix-reference-links-for-mm-stable-tree.patch
docs-mm-damon-move-the-list-of-damos-actions-to-design-doc.patch
docs-mm-damon-move-damon-operation-sets-list-from-the-usage-to-the-design-document.patch
docs-mm-damon-move-monitoring-target-regions-setup-detail-from-the-usage-to-the-design-document.patch
docs-admin-guide-mm-damon-usage-fix-wrong-quotas-diabling-condition.patch

